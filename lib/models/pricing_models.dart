class PricingEstimateRequest {
  final String sizeClass;
  final DateTime dropAt;
  final DateTime pickupAt;
  final String? protectionLevel;
  final String? paymentMethod;
  final int? installmentCount;
  final String? locationId;

  const PricingEstimateRequest({
    required this.sizeClass,
    required this.dropAt,
    required this.pickupAt,
    this.protectionLevel,
    this.paymentMethod,
    this.installmentCount,
    this.locationId,
  });

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'sizeClass': sizeClass,
      'dropAt': dropAt.toUtc().toIso8601String(),
      'pickupAt': pickupAt.toUtc().toIso8601String(),
    };
    if (protectionLevel != null) payload['protectionLevel'] = protectionLevel;
    if (paymentMethod != null) payload['paymentMethod'] = paymentMethod;
    if (installmentCount != null) payload['installmentCount'] = installmentCount;
    if (locationId != null) payload['locationId'] = locationId;
    return payload;
  }
}

class PricingEstimateResponse {
  final String currency;
  final String pricingBand;
  final int total;
  final Map<String, dynamic> breakdown;

  const PricingEstimateResponse({
    required this.currency,
    required this.pricingBand,
    required this.total,
    required this.breakdown,
  });

  factory PricingEstimateResponse.fromJson(Map<String, dynamic> json) {
    final rawTotal = json['total'];
    final total = rawTotal is num ? rawTotal.round() : int.tryParse('$rawTotal') ?? 0;
    final breakdownRaw = json['breakdown'];
    return PricingEstimateResponse(
      currency: (json['currency'] ?? '').toString(),
      pricingBand: (json['pricingBand'] ?? '').toString(),
      total: total,
      breakdown: breakdownRaw is Map<String, dynamic>
          ? Map<String, dynamic>.from(breakdownRaw)
          : {},
    );
  }
}

class PricingQuoteResponse {
  final double durationHours;
  final String tier;
  final int priceTry;
  final int? daysCharged;
  final Map<String, dynamic> breakdown;

  const PricingQuoteResponse({
    required this.durationHours,
    required this.tier,
    required this.priceTry,
    required this.breakdown,
    this.daysCharged,
  });

  factory PricingQuoteResponse.fromJson(Map<String, dynamic> json) {
    final rawPrice = json['priceTry'];
    final priceTry =
        rawPrice is num ? rawPrice.round() : int.tryParse('$rawPrice') ?? 0;
    final rawDuration = json['durationHours'];
    final durationHours = rawDuration is num
        ? rawDuration.toDouble()
        : double.tryParse('$rawDuration') ?? 0;
    final rawDays = json['daysCharged'];
    final daysCharged =
        rawDays is num ? rawDays.round() : int.tryParse('$rawDays');
    final breakdownRaw = json['breakdown'];
    return PricingQuoteResponse(
      durationHours: durationHours,
      tier: (json['tier'] ?? '').toString(),
      priceTry: priceTry,
      daysCharged: daysCharged,
      breakdown: breakdownRaw is Map<String, dynamic>
          ? Map<String, dynamic>.from(breakdownRaw)
          : {},
    );
  }
}
