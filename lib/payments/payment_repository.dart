abstract class PaymentRepository {
  Future<Map<String, dynamic>> pay({
    required int amount,
    required String currency,
    required String method,
  });
}
