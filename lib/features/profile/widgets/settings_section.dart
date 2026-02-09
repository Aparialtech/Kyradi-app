import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../core/app_locale.dart';
import '../../../core/app_theme_mode.dart';
import '../../../core/background_theme_mode.dart';
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
    required this.criticalOnly,
    required this.onCriticalOnlyChanged,
  });

  final bool inAppNotifications;
  final bool emailNotifications;
  final ValueChanged<bool> onInAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final String languageCode;
  final ValueChanged<String> onLanguageChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;
  final bool criticalOnly;
  final ValueChanged<bool> onCriticalOnlyChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Sadece kritik bildirimler'),
            subtitle: const Text('Bilgilendirme bildirimlerini sessize alır.'),
            value: criticalOnly,
            onChanged: onCriticalOnlyChanged,
          ),
          const SizedBox(height: 4),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const ThreeDIconBadge(icon: Icons.translate_outlined),
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
            leading: const ThreeDIconBadge(icon: Icons.dark_mode_outlined),
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
          const SizedBox(height: 10),
          Divider(color: theme.colorScheme.outlineVariant),
          const SizedBox(height: 10),
          Row(
            children: [
              const ThreeDIconBadge(icon: Icons.palette_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Arka plan teması',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ValueListenableBuilder<AppBackgroundTheme>(
            valueListenable: AppBackgroundThemeMode.notifier,
            builder: (context, selected, _) {
              return SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: AppBackgroundTheme.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final item = AppBackgroundTheme.values[index];
                    return _BackgroundThemeCard(
                      theme: item,
                      selected: item == selected,
                      onSelect: () => AppBackgroundThemeMode.set(item),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _BackgroundThemeCard extends StatelessWidget {
  const _BackgroundThemeCard({
    required this.theme,
    required this.selected,
    required this.onSelect,
  });

  final AppBackgroundTheme theme;
  final bool selected;
  final VoidCallback onSelect;

  String get _label {
    switch (theme) {
      case AppBackgroundTheme.ocean:
        return 'Okyanus';
      case AppBackgroundTheme.aurora:
        return 'Aurora';
      case AppBackgroundTheme.sunset:
        return 'Gün batımı';
      case AppBackgroundTheme.citrus:
        return 'Narenciye';
      case AppBackgroundTheme.graphite:
        return 'Grafit';
      case AppBackgroundTheme.sakura:
        return 'Sakura';
      case AppBackgroundTheme.mint:
        return 'Mint';
      case AppBackgroundTheme.midnight:
        return 'Gece';
    }
  }

  List<Color> _previewColors(bool isDark) {
    switch (theme) {
      case AppBackgroundTheme.ocean:
        return isDark
            ? const [Color(0xFF0F172A), Color(0xFF111827)]
            : const [Color(0xFFF5F7FC), Color(0xFFE9EFF7)];
      case AppBackgroundTheme.aurora:
        return isDark
            ? const [Color(0xFF0B1220), Color(0xFF0F1B2D)]
            : const [Color(0xFFF6FFFD), Color(0xFFEAF7F5)];
      case AppBackgroundTheme.sunset:
        return isDark
            ? const [Color(0xFF140B12), Color(0xFF1A0F1A)]
            : const [Color(0xFFFFF6F1), Color(0xFFFFE9E1)];
      case AppBackgroundTheme.citrus:
        return isDark
            ? const [Color(0xFF11120B), Color(0xFF171A10)]
            : const [Color(0xFFFFFBEA), Color(0xFFFFF1C9)];
      case AppBackgroundTheme.graphite:
        return isDark
            ? const [Color(0xFF0B0F16), Color(0xFF0F1622)]
            : const [Color(0xFFF7F8FA), Color(0xFFECEFF4)];
      case AppBackgroundTheme.sakura:
        return isDark
            ? const [Color(0xFF130A12), Color(0xFF1B0D16)]
            : const [Color(0xFFFFF5F8), Color(0xFFFFE7EF)];
      case AppBackgroundTheme.mint:
        return isDark
            ? const [Color(0xFF07131A), Color(0xFF071C1D)]
            : const [Color(0xFFF2FFFB), Color(0xFFE6FFF5)];
      case AppBackgroundTheme.midnight:
        return isDark
            ? const [Color(0xFF070A12), Color(0xFF0B1220)]
            : const [Color(0xFFF6F7FF), Color(0xFFE9ECFF)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final isDark = themeData.brightness == Brightness.dark;
    final colors = _previewColors(isDark);
    final border = selected
        ? themeData.colorScheme.primary.withValues(alpha: 0.8)
        : themeData.colorScheme.outlineVariant.withValues(alpha: 0.6);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: border, width: selected ? 1.6 : 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.08),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeData.colorScheme.surface.withValues(alpha: 0.55),
                  border: Border.all(
                    color: themeData.colorScheme.onSurface.withValues(alpha: 0.08),
                  ),
                ),
                child: Icon(
                  selected ? Icons.check_rounded : Icons.blur_on_rounded,
                  size: 18,
                  color: selected
                      ? themeData.colorScheme.primary
                      : themeData.colorScheme.onSurface.withValues(alpha: 0.72),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  _label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: themeData.textTheme.labelLarge?.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF0B1220),
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
