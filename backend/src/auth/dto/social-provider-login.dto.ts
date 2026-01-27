import { IsOptional, IsString } from 'class-validator';

export class SocialProviderLoginDto {
  @IsOptional()
  @IsString()
  idToken?: string;

  @IsOptional()
  @IsString()
  accessToken?: string;

  @IsOptional()
  @IsString()
  authorizationCode?: string;

  @IsOptional()
  @IsString()
  platform?: 'ios' | 'android';

  @IsOptional()
  @IsString()
  deviceId?: string;
}
