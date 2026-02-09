import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppBackgroundTheme {
  ocean,
  aurora,
  sunset,
  citrus,
  graphite,
  sakura,
  mint,
  midnight,
}

class AppBackgroundThemeMode {
  AppBackgroundThemeMode._();

  static const _prefsKey = 'background_theme';
  static final ValueNotifier<AppBackgroundTheme> notifier =
      ValueNotifier<AppBackgroundTheme>(AppBackgroundTheme.ocean);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = (prefs.getString(_prefsKey) ?? '').trim();
    final parsed = _parse(raw);
    if (parsed != null) {
      notifier.value = parsed;
    }
  }

  static Future<void> set(AppBackgroundTheme theme) async {
    notifier.value = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, theme.name);
  }

  static AppBackgroundTheme? _parse(String raw) {
    for (final v in AppBackgroundTheme.values) {
      if (v.name == raw) return v;
    }
    return null;
  }
}
