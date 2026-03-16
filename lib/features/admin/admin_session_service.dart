import 'package:shared_preferences/shared_preferences.dart';

class AdminSessionService {
  AdminSessionService._();

  static const String _roleKey = 'admin_session_role';
  static const String _emailKey = 'admin_session_email';
  static const String _expiresAtKey = 'admin_session_expires_at';
  static const Duration _sessionTtl = Duration(hours: 12);

  static Future<void> markAuthenticated({
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final expiresAt = DateTime.now().add(_sessionTtl).millisecondsSinceEpoch;
    await prefs.setString(_roleKey, role);
    await prefs.setString(_emailKey, email);
    await prefs.setInt(_expiresAtKey, expiresAt);
  }

  static Future<bool> hasValidSession() async {
    final prefs = await SharedPreferences.getInstance();
    final role = (prefs.getString(_roleKey) ?? '').toLowerCase();
    final expiresAt = prefs.getInt(_expiresAtKey) ?? 0;
    if (expiresAt <= DateTime.now().millisecondsSinceEpoch) {
      await clear();
      return false;
    }
    return role == 'admin' || role == 'editor';
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_roleKey);
    await prefs.remove(_emailKey);
    await prefs.remove(_expiresAtKey);
  }
}

