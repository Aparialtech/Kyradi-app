import 'package:flutter/material.dart';

Color getLuggageColor(String? colorString) {
  final normalized = colorString?.trim().toLowerCase();
  switch (normalized) {
    case 'red':
    case 'kirmizi':
      return const Color(0xFFE53935);
    case 'black':
    case 'siyah':
      return const Color(0xFF111827);
    case 'blue':
    case 'mavi':
      return const Color(0xFF2563EB);
    case 'yellow':
    case 'sari':
      return const Color(0xFFF59E0B);
    case 'green':
    case 'yesil':
      return const Color(0xFF16A34A);
    case 'white':
    case 'beyaz':
      return const Color(0xFFFFFFFF);
    default:
      return const Color(0xFF94A3B8);
  }
}

Widget getLuggageIcon(
  String? colorString, {
  double size = 48,
  bool withShadow = true,
}) {
  final color = getLuggageColor(colorString);
  final isWhite = color == const Color(0xFFFFFFFF);
  final iconColor = isWhite ? const Color(0xFFF8FAFC) : color;

  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: 0.95),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(
        color: isWhite
            ? const Color(0xFFCBD5E1).withValues(alpha: 0.95)
            : Colors.white.withValues(alpha: 0.70),
      ),
      boxShadow: withShadow
          ? [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ]
          : const [],
    ),
    alignment: Alignment.center,
    child: Icon(
      Icons.luggage_rounded,
      size: size * 0.58,
      color: iconColor,
    ),
  );
}
