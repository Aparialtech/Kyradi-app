import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { LuggagesController } from './luggages.controller';
import { LuggagesService } from './luggages.service';
import { Luggage, LuggageSchema } from './schemas/luggage.schema';
import { Location, LocationSchema } from '../locations/schemas/location.schema';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Luggage.name, schema: LuggageSchema },
      { name: Location.name, schema: LocationSchema },
    ]),
  ],
  controllers: [LuggagesController],
  providers: [LuggagesService],
  exports: [LuggagesService],
})
export class LuggagesModule {}
