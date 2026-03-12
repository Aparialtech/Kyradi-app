import 'package:shared_preferences/shared_preferences.dart';

class PaymentMethodPrefs {
  static const String creditKey = 'payment_method_credit_enabled';
  static const String debitKey = 'payment_method_debit_enabled';
  static const String hotelKey = 'payment_method_hotel_enabled';

  static Future<PaymentMethodAvailability> load() async {
    final prefs = await SharedPreferences.getInstance();
    return PaymentMethodAvailability(
      creditCardEnabled: prefs.getBool(creditKey) ?? true,
      debitCardEnabled: prefs.getBool(debitKey) ?? true,
      hotelPayEnabled: prefs.getBool(hotelKey) ?? true,
    );
  }

  static Future<void> setCreditEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(creditKey, value);
  }

  static Future<void> setDebitEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(debitKey, value);
  }

  static Future<void> setHotelEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(hotelKey, value);
  }
}

class PaymentMethodAvailability {
  const PaymentMethodAvailability({
    required this.creditCardEnabled,
    required this.debitCardEnabled,
    required this.hotelPayEnabled,
  });

  const PaymentMethodAvailability.defaults()
    : creditCardEnabled = true,
      debitCardEnabled = true,
      hotelPayEnabled = true;

  final bool creditCardEnabled;
  final bool debitCardEnabled;
  final bool hotelPayEnabled;

  bool get cardEnabled => creditCardEnabled || debitCardEnabled;
}
