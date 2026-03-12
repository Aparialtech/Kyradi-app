import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/crash_log.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool _permissionRequested = false;

  Future<void> ensureInitialized() async {
    if (_initialized || kIsWeb) return;
    try {
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      const settings = InitializationSettings(android: android, iOS: ios);
      await _plugin.initialize(settings);
      _initialized = true;
      await _requestPermissions();
    } catch (e) {
      appLog('local_notification', 'init failed: $e', level: AppLogLevel.warn);
    }
  }

  Future<void> _requestPermissions() async {
    if (_permissionRequested || !_initialized) return;
    _permissionRequested = true;
    try {
      await _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      await _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    } catch (e) {
      appLog(
        'local_notification',
        'permission request failed: $e',
        level: AppLogLevel.warn,
      );
    }
  }

  Future<void> showReservationCreated(String reservationLabel) async {
    final prefs = await SharedPreferences.getInstance();
    final pushEnabled = prefs.getBool('pref_push_reminder') ?? true;
    if (!pushEnabled) return;

    await ensureInitialized();
    if (!_initialized) return;

    final safeLabel = reservationLabel.trim().isEmpty
        ? 'Rezervasyonunuz'
        : reservationLabel.trim();

    try {
      await _show(
        channelId: 'kyradi_reservations',
        channelName: 'Rezervasyon Bildirimleri',
        channelDescription: 'Rezervasyon durum guncellemeleri',
        title: 'KYRADI',
        body: '$safeLabel isimli rezervasyonunuz alinmistir.',
      );
    } catch (e) {
      appLog('local_notification', 'show failed: $e', level: AppLogLevel.warn);
    }
  }

  Future<void> showLuggageStatusUpdated({
    required String reservationLabel,
    required String statusLabel,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final pushEnabled = prefs.getBool('pref_push_reminder') ?? true;
    if (!pushEnabled) return;

    await ensureInitialized();
    if (!_initialized) return;

    final safeLabel = reservationLabel.trim().isEmpty
        ? 'Rezervasyonunuz'
        : reservationLabel.trim();
    final safeStatus = statusLabel.trim().isEmpty
        ? 'Guncellendi'
        : statusLabel.trim();

    try {
      await _show(
        channelId: 'kyradi_status_updates',
        channelName: 'Durum Bildirimleri',
        channelDescription: 'Bavul durum degisiklikleri',
        title: 'Durum Guncellendi',
        body: '$safeLabel: $safeStatus',
      );
    } catch (e) {
      appLog(
        'local_notification',
        'status show failed: $e',
        level: AppLogLevel.warn,
      );
    }
  }

  Future<void> showPaymentSuccess({
    required String reservationLabel,
    required int amountTry,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final pushEnabled = prefs.getBool('pref_push_reminder') ?? true;
    if (!pushEnabled) return;

    await ensureInitialized();
    if (!_initialized) return;

    final safeLabel = reservationLabel.trim().isEmpty
        ? 'Rezervasyonunuz'
        : reservationLabel.trim();
    final amountLabel = amountTry > 0 ? '$amountTry ₺' : 'Odeme';

    try {
      await _show(
        channelId: 'kyradi_payments',
        channelName: 'Odeme Bildirimleri',
        channelDescription: 'Odeme tamamlanma bildirimleri',
        title: 'Odeme Basarili',
        body: '$safeLabel icin $amountLabel odeme tamamlandi.',
      );
    } catch (e) {
      appLog(
        'local_notification',
        'payment show failed: $e',
        level: AppLogLevel.warn,
      );
    }
  }

  Future<void> showReservationCancelled(String reservationLabel) async {
    final prefs = await SharedPreferences.getInstance();
    final pushEnabled = prefs.getBool('pref_push_reminder') ?? true;
    if (!pushEnabled) return;

    await ensureInitialized();
    if (!_initialized) return;

    final safeLabel = reservationLabel.trim().isEmpty
        ? 'Rezervasyonunuz'
        : reservationLabel.trim();

    try {
      await _show(
        channelId: 'kyradi_reservation_cancelled',
        channelName: 'Rezervasyon Iptal',
        channelDescription: 'Iptal edilen rezervasyon bildirimleri',
        title: 'Rezervasyon Iptal Edildi',
        body: '$safeLabel icin iptal islemi tamamlandi.',
      );
    } catch (e) {
      appLog(
        'local_notification',
        'cancel show failed: $e',
        level: AppLogLevel.warn,
      );
    }
  }

  Future<void> _show({
    required String channelId,
    required String channelName,
    required String channelDescription,
    required String title,
    required String body,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDescription,
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    await _plugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }
}
