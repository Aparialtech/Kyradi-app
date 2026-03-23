import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { createHash } from 'crypto';
import * as fs from 'fs';
import * as path from 'path';
import {
  IdentityVerification,
  IdentityVerificationStatus,
} from './schemas/identity-verification.schema';
import { IdentityPersonalDto } from './dto/identity-personal.dto';
import { User } from './schemas/user.schema';
import { KycVerificationCode } from './schemas/kyc-verification.schema';
import { MailService } from '../common/mail/mail.service';

type IdentityDocType = 'id_front' | 'id_back' | 'selfie';

@Injectable()
export class IdentityVerificationService {
  private ocrModuleUnavailable = false;
  private readonly docKeywords = [
    'T.C',
    'TC',
    'KIMLIK',
    'KİMLİK',
    'IDENTITY',
    'DOGUM',
    'DOĞUM',
    'SOYADI',
    'ADI',
  ];

  constructor(
    @InjectModel(IdentityVerification.name)
    private readonly identityModel: Model<IdentityVerification>,
    @InjectModel(User.name)
    private readonly userModel: Model<User>,
    @InjectModel(KycVerificationCode.name)
    private readonly kycCodeModel: Model<KycVerificationCode>,
    private readonly mailService: MailService,
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
    return (
      (process.env.KYC_AUTO_APPROVE_IN_DEV ?? 'true').toLowerCase() === 'true'
    );
  }

  retentionDays(): number {
    const raw = Number(process.env.KYC_DOC_RETENTION_DAYS ?? 30);
    return Number.isFinite(raw) && raw > 0 ? raw : 30;
  }

  otpTtlMin(): number {
    const raw = Number(process.env.KYC_OTP_TTL_MIN ?? 10);
    return Number.isFinite(raw) && raw > 0 ? raw : 10;
  }

  otpRateLimit(): number {
    const raw = Number(process.env.KYC_OTP_RATE_LIMIT ?? 3);
    return Number.isFinite(raw) && raw > 0 ? raw : 3;
  }

  private docVerifierEnabled(): boolean {
    return (
      (process.env.KYC_DOC_VERIFIER_ENABLED ?? 'false').toLowerCase() === 'true'
    );
  }

  private localDocCheckEnabled(): boolean {
    return (
      (process.env.KYC_LOCAL_DOC_CHECK_ENABLED ?? 'true').toLowerCase() ===
      'true'
    );
  }

  private ocrRequired(): boolean {
    return (
      (process.env.KYC_DOC_OCR_REQUIRED ?? 'false').toLowerCase() === 'true'
    );
  }

  private ocrLang(): string {
    return (process.env.KYC_DOC_OCR_LANG ?? 'tur+eng').trim();
  }

  private normalizeText(value?: string | null): string {
    const raw = (value ?? '')
      .replace(/ı/g, 'i')
      .replace(/İ/g, 'I')
      .normalize('NFKD')
      .replace(/[\u0300-\u036f]/g, '');
    return raw.replace(/[^A-Za-z0-9]/g, '').toUpperCase();
  }

  private normalizeDate(value?: string | null): string {
    const raw = (value ?? '').trim();
    const m = raw.match(/^(\d{4})[-/. ]?(\d{2})[-/. ]?(\d{2})$/);
    if (!m) return '';
    return `${m[1]}-${m[2]}-${m[3]}`;
  }

  private normalizeDateFromFreeText(value?: string | null): string {
    const raw = (value ?? '').trim();
    const m = raw.match(
      /\b(19|20\d{2})[-/. ](0[1-9]|1[0-2])[-/. ]([0-2]\d|3[01])\b/,
    );
    if (!m) return '';
    return `${m[1]}-${m[2]}-${m[3]}`;
  }

  private toIdentityFilePath(url?: string): string | null {
    const v = (url ?? '').trim();
    if (!v) return null;
    const marker = '/uploads/identity/';
    const idx = v.indexOf(marker);
    if (idx === -1) return null;
    const relative = v.slice(idx + marker.length).replace(/^\/+/, '');
    if (!relative) return null;
    return path.join(process.cwd(), 'uploads', 'identity', relative);
  }

