class PricingBreakdown {
  const PricingBreakdown({
    required this.durationMinutes,
    required this.durationHours,
    required this.durationDays,
    required this.hourlyCost,
    required this.dailyCost,
    required this.baseCost,
    required this.insuranceFee,
    required this.hotelFee,
    required this.total,
    required this.chosen,
  });

  final int durationMinutes;
  final int durationHours;
  final int durationDays;
  final int hourlyCost;
  final int dailyCost;
  final int baseCost;
  final int insuranceFee;
  final int hotelFee;
  final int total;
  final String chosen;

  Map<String, dynamic> toJson() => {
        'durationMinutes': durationMinutes,
        'durationHours': durationHours,
        'durationDays': durationDays,
        'hourlyCost': hourlyCost,
        'dailyCost': dailyCost,
        'baseCost': baseCost,
        'insuranceFee': insuranceFee,
        'hotelFee': hotelFee,
        'total': total,
        'chosen': chosen,
      };
}
