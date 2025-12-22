import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export enum LuggageStatus {
  AWAITING = 'awaiting_drop',
  DROPPED = 'dropped',
  PICKED = 'picked_up',
  CANCELLED = 'cancelled',
}

@Schema({ _id: false })
export class PickupDelegate {
  @Prop()
  fullName?: string;

  @Prop()
  phone?: string;

  @Prop()
  email?: string;
}

export const PickupDelegateSchema = SchemaFactory.createForClass(PickupDelegate);

@Schema({ collection: 'luggages', timestamps: true })
export class Luggage extends Document {
  @Prop({ type: String, required: true })
  userId: string;

  @Prop({ required: true, unique: true })
  qrCode: string;

  @Prop({ required: true })
  pickupPinHash: string;

  @Prop({ type: PickupDelegateSchema })
  pickupDelegate?: PickupDelegate;

  @Prop()
  delegateCodeHash?: string;

  @Prop()
  delegateExpiresAt?: Date;

  @Prop()
  delegateUsedAt?: Date;

  @Prop()
  label?: string;

  @Prop()
  size?: string;

  @Prop()
  weight?: string;

  @Prop()
  color?: string;

  @Prop()
  note?: string;

  @Prop({ enum: LuggageStatus, default: LuggageStatus.AWAITING })
  status: LuggageStatus;

  @Prop({ required: true })
  dropLocationId: string;

  @Prop({ required: true })
  dropLocationName: string;

  @Prop()
  scheduledDropTime?: Date;

  @Prop()
  scheduledPickupTime?: Date;

  @Prop()
  dropConfirmedAt?: Date;

  @Prop()
  pickupConfirmedAt?: Date;
}

export const LuggageSchema = SchemaFactory.createForClass(Luggage);
