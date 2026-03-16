import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { LuggagesController } from './luggages.controller';
import { PricingController } from './pricing.controller';
import { LuggagesService } from './luggages.service';
import { Luggage, LuggageSchema } from './schemas/luggage.schema';
import { Location, LocationSchema } from '../locations/schemas/location.schema';
import { User, UserSchema } from '../users/schemas/user.schema';
import { MailService } from '../common/mail/mail.service';
import { LuggagePushService } from './luggage-push.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Luggage.name, schema: LuggageSchema },
      { name: Location.name, schema: LocationSchema },
      { name: User.name, schema: UserSchema },
    ]),
  ],
  controllers: [LuggagesController, PricingController],
  providers: [LuggagesService, MailService, LuggagePushService],
  exports: [LuggagesService],
})
export class LuggagesModule {}
