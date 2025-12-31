import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get('/__version')
  version() {
    return {
      builtAt: process.env.BUILT_AT || 'unknown',
      commit: process.env.RAILWAY_GIT_COMMIT_SHA || process.env.GIT_SHA || 'unknown',
    };
  }
}
