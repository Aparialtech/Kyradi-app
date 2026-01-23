import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color brandPrimary = Color(0xFF005C99);
  static const Color brandSecondary = Color(0xFF166866);
  static const Color brandAccent = Color(0xFF2C2966);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF2E2E2E);

  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 20;

  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 12,
      offset: const Offset(0, 6),
    ),
  ];
}
