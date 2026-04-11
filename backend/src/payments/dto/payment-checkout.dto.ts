import { IsIn, IsInt, IsOptional, IsString, Min } from 'class-validator';

export class PaymentCheckoutDto {
  @IsString()
  reservationId: string;

  @IsIn(['card', 'installment', 'pay_at_hotel', 'transfer'])
  paymentMethod: 'card' | 'installment' | 'pay_at_hotel' | 'transfer';

  @IsOptional()
  @IsInt()
  @Min(1)
  installmentCount?: number;
}
