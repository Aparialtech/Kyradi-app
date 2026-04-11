import {
  IsIn,
  IsInt,
  IsISO8601,
  IsNotEmpty,
  IsOptional,
  IsString,
  Min,
} from 'class-validator';

export class CreateLuggageDto {
  @IsOptional()
  @IsString()
  qrCode?: string;

  @IsOptional()
  @IsString()
  label?: string;

  @IsOptional()
  @IsString()
  size?: string;

  @IsOptional()
  @IsString()
  weight?: string;

  @IsOptional()
  @IsString()
  color?: string;

  @IsOptional()
  @IsString()
  note?: string;

  @IsOptional()
  @IsString()
  ownerName?: string;

  @IsOptional()
  @IsString()
  ownerPhone?: string;

  @IsOptional()
  @IsString()
  ownerEmail?: string;

  @IsOptional()
  @IsIn(['card', 'installment', 'pay_at_hotel', 'transfer', 'wallet'])
  paymentMethod?:
    | 'card'
    | 'installment'
    | 'pay_at_hotel'
    | 'transfer'
    | 'wallet';

  @IsOptional()
  @IsInt()
  @Min(0)
  totalPrice?: number;

  @IsString()
  @IsNotEmpty()
  dropLocationId: string;

  @IsString()
  @IsNotEmpty()
  dropLocationName: string;

  @IsOptional()
  @IsISO8601()
  scheduledDropTime?: Date | string;

  @IsOptional()
  @IsISO8601()
  scheduledPickupTime?: Date | string;
}
