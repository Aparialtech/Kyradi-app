import { IsIn, IsInt, IsISO8601, IsOptional, IsString, Min } from 'class-validator';

export class PricingEstimateDto {
  @IsIn(['small', 'medium', 'large'])
  sizeClass: 'small' | 'medium' | 'large';

  @IsISO8601()
  dropAt: string;

  @IsISO8601()
  pickupAt: string;

  @IsOptional()
  @IsIn(['standard', 'premium'])
  protectionLevel?: 'standard' | 'premium';

  @IsOptional()
  @IsIn(['card', 'installment', 'pay_at_hotel'])
  paymentMethod?: 'card' | 'installment' | 'pay_at_hotel';

  @IsOptional()
  @IsInt()
  @Min(1)
  installmentCount?: number;

  @IsOptional()
  @IsString()
  locationId?: string;
}