  private extractTcCandidates(text: string): string[] {
    const set = new Set<string>();
    const direct = text.match(/\b[1-9]\d{10}\b/g) ?? [];
    for (const item of direct) {
      if (this.validateTcNo(item)) set.add(item);
    }
    const compressed = text.replace(/\s+/g, '');
    const maybe = compressed.match(/[1-9]\d{10}/g) ?? [];
    for (const item of maybe) {
      if (this.validateTcNo(item)) set.add(item);
    }
    return Array.from(set);
  }

  private async extractTextWithOcr(filePath: string): Promise<string | null> {
    if (this.ocrModuleUnavailable) return null;
    const modName = process.env.KYC_OCR_MODULE || 'tesseract.js';
    try {
      const stat = await fs.promises.stat(filePath);
      if (!stat.isFile()) return null;
    } catch {
      return null;
    }

    try {
      const mod = await import(modName);
      const recognize =
        (mod as any).recognize ??
        (mod as any).default?.recognize ??
        (mod as any).Tesseract?.recognize;
      if (typeof recognize !== 'function') {
        this.ocrModuleUnavailable = true;
        return null;
      }
      const result = await recognize(filePath, this.ocrLang(), {
        logger: () => undefined,
      });
      const text = result?.data?.text;
      if (typeof text !== 'string') return null;
      return text;
    } catch {
      this.ocrModuleUnavailable = true;
      return null;
    }
  }

  private async checkLocalIdentityConsistency(record: IdentityVerification) {
    const docs = record.documents ?? ({} as any);
    const frontPath = this.toIdentityFilePath(docs?.idFront?.url);
    const backPath = this.toIdentityFilePath(docs?.idBack?.url);
    if (!frontPath || !backPath) {
      throw new BadRequestException('KYC_DOC_PATH_INVALID');
    }

    const [frontText, backText] = await Promise.all([
      this.extractTextWithOcr(frontPath),
      this.extractTextWithOcr(backPath),
    ]);
    const combined = `${frontText ?? ''}\n${backText ?? ''}`.trim();
    if (!combined) {
      if (this.ocrRequired()) {
        throw new BadRequestException('KYC_OCR_UNAVAILABLE');
      }
      return;
    }

    const upper = combined.toUpperCase();
    const keywordHits = this.docKeywords.filter((k) =>
      upper.includes(k.toUpperCase()),
    ).length;
    if (keywordHits < 2) {
      throw new BadRequestException('KYC_DOC_NOT_REAL_ID');
    }

    const expectedTc = this._normalizeNationalId(record.personal?.tcNo ?? '');
    const tcCandidates = this.extractTcCandidates(combined);
    if (!expectedTc || !tcCandidates.includes(expectedTc)) {
      throw new BadRequestException('KYC_DOC_TC_MISMATCH');
    }

    const expectedBirth = this.normalizeDate(record.personal?.birthDate ?? '');
    if (expectedBirth) {
      const foundBirth = this.normalizeDateFromFreeText(combined);
      if (!foundBirth || foundBirth !== expectedBirth) {
        throw new BadRequestException('KYC_DOC_BIRTHDATE_MISMATCH');
      }
    }

    const name = this.normalizeText(record.personal?.name ?? '');
    const surname = this.normalizeText(record.personal?.surname ?? '');
    const normalizedDoc = this.normalizeText(combined);
    if (name && !normalizedDoc.includes(name)) {
      throw new BadRequestException('KYC_DOC_NAME_MISMATCH');
    }
    if (surname && !normalizedDoc.includes(surname)) {
      throw new BadRequestException('KYC_DOC_SURNAME_MISMATCH');
    }
  }

