import { IsIn, IsOptional, IsString } from 'class-validator';

export class PaymentWebhookDto {
  @IsString()
  providerPaymentId: string;

  @IsIn(['success', 'failed', 'paid'])
  status: 'success' | 'failed' | 'paid';

  @IsOptional()
  @IsString()
  transactionId?: string;
}
