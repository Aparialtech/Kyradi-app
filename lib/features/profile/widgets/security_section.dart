import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/section_card.dart';

class SecuritySection extends StatelessWidget {
  const SecuritySection({
    super.key,
    required this.onChangePassword,
    required this.onLogout,
  });

  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SectionCard(
      radius: 24,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ThreeDIconBadge(icon: Icons.shield_outlined),
              const SizedBox(width: 10),
              Text(
                loc.securitySectionTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.lock_reset_outlined),
            title: Text(loc.changePasswordTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onChangePassword,
          ),
          Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ThreeDIconBadge(
              icon: Icons.logout,
              accent: theme.colorScheme.error,
            ),
            title: Text(loc.logout),
            trailing: const Icon(Icons.chevron_right),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
