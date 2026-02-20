import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Put,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminRoleGuard } from '../common/guards/admin-role.guard';
import { Roles } from '../common/decorators/roles.decorator';
import { UpsertLocationDto } from './dto/upsert-location.dto';
import { UpsertCampaignDto } from './dto/upsert-campaign.dto';
import { AdminPanelApiKeyGuard } from '../common/guards/admin-panel-api-key.guard';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @UseGuards(AdminPanelApiKeyGuard)
  @Post('bootstrap/promote-self')
  promoteSelf(@Req() req: any) {
    const userId = req?.user?.id?.toString() ?? '';
    return this.adminService.promoteSelfToAdmin(userId);
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Get('overview')
  overview() {
    return this.adminService.getOverview();
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Get('locations')
  locations() {
    return this.adminService.listLocations();
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Post('locations')
  createLocation(@Body() dto: UpsertLocationDto) {
    return this.adminService.createLocation(dto);
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Put('locations/:id')
  updateLocation(@Param('id') id: string, @Body() dto: UpsertLocationDto) {
    return this.adminService.updateLocation(id, dto);
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Get('campaigns')
  campaigns() {
    return this.adminService.listCampaigns();
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Post('campaigns')
  createCampaign(@Body() dto: UpsertCampaignDto, @Req() req: any) {
    const actor = req?.adminUser?.id?.toString() ?? req?.user?.id?.toString() ?? 'system';
    return this.adminService.createCampaign(dto, actor);
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Put('campaigns/:id')
  updateCampaign(
    @Param('id') id: string,
    @Body() dto: UpsertCampaignDto,
    @Req() req: any,
  ) {
    const actor = req?.adminUser?.id?.toString() ?? req?.user?.id?.toString() ?? 'system';
    return this.adminService.updateCampaign(id, dto, actor);
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Get('users')
  users(@Query('q') q?: string) {
    return this.adminService.listUsers(q);
  }

  @UseGuards(AdminRoleGuard)
  @Roles('admin', 'editor')
  @Get('users/:id/activities')
  userActivities(@Param('id') id: string) {
    return this.adminService.getUserActivities(id);
  }
}
