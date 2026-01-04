import { BadRequestException, Body, Controller, Get, Post, Query } from '@nestjs/common';
import { calculatePricingQuote } from '../common/utils/pricing-quote.util';
import { MockPaymentDto } from './dto/mock-payment.dto';
import { PaymentsService } from './payments.service';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('checkout')
  checkout(@Body() body: Record<string, unknown>) {
    const sizeClass = body['sizeClass']?.toString();
    const startAt = body['startAt']?.toString();
    const endAt = body['endAt']?.toString();
    const protectionLevel = body['protectionLevel']?.toString();
    if (sizeClass && startAt && endAt) {
      const quote = calculatePricingQuote(
        sizeClass,
        new Date(startAt),
        new Date(endAt),
        protectionLevel,
      );
      return {
        ok: true,
        priceTry: quote.priceTry,
        tier: quote.tier,
      };
    }
    return { ok: true };
  }

  @Get('status')
  async status(@Query('reservationId') reservationId?: string) {
    if (!reservationId?.trim()) {
      throw new BadRequestException({ message: 'reservationId is required' });
    }
    const status = await this.paymentsService.getStatus(reservationId.trim());
    const paymentStatus = status.paymentStatus ?? 'unpaid';
    return {
      ok: true,
      reservationId,
      status: paymentStatus,
      paymentStatus,
      totalPrice: status.totalPrice ?? 0,
      transactionId: status.transactionId ?? null,
      paidAt: status.paidAt ?? null,
    };
  }

  @Post('mock')
  async mockPayment(@Body() dto: MockPaymentDto) {
    const paymentId = `MOCK_${Date.now()}`;
    const reservationId = dto.bookingId?.toString() ?? '';
    const amount = typeof dto.amount === 'number' ? dto.amount : Number(dto.amount ?? 0);
    if (reservationId.trim().length > 0) {
      await this.paymentsService.markMockPaid(reservationId, paymentId, amount);
    }
    return {
      ok: true,
      status: 'success',
      paymentId,
    };
  }
}
