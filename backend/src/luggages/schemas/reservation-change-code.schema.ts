import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'reservation_change_codes', timestamps: true })
export class ReservationChangeCode extends Document {
  @Prop({ required: true })
  userId: string;

  @Prop({ required: true })
  luggageId: string;

  @Prop({ required: true, lowercase: true })
  email: string;

  @Prop({ required: true })
  codeHash: string;

  @Prop({ type: Object, default: {} })
  pendingChanges: Record<string, any>;

  @Prop({ required: true })
  expiresAt: Date;

  @Prop({ default: 0 })
  attempts: number;

  @Prop({ default: () => new Date() })
  lastSentAt: Date;
}

export const ReservationChangeCodeSchema =
  SchemaFactory.createForClass(ReservationChangeCode);

ReservationChangeCodeSchema.index({ userId: 1, luggageId: 1 });
ReservationChangeCodeSchema.index({ luggageId: 1, lastSentAt: -1 });
ReservationChangeCodeSchema.index({ expiresAt: 1 }, { expireAfterSeconds: 0 });
