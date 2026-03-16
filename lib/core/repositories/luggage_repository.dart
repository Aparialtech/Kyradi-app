import '../../models/luggage.dart';
import '../../services/api_service.dart';

class LuggageRepository {
  const LuggageRepository();

  static const Duration _locationCacheTtl = Duration(minutes: 3);
  static List<Map<String, dynamic>> _cachedLocations = const [];
  static DateTime? _cachedLocationsAt;

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
    final requestPayload = Map<String, dynamic>.from(payload);
    await _resolveLocationPayload(requestPayload);
    var result = await ApiService.createLuggage(userId, requestPayload);
    if (_isLocationNotFound(result)) {
      await _resolveLocationPayload(requestPayload, forceRefresh: true);
      result = await ApiService.createLuggage(userId, requestPayload);
    }
    if (result['ok'] == true && result['luggage'] is Map) {
      return LuggageModel.fromJson(
        Map<String, dynamic>.from(result['luggage'] as Map),
      );
    }
    final message =
        (result['message'] ?? result['error'] ?? 'LUGGAGE_CREATE_FAILED')
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

  Future<Map<String, dynamic>> cancel(String userId, String luggageId) {
    return ApiService.cancelLuggage(userId, luggageId);
  }

  Future<void> _resolveLocationPayload(
    Map<String, dynamic> payload, {
    bool forceRefresh = false,
  }) async {
    final rawId = (payload['dropLocationId'] ?? '').toString().trim();
    final rawName = (payload['dropLocationName'] ?? '').toString().trim();
    if (rawId.isEmpty && rawName.isEmpty) return;

    final locations = await _loadLocations(forceRefresh: forceRefresh);
    if (locations.isEmpty) return;

    Map<String, dynamic>? match = _findById(locations, rawId);
    match ??= _findByName(locations, rawName);

    if (match == null) return;

    final resolvedId = _locationId(match);
    final resolvedName = (match['name'] ?? '').toString().trim();
    if (resolvedId.isNotEmpty) {
      payload['dropLocationId'] = resolvedId;
    }
    if (resolvedName.isNotEmpty) {
      payload['dropLocationName'] = resolvedName;
    }
  }

  Future<List<Map<String, dynamic>>> _loadLocations({
    bool forceRefresh = false,
  }) async {
    final now = DateTime.now();
    final hasFreshCache =
        !forceRefresh &&
        _cachedLocations.isNotEmpty &&
        _cachedLocationsAt != null &&
        now.difference(_cachedLocationsAt!) <= _locationCacheTtl;
    if (hasFreshCache) {
      return _cachedLocations;
    }

    final response = await ApiService.getLocations();
    final rawItems = response['locations'];
    if (response['ok'] == true && rawItems is List) {
      final parsed = rawItems
          .whereType<Map>()
          .map((raw) => Map<String, dynamic>.from(raw))
          .where((item) => _locationId(item).isNotEmpty)
          .toList();
      if (parsed.isNotEmpty) {
        _cachedLocations = parsed;
        _cachedLocationsAt = now;
        return parsed;
      }
    }
    return _cachedLocations;
  }

  Map<String, dynamic>? _findById(
    List<Map<String, dynamic>> locations,
    String rawId,
  ) {
    final target = _normalize(rawId);
    if (target.isEmpty) return null;
    for (final item in locations) {
      final candidates = <String>[
        _locationId(item),
        (item['id'] ?? '').toString(),
        (item['slug'] ?? '').toString(),
        (item['code'] ?? '').toString(),
        (item['name'] ?? '').toString(),
      ];
      for (final candidate in candidates) {
        if (_normalize(candidate) == target) {
          return item;
        }
      }
    }
    return null;
  }

  Map<String, dynamic>? _findByName(
    List<Map<String, dynamic>> locations,
    String rawName,
  ) {
    final target = _normalize(rawName);
    if (target.isEmpty) return null;
    for (final item in locations) {
      final name = _normalize((item['name'] ?? '').toString());
      final address = _normalize((item['address'] ?? '').toString());
      if (name.isNotEmpty &&
          (name == target || name.contains(target) || target.contains(name))) {
        return item;
      }
      if (address.isNotEmpty &&
          (address.contains(target) || target.contains(address))) {
        return item;
      }
    }
    return null;
  }

  String _locationId(Map<String, dynamic> location) {
    return (location['_id'] ?? location['id'] ?? '').toString().trim();
  }

  String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('ı', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .replaceAll(RegExp(r'[^a-z0-9 ]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  bool _isLocationNotFound(Map<String, dynamic> result) {
    final message = '${result['message'] ?? ''} ${result['error'] ?? ''}'
        .toUpperCase();
    return message.contains('LOCATION_NOT_FOUND');
  }
}
