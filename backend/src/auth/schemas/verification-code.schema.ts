import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'user_verification_codes', timestamps: true })
export class VerificationCode extends Document {
  @Prop({ required: true, lowercase: true })
  email: string;

  @Prop({ required: true })
  code: string;

  @Prop({ required: true })
  expiresAt: Date;
}

export const VerificationCodeSchema = SchemaFactory.createForClass(VerificationCode);
VerificationCodeSchema.index({ email: 1 });
VerificationCodeSchema.index({ email: 1, code: 1 });
VerificationCodeSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
