import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { UsersModule } from '../users/users.module';
import { ResetToken, ResetTokenSchema } from './schemas/reset-token.schema';
import { VerificationCode, VerificationCodeSchema } from './schemas/verification-code.schema';
import { MailService } from '../common/mail/mail.service';

@Module({
  imports: [
    UsersModule,
    MongooseModule.forFeature([
      { name: ResetToken.name, schema: ResetTokenSchema },
      { name: VerificationCode.name, schema: VerificationCodeSchema },
    ]),
  ],
  controllers: [AuthController],
  providers: [AuthService, MailService]
})
export class AuthModule {}
