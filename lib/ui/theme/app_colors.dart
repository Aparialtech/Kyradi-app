import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF005C99);
  static const Color secondary = Color(0xFF166866);
  static const Color accent = Color(0xFF2C2966);
  static const Color neutralDark = Color(0xFF2C3E50);
  static const Color background = Color(0xFFEFEFEF);
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF2E2E2E);

  static ColorScheme lightScheme() {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: accent,
      onPrimaryContainer: Colors.white,
      secondary: secondary,
      onSecondary: Colors.white,
      secondaryContainer: neutralDark,
      onSecondaryContainer: Colors.white,
      tertiary: accent,
      onTertiary: Colors.white,
      surface: surface,
      onSurface: text,
      surfaceContainerHighest: const Color(0xFFD8DEE6),
      onSurfaceVariant: const Color(0xFF4D5866),
      outline: const Color(0xFF9AA4AE),
      outlineVariant: const Color(0xFFC3C8CE),
      inverseSurface: neutralDark,
      onInverseSurface: Colors.white,
      inversePrimary: const Color(0xFFA9D2F4),
    );
  }

  static ColorScheme darkScheme() {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.dark,
    ).copyWith(
      primary: const Color(0xFF5AB0FF),
      onPrimary: const Color(0xFF0B1A26),
      primaryContainer: const Color(0xFF163B5C),
      onPrimaryContainer: Colors.white,
      secondary: const Color(0xFF4FAEAA),
      onSecondary: const Color(0xFF0B1A26),
      secondaryContainer: const Color(0xFF1B2E2D),
      onSecondaryContainer: Colors.white,
      tertiary: const Color(0xFF6C6AD6),
      onTertiary: const Color(0xFF0B0B1A),
      surface: const Color(0xFF111821),
      onSurface: const Color(0xFFE7EDF5),
      surfaceContainerHighest: const Color(0xFF1A2431),
      onSurfaceVariant: const Color(0xFFB5C3D4),
      outline: const Color(0xFF3B4A5A),
      outlineVariant: const Color(0xFF2A3644),
      inverseSurface: const Color(0xFFE7EDF5),
      onInverseSurface: const Color(0xFF111821),
      inversePrimary: const Color(0xFF2C4C6B),
    );
  }
}
