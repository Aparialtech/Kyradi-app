import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'password_reset_tokens', timestamps: true })
export class ResetToken extends Document {
  @Prop({ required: true, lowercase: true })
  email: string;

  @Prop({ required: true })
  code: string;

  @Prop({ required: true })
  expiresAt: Date;
}

export const ResetTokenSchema = SchemaFactory.createForClass(ResetToken);
