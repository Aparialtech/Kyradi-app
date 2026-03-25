import { BadRequestException, Body, Controller, Get, Post, Query, ForbiddenException } from '@nestjs/common';
import { calculatePricingQuote } from '../common/utils/pricing-quote.util';
import { MockPaymentDto } from './dto/mock-payment.dto';
import { PaymentCheckoutDto } from './dto/payment-checkout.dto';
import { PaymentsService } from './payments.service';

@Controller('payments')
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('checkout')
  async checkout(@Body() body: Record<string, unknown>) {
    const sizeClass = body['sizeClass']?.toString();
    const startAt = body['startAt']?.toString();
    const endAt = body['endAt']?.toString();
    const protectionLevel = body['protectionLevel']?.toString();
    const reservationId = body['reservationId']?.toString().trim();
    const paymentMethod = body['paymentMethod']?.toString().trim();
    if (sizeClass && startAt && endAt && !reservationId) {
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

    if (reservationId && paymentMethod) {
      if (!['card', 'installment', 'pay_at_hotel'].includes(paymentMethod)) {
        throw new BadRequestException('INVALID_PAYMENT_METHOD');
      }
      const dto: PaymentCheckoutDto = {
        reservationId,
        paymentMethod: paymentMethod as PaymentCheckoutDto['paymentMethod'],
      };
      const checkout = await this.paymentsService.createCheckout(
        dto,
        process.env.MAGICPAY_CHECKOUT_BASE_URL ?? null,
      );
      return { ok: true, ...checkout };
    }

    // Backward-compatible fallback for legacy clients that only expect {ok:true}.
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
    const demoMode = (process.env.PAYMENTS_DEMO_MODE ?? '').toLowerCase() === 'true';
    if (!demoMode) {
      throw new ForbiddenException('PAYMENTS_DEMO_DISABLED');
    }
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
