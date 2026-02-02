import { IsNumber, IsOptional, IsString, Min } from 'class-validator';

export class WalletPayDto {
  @IsString()
  reservationId!: string;

  @IsOptional()
  @IsNumber()
  @Min(1)
  amount?: number;
}
