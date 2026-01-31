import 'package:firebase_core/firebase_core.dart';
import '../../utils/crash_log.dart';
import '../../firebase_options.dart';

class FirebaseBootstrap {
  FirebaseBootstrap._();

  static bool isReady = false;
  static String lastErrorCode = '';

  static Future<void> initFirebase() async {
    try {
      if (DefaultFirebaseOptions.isConfigured) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        appLog('firebase', 'init with explicit options',
            level: AppLogLevel.info);
      } else {
        await Firebase.initializeApp();
        appLog('firebase', 'init with platform defaults',
            level: AppLogLevel.info);
      }
      isReady = true;
      appLog('firebase', 'ready=true', level: AppLogLevel.info);
    } catch (e) {
      isReady = false;
      lastErrorCode = 'INIT_FAILED';
      appLog('firebase', 'init failed: $e', level: AppLogLevel.error);
    }
  }
}
