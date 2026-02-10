import { BadRequestException, Body, Controller, Post, Req, UnauthorizedException } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { SaasClient } from './saas.client';
import { SaasIntegrationService } from './saas.service';
import type { SaasStatusUpdate } from './saas.types';

@Controller('integrations/saas')
export class SaasController {
  constructor(
    private readonly saasClient: SaasClient,
    private readonly saasIntegration: SaasIntegrationService,
  ) {}

  @Public()
  @Post('status-update')
  async statusUpdate(@Req() req: any, @Body() body: SaasStatusUpdate) {
    if (!this.saasClient.isEnabled()) {
      throw new BadRequestException('SAAS_DISABLED');
    }
    console.log({
      hasRawBody: !!req?.rawBody,
      rawBodyLength: req?.rawBody?.length,
    });
    if (!req?.rawBody || req.rawBody.length === 0) {
      throw new UnauthorizedException('RAW_BODY_MISSING');
    }
    const signature = req?.headers?.['x-kyradi-signature']?.toString();
    const ok = this.saasClient.verifyIncomingSignature(req?.rawBody, body, signature);
    if (!ok) {
      throw new UnauthorizedException('INVALID_SIGNATURE');
    }
    return this.saasIntegration.applyStatusUpdate(body);
  }
}
