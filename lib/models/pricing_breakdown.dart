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

  factory PricingBreakdown.fromJson(Map<String, dynamic> json) {
    return PricingBreakdown(
      durationMinutes: (json['durationMinutes'] ?? 0) as int,
      durationHours: (json['durationHours'] ?? 0) as int,
      durationDays: (json['durationDays'] ?? 0) as int,
      hourlyCost: (json['hourlyCost'] ?? 0) as int,
      dailyCost: (json['dailyCost'] ?? 0) as int,
      baseCost: (json['baseCost'] ?? 0) as int,
      insuranceFee: (json['insuranceFee'] ?? 0) as int,
      hotelFee: (json['hotelFee'] ?? 0) as int,
      total: (json['total'] ?? 0) as int,
      chosen: (json['chosen'] ?? '').toString(),
    );
  }
}
