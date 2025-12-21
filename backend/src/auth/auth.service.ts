import { Injectable, UnauthorizedException, BadRequestException, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { UsersService } from '../users/users.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { verifyPassword, hashPassword } from '../common/utils/password.util';
import { generateToken } from '../common/utils/token.util';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { ResetToken } from './schemas/reset-token.schema';
import { MailService } from '../common/mail/mail.service';
import { VerificationCode } from './schemas/verification-code.schema';
import { VerifyCodeDto } from './dto/verify-code.dto';
import { ResendVerifyDto } from './dto/resend-verify.dto';

@Injectable()
export class AuthService {
  private readonly secret = process.env.JWT_SECRET || 'super-secret-key';

  constructor(
    private readonly usersService: UsersService,
    private readonly mailService: MailService,
    @InjectModel(ResetToken.name)
    private readonly resetTokenModel: Model<ResetToken>,
    @InjectModel(VerificationCode.name)
    private readonly verificationCodeModel: Model<VerificationCode>,
  ) {}

  async register(dto: CreateUserDto) {
    const user = await this.usersService.create(dto);
    const token = this.generateToken(user._id?.toString() ?? user['id'], user.email);
    await this.issueVerificationCode(user.email);
    return {
      accessToken: token,
      user,
      pendingVerification: true,
      message: 'Kayıt oluşturuldu. Doğrulama kodu gönderildi.',
    };
  }

  async login(dto: LoginDto) {
    const userDoc = await this.usersService.findByEmail(dto.email);
    if (!userDoc) {
      throw new UnauthorizedException('Invalid credentials');
    }
    if (!verifyPassword(dto.password, userDoc.passwordHash)) {
      throw new UnauthorizedException('Invalid credentials');
    }
    if ((userDoc.verified ?? true) === false) {
      throw new ForbiddenException('Hesabını doğrulaman gerekiyor');
    }
    const safeUser = this.usersService.toSafeObject(userDoc as any);
    const token = this.generateToken(userDoc.id, userDoc.email);
    return { accessToken: token, user: safeUser };
  }

  private generateToken(userId: string, email: string) {
    return generateToken({ sub: userId, email }, this.secret);
  }

  async forgot(dto: ForgotPasswordDto) {
    const user = await this.usersService.findByEmail(dto.email);
    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);
    await this.resetTokenModel.deleteMany({ email: dto.email.toLowerCase() });
    await this.resetTokenModel.create({ email: dto.email.toLowerCase(), code, expiresAt });
    const mailSent = await this.mailService.sendResetCode(dto.email, code);

    const response: Record<string, unknown> = {
      message: mailSent
        ? 'Şifre sıfırlama kodu e-posta ile gönderildi'
        : 'Kod oluşturuldu ancak e-posta gönderilemedi',
      delivered: mailSent,
    };

    const exposeCode =
      (process.env.NODE_ENV !== 'production' && process.env.EXPOSE_RESET_CODE !== 'false') ||
      !mailSent;
    if (exposeCode) {
      response['code'] = code;
    }

    return response;
  }

  private async issueVerificationCode(email: string) {
    const normalized = email.toLowerCase();
    await this.verificationCodeModel.deleteMany({ email: normalized });
    const code = Math.floor(100000 + Math.random() * 900000).toString();
    const expiresAt = new Date(Date.now() + 15 * 60 * 1000);
    await this.verificationCodeModel.create({ email: normalized, code, expiresAt });
    const delivered = await this.mailService.sendVerificationCode(email, code);
    return { code, delivered };
  }

  async verifyCode(dto: VerifyCodeDto) {
    const normalized = dto.email.toLowerCase();
    const record = await this.verificationCodeModel
      .findOne({ email: normalized, code: dto.code })
      .exec();
    if (!record || record.expiresAt < new Date()) {
      throw new BadRequestException('Kod geçersiz veya süresi dolmuş');
    }
    const user = await this.usersService.findByEmail(dto.email);
    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    user.verified = true;
    await user.save();
    await this.verificationCodeModel.deleteMany({ email: normalized });
    return { message: 'Hesap doğrulandı' };
  }

  async resendVerification(dto: ResendVerifyDto) {
    const user = await this.usersService.findByEmail(dto.email);
    if (!user) {
      throw new NotFoundException('Kullanıcı bulunamadı');
    }
    if (user.verified) {
      return { message: 'Hesap zaten doğrulandı', alreadyVerified: true };
    }
    const { delivered, code } = await this.issueVerificationCode(dto.email);
    const exposeCode =
      (process.env.NODE_ENV !== 'production' && process.env.EXPOSE_VERIFICATION_CODE !== 'false') ||
      !delivered;
    return {
      message: delivered ? 'Doğrulama kodu gönderildi' : 'Kod oluşturuldu ancak e-posta gönderilemedi',
      delivered,
      ...(exposeCode ? { code } : {}),
    };
  }

  async reset(dto: ResetPasswordDto) {
    const token = await this.resetTokenModel
      .findOne({ email: dto.email.toLowerCase(), code: dto.code })
      .exec();
    if (!token || token.expiresAt < new Date()) {
      throw new BadRequestException('Kod geçersiz veya süresi dolmuş');
    }
    const user = await this.usersService.findByEmail(dto.email);
    if (!user) throw new NotFoundException('Kullanıcı bulunamadı');
    user.passwordHash = hashPassword(dto.newPassword);
    await user.save();
    await this.resetTokenModel.deleteMany({ email: dto.email.toLowerCase() });
    return { message: 'Şifre güncellendi' };
  }

  async changePassword(dto: ChangePasswordDto) {
    const userDoc = await this.usersService.findDocumentById(dto.userId);
    if (!userDoc || !verifyPassword(dto.oldPassword, userDoc.passwordHash)) {
      throw new UnauthorizedException('Eski şifre hatalı');
    }
    userDoc.passwordHash = hashPassword(dto.newPassword);
    await userDoc.save();
    return { message: 'Şifre değiştirildi' };
  }
}
