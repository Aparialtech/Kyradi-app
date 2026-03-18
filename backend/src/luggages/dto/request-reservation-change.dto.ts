import { IsISO8601, IsOptional, IsString } from 'class-validator';

export class RequestReservationChangeDto {
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
  dropLocationId?: string;

  @IsOptional()
  @IsString()
  dropLocationName?: string;

  @IsOptional()
  @IsISO8601()
  scheduledDropTime?: string;

  @IsOptional()
  @IsISO8601()
  scheduledPickupTime?: string;

  @IsOptional()
  @IsString()
  pickupDelegateFullName?: string;

  @IsOptional()
  @IsString()
  pickupDelegatePhone?: string;

  @IsOptional()
  @IsString()
  pickupDelegateEmail?: string;
}
