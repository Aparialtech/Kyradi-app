import { BadRequestException } from '@nestjs/common';

export type PricingTier = '0_6' | '6_24' | 'daily';
export type PricingSizeClass = 'S' | 'M' | 'L';

export interface PricingQuoteResult {
  durationHours: number;
  tier: PricingTier;
  daysCharged?: number;
  priceTry: number;
  breakdown: {
    sizeClass: PricingSizeClass;
    tier: PricingTier;
    unitPrice: number;
    premiumProtectionFee?: number;
    daysCharged?: number;
  };
}

const PRICE_TABLE: Record<PricingSizeClass, { t0_6: number; t6_24: number; daily: number }> = {
  S: { t0_6: 29, t6_24: 59, daily: 99 },
  M: { t0_6: 39, t6_24: 79, daily: 129 },
  L: { t0_6: 49, t6_24: 99, daily: 159 },
};

function normalizeSizeClass(sizeClass: string): PricingSizeClass {
  const cleaned = sizeClass.trim().toLowerCase();
  if (cleaned === 'small') return 'S';
  if (cleaned === 'medium') return 'M';
  if (cleaned === 'large') return 'L';
  const upper = sizeClass.trim().toUpperCase();
  if (upper === 'S' || upper === 'M' || upper === 'L') return upper;
  throw new BadRequestException('INVALID_SIZE_CLASS');
}

export function calculatePricingQuote(
  sizeClass: string,
  startAt: Date,
  endAt: Date,
  protectionLevel?: string,
): PricingQuoteResult {
  if (Number.isNaN(startAt.getTime()) || Number.isNaN(endAt.getTime())) {
    throw new BadRequestException('INVALID_DATE');
  }

  const durationHours = (endAt.getTime() - startAt.getTime()) / 3600000;
  if (!(durationHours > 0)) {
    throw new BadRequestException('INVALID_DURATION');
  }

  const normalizedSize = normalizeSizeClass(sizeClass);
  const priceRow = PRICE_TABLE[normalizedSize];
  if (!priceRow) {
    throw new BadRequestException('INVALID_SIZE_CLASS');
  }

  let tier: PricingTier;
  let unitPrice: number;
  let daysCharged: number | undefined;
  let priceTry: number;

  if (durationHours <= 6) {
    tier = '0_6';
    unitPrice = priceRow.t0_6;
    priceTry = unitPrice;
  } else if (durationHours <= 24) {
    tier = '6_24';
    unitPrice = priceRow.t6_24;
    priceTry = unitPrice;
  } else {
    tier = 'daily';
    unitPrice = priceRow.daily;
    daysCharged = Math.ceil(durationHours / 24);
    priceTry = daysCharged * unitPrice;
  }

  const premiumProtectionFee =
    protectionLevel === 'premium' ? Math.round(priceTry * 0.2) : 0;
  const totalPrice = priceTry + premiumProtectionFee;

  return {
    durationHours,
    tier,
    daysCharged,
    priceTry: totalPrice,
    breakdown: {
      sizeClass: normalizedSize,
      tier,
      unitPrice,
      ...(premiumProtectionFee > 0 ? { premiumProtectionFee } : {}),
      ...(daysCharged ? { daysCharged } : {}),
    },
  };
}
