bool isValidTurkishId(String value) {
  final v = value.trim();
  if (!RegExp(r'^\d{11}$').hasMatch(v)) return false;
  if (v.startsWith('0')) return false;
  final digits = v.split('').map(int.parse).toList(growable: false);
  final oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
  final evenSum = digits[1] + digits[3] + digits[5] + digits[7];
  final digit10 = ((oddSum * 7 - evenSum) % 10 + 10) % 10;
  if (digit10 != digits[9]) return false;
  final sum10 = digits.take(10).fold<int>(0, (a, b) => a + b);
  final digit11 = sum10 % 10;
  return digit11 == digits[10];
}

