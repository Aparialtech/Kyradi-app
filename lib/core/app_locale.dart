import 'package:flutter/material.dart';

class AppLocale {
  static final ValueNotifier<Locale?> notifier =
      ValueNotifier<Locale?>(const Locale('tr'));
}