  private async ensurePersonalMatchesUserProfile(record: IdentityVerification) {
    const user = await this.userModel.findById(record.userId).lean().exec();
    if (!user) {
      throw new BadRequestException('USER_NOT_FOUND');
    }
    const personal = record.personal ?? ({} as any);
    const tcNo = this._normalizeNationalId(personal.tcNo ?? '');
    const birthDate = this.normalizeDate(personal.birthDate ?? '');
    const name = this.normalizeText(personal.name ?? '');
    const surname = this.normalizeText(personal.surname ?? '');

    const userTc = this._normalizeNationalId((user as any).nationalId ?? '');
    if (userTc && tcNo && userTc !== tcNo) {
      throw new BadRequestException('KYC_PROFILE_MISMATCH');
    }

    const userBirth = this.normalizeDate(
      (user as any).birthDate?.toString() ?? '',
    );
    if (userBirth && birthDate && userBirth !== birthDate) {
      throw new BadRequestException('KYC_PROFILE_MISMATCH');
    }

    const userName = this.normalizeText((user as any).name ?? '');
    if (userName && name && userName !== name) {
      throw new BadRequestException('KYC_PROFILE_MISMATCH');
    }

    const userSurname = this.normalizeText((user as any).surname ?? '');
    if (userSurname && surname && userSurname !== surname) {
      throw new BadRequestException('KYC_PROFILE_MISMATCH');
    }
  }

  private docVerifierStrict(): boolean {
    return (
      (process.env.KYC_DOC_VERIFIER_STRICT ?? 'false').toLowerCase() === 'true'
    );
  }

  private docVerifierMinConfidence(): number {
    const raw = Number(process.env.KYC_DOC_VERIFIER_MIN_CONFIDENCE ?? 0.75);
    if (!Number.isFinite(raw)) return 0.75;
    if (raw < 0) return 0;
    if (raw > 1) return 1;
    return raw;
  }

  private docVerifierTimeoutMs(): number {
    const raw = Number(process.env.KYC_DOC_VERIFIER_TIMEOUT_MS ?? 7000);
    return Number.isFinite(raw) && raw > 0 ? Math.floor(raw) : 7000;
  }

