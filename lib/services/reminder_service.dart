import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/app_notification.dart';

class ReminderService {
  ReminderService._();

  static bool pushEnabled = true;
  static bool emailEnabled = true;

  static final List<Timer> _scheduledTimers = [];

  static void setPushEnabled(bool value) {
    pushEnabled = value;
  }

  static void setEmailEnabled(bool value) {
    emailEnabled = value;
  }

  static void scheduleReminders(
    BuildContext context, {
    required String label,
    DateTime? dropTime,
    DateTime? pickupTime,
  }) {
    _schedule(
      context,
      time: dropTime,
      pushMessage: '$label için bırakma saati yaklaşıyor.',
      emailSubject: 'Bırakma hatırlatıcısı',
    );
    _schedule(
      context,
      time: pickupTime,
      pushMessage: '$label için teslim alma saati yaklaşıyor.',
      emailSubject: 'Teslim alma hatırlatıcısı',
    );
  }

  static void _schedule(
    BuildContext context, {
    required DateTime? time,
    required String pushMessage,
    required String emailSubject,
  }) {
    if (time == null) return;
    final difference = time.difference(DateTime.now());
    if (difference.isNegative) {
      if (pushEnabled) {
        AppNotification.show(
          context,
          message: pushMessage,
          type: AppNotificationType.info,
        );
      }
      return;
    }

    if (pushEnabled) {
      final timer = Timer(difference, () {
        AppNotification.show(
          context,
          message: pushMessage,
          type: AppNotificationType.info,
        );
      });
      _scheduledTimers.add(timer);
    }

    if (emailEnabled) {
      debugPrint('[ReminderService] Email scheduled: $emailSubject at $time');
    }
  }

  static void cancelAll() {
    for (final timer in _scheduledTimers) {
      timer.cancel();
    }
    _scheduledTimers.clear();
  }
}
