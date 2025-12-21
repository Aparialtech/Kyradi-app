import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { LocationsService } from './locations.service';
import { LocationsController } from './locations.controller';
import { Location, LocationSchema } from './schemas/location.schema';

@Module({
  imports: [MongooseModule.forFeature([{ name: Location.name, schema: LocationSchema }])],
  providers: [LocationsService],
  controllers: [LocationsController],
})
export class LocationsModule {}
