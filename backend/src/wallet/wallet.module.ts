import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { WalletController } from './wallet.controller';
import { WalletService } from './wallet.service';
import { Wallet, WalletSchema, WalletTransaction, WalletTransactionSchema } from './schemas/wallet.schema';
import { Luggage, LuggageSchema } from '../luggages/schemas/luggage.schema';
import { SaasModule } from '../integrations/saas/saas.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: Wallet.name, schema: WalletSchema },
      { name: WalletTransaction.name, schema: WalletTransactionSchema },
      { name: Luggage.name, schema: LuggageSchema },
    ]),
    SaasModule,
  ],
  controllers: [WalletController],
  providers: [WalletService],
})
export class WalletModule {}
