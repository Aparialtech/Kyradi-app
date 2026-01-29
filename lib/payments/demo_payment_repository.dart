import 'dart:async';
import 'payment_repository.dart';

class DemoPaymentRepository implements PaymentRepository {
  @override
  Future<Map<String, dynamic>> pay({
    required int amount,
    required String currency,
    required String method,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 1200));
    return {
      'ok': true,
      'status': 'success',
      'paymentId': 'DEMO-${DateTime.now().millisecondsSinceEpoch}',
    };
  }
}
