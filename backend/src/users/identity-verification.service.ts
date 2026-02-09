import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import {
  IdentityVerification,
  IdentityVerificationStatus,
} from './schemas/identity-verification.schema';
import { IdentityPersonalDto } from './dto/identity-personal.dto';
import { User } from './schemas/user.schema';

type IdentityDocType = 'id_front' | 'id_back' | 'selfie';

@Injectable()
export class IdentityVerificationService {
  constructor(
    @InjectModel(IdentityVerification.name)
    private readonly identityModel: Model<IdentityVerification>,
    @InjectModel(User.name)
    private readonly userModel: Model<User>,
  ) {}

  isEnabled(): boolean {
    return (process.env.KYC_ENABLED ?? '').toLowerCase() === 'true';
  }

  requireSelfie(): boolean {
    return (process.env.KYC_REQUIRE_SELFIE ?? '').toLowerCase() === 'true';
  }

  autoApproveInDev(): boolean {
    const isProd = (process.env.NODE_ENV ?? '').toLowerCase() === 'production';
    if (isProd) return false;
    return (process.env.KYC_AUTO_APPROVE_IN_DEV ?? 'true').toLowerCase() === 'true';
  }

  retentionDays(): number {
    const raw = Number(process.env.KYC_DOC_RETENTION_DAYS ?? 30);
    return Number.isFinite(raw) && raw > 0 ? raw : 30;
  }

  private _maskTc(tcNo: string): string {
    const v = (tcNo ?? '').trim();
    if (v.length < 2) return '***';
    return `${'*'.repeat(Math.max(0, v.length - 2))}${v.slice(-2)}`;
  }

  private _normalizeBirthDate(raw: string): string {
    const value = (raw ?? '').trim();
    if (!/^\d{4}-\d{2}-\d{2}$/.test(value)) {
      throw new BadRequestException('BIRTHDATE_INVALID');
    }
    return value;
  }

  // Turkish ID number validation (11 digits + checksum).
  validateTcNo(tcNo: string): boolean {
    const v = (tcNo ?? '').trim();
    if (!/^\d{11}$/.test(v)) return false;
    if (v[0] === '0') return false;
    const digits = v.split('').map((d) => Number(d));
    const oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    const evenSum = digits[1] + digits[3] + digits[5] + digits[7];
    const digit10 = ((oddSum * 7 - evenSum) % 10 + 10) % 10;
    if (digit10 !== digits[9]) return false;
    const sum10 = digits.slice(0, 10).reduce((a, b) => a + b, 0);
    const digit11 = sum10 % 10;
    return digit11 === digits[10];
  }

  private ensureEnabled() {
    if (!this.isEnabled()) {
      throw new BadRequestException('KYC_DISABLED');
    }
  }

  private ensureSchema(record: any) {
    if (!record.personal) record.personal = {};
    if (!record.documents) record.documents = {};
    if (!record.review) record.review = {};
    if (!record.audit) record.audit = {};
    if (!record.security) record.security = {};
  }

  async ensureDraft(userId: string, meta?: { ip?: string; userAgent?: string }) {
    this.ensureEnabled();
    const existing = await this.identityModel.findOne({ userId }).exec();
    if (existing) {
      this.ensureSchema(existing);
      if (meta?.ip || meta?.userAgent) {
        existing.security = {
          ...(existing.security ?? {}),
          ...(meta.ip ? { ip: meta.ip } : {}),
          ...(meta.userAgent ? { userAgent: meta.userAgent.slice(0, 180) } : {}),
        };
        await existing.save();
      }
      return existing;
    }
    const expiresAt = new Date(Date.now() + this.retentionDays() * 86400 * 1000);
    return this.identityModel.create({
      userId,
      status: 'pending',
      audit: { expiresAt },
      security: {
        ip: meta?.ip,
        userAgent: meta?.userAgent?.slice(0, 180),
      },
    });
  }

  async getStatus(userId: string) {
    this.ensureEnabled();
    const record = await this.identityModel.findOne({ userId }).lean().exec();
    if (!record) {
      return {
        status: 'unverified' as IdentityVerificationStatus,
        requireSelfie: this.requireSelfie(),
        missing: ['personal', 'id_front', 'id_back'],
      };
    }
    const missing = this.computeMissing(record);
    return {
      verificationId: (record as any)._id?.toString(),
      status: record.status,
      requireSelfie: this.requireSelfie(),
      missing,
      review: record.review ?? {},
    };
  }

