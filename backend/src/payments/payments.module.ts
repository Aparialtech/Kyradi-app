import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { PaymentsController } from './payments.controller';
import { PaymentsService } from './payments.service';
import { Luggage, LuggageSchema } from '../luggages/schemas/luggage.schema';

@Module({
  imports: [
    MongooseModule.forFeature([{ name: Luggage.name, schema: LuggageSchema }]),
  ],
  controllers: [PaymentsController],
  providers: [PaymentsService],
})
export class PaymentsModule {}
