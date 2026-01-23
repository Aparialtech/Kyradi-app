import 'package:flutter/material.dart';
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
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Security',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.lock_reset_outlined),
            title: const Text('Change password'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onChangePassword,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
