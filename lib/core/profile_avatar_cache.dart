import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileAvatarCache {
  ProfileAvatarCache._();

  static final ValueNotifier<String?> notifier = ValueNotifier<String?>(null);

  static String _key(String? userId) => 'profile_avatar_path_${userId ?? 'unknown'}';

  static Future<void> load(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    notifier.value = prefs.getString(_key(userId));
  }

  static Future<void> set(String? userId, String? path) async {
    final prefs = await SharedPreferences.getInstance();
    if (path == null || path.trim().isEmpty) {
      await prefs.remove(_key(userId));
      notifier.value = null;
    } else {
      await prefs.setString(_key(userId), path.trim());
      notifier.value = path.trim();
    }
  }
}
