import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'profile_verification_codes', timestamps: true })
export class ProfileVerificationCode extends Document {
  @Prop({ required: true })
  userId: string;

  @Prop({ required: true })
  email: string;

  @Prop({ required: true })
  code: string;

  @Prop({ required: true })
  expiresAt: Date;

  @Prop({ default: 0 })
  attempts: number;

  @Prop({ default: () => new Date() })
  lastSentAt: Date;
}

export const ProfileVerificationCodeSchema =
  SchemaFactory.createForClass(ProfileVerificationCode);
