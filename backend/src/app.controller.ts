import { Controller, Get } from '@nestjs/common';
import { Public } from './common/decorators/public.decorator';

@Controller()
export class AppController {
  @Public()
  @Get('/__version')
  version() {
    return {
      builtAt: process.env.BUILT_AT || 'unknown',
      commit: process.env.RAILWAY_GIT_COMMIT_SHA || process.env.GIT_SHA || 'unknown',
    };
  }
}
