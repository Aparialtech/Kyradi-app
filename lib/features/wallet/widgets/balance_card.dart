import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';
import '../../../l10n/app_localizations.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({
    super.key,
    required this.balance,
    required this.monthlyEarned,
    required this.obscureBalance,
    required this.onToggleVisibility,
    required this.onQuickTopUp,
  });

  final double balance;
  final double monthlyEarned;
  final bool obscureBalance;
  final VoidCallback onToggleVisibility;
  final VoidCallback onQuickTopUp;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    return SectionCard(
      padding: const EdgeInsets.all(20),
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.92),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.18),
                    theme.colorScheme.secondary.withValues(alpha: 0.06),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: theme.colorScheme.primary.withValues(alpha: 0.14),
                    ),
                    child: Text(
                      'KYRADI WALLET',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: onToggleVisibility,
                    icon: Icon(
                      obscureBalance
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                    color: theme.colorScheme.primary,
                    tooltip: obscureBalance
                        ? 'Bakiyeyi goster'
                        : 'Bakiyeyi gizle',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                loc.walletBalanceLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                obscureBalance ? '••••• ₺' : '${balance.toStringAsFixed(2)} ₺',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  obscureBalance
                      ? loc.walletMonthlyEarnedLabel('•••')
                      : loc.walletMonthlyEarnedLabel(
                          monthlyEarned.toStringAsFixed(2),
                        ),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onQuickTopUp,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: const Text('Hizli Yukle'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
