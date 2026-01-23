import 'package:flutter/material.dart';

class WalletHeader extends StatelessWidget {
  const WalletHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRulesTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onRulesTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        TextButton.icon(
          onPressed: onRulesTap,
          icon: const Icon(Icons.info_outline),
          label: const Text('Rules'),
        ),
      ],
    );
  }
}
