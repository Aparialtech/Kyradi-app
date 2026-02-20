import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { AdminRoleGuard } from '../common/guards/admin-role.guard';
import { AdminPanelApiKeyGuard } from '../common/guards/admin-panel-api-key.guard';
import { User, UserSchema } from '../users/schemas/user.schema';
import { Luggage, LuggageSchema } from '../luggages/schemas/luggage.schema';
import { Location, LocationSchema } from '../locations/schemas/location.schema';
import { Campaign, CampaignSchema } from '../campaigns/schemas/campaign.schema';
import {
  AdminAuditEvent,
  AdminAuditEventSchema,
} from './schemas/admin-audit-event.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: Luggage.name, schema: LuggageSchema },
      { name: Location.name, schema: LocationSchema },
      { name: Campaign.name, schema: CampaignSchema },
      { name: AdminAuditEvent.name, schema: AdminAuditEventSchema },
    ]),
  ],
  controllers: [AdminController],
  providers: [AdminService, AdminRoleGuard, AdminPanelApiKeyGuard],
})
export class AdminModule {}
