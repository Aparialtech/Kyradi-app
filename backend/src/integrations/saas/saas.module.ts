import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { SaasClient } from './saas.client';
import { SaasIntegrationService } from './saas.service';
import { SaasController } from './saas.controller';
import { Luggage, LuggageSchema } from '../../luggages/schemas/luggage.schema';
import { User, UserSchema } from '../../users/schemas/user.schema';
import { Location, LocationSchema } from '../../locations/schemas/location.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Luggage.name, schema: LuggageSchema },
      { name: User.name, schema: UserSchema },
      { name: Location.name, schema: LocationSchema },
    ]),
  ],
  controllers: [SaasController],
  providers: [SaasClient, SaasIntegrationService],
  exports: [SaasIntegrationService],
})
export class SaasModule {}
