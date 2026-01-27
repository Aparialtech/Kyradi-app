import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { jwtVerify } from 'jose';
import { Request } from 'express';
import { verifyToken } from '../utils/token.util';
import { IS_PUBLIC_KEY } from '../decorators/public.decorator';

type AuthUser = {
  id: string;
  email?: string;
  tokenType: 'jwt' | 'legacy';
};

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const isPublic = this.reflector.getAllAndOverride<boolean>(IS_PUBLIC_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);
    if (isPublic) {
      return true;
    }

    const request = context.switchToHttp().getRequest<Request>();
    const token = this.extractToken(request);
    const headerPresent = !!request.headers.authorization;
    const bearerPresent = headerPresent && request.headers.authorization?.toLowerCase().startsWith('bearer ');
    const tokenLen = token?.length ?? 0;
    if (!token) {
      console.log('AUTH_GUARD', `headerPresent=${headerPresent}`, `bearerPresent=${bearerPresent}`, `tokenLen=${tokenLen}`, 'verifyOk=false');
      throw new UnauthorizedException('UNAUTHORIZED');
    }

    const user =
      (await this.verifyJwt(token)) ??
      this.verifyLegacy(token) ??
      null;

    if (!user) {
      console.log('AUTH_GUARD', `headerPresent=${headerPresent}`, `bearerPresent=${bearerPresent}`, `tokenLen=${tokenLen}`, 'verifyOk=false');
      throw new UnauthorizedException('UNAUTHORIZED');
    }

    console.log('AUTH_GUARD', `headerPresent=${headerPresent}`, `bearerPresent=${bearerPresent}`, `tokenLen=${tokenLen}`, 'verifyOk=true');
    (request as any).user = user;
    return true;
  }

  private extractToken(req: Request): string | null {
    const header = req.headers.authorization;
    if (!header) return null;
    const [type, value] = header.split(' ');
    if (type?.toLowerCase() !== 'bearer' || !value) return null;
    return value.trim();
  }

  private async verifyJwt(token: string): Promise<AuthUser | null> {
    const secret = process.env.JWT_SECRET;
    if (!secret) return null;
    try {
      const { payload } = await jwtVerify(token, new TextEncoder().encode(secret), {
        algorithms: ['HS256'],
      });
      const sub = payload.sub?.toString();
      if (!sub) return null;
      return {
        id: sub,
        email: payload.email?.toString(),
        tokenType: 'jwt',
      };
    } catch {
      return null;
    }
  }

  private verifyLegacy(token: string): AuthUser | null {
    const secret = process.env.JWT_SECRET;
    if (!secret) return null;
    const payload = verifyToken(token, secret);
    if (!payload) return null;
    return { id: payload.sub, email: payload.email, tokenType: 'legacy' };
  }
}
