import { Body, Controller, Post, BadRequestException, UsePipes, ValidationPipe } from '@nestjs/common';
import { Throttle } from '@nestjs/throttler';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { VerifyCodeDto } from './dto/verify-code.dto';
import { ResendVerifyDto } from './dto/resend-verify.dto';
import { SocialLoginDto } from './dto/social-login.dto';
import { SocialProviderLoginDto } from './dto/social-provider-login.dto';
import { Public } from '../common/decorators/public.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @Public()
  @Throttle(10, 60)
  @UsePipes(new ValidationPipe({ transform: true, whitelist: true }))
  register(@Body() dto: CreateUserDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @Public()
  @Throttle(10, 60)
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('forgot')
  @Public()
  @Throttle(3, 300)
  forgot(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgot(dto);
  }

  @Post('reset')
  @Public()
  @Throttle(3, 300)
  reset(@Body() dto: ResetPasswordDto) {
    return this.authService.reset(dto);
  }

  @Post('change-password')
  changePassword(@Body() dto: ChangePasswordDto) {
    return this.authService.changePassword(dto);
  }

  @Post('verify')
  @Public()
  @Throttle(3, 300)
  verify(@Body() dto: VerifyCodeDto) {
    return this.authService.verifyCode(dto);
  }

  @Post('resend-verify')
  @Public()
  @Throttle(3, 300)
  resendVerify(@Body() dto: ResendVerifyDto) {
    return this.authService.resendVerification(dto);
  }

  @Post('social')
  @Public()
  @Throttle(10, 60)
  socialLogin(@Body() dto: SocialLoginDto) {
    console.log('AUTH_SOCIAL_HIT_FROM_NEW_CODE');
    return this.authService.socialLogin(dto);
  }

  @Post('social/google')
  @Public()
  @Throttle(10, 60)
  socialGoogle(@Body() dto: SocialProviderLoginDto) {
    if (!dto.idToken) {
      throw new BadRequestException('SOCIAL_TOKEN_INVALID');
    }
    return this.authService.socialLogin({
      provider: 'google',
      idToken: dto.idToken,
      accessToken: dto.accessToken,
      authorizationCode: dto.authorizationCode,
    });
  }

  @Post('social/apple')
  @Public()
  @Throttle(10, 60)
  socialApple(@Body() dto: SocialProviderLoginDto) {
    return this.authService.socialLogin({
      provider: 'apple',
      idToken: dto.idToken,
      accessToken: dto.accessToken,
      authorizationCode: dto.authorizationCode,
    });
  }
}
