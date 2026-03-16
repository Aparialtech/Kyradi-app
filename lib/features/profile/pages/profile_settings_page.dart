import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/shell/shell_spacing.dart';
import '../../../widgets/app_mesh_background.dart';
import '../widgets/settings_section.dart';

class ProfileSettingsPage extends StatelessWidget {
  const ProfileSettingsPage({
    super.key,
    required this.inAppNotifications,
    required this.emailNotifications,
    required this.onInAppChanged,
    required this.onEmailChanged,
    required this.languageCode,
    required this.onLanguageChanged,
    required this.currencyCode,
    required this.onCurrencyChanged,
    required this.themeMode,
    required this.onThemeChanged,
    required this.criticalOnly,
    required this.onCriticalOnlyChanged,
  });

  final bool inAppNotifications;
  final bool emailNotifications;
  final ValueChanged<bool> onInAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final String languageCode;
  final ValueChanged<String> onLanguageChanged;
  final String currencyCode;
  final ValueChanged<String> onCurrencyChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final bool criticalOnly;
  final ValueChanged<bool> onCriticalOnlyChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomSafePadding = shellBottomContentPadding(context, extra: -16);
    return Scaffold(
      appBar: AppBar(title: Text(loc.settingsTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomSafePadding),
            children: [
              SettingsSection(
                inAppNotifications: inAppNotifications,
                emailNotifications: emailNotifications,
                onInAppChanged: onInAppChanged,
                onEmailChanged: onEmailChanged,
                languageCode: languageCode,
                onLanguageChanged: onLanguageChanged,
                currencyCode: currencyCode,
                onCurrencyChanged: onCurrencyChanged,
                themeMode: themeMode,
                onThemeChanged: onThemeChanged,
                criticalOnly: criticalOnly,
                onCriticalOnlyChanged: onCriticalOnlyChanged,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
