import { BadRequestException, Injectable, Logger, NotFoundException } from '@nestjs/common';
import { InjectModel } from '@nestjs/mongoose';
import { Model } from 'mongoose';
import { Luggage, PaymentMethod, PaymentStatus } from '../luggages/schemas/luggage.schema';
import { PaymentCheckoutDto } from './dto/payment-checkout.dto';
import { PaymentWebhookDto } from './dto/payment-webhook.dto';

@Injectable()
export class PaymentsService {
  private readonly logger = new Logger(PaymentsService.name);

  constructor(
    @InjectModel(Luggage.name)
    private readonly luggageModel: Model<Luggage>,
  ) {}

  async createCheckout(dto: PaymentCheckoutDto, checkoutBaseUrl: string | null) {
    const luggage = await this.luggageModel.findById(dto.reservationId).exec();
    if (!luggage) throw new NotFoundException('RESERVATION_NOT_FOUND');

    const paymentMethod = dto.paymentMethod as PaymentMethod;
    if (paymentMethod === PaymentMethod.PAY_AT_HOTEL) {
      luggage.paymentMethod = paymentMethod;
      luggage.paymentStatus = PaymentStatus.UNPAID;
      luggage.checkoutUrl = undefined;
      await luggage.save();
      return {
        checkoutUrl: null,
        providerPaymentId: luggage.providerPaymentId ?? null,
        paymentStatus: luggage.paymentStatus,
      };
    }

    const providerPaymentId = this._generateProviderPaymentId();
    const checkoutUrl = checkoutBaseUrl
      ? `${checkoutBaseUrl.replace(/\/$/, '')}/${providerPaymentId}`
      : null;

    luggage.paymentMethod = paymentMethod;
    luggage.paymentStatus = PaymentStatus.PENDING;
    luggage.providerPaymentId = providerPaymentId;
    luggage.checkoutUrl = checkoutUrl ?? undefined;
    await luggage.save();

    if (!checkoutUrl) {
      this.logger.warn('MAGICPAY_CHECKOUT_BASE_URL not set; checkoutUrl is null.');
    }

    return {
      checkoutUrl,
      providerPaymentId,
      paymentStatus: luggage.paymentStatus,
    };
  }

  async handleWebhook(dto: PaymentWebhookDto) {
    const luggage = await this.luggageModel
      .findOne({ providerPaymentId: dto.providerPaymentId })
      .exec();
    if (!luggage) throw new NotFoundException('PAYMENT_NOT_FOUND');

    const now = new Date();
    if (dto.status === 'success' || dto.status === 'paid') {
      luggage.paymentStatus = PaymentStatus.PAID;
      luggage.transactionId = dto.transactionId ?? luggage.transactionId;
      luggage.paidAt = now;
    } else if (dto.status === 'failed') {
      luggage.paymentStatus = PaymentStatus.FAILED;
    } else {
      throw new BadRequestException('INVALID_PAYMENT_STATUS');
    }
    await luggage.save();

    return {
      ok: true,
      paymentStatus: luggage.paymentStatus,
      transactionId: luggage.transactionId ?? null,
      paidAt: luggage.paidAt ?? null,
    };
  }

  async getStatus(reservationId: string) {
    const luggage = await this.luggageModel.findById(reservationId).lean().exec();
    if (!luggage) {
      return {
        paymentStatus: PaymentStatus.UNPAID,
        totalPrice: 0,
        transactionId: null,
        paidAt: null,
      };
    }
    return {
      paymentStatus: luggage.paymentStatus ?? PaymentStatus.UNPAID,
      totalPrice: luggage.totalPrice ?? 0,
      transactionId: luggage.transactionId ?? null,
      paidAt: luggage.paidAt ?? null,
    };
  }

  async markMockPaid(reservationId: string, paymentId: string, amount?: number) {
    if (!reservationId) return false;
    const luggage = await this.luggageModel.findById(reservationId).exec();
    if (!luggage) return false;
    luggage.paymentStatus = PaymentStatus.PAID;
    luggage.paidAt = new Date();
    luggage.providerPaymentId = paymentId;
    luggage.transactionId = paymentId;
    if (typeof amount === 'number' && amount > 0) {
      luggage.totalPrice = Math.round(amount);
    }
    await luggage.save();
    return true;
  }

  verifyWebhookSignature(signature: string | undefined) {
    const secret = process.env.MAGICPAY_WEBHOOK_SECRET;
    if (!secret) return true;
    return signature === secret;
  }

  private _generateProviderPaymentId() {
    const stamp = Date.now().toString(36);
    const random = Math.floor(100000 + Math.random() * 900000).toString(36);
    return `MP-${stamp}-${random}`.toUpperCase();
  }
}
