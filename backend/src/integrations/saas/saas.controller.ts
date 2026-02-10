import { BadRequestException, Body, Controller, Post, Req, UnauthorizedException } from '@nestjs/common';
import { Public } from '../../common/decorators/public.decorator';
import { SaasClient } from './saas.client';
import { SaasIntegrationService } from './saas.service';
import type { SaasDiagnoseRequest, SaasStatusUpdate } from './saas.types';

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
    const sig = req?.headers?.['x-kyradi-signature']?.toString();
    const keys = body && typeof body === 'object' ? Object.keys(body as any) : [];
    console.log('[SAAS_BODY]', {
      keys,
      reservationId: (body as any)?.reservationId ?? null,
      saasReservationId: (body as any)?.saasReservationId ?? null,
      externalReservationId: (body as any)?.externalReservationId ?? null,
    });
    console.log('[SAAS_SIG]', {
      hasRawBody: !!req?.rawBody,
      rawLen: req?.rawBody?.length,
      sigLen: sig?.length,
    });
    if (!req?.rawBody || req.rawBody.length === 0) {
      throw new UnauthorizedException('RAW_BODY_MISSING');
    }
    const ok = this.saasClient.verifyIncomingSignature(req?.rawBody, body, sig);
    if (!ok) {
      throw new UnauthorizedException('INVALID_SIGNATURE');
    }
    return this.saasIntegration.applyStatusUpdate(body);
  }

  @Public()
  @Post('diagnose')
  async diagnose(@Req() req: any, @Body() body: SaasDiagnoseRequest) {
    if (!this.saasClient.isEnabled()) {
      throw new BadRequestException('SAAS_DISABLED');
    }
    const sig = req?.headers?.['x-kyradi-signature']?.toString();
    const keys = body && typeof body === 'object' ? Object.keys(body as any) : [];
    console.log('[SAAS_DIAG_BODY]', {
      keys,
      reservationId: (body as any)?.reservationId ?? null,
      saasReservationId: (body as any)?.saasReservationId ?? null,
      externalReservationId: (body as any)?.externalReservationId ?? null,
    });
    console.log('[SAAS_DIAG_SIG]', {
      hasRawBody: !!req?.rawBody,
      rawLen: req?.rawBody?.length,
      sigLen: sig?.length,
    });
    if (!req?.rawBody || req.rawBody.length === 0) {
      throw new UnauthorizedException('RAW_BODY_MISSING');
    }
    const ok = this.saasClient.verifyIncomingSignature(req?.rawBody, body, sig);
    if (!ok) {
      throw new UnauthorizedException('INVALID_SIGNATURE');
    }
    return this.saasIntegration.diagnoseStatusUpdate(body as any);
  }
}
