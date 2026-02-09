import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

export type IdentityVerificationStatus =
  | 'unverified'
  | 'pending'
  | 'pending_review'
  | 'verified'
  | 'rejected'
  | 'expired';

@Schema({ _id: false })
export class IdentityPersonalInfo {
  @Prop()
  name?: string;

  @Prop()
  surname?: string;

  @Prop()
  tcNo?: string;

  @Prop()
  birthDate?: string; // YYYY-MM-DD
}

export const IdentityPersonalInfoSchema =
  SchemaFactory.createForClass(IdentityPersonalInfo);

@Schema({ _id: false })
export class IdentityDocumentMeta {
  @Prop()
  url?: string;

  @Prop()
  mime?: string;

  @Prop()
  size?: number;

  @Prop()
  sha256?: string;
}

export const IdentityDocumentMetaSchema =
  SchemaFactory.createForClass(IdentityDocumentMeta);

@Schema({ _id: false })
export class IdentityDocuments {
  @Prop({ type: IdentityDocumentMetaSchema })
  idFront?: IdentityDocumentMeta;

  @Prop({ type: IdentityDocumentMetaSchema })
  idBack?: IdentityDocumentMeta;

  @Prop({ type: IdentityDocumentMetaSchema })
  selfie?: IdentityDocumentMeta;
}

export const IdentityDocumentsSchema =
  SchemaFactory.createForClass(IdentityDocuments);

@Schema({ _id: false })
export class IdentityReview {
  @Prop()
  reviewedBy?: string;

  @Prop()
  reviewedAt?: Date;

  @Prop()
  reason?: string;
}

export const IdentityReviewSchema = SchemaFactory.createForClass(IdentityReview);

@Schema({ _id: false })
export class IdentityAudit {
  @Prop()
  submittedAt?: Date;

  @Prop()
  expiresAt?: Date;
}

export const IdentityAuditSchema = SchemaFactory.createForClass(IdentityAudit);

@Schema({ _id: false })
export class IdentitySecurity {
  @Prop()
  ip?: string;

  @Prop()
  userAgent?: string;
}

export const IdentitySecuritySchema =
  SchemaFactory.createForClass(IdentitySecurity);

@Schema({ collection: 'identity_verifications', timestamps: true })
export class IdentityVerification extends Document {
  @Prop({ required: true, unique: true, index: true })
  userId: string;

  @Prop({ default: 'unverified' })
  status: IdentityVerificationStatus;

  @Prop({ type: IdentityPersonalInfoSchema, default: {} })
  personal: IdentityPersonalInfo;

  @Prop({ type: IdentityDocumentsSchema, default: {} })
  documents: IdentityDocuments;

  @Prop({ type: IdentityReviewSchema, default: {} })
  review: IdentityReview;

  @Prop({ type: IdentityAuditSchema, default: {} })
  audit: IdentityAudit;

  @Prop({ type: IdentitySecuritySchema, default: {} })
  security: IdentitySecurity;
}

export const IdentityVerificationSchema =
  SchemaFactory.createForClass(IdentityVerification);

