import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return ios;
      case TargetPlatform.android:
        return android;
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        return other;
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for fuchsia.',
        );
    }
  }

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'DUMMY_IOS_API_KEY',
    appId: 'DUMMY_IOS_APP_ID',
    messagingSenderId: 'DUMMY_IOS_SENDER_ID',
    projectId: 'DUMMY_PROJECT_ID',
    iosBundleId: 'com.example.kyradi',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'DUMMY_ANDROID_API_KEY',
    appId: 'DUMMY_ANDROID_APP_ID',
    messagingSenderId: 'DUMMY_ANDROID_SENDER_ID',
    projectId: 'DUMMY_PROJECT_ID',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'DUMMY_WEB_API_KEY',
    appId: 'DUMMY_WEB_APP_ID',
    messagingSenderId: 'DUMMY_WEB_SENDER_ID',
    projectId: 'DUMMY_PROJECT_ID',
  );

  static const FirebaseOptions other = FirebaseOptions(
    apiKey: 'DUMMY_OTHER_API_KEY',
    appId: 'DUMMY_OTHER_APP_ID',
    messagingSenderId: 'DUMMY_OTHER_SENDER_ID',
    projectId: 'DUMMY_PROJECT_ID',
  );

  static bool get isConfigured {
    return !ios.apiKey.startsWith('DUMMY') &&
        !android.apiKey.startsWith('DUMMY') &&
        !web.apiKey.startsWith('DUMMY');
  }
}
