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
                accent: const Color(0xFFE53935),
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
                accent: const Color(0xFF2563EB),
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
                accent: const Color(0xFF10B981),
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
                accent: const Color(0xFFF59E0B),
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
                accent: const Color(0xFF6366F1),
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
    required this.accent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      splashColor: accent.withValues(alpha: 0.12),
      highlightColor: accent.withValues(alpha: 0.06),
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
            _ThreeDIcon(accent: accent, icon: icon),
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

class _ThreeDIcon extends StatelessWidget {
  const _ThreeDIcon({
    required this.accent,
    required this.icon,
  });

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surface;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.25),
                accent.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: base,
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
        ),
        Icon(
          icon,
          size: 18,
          color: accent,
          shadows: [
            Shadow(
              color: accent.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ],
    );
  }
}
