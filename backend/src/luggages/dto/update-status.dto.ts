import { IsEnum, IsOptional, IsString } from 'class-validator';
import { LuggageStatus } from '../schemas/luggage.schema';

export class UpdateLuggageStatusDto {
  @IsEnum(LuggageStatus)
  status: LuggageStatus;

  @IsOptional()
  @IsString()
  pickupPin?: string;

  @IsOptional()
  @IsString()
  delegateCode?: string;
}
