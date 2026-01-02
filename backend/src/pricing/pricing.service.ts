import { Injectable } from '@nestjs/common';
import { calculatePricingQuote } from '../common/utils/pricing-quote.util';

@Injectable()
export class PricingService {
  quote(sizeClass: string, startAt: Date, endAt: Date, protectionLevel?: string) {
    const quote = calculatePricingQuote(sizeClass, startAt, endAt, protectionLevel);
    return {
      sizeClass: quote.breakdown.sizeClass,
      startAt: startAt.toISOString(),
      endAt: endAt.toISOString(),
      durationHours: quote.durationHours,
      tier: quote.tier,
      daysCharged: quote.daysCharged,
      unitPrice: quote.breakdown.unitPrice,
      priceTry: quote.priceTry,
    };
  }
}
