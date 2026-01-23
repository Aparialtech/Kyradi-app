import 'package:flutter/material.dart';
import '../../../core/app_locale.dart';
import '../../../widgets/section_card.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.inAppNotifications,
    required this.emailNotifications,
    required this.onInAppChanged,
    required this.onEmailChanged,
    required this.languageCode,
    required this.onLanguageChanged,
  });

  final bool inAppNotifications;
  final bool emailNotifications;
  final ValueChanged<bool> onInAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final String languageCode;
  final ValueChanged<String> onLanguageChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('In-app notifications'),
            value: inAppNotifications,
            onChanged: onInAppChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Email reminders'),
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.translate_outlined),
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: languageCode,
              underline: const SizedBox.shrink(),
              items: const [
                DropdownMenuItem(value: 'tr', child: Text('Türkçe')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'de', child: Text('Deutsch')),
                DropdownMenuItem(value: 'es', child: Text('Español')),
                DropdownMenuItem(value: 'ru', child: Text('Русский')),
              ],
              onChanged: (value) {
                if (value == null) return;
                onLanguageChanged(value);
                AppLocale.notifier.value = Locale(value);
              },
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.dark_mode_outlined),
            title: const Text('Theme'),
            trailing: const Text('Light'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
