import '../models/luggage.dart';
import 'api_service.dart';

class LuggageService {
  const LuggageService._();

  static Future<List<LuggageModel>> getUserLuggages(String userId) async {
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

  static Future<Map<String, dynamic>> updateStatus(
    String userId,
    String luggageId,
    String status,
  ) {
    return ApiService.updateLuggageStatus(userId, luggageId, status);
  }
}
