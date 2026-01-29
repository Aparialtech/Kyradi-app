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
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.securitySectionTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_reset_outlined),
            title: Text(loc.changePasswordTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onChangePassword,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: Text(loc.logout),
            trailing: const Icon(Icons.chevron_right),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
