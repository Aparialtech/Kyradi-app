import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppCurrency { tl, eur, usd }

class AppCurrencyMode {
  AppCurrencyMode._();

  static const _prefsKey = 'preferred_currency';
  static final ValueNotifier<AppCurrency> notifier = ValueNotifier<AppCurrency>(
    AppCurrency.tl,
  );

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_prefsKey) ?? 'tl';
    notifier.value = fromCode(raw);
  }

  static Future<void> set(AppCurrency currency) async {
    notifier.value = currency;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, toCode(currency));
  }

  static AppCurrency fromCode(String raw) {
    switch (raw.toLowerCase()) {
      case 'eur':
        return AppCurrency.eur;
      case 'usd':
        return AppCurrency.usd;
      case 'tl':
      default:
        return AppCurrency.tl;
    }
  }

  static String toCode(AppCurrency currency) {
    switch (currency) {
      case AppCurrency.eur:
        return 'eur';
      case AppCurrency.usd:
        return 'usd';
      case AppCurrency.tl:
        return 'tl';
    }
  }

  static String symbol(AppCurrency currency) {
    switch (currency) {
      case AppCurrency.eur:
        return '€';
      case AppCurrency.usd:
        return '\$';
      case AppCurrency.tl:
        return '₺';
    }
  }

  static String uiLabel(AppCurrency currency) {
    switch (currency) {
      case AppCurrency.eur:
        return 'EUR (€)';
      case AppCurrency.usd:
        return 'USD (\$)';
      case AppCurrency.tl:
        return 'TRY (₺)';
    }
  }

  // Base wallet values are stored in TRY.
  static double convertFromTry(double amountTry, AppCurrency currency) {
    switch (currency) {
      case AppCurrency.eur:
        return amountTry * 0.028;
      case AppCurrency.usd:
        return amountTry * 0.031;
      case AppCurrency.tl:
        return amountTry;
    }
  }

  static String formatFromTry(
    double amountTry, {
    AppCurrency? currency,
    int fractionDigits = 2,
  }) {
    final selected = currency ?? notifier.value;
    final converted = convertFromTry(amountTry, selected);
    return '${symbol(selected)}${converted.toStringAsFixed(fractionDigits)}';
  }
}
