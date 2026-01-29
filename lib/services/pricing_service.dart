import 'dart:math';
import '../models/pricing_breakdown.dart';

class PricingService {
  PricingService._();

  static const int hourlyRate = 100;
  static const int dailyRate = 500;
  static const int insuranceFee = 99;

  static PricingBreakdown calculate({
    required DateTime start,
    required DateTime end,
    required bool insurance,
    required String paymentMethod,
  }) {
    final minutes = end.difference(start).inMinutes;
    final safeMinutes = max(60, minutes);
    final hours = (safeMinutes / 60).ceil();
    final days = (safeMinutes / (24 * 60)).ceil();
    final hourlyCost = hours * hourlyRate;
    final dailyCost = days * dailyRate;
    final baseCost = min(hourlyCost, dailyCost);
    final insuranceCost = insurance ? insuranceFee : 0;
    final hotelFee = paymentMethod == 'pay_at_hotel'
        ? (baseCost * 0.10).round()
        : 0;
    final total = baseCost + insuranceCost + hotelFee;
    return PricingBreakdown(
      durationMinutes: safeMinutes,
      durationHours: hours,
      durationDays: days,
      hourlyCost: hourlyCost,
      dailyCost: dailyCost,
      baseCost: baseCost,
      insuranceFee: insuranceCost,
      hotelFee: hotelFee,
      total: total,
      chosen: hourlyCost <= dailyCost ? 'hourly' : 'daily',
    );
  }
}
