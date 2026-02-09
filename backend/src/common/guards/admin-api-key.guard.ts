import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';

@Injectable()
export class AdminApiKeyGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const isProd = (process.env.NODE_ENV ?? '').toLowerCase() === 'production';
    const enabled = (process.env.KYC_ENABLED ?? '').toLowerCase() === 'true';
    if (!enabled) {
      throw new ForbiddenException('KYC_DISABLED');
    }
    const required = (process.env.ADMIN_API_KEY ?? '').trim();
    if (!required) {
      // Keep admin endpoints closed by default.
      throw new ForbiddenException(isProd ? 'ADMIN_DISABLED' : 'ADMIN_API_KEY_MISSING');
    }
    const req = context.switchToHttp().getRequest();
    const provided =
      (req.headers['x-admin-api-key'] ?? req.headers['X-Admin-Api-Key'])?.toString() ??
      '';
    if (provided.trim() !== required) {
      throw new ForbiddenException('FORBIDDEN');
    }
    (req as any).adminActor = 'api-key';
    return true;
  }
}

