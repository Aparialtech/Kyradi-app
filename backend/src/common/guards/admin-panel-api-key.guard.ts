import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';

@Injectable()
export class AdminPanelApiKeyGuard implements CanActivate {
  canActivate(context: ExecutionContext): boolean {
    const enabledRaw = (process.env.ADMIN_PANEL_ENABLED ?? 'true')
      .toString()
      .trim()
      .toLowerCase();
    if (enabledRaw === 'false' || enabledRaw === '0' || enabledRaw === 'off') {
      throw new ForbiddenException('ADMIN_PANEL_DISABLED');
    }
    const required = (process.env.ADMIN_API_KEY ?? '').trim();
    if (!required) {
      const isProd = (process.env.NODE_ENV ?? '').toLowerCase() === 'production';
      throw new ForbiddenException(isProd ? 'ADMIN_DISABLED' : 'ADMIN_API_KEY_MISSING');
    }
    const req = context.switchToHttp().getRequest();
    const provided =
      (req.headers['x-admin-api-key'] ?? req.headers['X-Admin-Api-Key'])?.toString() ??
      '';
    if (provided.trim() !== required) {
      throw new ForbiddenException('FORBIDDEN');
    }
    return true;
  }
}