  computeMissing(record: any): string[] {
    const missing: string[] = [];
    const p = record.personal ?? {};
    if (!p.name || !p.surname || !p.tcNo || !p.birthDate) {
      missing.push('personal');
    }
    const docs = record.documents ?? {};
    if (!docs.idFront?.url) missing.push('id_front');
    if (!docs.idBack?.url) missing.push('id_back');
    if (this.requireSelfie() && !docs.selfie?.url) missing.push('selfie');
    return missing;
  }

  async savePersonal(
    userId: string,
    dto: IdentityPersonalDto,
    meta?: { ip?: string; userAgent?: string },
  ) {
    const record = await this.ensureDraft(userId, meta);
    const tcNo = dto.tcNo.trim();
    if (!this.validateTcNo(tcNo)) {
      console.log('KYC', 'tc_invalid', `userId=${userId}`, `tc=${this._maskTc(tcNo)}`);
      throw new BadRequestException('TC_INVALID');
    }
    const birthDate = this._normalizeBirthDate(dto.birthDate);
    record.personal = {
      name: dto.name.trim(),
      surname: dto.surname.trim(),
      tcNo,
      birthDate,
    };
    if (record.status === 'unverified') record.status = 'pending';
    record.security = {
      ...(record.security ?? {}),
      ...(meta?.ip ? { ip: meta.ip } : {}),
      ...(meta?.userAgent ? { userAgent: meta.userAgent.slice(0, 180) } : {}),
    };
    await record.save();
    return {
      verificationId: record._id.toString(),
      status: record.status,
      requireSelfie: this.requireSelfie(),
      missing: this.computeMissing(record),
    };
  }

  async attachDocument(params: {
    userId: string;
    type: IdentityDocType;
    url: string;
    mime?: string;
    size?: number;
    sha256?: string;
  }) {
    const record = await this.ensureDraft(params.userId);
    const meta = {
      url: params.url,
      mime: params.mime,
      size: params.size,
      sha256: params.sha256,
    };
    if (!record.documents) record.documents = {} as any;
    if (params.type === 'id_front') (record.documents as any).idFront = meta;
    if (params.type === 'id_back') (record.documents as any).idBack = meta;
    if (params.type === 'selfie') (record.documents as any).selfie = meta;
    if (record.status === 'unverified') record.status = 'pending';
    await record.save();
    return {
      verificationId: record._id.toString(),
      status: record.status,
      missing: this.computeMissing(record),
    };
  }

  async submit(userId: string) {
    const record = await this.ensureDraft(userId);
    const missing = this.computeMissing(record);
    if (missing.length > 0) {
      throw new BadRequestException('MISSING_KYC_FIELDS');
    }
    record.status = 'pending_review';
    record.audit = {
      ...(record.audit ?? {}),
      submittedAt: new Date(),
      expiresAt:
        record.audit?.expiresAt ??
        new Date(Date.now() + this.retentionDays() * 86400 * 1000),
    };
    await record.save();

    if (this.autoApproveInDev()) {
      await this.approve(userId, 'dev-auto');
      const refreshed = await this.identityModel.findOne({ userId }).lean().exec();
      return {
        status: refreshed?.status ?? 'verified',
        autoApproved: true,
      };
    }

    return {
      status: record.status,
      autoApproved: false,
    };
  }

  async approve(userId: string, reviewedBy: string) {
    this.ensureEnabled();
    const record = await this.identityModel.findOne({ userId }).exec();
    if (!record) throw new BadRequestException('KYC_NOT_STARTED');
    record.status = 'verified';
    record.review = {
      reviewedBy,
      reviewedAt: new Date(),
    };
    await record.save();
    await this.userModel
      .findByIdAndUpdate(
        userId,
        {
          $set: {
            identityVerified: true,
            verified: true,
            verificationStatus: 'verified',
            verifiedAt: new Date(),
          },
        },
        { new: true },
      )
      .exec();
    return { status: record.status };
  }

  async reject(userId: string, reviewedBy: string, reason: string) {
    this.ensureEnabled();
    const record = await this.identityModel.findOne({ userId }).exec();
    if (!record) throw new BadRequestException('KYC_NOT_STARTED');
    if (!reason || reason.trim().length < 3) {
      throw new BadRequestException('REASON_REQUIRED');
    }
    record.status = 'rejected';
    record.review = {
      reviewedBy,
      reviewedAt: new Date(),
      reason: reason.trim(),
    };
    await record.save();
    await this.userModel
      .findByIdAndUpdate(
        userId,
        {
          $set: {
            identityVerified: false,
          },
        },
        { new: true },
      )
      .exec();
    return { status: record.status };
  }
}
