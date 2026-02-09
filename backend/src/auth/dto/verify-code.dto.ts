import { IsEmail, IsString, MinLength } from 'class-validator';

export class VerifyCodeDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(3)
  code: string;
}
