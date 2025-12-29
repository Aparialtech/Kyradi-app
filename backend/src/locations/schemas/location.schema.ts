import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type OpeningHoursRange = {
  start: string;
  end: string;
};

export type OpeningHours = {
  mon?: OpeningHoursRange[];
  tue?: OpeningHoursRange[];
  wed?: OpeningHoursRange[];
  thu?: OpeningHoursRange[];
  fri?: OpeningHoursRange[];
  sat?: OpeningHoursRange[];
  sun?: OpeningHoursRange[];
};

@Schema({ collection: 'locations', timestamps: true })
export class Location extends Document {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  address: string;

  @Prop({ required: true })
  latitude: number;

  @Prop({ required: true })
  longitude: number;

  @Prop({ required: true, min: 0 })
  totalSlots: number;

  @Prop({ required: true, min: 0 })
  availableSlots: number;

  @Prop({ default: 0, min: 0 })
  usedSlots: number;

  @Prop({ default: 50, min: 0 })
  maxCapacity: number;

  @Prop({ type: Object, default: {} })
  openingHours: OpeningHours;

  @Prop({ default: 'Europe/Istanbul' })
  timezone: string;

  @Prop({ default: true })
  isActive: boolean;
}

export const LocationSchema = SchemaFactory.createForClass(Location);
LocationSchema.path('_id', String);
LocationSchema.path('_id', String);
