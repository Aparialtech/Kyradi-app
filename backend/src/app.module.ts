import { Module } from '@nestjs/common';
import { APP_GUARD } from '@nestjs/core';
import { ConfigModule } from '@nestjs/config';
import { MongooseModule } from '@nestjs/mongoose';
import { ThrottlerGuard, ThrottlerModule } from '@nestjs/throttler';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { LocationsModule } from './locations/locations.module';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';
import { LuggagesModule } from './luggages/luggages.module';
import { UploadsModule } from './uploads/uploads.module';
import { PaymentsModule } from './payments/payments.module';
import { PricingModule } from './pricing/pricing.module';
import { DirectionsModule } from './directions/directions.module';
import { AuthGuard } from './common/guards/auth.guard';
import { ChatModule } from './chat/chat.module';
import { ReservationsModule } from './reservations/reservations.module';
import { WalletModule } from './wallet/wallet.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env.local', '.env'],
    }),
    ThrottlerModule.forRoot({
      throttlers: [
        {
          // @nestjs/throttler v5+ expects ttl in milliseconds.
          // Backward compatible: if env is given in seconds (<= 1000), convert to ms.
          ttl: (() => {
            const raw = Number(process.env.THROTTLE_TTL ?? 60);
            if (!Number.isFinite(raw) || raw <= 0) return 60_000;
            return raw <= 1000 ? raw * 1000 : raw;
          })(),
          limit: Number(process.env.THROTTLE_LIMIT ?? 60),
        },
      ],
    }),
    MongooseModule.forRoot(process.env.MONGODB_URI || ''),
    AuthModule,
    UsersModule,
    LuggagesModule,
    LocationsModule,
    UploadsModule,
    PaymentsModule,
    PricingModule,
    DirectionsModule,
    ChatModule,
    ReservationsModule,
    WalletModule,
  ],
  controllers: [AppController],
  providers: [
    AppService,
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
    {
      provide: APP_GUARD,
      useClass: AuthGuard,
    },
  ],
})
export class AppModule {}
