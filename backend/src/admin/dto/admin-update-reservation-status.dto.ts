import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';
import { LuggageStatus } from '../../luggages/schemas/luggage.schema';

export class AdminUpdateReservationStatusDto {
  @IsEnum(LuggageStatus)
  status!: LuggageStatus;

  @IsOptional()
  @IsString()
  @MaxLength(120)
  storageUnit?: string;
}
