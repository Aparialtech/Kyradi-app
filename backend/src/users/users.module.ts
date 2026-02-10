import { forwardRef, Module } from '@nestjs/common';
import { MongooseModule } from '@nestjs/mongoose';
import { UsersController } from './users.controller';
import { UsersService } from './users.service';
import { User, UserSchema } from './schemas/user.schema';
import {
  ProfileVerificationCode,
  ProfileVerificationCodeSchema,
} from './schemas/profile-verification.schema';
import {
  IdentityVerification,
  IdentityVerificationSchema,
} from './schemas/identity-verification.schema';
import {
  KycVerificationCode,
  KycVerificationCodeSchema,
} from './schemas/kyc-verification.schema';
import { MailService } from '../common/mail/mail.service';
import { MeController } from './me.controller';
import { ProfileVerificationService } from './verification.service';
import { IdentityVerificationService } from './identity-verification.service';
import { IdentityAdminController } from './identity.admin.controller';
import { UploadsModule } from '../uploads/uploads.module';

@Module({
  imports: [
    MongooseModule.forFeature([
      { name: User.name, schema: UserSchema },
      { name: ProfileVerificationCode.name, schema: ProfileVerificationCodeSchema },
      { name: IdentityVerification.name, schema: IdentityVerificationSchema },
      { name: KycVerificationCode.name, schema: KycVerificationCodeSchema },
    ]),
    forwardRef(() => UploadsModule),
  ],
  controllers: [UsersController, MeController, IdentityAdminController],
  providers: [
    UsersService,
    MailService,
    ProfileVerificationService,
    IdentityVerificationService,
  ],
  exports: [UsersService, IdentityVerificationService],
})
export class UsersModule {}
