import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/section_card.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({super.key, required this.onFaq, required this.onAbout});

  final VoidCallback onFaq;
  final VoidCallback onAbout;

  Future<void> _launch(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

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
              const ThreeDIconBadge(icon: Icons.support_agent_outlined),
              const SizedBox(width: 10),
              Text(
                loc.supportSectionTitle,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.help_outline),
            title: Text(loc.faqTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onFaq,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.info_outline),
            title: Text(loc.aboutKyradiTitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: onAbout,
          ),
          Divider(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.chat_bubble_outline),
            title: Text(loc.whatsappLabel),
            onTap: () => _launch(Uri.parse('https://wa.me/905000000000')),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.phone_outlined),
            title: Text(loc.callLabel),
            onTap: () => _launch(Uri.parse('tel:+905000000000')),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.email_outlined),
            title: Text(loc.emailLabel),
            onTap: () => _launch(Uri.parse('mailto:support@kyradi.com')),
          ),
        ],
      ),
    );
  }
}
