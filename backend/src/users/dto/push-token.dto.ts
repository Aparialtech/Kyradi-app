import { IsBoolean, IsOptional, IsString, MaxLength } from 'class-validator';

export class PushTokenDto {
  @IsString()
  @MaxLength(2048)
  token!: string;

  @IsOptional()
  @IsString()
  @MaxLength(32)
  platform?: string;

  @IsOptional()
  @IsString()
  @MaxLength(32)
  appVersion?: string;

  @IsOptional()
  @IsBoolean()
  enabled?: boolean;
}

