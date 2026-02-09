import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationPrefs {
  NotificationPrefs._();

  static const _criticalOnlyKey = 'notifications_critical_only';
  static final ValueNotifier<bool> criticalOnly = ValueNotifier<bool>(false);

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    criticalOnly.value = prefs.getBool(_criticalOnlyKey) ?? false;
  }

  static Future<void> setCriticalOnly(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_criticalOnlyKey, value);
    criticalOnly.value = value;
  }
}
