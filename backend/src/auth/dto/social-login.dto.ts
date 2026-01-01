import { IsIn, IsOptional, IsString } from 'class-validator';

export class SocialLoginDto {
  @IsString()
  @IsIn(['google', 'apple'])
  provider: 'google' | 'apple';

  @IsOptional()
  @IsString()
  idToken?: string;

  @IsOptional()
  @IsString()
  accessToken?: string;

  @IsOptional()
  @IsString()
  authorizationCode?: string;
}
