import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Support',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.help_outline),
            title: const Text('FAQ'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onFaq,
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.info_outline),
            title: const Text('About Kyradi'),
            trailing: const Icon(Icons.chevron_right),
            onTap: onAbout,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.chat_bubble_outline),
            title: const Text('WhatsApp'),
            onTap: () => _launch(Uri.parse('https://wa.me/905000000000')),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.phone_outlined),
            title: const Text('Call'),
            onTap: () => _launch(Uri.parse('tel:+905000000000')),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.email_outlined),
            title: const Text('Email'),
            onTap: () => _launch(Uri.parse('mailto:support@kyradi.com')),
          ),
        ],
      ),
    );
  }
}
