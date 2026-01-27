import { Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User, UserSchema } from './schemas/user.schema';
import {
  ProfileVerificationCode,
  ProfileVerificationCodeSchema,
} from './schemas/profile-verification.schema';
import { MailService } from '../common/mail/mail.service';
import { MeController } from './me.controller';
import { ProfileVerificationService } from './verification.service';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: ProfileVerificationCode.name, schema: ProfileVerificationCodeSchema },
    ]),
  ],
  controllers: [UsersController, MeController],
  providers: [UsersService, MailService, ProfileVerificationService],
  exports: [UsersService],
})
export class UsersModule {}
