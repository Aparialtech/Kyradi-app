import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

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
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 4,
                width: 26,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.9),
                      theme.colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
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
          label: Text(loc.walletRulesAction),
        ),
      ],
    );
  }
}
