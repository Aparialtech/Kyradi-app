import { IsIn, IsOptional, IsString } from 'class-validator';

export class MockPaymentDto {
  @IsOptional()
  amount?: number;

  @IsOptional()
  @IsString()
  currency?: string;

  @IsOptional()
  @IsIn(['standard', 'premium'])
  protectionLevel?: 'standard' | 'premium';

  @IsOptional()
  @IsString()
  bookingId?: string;
}
