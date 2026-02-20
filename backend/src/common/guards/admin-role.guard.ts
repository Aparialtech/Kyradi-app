import {
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  Injectable,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { ROLES_KEY } from '../decorators/roles.decorator';
import { User } from '../../users/schemas/user.schema';

type AllowedRole = 'admin' | 'editor' | 'user';

@Injectable()
export class AdminRoleGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    @InjectModel(User.name) private readonly userModel: Model<User>,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const enabledRaw = (process.env.ADMIN_PANEL_ENABLED ?? 'true')
      .toString()
      .trim()
      .toLowerCase();
    if (enabledRaw === 'false' || enabledRaw === '0' || enabledRaw === 'off') {
      throw new ForbiddenException('ADMIN_PANEL_DISABLED');
    }

    const requiredRoles =
      this.reflector.getAllAndOverride<AllowedRole[]>(ROLES_KEY, [
        context.getHandler(),
        context.getClass(),
      ]) ?? ['admin', 'editor'];

    const req = context.switchToHttp().getRequest();
    const userId = req?.user?.id?.toString() ?? '';
    if (!userId) {
      throw new ForbiddenException('FORBIDDEN');
    }

    const user = await this.userModel.findById(userId).lean().exec();
    if (!user) {
      throw new ForbiddenException('FORBIDDEN');
    }
    const role = ((user as any).role ?? 'user').toString() as AllowedRole;
    if (!requiredRoles.includes(role)) {
      throw new ForbiddenException('FORBIDDEN');
    }
    (req as any).adminUser = {
      id: userId,
      role,
      email: (user as any).email ?? '',
    };
    return true;
  }
}
