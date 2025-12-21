import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

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
}

export const LocationSchema = SchemaFactory.createForClass(Location);
LocationSchema.path('_id', String);
LocationSchema.path('_id', String);
