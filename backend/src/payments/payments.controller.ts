import { BadRequestException, Body, Controller, Get, Post, Query } from '@nestjs/common';
import { calculatePricingQuote } from '../common/utils/pricing-quote.util';

@Controller('payments')
export class PaymentsController {
  @Post('checkout')
  checkout(@Body() body: Record<string, unknown>) {
    const sizeClass = body['sizeClass']?.toString();
    const startAt = body['startAt']?.toString();
    const endAt = body['endAt']?.toString();
    if (sizeClass && startAt && endAt) {
      const quote = calculatePricingQuote(sizeClass, new Date(startAt), new Date(endAt));
      return {
        ok: true,
        priceTry: quote.priceTry,
        tier: quote.tier,
      };
    }
    return { ok: true };
  }

  @Get('status')
  status(@Query('reservationId') reservationId?: string) {
    if (!reservationId?.trim()) {
      throw new BadRequestException({ message: 'reservationId is required' });
    }
    return { ok: true, reservationId, status: 'unknown' };
  }
}
