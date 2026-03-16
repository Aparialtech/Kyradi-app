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
    if (!await _canNotify()) return;
    final safeLabel = _safeReservationLabel(reservationLabel);

    try {
      await _show(
        channelId: 'kyradi_reservations',
        channelName: 'Rezervasyon Bildirimleri',
        channelDescription: 'Rezervasyon durum güncellemeleri',
        title: 'Rezervasyon Alındı',
        body: '$safeLabel başarıyla oluşturuldu.',
      );
    } catch (e) {
      appLog('local_notification', 'show failed: $e', level: AppLogLevel.warn);
    }
  }

  Future<void> showLuggageStatusUpdated({
    required String reservationLabel,
    required String statusLabel,
  }) async {
    if (!await _canNotify()) return;
    final safeLabel = _safeReservationLabel(reservationLabel);
    final safeStatus = statusLabel.trim().isEmpty
        ? 'Güncellendi'
        : statusLabel.trim();

    try {
      await _show(
        channelId: 'kyradi_status_updates',
        channelName: 'Durum Bildirimleri',
        channelDescription: 'Bavul durum değişiklikleri',
        title: 'Rezervasyon Güncellendi',
        body: '$safeLabel durumu: $safeStatus',
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
    if (!await _canNotify()) return;
    final safeLabel = _safeReservationLabel(reservationLabel);
    final paymentLabel = amountTry > 0 ? '$amountTry ₺' : 'Ödeme';

    try {
      await _show(
        channelId: 'kyradi_payments',
        channelName: 'Ödeme Bildirimleri',
        channelDescription: 'Ödeme tamamlanma bildirimleri',
        title: 'Ödeme Tamamlandı',
        body: '$safeLabel için $paymentLabel işlemi onaylandı.',
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
    if (!await _canNotify()) return;
    final safeLabel = _safeReservationLabel(reservationLabel);

    try {
      await _show(
        channelId: 'kyradi_reservation_cancelled',
        channelName: 'Rezervasyon İptal',
        channelDescription: 'İptal edilen rezervasyon bildirimleri',
        title: 'Rezervasyon İptal Edildi',
        body: '$safeLabel için iptal işlemi tamamlandı.',
      );
    } catch (e) {
      appLog(
        'local_notification',
        'cancel show failed: $e',
        level: AppLogLevel.warn,
      );
    }
  }

  Future<void> showGeneric({
    required String title,
    required String body,
    String channelId = 'kyradi_general',
    String channelName = 'Genel Bildirimler',
    String channelDescription = 'Uygulama bildirimleri',
  }) async {
    if (!await _canNotify()) return;
    final safeTitle = title.trim().isEmpty ? 'KYRADI' : title.trim();
    final safeBody = body.trim().isEmpty
        ? 'Yeni bir bildirimin var.'
        : body.trim();
    try {
      await _show(
        channelId: channelId,
        channelName: channelName,
        channelDescription: channelDescription,
        title: safeTitle,
        body: safeBody,
      );
    } catch (e) {
      appLog(
        'local_notification',
        'generic show failed: $e',
        level: AppLogLevel.warn,
      );
    }
  }

  Future<bool> _canNotify() async {
    final prefs = await SharedPreferences.getInstance();
    final pushEnabled = prefs.getBool('pref_push_reminder') ?? true;
    if (!pushEnabled) return false;
    await ensureInitialized();
    return _initialized;
  }

  String _safeReservationLabel(String reservationLabel) {
    final value = reservationLabel.trim();
    if (value.isEmpty) return 'Rezervasyonunuz';
    return value;
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
