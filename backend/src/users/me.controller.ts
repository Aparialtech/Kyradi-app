import { Body, Controller, Get, Post, Put, Req, UseGuards } from '@nestjs/common';
import { AuthGuard } from '../common/guards/auth.guard';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { ProfileVerificationService } from './verification.service';

class EmailVerifyDto {
  code: string;
}

@UseGuards(AuthGuard)
@Controller('me')
export class MeController {
  constructor(
    private readonly usersService: UsersService,
    private readonly verificationService: ProfileVerificationService,
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
}
