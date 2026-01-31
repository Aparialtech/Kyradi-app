import 'package:flutter/material.dart';

class AnimatedCardPreview extends StatelessWidget {
  const AnimatedCardPreview({
    super.key,
    required this.cardNumber,
    required this.cardName,
    required this.expiry,
    required this.cvv,
    required this.showBack,
  });

  final String cardNumber;
  final String cardName;
  final String expiry;
  final String cvv;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final displayNumber = cardNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : cardNumber.replaceAllMapped(RegExp(r'.{4}'), (m) => '${m.group(0)} ');
    final displayName = cardName.isEmpty ? 'CARDHOLDER' : cardName.toUpperCase();
    final displayExpiry = expiry.isEmpty ? 'MM/YY' : expiry;
    final displayCvv = cvv.isEmpty ? '•••' : cvv;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final rotate = Tween<double>(begin: 1, end: 0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final angle = showBack ? 3.1416 * rotate.value : -3.1416 * rotate.value;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(angle),
              child: child,
            );
          },
        );
      },
      child: showBack
          ? _CardBack(
              key: const ValueKey('back'),
              cvv: displayCvv,
            )
          : _CardFront(
              key: const ValueKey('front'),
              number: displayNumber,
              name: displayName,
              expiry: displayExpiry,
            ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    super.key,
    required this.number,
    required this.name,
    required this.expiry,
  });

  final String number;
  final String name;
  final String expiry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF005C99), Color(0xFF2C2966)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KYRADI',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Text(
            number.trim(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                expiry,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key, required this.cvv});

  final String cvv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2966), Color(0xFF005C99)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            color: Colors.black.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      cvv,
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'CVV',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
