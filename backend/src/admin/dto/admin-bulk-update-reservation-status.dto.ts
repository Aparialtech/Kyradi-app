import { IsArray, IsIn, IsOptional, IsString, MaxLength } from 'class-validator';
import { LuggageStatus } from '../../luggages/schemas/luggage.schema';

export class AdminBulkUpdateReservationStatusDto {
  @IsArray()
  @IsString({ each: true })
  reservationIds!: string[];

  @IsIn([...Object.values(LuggageStatus), 'assigned'])
  status!: LuggageStatus | 'assigned';

  @IsOptional()
  @IsString()
  @MaxLength(120)
  storageUnit?: string;
}
