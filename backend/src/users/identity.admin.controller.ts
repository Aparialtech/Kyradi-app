import { Body, Controller, Param, Post, Req, UseGuards } from '@nestjs/common';
import { IdentityVerificationService } from './identity-verification.service';
import { AdminApiKeyGuard } from '../common/guards/admin-api-key.guard';

class RejectDto {
  reason: string;
}

@UseGuards(AdminApiKeyGuard)
@Controller('admin/identity')
export class IdentityAdminController {
  constructor(private readonly identityService: IdentityVerificationService) {}

  @Post(':userId/approve')
  approve(@Param('userId') userId: string, @Req() req: any) {
    const actor = (req as any).adminActor ?? 'admin';
    return this.identityService.approve(userId, actor);
  }

  @Post(':userId/reject')
  reject(
    @Param('userId') userId: string,
    @Body() dto: RejectDto,
    @Req() req: any,
  ) {
    const actor = (req as any).adminActor ?? 'admin';
    return this.identityService.reject(userId, actor, dto.reason);
  }
}

