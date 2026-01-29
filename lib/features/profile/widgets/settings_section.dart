import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/app_locale.dart';
import '../../../core/app_theme_mode.dart';
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
    required this.themeMode,
    required this.onThemeChanged,
  });

  final bool inAppNotifications;
  final bool emailNotifications;
  final ValueChanged<bool> onInAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final String languageCode;
  final ValueChanged<String> onLanguageChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.settingsTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(loc.settingsInAppNotifications),
            value: inAppNotifications,
            onChanged: onInAppChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(loc.settingsEmailReminders),
            value: emailNotifications,
            onChanged: onEmailChanged,
          ),
          const SizedBox(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.translate_outlined),
            title: Text(loc.settingsLanguage),
            trailing: DropdownButton<String>(
              value: languageCode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(value: 'tr', child: Text(loc.languageTurkish)),
                DropdownMenuItem(value: 'en', child: Text(loc.languageEnglish)),
                DropdownMenuItem(value: 'de', child: Text(loc.languageGerman)),
                DropdownMenuItem(value: 'es', child: Text(loc.languageSpanish)),
                DropdownMenuItem(value: 'ru', child: Text(loc.languageRussian)),
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
            title: Text(loc.settingsTheme),
            trailing: DropdownButton<ThemeMode>(
              value: themeMode,
              underline: const SizedBox.shrink(),
              items: [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(loc.settingsThemeSystem),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(loc.settingsThemeLight),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(loc.settingsThemeDark),
                ),
              ],
              onChanged: (value) {
                if (value == null) return;
                onThemeChanged(value);
                AppThemeMode.set(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
