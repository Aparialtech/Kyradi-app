import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ _id: false })
export class EmergencyContact {
  @Prop()
  fullName?: string;

  @Prop()
  phone?: string;

  @Prop()
  email?: string;

  @Prop()
  address?: string;

  @Prop()
  relation?: string;
}

export const EmergencyContactSchema = SchemaFactory.createForClass(EmergencyContact);

@Schema({ collection: 'users', timestamps: true })
export class User extends Document {
  @Prop({ required: true })
  name: string;

  @Prop({ required: true })
  surname: string;

  @Prop({ required: true, unique: true, lowercase: true })
  email: string;

  @Prop({ required: true })
  passwordHash: string;

  @Prop()
  phone?: string;

  @Prop()
  address?: string;

  @Prop({ default: 'none' })
  gender?: string;

  @Prop()
  identityDocumentUrl?: string;

  @Prop({ type: EmergencyContactSchema })
  emergencyContact?: EmergencyContact;

  @Prop({ default: true })
  pushReminderEnabled: boolean;

  @Prop({ default: true })
  emailReminderEnabled: boolean;

  @Prop({ default: false })
  verified: boolean;
}

export const UserSchema = SchemaFactory.createForClass(User);
