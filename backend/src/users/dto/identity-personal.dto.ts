import { IsString, Matches, MinLength } from 'class-validator';

export class IdentityPersonalDto {
  @IsString()
  @MinLength(2)
  name: string;

  @IsString()
  @MinLength(2)
  surname: string;

  @IsString()
  @Matches(/^\d{11}$/, { message: 'TC_INVALID' })
  tcNo: string;

  // YYYY-MM-DD
  @IsString()
  @Matches(/^\d{4}-\d{2}-\d{2}$/, { message: 'BIRTHDATE_INVALID' })
  birthDate: string;
}

