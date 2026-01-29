import 'package:flutter/material.dart';
import '../../../ui/haptics/app_haptics.dart';
import '../../../l10n/app_localizations.dart';

class WalletQuickActions extends StatelessWidget {
  const WalletQuickActions({
    super.key,
    required this.onTopUp,
    required this.onTransactions,
    required this.onCashback,
    required this.onCoupons,
    required this.onCards,
  });

  final VoidCallback onTopUp;
  final VoidCallback onTransactions;
  final VoidCallback onCashback;
  final VoidCallback onCoupons;
  final VoidCallback onCards;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: tileWidth,
              child: _ActionTile(
                label: loc.topUpSectionTitle,
                icon: Icons.account_balance_wallet_outlined,
                onTap: () {
                  AppHaptics.light();
                  onTopUp();
                },
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _ActionTile(
                label: loc.walletTransactionsTitle,
                icon: Icons.receipt_long_outlined,
                onTap: () {
                  AppHaptics.light();
                  onTransactions();
                },
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _ActionTile(
                label: loc.walletCashbackTitle,
                icon: Icons.redeem_outlined,
                onTap: () {
                  AppHaptics.light();
                  onCashback();
                },
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _ActionTile(
                label: loc.walletCouponsAction,
                icon: Icons.discount_outlined,
                onTap: () {
                  AppHaptics.light();
                  onCoupons();
                },
              ),
            ),
            SizedBox(
              width: tileWidth,
              child: _ActionTile(
                label: loc.walletCardsTitle,
                icon: Icons.credit_card_outlined,
                onTap: () {
                  AppHaptics.light();
                  onCards();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
      child: Ink(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.14),
                    theme.colorScheme.secondary.withValues(alpha: 0.12),
                  ],
                ),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: Icon(icon, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
