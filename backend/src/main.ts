import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';
import { join } from 'path';
import { AllExceptionsFilter } from './common/filters/all-exceptions.filter';
import { Logger, ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';
import mongoSanitize from 'express-mongo-sanitize';
import express from 'express';

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
    'PAYMENTS_DEMO_MODE',
    'SAAS_ENABLED',
    'SAAS_BASE_URL',
    'SAAS_INTEGRATION_SECRET',
    'SAAS_TIMEOUT_MS',
    'SAAS_RETRY_COUNT',
    'CHAT_PROVIDER',
    'CHAT_API_KEY',
    'CHAT_MODEL',
    'CHAT_TIMEOUT_MS',
    'EXPOSE_RESET_CODE',
    'EXPOSE_VERIFICATION_CODE',
    'PICKUP_PIN_EMAIL_ENABLED',
    'KYC_ENABLED',
    'KYC_REQUIRE_SELFIE',
    'KYC_AUTO_APPROVE_IN_DEV',
    'KYC_DOC_RETENTION_DAYS',
    'KYC_MAX_UPLOAD_MB',
    'KYC_OTP_TTL_MIN',
    'KYC_OTP_RATE_LIMIT',
    'ADMIN_API_KEY',
    'ADMIN_PANEL_ENABLED',
    'BUILT_AT',
    'GIT_SHA',
    'RAILWAY_GIT_COMMIT_SHA',
  ];

  const missingRequired = requiredKeys.filter((key) => !process.env[key]);
  const presence = [...requiredKeys, ...optionalKeys].reduce<
    Record<string, boolean>
  >((acc, key) => {
    acc[key] = !!process.env[key];
    return acc;
  }, {});
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

  const app = await NestFactory.create<NestExpressApplication>(AppModule, {
    bodyParser: false,
  });
  const trustProxy = (process.env.TRUST_PROXY ?? '1').toString();
  if (trustProxy) {
    app.set('trust proxy', trustProxy === 'true' ? 1 : Number(trustProxy) || 1);
  }

  app.disable('x-powered-by');
  app.use(
    helmet({
      contentSecurityPolicy: false,
      crossOriginEmbedderPolicy: false,
      referrerPolicy: { policy: 'no-referrer' },
      hsts: isProd
        ? {
            maxAge: 15552000,
            includeSubDomains: true,
          }
        : false,
    }),
  );

  const jsonLimitMb = Number(process.env.JSON_BODY_LIMIT_MB ?? 1);
  const jsonLimit = `${jsonLimitMb}mb`;
  const rawBodySaver = (req: any, _res: any, buf: Buffer) => {
    if (buf && buf.length > 0) {
      req.rawBody = buf.toString('utf8');
    }
  };
  app.use(express.json({ limit: jsonLimit, verify: rawBodySaver }));
  app.use(
    express.urlencoded({
      extended: true,
      limit: jsonLimit,
      verify: rawBodySaver,
    }),
  );
  // express-mongo-sanitize's built-in middleware tries to re-assign req.query.
  // With newer Express/Nest request objects, req.query may be getter-only, causing 500s.
  // We sanitize in-place to avoid any reassignment while keeping the protection.
  app.use((req, _res, next) => {
    try {
      const sanitize = (mongoSanitize as any).sanitize as
        | ((target: any, options?: any) => any)
        | undefined;
      if (typeof sanitize !== 'function') return next();
      const opts = { replaceWith: '_' };
      if (req.body) sanitize(req.body, opts);
      if (req.params) sanitize(req.params, opts);
      if (req.headers) sanitize(req.headers, opts);
      if (req.query) sanitize(req.query, opts);
      return next();
    } catch (e) {
      return next(e);
    }
  });

  const allowList = (process.env.CORS_ORIGINS ?? '')
    .split(',')
    .map((value) => value.trim())
    .filter(Boolean);
  app.enableCors({
    origin: (origin, callback) => {
      if (!origin) return callback(null, true);
      if (allowList.length === 0) return callback(null, true);
      if (allowList.includes(origin)) return callback(null, true);
      return callback(new Error('CORS_NOT_ALLOWED'), false);
    },
    credentials: false,
  });

  const forbidUnknown =
    (process.env.VALIDATION_FORBID_NON_WHITELISTED ?? '').toLowerCase() ===
    'true';
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: forbidUnknown,
    }),
  );

  app.useGlobalFilters(new AllExceptionsFilter());
  const uploadsDir = process.env.UPLOADS_DIR ?? join(process.cwd(), 'uploads');
  app.useStaticAssets(uploadsDir, {
    prefix: '/uploads/',
  });
  const port = Number(process.env.PORT) || 3000;
  console.log('BOOT OK - directions route should exist');
  await app.listen(port, '0.0.0.0');
}
bootstrap();
