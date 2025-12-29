import { IsIn, IsOptional, IsString } from 'class-validator';

export class SocialLoginDto {
  @IsString()
  @IsIn(['google', 'apple'])
  provider: 'google' | 'apple';

  @IsString()
  idToken: string;

  @IsOptional()
  @IsString()
  authorizationCode?: string;
}
