import { Module } from '@nestjs/common';
import { ReservationsController } from './reservations.controller';
import { LuggagesModule } from '../luggages/luggages.module';

@Module({
  imports: [LuggagesModule],
  controllers: [ReservationsController],
})
export class ReservationsModule {}
