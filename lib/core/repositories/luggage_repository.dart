import '../../models/luggage.dart';
import '../../services/api_service.dart';

class LuggageRepository {
  const LuggageRepository();

  Future<List<LuggageModel>> getUserLuggages(String userId) async {
    final response = await ApiService.getUserLuggages(userId);
    final items = response['luggages'];
    if (items is List) {
      return items
          .whereType<Map>()
          .map((raw) => LuggageModel.fromJson(Map<String, dynamic>.from(raw)))
          .toList();
    }
    return const [];
  }

  Future<LuggageModel> createLuggage(
    String userId,
    Map<String, dynamic> payload,
  ) async {
    final result = await ApiService.createLuggage(userId, payload);
    if (result['ok'] == true && result['luggage'] is Map) {
      return LuggageModel.fromJson(
        Map<String, dynamic>.from(result['luggage'] as Map),
      );
    }
    final message = (result['message'] ?? result['error'] ?? 'LUGGAGE_CREATE_FAILED')
        .toString();
    throw Exception(message);
  }

  Future<Map<String, dynamic>> updateStatus(
    String userId,
    String luggageId,
    String status,
    String? pickupPin,
    String? delegateCode,
  ) {
    return ApiService.updateLuggageStatus(
      userId,
      luggageId,
      status,
      pickupPin,
      delegateCode,
    );
  }

  Future<Map<String, dynamic>> cancel(
    String userId,
    String luggageId,
  ) {
    return ApiService.cancelLuggage(userId, luggageId);
  }
}
