import { IsEnum } from 'class-validator';
import { LuggageStatus } from '../schemas/luggage.schema';

export class UpdateLuggageStatusDto {
  @IsEnum(LuggageStatus)
  status: LuggageStatus;
}
