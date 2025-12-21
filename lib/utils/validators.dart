// lib/utils/validators.dart
import 'package:flutter/services.dart';

import '../l10n/app_localizations.dart';

class AppValidators {
  // E-posta: basit ve güvenli bir regex
  static String? email(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) return l10n.validationEmailRequired;
    final ok = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(v.trim());
    if (!ok) return l10n.validationEmailInvalid;
    return null;
  }

  // Şifre: >=8 karakter, en az 1 harf + 1 rakam
  static String? password(String? v, AppLocalizations l10n) {
    if (v == null || v.isEmpty) return l10n.validationPasswordRequired;
    if (v.length < 8) return l10n.validationMinChars('8');
    if (!RegExp(r'[A-Za-z]').hasMatch(v)) return l10n.validationPasswordNeedsLetter;
    if (!RegExp(r'\d').hasMatch(v)) return l10n.validationPasswordNeedsNumber;
    return null;
  }

  // Şifre tekrar: şifre ile aynı olmalı
  static String? passwordRepeat(String? v, String original, AppLocalizations l10n) {
    if (v == null || v.isEmpty) return l10n.validationPasswordRepeatRequired;
    if (v != original) return l10n.passwordMismatch;
    return null;
  }

  // TC Kimlik: 11 hane + basit checksum
  static String? tcKimlik(String? v, AppLocalizations l10n) {
    if (v == null || v.isEmpty) return l10n.validationNationalIdRequired;
    if (!RegExp(r'^\d{11}$').hasMatch(v)) return l10n.validationNationalIdLength;

    // Checksum (TÜİK kuralı)
    final digits = v.split('').map(int.parse).toList();
    // 10. hane
    final t10 = (((digits[0] + digits[2] + digits[4] + digits[6] + digits[8]) * 7)
            - (digits[1] + digits[3] + digits[5] + digits[7])) % 10;
    if (digits[9] != t10) return l10n.validationNationalIdChecksumTen;

    // 11. hane
    final t11 = (digits.sublist(0, 10).reduce((a, b) => a + b)) % 10;
    if (digits[10] != t11) return l10n.validationNationalIdChecksumEleven;

    // İlk hane 0 olamaz
    if (digits[0] == 0) return l10n.validationNationalIdInvalid;
    return null;
  }

  // Telefon: +90 5xx xxx xx xx gibi
  static String? phone(String? v, AppLocalizations l10n) {
    if (v == null || v.trim().isEmpty) return l10n.validationPhoneRequired;
    final s = v.replaceAll(' ', '');
    final ok = RegExp(r'^\+90\d{10}$').hasMatch(s);
    if (!ok) return l10n.validationPhoneFormat;
    return null;
  }

  // 18+ kontrolü
  static String? age18(DateTime? birthDate, AppLocalizations l10n) {
    if (birthDate == null) return l10n.validationBirthDateRequired;
    final now = DateTime.now();
    int age = now.year - birthDate.year;
    if (now.month < birthDate.month ||
        (now.month == birthDate.month && now.day < birthDate.day)) {
      age--;
    }
    if (age < 18) return l10n.validationAgeRequirement;
    return null;
  }

  // Sadece rakam input formatter (gerekirse)
  static final digitsOnlyFormatter = FilteringTextInputFormatter.allow(RegExp(r'\d'));
}
