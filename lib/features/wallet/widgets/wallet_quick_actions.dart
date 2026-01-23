import 'package:flutter/material.dart';
import '../../../ui/haptics/app_haptics.dart';

class WalletQuickActions extends StatelessWidget {
  const WalletQuickActions({
    super.key,
    required this.onUseCashback,
    required this.onCoupons,
    required this.onInvite,
  });

  final VoidCallback onUseCashback;
  final VoidCallback onCoupons;
  final VoidCallback onInvite;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
      child: _ActionTile(
        label: 'Use cashback',
        icon: Icons.redeem_outlined,
        onTap: () {
          AppHaptics.light();
          onUseCashback();
        },
      ),
    ),
        const SizedBox(width: 12),
        Expanded(
      child: _ActionTile(
        label: 'Coupons',
        icon: Icons.discount_outlined,
        onTap: () {
          AppHaptics.light();
          onCoupons();
        },
      ),
    ),
        const SizedBox(width: 12),
        Expanded(
      child: _ActionTile(
        label: 'Invite',
        icon: Icons.group_add_outlined,
        onTap: () {
          AppHaptics.light();
          onInvite();
        },
      ),
    ),
      ],
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
        ),
        child: Column(
          children: [
            Icon(icon, color: theme.colorScheme.primary),
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
