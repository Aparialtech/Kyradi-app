import { IsString, Length } from 'class-validator';

export class ConfirmReservationChangeDto {
  @IsString()
  @Length(6, 6)
  code: string;
}
