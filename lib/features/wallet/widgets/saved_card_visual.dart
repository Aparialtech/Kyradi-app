import 'package:flutter/material.dart';
import '../models/saved_card.dart';

class SavedCardVisual extends StatelessWidget {
  const SavedCardVisual({
    super.key,
    required this.card,
    this.onTap,
  });

  final SavedCard card;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradient = cardBrandGradient(card.brand);
    final child = AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                cardBrandLabel(card.brand),
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  card.type == 'credit' ? 'CREDIT' : 'DEBIT',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white70,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            '**** **** **** ${card.last4}',
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Text(
                  card.holder.toUpperCase(),
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                card.expiry,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    if (onTap == null) return child;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: child,
    );
  }
}

LinearGradient cardBrandGradient(String brand) {
  switch (brand) {
    case 'visa':
      return const LinearGradient(
        colors: [Color(0xFF1E3A8A), Color(0xFF2563EB)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case 'mastercard':
      return const LinearGradient(
        colors: [Color(0xFFF97316), Color(0xFFEF4444)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case 'amex':
      return const LinearGradient(
        colors: [Color(0xFF0EA5E9), Color(0xFF38BDF8)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case 'discover':
      return const LinearGradient(
        colors: [Color(0xFFF59E0B), Color(0xFFFACC15)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    case 'jcb':
      return const LinearGradient(
        colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    default:
      return const LinearGradient(
        colors: [Color(0xFF111827), Color(0xFF374151)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
  }
}
