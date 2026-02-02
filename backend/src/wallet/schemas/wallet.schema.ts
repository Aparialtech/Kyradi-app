import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type WalletDocument = Wallet & Document;

@Schema({ collection: 'wallets', timestamps: true })
export class Wallet {
  @Prop({ required: true, unique: true })
  userId: string;

  @Prop({ default: 0 })
  balance: number;
}

export const WalletSchema = SchemaFactory.createForClass(Wallet);

export type WalletTransactionDocument = WalletTransaction & Document;

@Schema({ collection: 'wallet_transactions', timestamps: true })
export class WalletTransaction {
  @Prop({ required: true })
  userId: string;

  @Prop({ required: true })
  type: 'topup' | 'pay' | 'refund';

  @Prop({ required: true })
  amount: number;

  @Prop()
  reservationId?: string;

  @Prop()
  note?: string;
}

export const WalletTransactionSchema = SchemaFactory.createForClass(
  WalletTransaction,
);
