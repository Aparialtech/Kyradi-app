import 'package:vibration/vibration.dart';

class AppHaptics {
  AppHaptics._();

  static Future<void> light() async {
    final hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator == true) {
      await Vibration.vibrate(duration: 120);
    }
  }
}
