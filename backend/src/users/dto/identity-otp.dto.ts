import { IsString, Length } from 'class-validator';

export class IdentityOtpDto {
  @IsString()
  @Length(6, 6)
  code: string;
}
