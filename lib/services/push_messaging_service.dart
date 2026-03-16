import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../core/firebase/firebase_bootstrap.dart';
import '../firebase_options.dart';
import '../router/app_router.dart';
import '../utils/crash_log.dart';
import 'api_service.dart';
import 'local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (_) {
    // Firebase may already be initialized in isolate; ignore.
  }
}

class PushMessagingService {
  PushMessagingService._();

  static final PushMessagingService instance = PushMessagingService._();

  bool _initialized = false;
  String? _cachedToken;
  StreamSubscription<RemoteMessage>? _onMessageSub;
  StreamSubscription<RemoteMessage>? _onMessageOpenedAppSub;
  StreamSubscription<String>? _onTokenRefreshSub;
  String? _lastOpenedLuggageId;

  Future<void> ensureInitialized() async {
    if (_initialized || kIsWeb) return;
    if (!FirebaseBootstrap.isReady) return;
    try {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      final messaging = FirebaseMessaging.instance;
      await messaging.requestPermission(alert: true, badge: true, sound: true);
      await messaging.setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: true,
      );

      _onMessageSub ??= FirebaseMessaging.onMessage.listen(
        _handleForegroundMessage,
      );
      _onMessageOpenedAppSub ??= FirebaseMessaging.onMessageOpenedApp.listen(
        _handleMessageTap,
      );
      _onTokenRefreshSub ??= messaging.onTokenRefresh.listen((token) {
        _cachedToken = token;
        unawaited(syncTokenWithBackend());
      });

      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageTap(initialMessage);
      }
      _cachedToken ??= await messaging.getToken();
      await syncTokenWithBackend();
      _initialized = true;
    } catch (e) {
      appLog('push', 'init failed: $e', level: AppLogLevel.warn);
    }
  }

  Future<void> syncTokenWithBackend() async {
    if (kIsWeb) return;
    try {
      await ApiService.ensureInitialized();
      if (!ApiService.isAuthenticated) return;
      final token = _cachedToken ?? await FirebaseMessaging.instance.getToken();
      if (token == null || token.trim().isEmpty) return;
      _cachedToken = token.trim();
      final res = await ApiService.registerPushToken(
        token: _cachedToken!,
        platform: _platformName(),
      );
      if (res['ok'] != true) {
        appLog(
          'push',
          'token register failed: ${res['error'] ?? res['message'] ?? 'unknown'}',
          level: AppLogLevel.warn,
        );
      }
    } catch (e) {
      appLog('push', 'sync failed: $e', level: AppLogLevel.warn);
    }
  }

  Future<void> unregisterCurrentToken() async {
    if (kIsWeb) return;
    try {
      await ApiService.ensureInitialized();
      if (!ApiService.isAuthenticated) return;
      final token = _cachedToken ?? await FirebaseMessaging.instance.getToken();
      if (token == null || token.trim().isEmpty) return;
      _cachedToken = token.trim();
      await ApiService.removePushToken(_cachedToken!);
    } catch (e) {
      appLog('push', 'unregister failed: $e', level: AppLogLevel.warn);
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final title =
        message.notification?.title ?? message.data['title'] ?? 'KYRADI';
    final body =
        message.notification?.body ??
        message.data['body'] ??
        'Rezervasyonunda yeni bir güncelleme var.';
    unawaited(
      LocalNotificationService.instance.showGeneric(
        title: title.toString(),
        body: body.toString(),
        channelId: 'kyradi_push_live',
        channelName: 'Canlı Push Bildirimleri',
        channelDescription: 'Sunucudan gelen canlı rezervasyon bildirimleri',
      ),
    );
  }

  void _handleMessageTap(RemoteMessage message) {
    final luggageId =
        message.data['luggageId']?.toString() ??
        message.data['reservationId']?.toString() ??
        '';
    if (luggageId.isEmpty) return;
    if (_lastOpenedLuggageId == luggageId) return;
    _lastOpenedLuggageId = luggageId;
    final context = rootNavigatorKey.currentContext;
    if (context == null) return;
    GoRouter.of(context).go('/luggage/$luggageId');
  }

  String _platformName() {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
        return 'ios';
      case TargetPlatform.android:
        return 'android';
      case TargetPlatform.macOS:
        return 'macos';
      case TargetPlatform.windows:
        return 'windows';
      case TargetPlatform.linux:
        return 'linux';
      case TargetPlatform.fuchsia:
        return 'fuchsia';
    }
  }
}
