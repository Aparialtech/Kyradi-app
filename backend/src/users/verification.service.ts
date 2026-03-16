import { BadRequestException, Injectable } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { createHash } from 'crypto';
import { ProfileVerificationCode } from './schemas/profile-verification.schema';
import { User } from './schemas/user.schema';
import { MailService } from '../common/mail/mail.service';

@Injectable()
export class ProfileVerificationService {
  constructor(
    @InjectModel(ProfileVerificationCode.name)
    private readonly verificationModel: Model<ProfileVerificationCode>,
    @InjectModel(User.name)
    private readonly userModel: Model<User>,
    private readonly mailService: MailService,
  ) {}

  private hashOtp(code: string, userId: string): string {
    const secret = process.env.JWT_SECRET || 'kyradi-email-otp';
    return createHash('sha256')
      .update(`${code}:${secret}:${userId}`)
      .digest('hex');
  }

  async startEmailVerification(userId: string) {
    const user = await this.userModel.findById(userId).exec();
    if (!user) throw new BadRequestException('USER_NOT_FOUND');
    const existing = await this.verificationModel
      .findOne({ userId })
      .sort({ lastSentAt: -1 })
      .exec();
    if (existing && existing.lastSentAt) {
      const delta = Date.now() - new Date(existing.lastSentAt).getTime();
      if (delta < 60 * 1000) {
        throw new BadRequestException('OTP_RATE_LIMIT');
      }
    }
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const codeHash = this.hashOtp(code, userId);
    const expiresAt = new Date(Date.now() + 10 * 60 * 1000);
    await this.verificationModel.deleteMany({ userId });
    await this.verificationModel.create({
      userId,
      email: user.email.toLowerCase(),
      codeHash,
      expiresAt,
      attempts: 0,
      lastSentAt: new Date(),
    });
    const delivered = await this.mailService.sendVerificationCode(user.email, code);
    user.verificationStatus = 'pending';
    user.verificationRequestedAt = new Date();
    await user.save();
    return {
      delivered,
      message: delivered
        ? 'Doğrulama kodu gönderildi'
        : 'Kod oluşturuldu ancak e-posta gönderilemedi',
    };
  }

  private normalizeOtp(code: string): string {
    return (code ?? '').replace(/[^0-9]/g, '');
  }

  async verifyEmailCode(userId: string, code: string) {
    const normalizedCode = this.normalizeOtp(code);
    if (normalizedCode.length !== 6) {
      throw new BadRequestException('OTP_INVALID');
    }
    const record = await this.verificationModel
      .findOne({ userId })
      .sort({ lastSentAt: -1, createdAt: -1 })
      .exec();
    if (!record) throw new BadRequestException('OTP_INVALID');
    if (record.expiresAt < new Date()) {
      throw new BadRequestException('OTP_EXPIRED');
    }
    if ((record.attempts ?? 0) >= 5) {
      throw new BadRequestException('OTP_ATTEMPTS_EXCEEDED');
    }
    const hash = this.hashOtp(normalizedCode, userId);
    const isMatch =
      (record.codeHash?.length ?? 0) > 0
        ? record.codeHash === hash
        : record.code === normalizedCode;
    if (!isMatch) {
      record.attempts = (record.attempts ?? 0) + 1;
      await record.save();
      throw new BadRequestException('OTP_INVALID');
    }
    await this.verificationModel.deleteMany({ userId });
    const user = await this.userModel.findById(userId).exec();
    if (user) {
      user.verificationStatus = 'verified';
      user.verifiedAt = new Date();
      await user.save();
    }
    return { message: 'Hesap doğrulandı', verified: true };
  }
}
