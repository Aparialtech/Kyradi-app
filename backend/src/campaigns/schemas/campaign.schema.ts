import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'campaigns', timestamps: true })
export class Campaign extends Document {
  @Prop({ required: true, trim: true })
  title: string;

  @Prop({ required: true, trim: true })
  subtitle: string;

  @Prop({ required: true, trim: true })
  details: string;

  @Prop({ default: 'local_offer_outlined' })
  iconKey: string;

  @Prop({ default: '#0F766E' })
  gradientStart: string;

  @Prop({ default: '#5EEAD4' })
  gradientEnd: string;

  @Prop({ default: true })
  isActive: boolean;

  @Prop({ default: 0 })
  sortOrder: number;

  @Prop()
  startsAt?: Date;

  @Prop()
  endsAt?: Date;

  @Prop()
  createdBy?: string;

  @Prop()
  updatedBy?: string;
}

export const CampaignSchema = SchemaFactory.createForClass(Campaign);
CampaignSchema.index({ isActive: 1, sortOrder: 1, updatedAt: -1 });
