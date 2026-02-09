import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/section_card.dart';

class SupportSection extends StatelessWidget {
  const SupportSection({
    super.key,
    required this.onFaq,
    required this.onAbout,
  });

  final VoidCallback onFaq;
  final VoidCallback onAbout;

  Future<void> _launch(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.supportSectionTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
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
          const Divider(),
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
