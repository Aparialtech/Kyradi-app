import 'package:shared_preferences/shared_preferences.dart';

class WalletPaymentHandler {
  const WalletPaymentHandler._();

  static Future<double> getBalance() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble('wallet_balance') ?? 0;
  }

  static Future<void> setBalance(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('wallet_balance', value);
  }

  static Future<bool> canPay(int amount) async {
    final balance = await getBalance();
    return balance >= amount;
  }
}
