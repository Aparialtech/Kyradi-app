import { Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { LoginDto } from './dto/login.dto';
import { ForgotPasswordDto } from './dto/forgot-password.dto';
import { ResetPasswordDto } from './dto/reset-password.dto';
import { ChangePasswordDto } from './dto/change-password.dto';
import { VerifyCodeDto } from './dto/verify-code.dto';
import { ResendVerifyDto } from './dto/resend-verify.dto';
import { SocialLoginDto } from './dto/social-login.dto';
import { Public } from '../common/decorators/public.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  @Public()
  register(@Body() dto: CreateUserDto) {
    return this.authService.register(dto);
  }

  @Post('login')
  @Public()
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Post('forgot')
  @Public()
  forgot(@Body() dto: ForgotPasswordDto) {
    return this.authService.forgot(dto);
  }

  @Post('reset')
  @Public()
  reset(@Body() dto: ResetPasswordDto) {
    return this.authService.reset(dto);
  }

  @Post('change-password')
  changePassword(@Body() dto: ChangePasswordDto) {
    return this.authService.changePassword(dto);
  }

  @Post('verify')
  @Public()
  verify(@Body() dto: VerifyCodeDto) {
    return this.authService.verifyCode(dto);
  }

  @Post('resend-verify')
  @Public()
  resendVerify(@Body() dto: ResendVerifyDto) {
    return this.authService.resendVerification(dto);
  }

  @Post('social')
  @Public()
  socialLogin(@Body() dto: SocialLoginDto) {
    console.log('AUTH_SOCIAL_HIT_FROM_NEW_CODE');
    return this.authService.socialLogin(dto);
  }
}
