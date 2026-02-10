import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'kyc_verification_codes', timestamps: true })
export class KycVerificationCode extends Document {
  @Prop({ required: true, index: true })
  userId: string;

  @Prop({ default: 'kyc_identity', index: true })
  purpose: string;

  @Prop({ required: true })
  codeHash: string;

  @Prop({ required: true })
  expiresAt: Date;

  @Prop()
  usedAt?: Date;

  @Prop({ default: 0 })
  sendCount: number;

  @Prop({ default: 0 })
  verifyFailCount: number;

  @Prop()
  lastSentAt?: Date;
}

export const KycVerificationCodeSchema =
  SchemaFactory.createForClass(KycVerificationCode);
