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
import { SocialLoginDto } from './dto/social-login.dto';
import { createRemoteJWKSet, jwtVerify, JWTPayload } from 'jose';

@Injectable()
export class AuthService {
  private readonly secret = process.env.JWT_SECRET || 'super-secret-key';
  private readonly googleJwks = createRemoteJWKSet(
    new URL('https://www.googleapis.com/oauth2/v3/certs'),
  );
  private readonly appleJwks = createRemoteJWKSet(
    new URL('https://appleid.apple.com/auth/keys'),
  );

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

  private async verifyGoogleIdToken(idToken: string) {
    const audience = process.env.GOOGLE_CLIENT_ID;
    if (!audience) {
      throw new BadRequestException('TOKEN_INVALID');
    }
    const { payload } = await jwtVerify(idToken, this.googleJwks, {
      issuer: ['https://accounts.google.com', 'accounts.google.com'],
      audience,
    });
    return payload;
  }

  private async verifyAppleIdToken(idToken: string) {
    const audience = process.env.APPLE_AUDIENCE;
    if (!audience) {
      throw new BadRequestException('TOKEN_INVALID');
    }
    const { payload } = await jwtVerify(idToken, this.appleJwks, {
      issuer: 'https://appleid.apple.com',
      audience,
    });
    return payload;
  }

  private extractProfile(payload: JWTPayload) {
    const email = payload.email?.toString().toLowerCase();
    const sub = payload.sub?.toString();
    const givenName = (payload as any).given_name?.toString();
    const familyName = (payload as any).family_name?.toString();
    const name = (payload as any).name?.toString();
    return { email, sub, givenName, familyName, name };
  }

  private buildName(profile: {
    givenName?: string;
    familyName?: string;
    name?: string;
    email?: string;
  }) {
    const fallback = (profile.email ?? 'Kyradi User').split('@')[0];
    const full = profile.name?.trim();
    if (full && full.includes(' ')) {
      const parts = full.split(' ').filter(Boolean);
      return {
        name: profile.givenName ?? parts[0] ?? fallback,
        surname: profile.familyName ?? parts.slice(1).join(' ') || 'User',
      };
    }
    return {
      name: profile.givenName ?? full ?? fallback,
      surname: profile.familyName ?? 'User',
    };
  }

  async socialLogin(dto: SocialLoginDto) {
    if (dto.provider !== 'google' && dto.provider !== 'apple') {
      throw new BadRequestException('PROVIDER_UNSUPPORTED');
    }
    let payload: JWTPayload;
    try {
      payload =
        dto.provider === 'google'
          ? await this.verifyGoogleIdToken(dto.idToken)
          : await this.verifyAppleIdToken(dto.idToken);
    } catch (_) {
      throw new BadRequestException('TOKEN_INVALID');
    }
    const profile = this.extractProfile(payload);
    if (!profile.sub) {
      throw new BadRequestException('TOKEN_INVALID');
    }

    let user = await this.usersService.findByProvider(dto.provider, profile.sub);
    if (!user && profile.email) {
      user = await this.usersService.findByEmail(profile.email);
      if (user) {
        await this.usersService.attachProvider(
          user,
          dto.provider,
          profile.sub,
          profile.email,
        );
      }
    }

    if (!user) {
      if (!profile.email) {
        throw new BadRequestException('EMAIL_MISSING');
      }
      const nameParts = this.buildName(profile);
      user = await this.usersService.createSocialUser({
        name: nameParts.name,
        surname: nameParts.surname,
        email: profile.email,
        provider: dto.provider,
        sub: profile.sub,
      });
    } else if ((user.verified ?? true) === false) {
      user.verified = true;
      await user.save();
    }

    const safeUser = this.usersService.toSafeObject(user as any);
    const token = this.generateToken(user.id, user.email);
    return { accessToken: token, user: safeUser };
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