  private docMinBytes(): number {
    const raw = Number(process.env.KYC_DOC_MIN_BYTES ?? 25 * 1024);
    return Number.isFinite(raw) && raw > 0 ? Math.floor(raw) : 25 * 1024;
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

  private _normalizeNationalId(raw: string): string {
    return (raw ?? '').replace(/\D/g, '');
  }

  private async _ensureNationalIdAvailable(tcNo: string, userId: string) {
    const existing = await this.userModel
      .findOne({
        nationalId: tcNo,
        _id: { $ne: userId },
        $or: [
          { verified: true },
          { identityVerified: true },
          { verificationStatus: 'verified' },
        ],
      })
      .select('_id')
      .lean()
      .exec();
    if (existing) {
      throw new ConflictException('NATIONAL_ID_ALREADY_REGISTERED');
    }
  }

  // Turkish ID number validation (11 digits + checksum).
  validateTcNo(tcNo: string): boolean {
    const v = (tcNo ?? '').trim();
    if (!/^\d{11}$/.test(v)) return false;
    if (v[0] === '0') return false;
    const digits = v.split('').map((d) => Number(d));
    const oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    const evenSum = digits[1] + digits[3] + digits[5] + digits[7];
    const digit10 = (((oddSum * 7 - evenSum) % 10) + 10) % 10;
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

  async ensureDraft(
    userId: string,
    meta?: { ip?: string; userAgent?: string },
  ) {
    this.ensureEnabled();
    const existing = await this.identityModel.findOne({ userId }).exec();
    if (existing) {
      this.ensureSchema(existing);
      if (!existing.attempts) existing.attempts = {};
      if (meta?.ip || meta?.userAgent) {
        existing.security = {
          ...(existing.security ?? {}),
          ...(meta.ip ? { ip: meta.ip } : {}),
          ...(meta.userAgent
            ? { userAgent: meta.userAgent.slice(0, 180) }
            : {}),
        };
        await existing.save();
      }
      return existing;
    }
    const expiresAt = new Date(
      Date.now() + this.retentionDays() * 86400 * 1000,
    );
    return this.identityModel.create({
      userId,
      status: 'draft',
      audit: { expiresAt },
      attempts: {},
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
        personal: {},
        documents: {},
      };
    }
    const missing = this.computeMissing(record);
    const personal = record.personal ?? {};
    const documents = record.documents ?? {};
    return {
      verificationId: (record as any)._id?.toString(),
      status: record.status,
      requireSelfie: this.requireSelfie(),
      missing,
      review: record.review ?? {},
      personal: {
        name: personal.name ?? '',
        surname: personal.surname ?? '',
        tcNo: personal.tcNo ?? '',
        birthDate: personal.birthDate ?? '',
      },
      documents: {
        idFrontUrl: documents.idFront?.url ?? '',
        idBackUrl: documents.idBack?.url ?? '',
        selfieUrl: documents.selfie?.url ?? '',
      },
      audit: record.audit ?? {},
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
    const tcNo = this._normalizeNationalId(dto.tcNo);
    if (!this.validateTcNo(tcNo)) {
      console.log(
        'KYC',
        'tc_invalid',
        `userId=${userId}`,
        `tc=${this._maskTc(tcNo)}`,
      );
      throw new BadRequestException('TC_INVALID');
    }
    await this._ensureNationalIdAvailable(tcNo, userId);
    const birthDate = this._normalizeBirthDate(dto.birthDate);
    record.personal = {
      name: dto.name.trim(),
      surname: dto.surname.trim(),
      tcNo,
      birthDate,
    };
    if (record.status === 'unverified' || record.status === 'draft') {
      record.status = 'draft';
    }
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
    if (record.status === 'unverified' || record.status === 'draft') {
      record.status = 'draft';
    }
    await record.save();
    return {
      verificationId: record._id.toString(),
      status: record.status,
      missing: this.computeMissing(record),
    };
  }

  private _hashOtp(code: string, userId: string): string {
    const secret = process.env.JWT_SECRET || 'super-secret-key';
    return createHash('sha256')
      .update(`${code}:${secret}:${userId}`)
      .digest('hex');
  }

  private _generateOtp(): string {
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  private _normalizeOtp(code: string): string {
    return (code ?? '').replace(/[^0-9]/g, '');
  }

  async sendOtp(userId: string, email: string) {
    const ttlMs = this.otpTtlMin() * 60 * 1000;
    const rateLimit = this.otpRateLimit();
    const now = new Date();
    let record = await this.kycCodeModel
      .findOne({ userId, purpose: 'kyc_identity' })
      .sort({ updatedAt: -1, createdAt: -1 })
      .exec();
    if (record?._id) {
      await this.kycCodeModel
        .deleteMany({
          userId,
          purpose: 'kyc_identity',
          _id: { $ne: record._id },
        })
        .exec();
    }
    if (record?.lastSentAt) {
      const delta = now.getTime() - new Date(record.lastSentAt).getTime();
      if (delta < ttlMs && (record.sendCount ?? 0) >= rateLimit) {
        throw new BadRequestException('OTP_RATE_LIMIT');
      }
      if (delta >= ttlMs) {
        record.sendCount = 0;
      }
    }
    const code = this._generateOtp();
    const codeHash = this._hashOtp(code, userId);
    const expiresAt = new Date(now.getTime() + ttlMs);
    if (!record) {
      record = await this.kycCodeModel.create({
        userId,
        purpose: 'kyc_identity',
        codeHash,
        expiresAt,
        usedAt: undefined,
        sendCount: 1,
        verifyFailCount: 0,
        lastSentAt: now,
      });
    } else {
      record.codeHash = codeHash;
      record.expiresAt = expiresAt;
      record.usedAt = undefined;
      record.lastSentAt = now;
      record.sendCount = (record.sendCount ?? 0) + 1;
      record.verifyFailCount = 0;
      await record.save();
    }
    const delivered = await this.mailService.sendKycIdentityCode(
      email,
      code,
      this.otpTtlMin(),
    );
    return { delivered, ttlMin: this.otpTtlMin() };
  }

  async submit(userId: string) {
    const record = await this.ensureDraft(userId);
    const missing = this.computeMissing(record);
    if (missing.length > 0) {
      throw new BadRequestException('MISSING_KYC_FIELDS');
    }
    await this.verifyRealIdentityDocuments(record);
    const user = await this.userModel.findById(userId).exec();
    if (!user) throw new BadRequestException('USER_NOT_FOUND');
    record.status = 'pending_otp';
    record.audit = {
      ...(record.audit ?? {}),
      submittedAt: new Date(),
      expiresAt:
        record.audit?.expiresAt ??
        new Date(Date.now() + this.retentionDays() * 86400 * 1000),
    };
    record.attempts = {
      ...(record.attempts ?? {}),
      otpSendCount: (record.attempts?.otpSendCount ?? 0) + 1,
      lastOtpSentAt: new Date(),
    };
    await record.save();
    const otp = await this.sendOtp(userId, user.email);
    return {
      status: record.status,
      delivered: otp.delivered,
      otpTtlMin: otp.ttlMin,
    };
  }

  private async verifyRealIdentityDocuments(record: IdentityVerification) {
    const docs = record.documents ?? ({} as any);
    const front = docs.idFront;
    const back = docs.idBack;

    if (!front?.url || !back?.url) {
      throw new BadRequestException('MISSING_KYC_FIELDS');
    }

    const minBytes = this.docMinBytes();
    if ((front.size ?? 0) < minBytes || (back.size ?? 0) < minBytes) {
      throw new BadRequestException('KYC_DOC_IMAGE_TOO_SMALL');
    }

    if (front.sha256 && back.sha256 && front.sha256 === back.sha256) {
      throw new BadRequestException('KYC_DOC_DUPLICATE_IMAGES');
    }

    await this.ensurePersonalMatchesUserProfile(record);

    if (this.localDocCheckEnabled()) {
      await this.checkLocalIdentityConsistency(record);
    }

    if (!this.docVerifierEnabled()) return;

    const verifierUrl = (process.env.KYC_DOC_VERIFIER_URL ?? '').trim();
    if (!verifierUrl) {
      if (this.docVerifierStrict()) {
        throw new BadRequestException('KYC_DOC_VERIFIER_NOT_CONFIGURED');
      }
      return;
    }

    const controller = new AbortController();
    const timer = setTimeout(
      () => controller.abort(),
      this.docVerifierTimeoutMs(),
    );
    try {
      const payload = {
        userId: record.userId,
        verificationId: record._id.toString(),
        personal: {
          name: record.personal?.name ?? '',
          surname: record.personal?.surname ?? '',
          birthDate: record.personal?.birthDate ?? '',
        },
        documents: {
          idFrontUrl: front.url,
          idBackUrl: back.url,
          selfieUrl: docs.selfie?.url ?? '',
        },
      };

      const response = await fetch(verifierUrl, {
        method: 'POST',
        headers: {
          'content-type': 'application/json',
          ...(process.env.KYC_DOC_VERIFIER_API_KEY
            ? { 'x-api-key': process.env.KYC_DOC_VERIFIER_API_KEY }
            : {}),
        },
        body: JSON.stringify(payload),
        signal: controller.signal,
      });

      if (!response.ok) {
        if (this.docVerifierStrict()) {
          throw new BadRequestException('KYC_DOC_VERIFICATION_UNAVAILABLE');
        }
        return;
      }

      const raw = (await response.json()) as Record<string, any>;
      const isIdDocument =
        raw?.isIdDocument === true ||
        raw?.isValidId === true ||
        raw?.valid === true;
      const confidence = Number(raw?.confidence ?? raw?.score ?? 0);
      const minConfidence = this.docVerifierMinConfidence();

      if (!isIdDocument) {
        throw new BadRequestException('KYC_DOC_NOT_REAL_ID');
      }
      if (Number.isFinite(confidence) && confidence < minConfidence) {
        throw new BadRequestException('KYC_DOC_LOW_CONFIDENCE');
      }
    } catch (error) {
      if (error instanceof BadRequestException) {
        throw error;
      }
      if (this.docVerifierStrict()) {
        throw new BadRequestException('KYC_DOC_VERIFICATION_UNAVAILABLE');
      }
    } finally {
      clearTimeout(timer);
    }
  }

  async verifyOtp(userId: string, code: string) {
    this.ensureEnabled();
    const normalizedCode = this._normalizeOtp(code);
    if (normalizedCode.length !== 6) {
      throw new BadRequestException('OTP_INVALID');
    }
    const record = await this.identityModel.findOne({ userId }).exec();
    if (!record) throw new BadRequestException('KYC_NOT_STARTED');
    if (record.status !== 'pending_otp') {
      throw new BadRequestException('INVALID_STATE');
    }
    const now = new Date();
    const tcNo = this._normalizeNationalId(record.personal?.tcNo ?? '');
    if (!this.validateTcNo(tcNo)) {
      throw new BadRequestException('TC_INVALID');
    }
    await this._ensureNationalIdAvailable(tcNo, userId);
    const recentCodes = await this.kycCodeModel
      .find({ userId, purpose: 'kyc_identity' })
      .sort({ updatedAt: -1, createdAt: -1 })
      .limit(10)
      .exec();
    if (recentCodes.length === 0) throw new BadRequestException('OTP_INVALID');
    const activeCode =
      recentCodes.find((item) => !item.usedAt) ?? recentCodes[0];
    if ((activeCode.verifyFailCount ?? 0) >= 5) {
      throw new BadRequestException('OTP_ATTEMPTS_EXCEEDED');
    }
    const hash = this._hashOtp(normalizedCode, userId);
    const matched = recentCodes.find(
      (item) => !item.usedAt && item.expiresAt >= now && item.codeHash === hash,
    );
    if (!matched) {
      activeCode.verifyFailCount = (activeCode.verifyFailCount ?? 0) + 1;
      await activeCode.save();
      record.attempts = {
        ...(record.attempts ?? {}),
        otpVerifyFailCount: (record.attempts?.otpVerifyFailCount ?? 0) + 1,
      };
      await record.save();
      throw new BadRequestException('OTP_INVALID');
    }
    matched.usedAt = now;
    matched.verifyFailCount = 0;
    await matched.save();
    record.status = 'verified';
    record.audit = {
      ...(record.audit ?? {}),
      verifiedAt: now,
    };
    await record.save();
    await this.userModel
      .findByIdAndUpdate(
        userId,
        {
          $set: {
            identityVerified: true,
            nationalId: tcNo,
          },
        },
        { new: true },
      )
      .exec();
    return { status: record.status };
  }

  async resendOtp(userId: string) {
    this.ensureEnabled();
    const record = await this.identityModel.findOne({ userId }).exec();
    if (!record) throw new BadRequestException('KYC_NOT_STARTED');
    if (record.status !== 'pending_otp') {
      throw new BadRequestException('INVALID_STATE');
    }
    const user = await this.userModel.findById(userId).exec();
    if (!user) throw new BadRequestException('USER_NOT_FOUND');
    const otp = await this.sendOtp(userId, user.email);
    record.attempts = {
      ...(record.attempts ?? {}),
      otpSendCount: (record.attempts?.otpSendCount ?? 0) + 1,
      lastOtpSentAt: new Date(),
    };
    await record.save();
    return {
      status: record.status,
      delivered: otp.delivered,
      otpTtlMin: otp.ttlMin,
    };
  }

  async approve(userId: string, reviewedBy: string) {
    this.ensureEnabled();
    const record = await this.identityModel.findOne({ userId }).exec();
    if (!record) throw new BadRequestException('KYC_NOT_STARTED');
    const tcNo = this._normalizeNationalId(record.personal?.tcNo ?? '');
    if (!this.validateTcNo(tcNo)) {
      throw new BadRequestException('TC_INVALID');
    }
    await this._ensureNationalIdAvailable(tcNo, userId);
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
            nationalId: tcNo,
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
