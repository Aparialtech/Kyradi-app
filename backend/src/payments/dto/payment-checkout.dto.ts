import { IsIn, IsInt, IsOptional, IsString, Min } from 'class-validator';

export class PaymentCheckoutDto {
  @IsString()
  reservationId: string;

  @IsIn(['card', 'installment', 'pay_at_hotel'])
  paymentMethod: 'card' | 'installment' | 'pay_at_hotel';

  @IsOptional()
  @IsInt()
  @Min(1)
  installmentCount?: number;
}
