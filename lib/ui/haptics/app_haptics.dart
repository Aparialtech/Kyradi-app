import 'package:vibration/vibration.dart';

class AppHaptics {
  AppHaptics._();

  static Future<void> light() async {
    if (await Vibration.hasVibrator() ?? false) {
      await Vibration.vibrate(duration: 120);
    }
  }
}
