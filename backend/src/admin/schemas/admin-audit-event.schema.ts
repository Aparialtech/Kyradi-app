import { Prop, Schema, SchemaFactory } from '@nestjs/mongoose';
import { Document } from 'mongoose';

@Schema({ collection: 'admin_audit_events', timestamps: true })
export class AdminAuditEvent extends Document {
  @Prop({ required: true })
  type: string;

  @Prop({ required: true })
  action: string;

  @Prop({ required: true })
  entityId: string;

  @Prop()
  actorId?: string;

  @Prop()
  summary?: string;

  @Prop({ type: Object })
  meta?: Record<string, unknown>;
}

export const AdminAuditEventSchema = SchemaFactory.createForClass(AdminAuditEvent);
AdminAuditEventSchema.index({ createdAt: -1 });
AdminAuditEventSchema.index({ type: 1, createdAt: -1 });
