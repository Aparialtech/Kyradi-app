class SavedCard {
  const SavedCard({
    required this.id,
    required this.type,
    required this.brand,
    required this.holder,
    required this.last4,
    required this.expiry,
  });

  final String id;
  final String type;
  final String brand;
  final String holder;
  final String last4;
  final String expiry;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'brand': brand,
        'holder': holder,
        'last4': last4,
        'expiry': expiry,
      };

  factory SavedCard.fromJson(Map<String, dynamic> json) {
    return SavedCard(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'credit',
      brand: json['brand']?.toString() ?? 'unknown',
      holder: json['holder']?.toString() ?? '',
      last4: json['last4']?.toString() ?? '0000',
      expiry: json['expiry']?.toString() ?? '',
    );
  }
}

String detectCardBrand(String digits) {
  if (digits.startsWith('4')) return 'visa';
  if (digits.startsWith('34') || digits.startsWith('37')) return 'amex';
  if (digits.startsWith('35')) return 'jcb';
  if (digits.startsWith('6')) return 'discover';
  if (digits.startsWith('5')) return 'mastercard';
  return 'card';
}

String cardBrandLabel(String brand) {
  switch (brand) {
    case 'visa':
      return 'VISA';
    case 'mastercard':
      return 'MASTERCARD';
    case 'amex':
      return 'AMEX';
    case 'discover':
      return 'DISCOVER';
    case 'jcb':
      return 'JCB';
    default:
      return 'CARD';
  }
}
