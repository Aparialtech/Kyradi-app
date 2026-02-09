import { Body, Controller, Get, Post, Put, Req, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../common/guards/auth.guard';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { ProfileVerificationService } from './verification.service';
import { IdentityVerificationService } from './identity-verification.service';
import { IdentityPersonalDto } from './dto/identity-personal.dto';

class EmailVerifyDto {
  code: string;
}

@UseGuards(AuthGuard)
@Controller('me')
export class MeController {
  constructor(
    private readonly usersService: UsersService,
    private readonly verificationService: ProfileVerificationService,
    private readonly identityService: IdentityVerificationService,
  ) {}

  @Get()
  getMe(@Req() req: any) {
    return this.usersService.findById(req.user.id);
  }

  @Put('profile')
  updateProfile(@Req() req: any, @Body() dto: UpdateUserDto) {
    return this.usersService.updateProfile(req.user.id, dto);
  }

  @Post('verification/email/start')
  startEmailVerification(@Req() req: any) {
    return this.verificationService.startEmailVerification(req.user.id);
  }

  @Post('verification/email/verify')
  verifyEmail(@Req() req: any, @Body() dto: EmailVerifyDto) {
    return this.verificationService.verifyEmailCode(req.user.id, dto.code);
  }

  @Post('verification/identity/start')
  startIdentity(@Req() req: any) {
    const ip =
      (req.headers['x-forwarded-for'] ?? req.ip ?? '').toString().split(',')[0].trim();
    const ua = (req.headers['user-agent'] ?? '').toString();
    return this.identityService.ensureDraft(req.user.id, { ip, userAgent: ua }).then((record) => ({
      verificationId: record._id.toString(),
      status: record.status,
      requireSelfie: this.identityService.requireSelfie(),
      missing: this.identityService.computeMissing(record),
    }));
  }

  @Put('verification/identity/personal')
  saveIdentityPersonal(@Req() req: any, @Body() dto: IdentityPersonalDto) {
    const ip =
      (req.headers['x-forwarded-for'] ?? req.ip ?? '').toString().split(',')[0].trim();
    const ua = (req.headers['user-agent'] ?? '').toString();
    return this.identityService.savePersonal(req.user.id, dto, { ip, userAgent: ua });
  }

  @Post('verification/identity/submit')
  submitIdentity(@Req() req: any) {
    return this.identityService.submit(req.user.id);
  }

  @Get('verification/identity/status')
  identityStatus(@Req() req: any) {
    return this.identityService.getStatus(req.user.id);
  }
}
