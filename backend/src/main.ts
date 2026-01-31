import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';
import { join } from 'path';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { Logger } from '@nestjs/common';

async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const isProd = (process.env.NODE_ENV ?? '').toLowerCase() === 'production';
  const requiredKeys = ['MONGODB_URI', 'JWT_SECRET'];
  const optionalKeys = [
    'PORT',
    'GOOGLE_CLIENT_ID',
    'APPLE_AUDIENCE',
    'FIREBASE_SERVICE_ACCOUNT_JSON',
    'FIREBASE_PROJECT_ID',
    'MAIL_PROVIDER',
    'MAIL_FROM',
    'RESEND_API_KEY',
    'MAIL_HOST',
    'MAIL_PORT',
    'MAIL_SECURE',
    'MAIL_USER',
    'MAIL_PASS',
    'GOOGLE_DIRECTIONS_API_KEY',
    'MAGICPAY_WEBHOOK_SECRET',
    'EXPOSE_RESET_CODE',
    'EXPOSE_VERIFICATION_CODE',
    'BUILT_AT',
    'GIT_SHA',
    'RAILWAY_GIT_COMMIT_SHA',
  ];

  const missingRequired = requiredKeys.filter((key) => !process.env[key]);
  const presence = [...requiredKeys, ...optionalKeys].reduce<Record<string, boolean>>(
    (acc, key) => {
      acc[key] = !!process.env[key];
      return acc;
    },
    {},
  );
  logger.log(`ENV presence: ${JSON.stringify(presence)}`);
  if (missingRequired.length > 0) {
    const msg = `Missing required env: ${missingRequired.join(', ')}`;
    if (isProd) {
      logger.error(msg);
      throw new Error(msg);
    } else {
      logger.warn(msg);
    }
  }

  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  app.enableCors();
  app.useGlobalFilters(new AllExceptionsFilter());
  app.useStaticAssets(join(process.cwd(), 'uploads'), {
    prefix: '/uploads/',
  });
  const port = Number(process.env.PORT) || 3000;
  console.log("BOOT OK - directions route should exist");
  await app.listen(port, '0.0.0.0');
}
bootstrap();
