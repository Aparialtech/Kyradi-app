import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TravelCompanionStore {
  TravelCompanionStore._();

  static const String _flightPrefix = 'travel_flight_';

  static Future<void> saveFlightInfo({
    required String luggageId,
    required String airline,
    required DateTime flightAt,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = jsonEncode({
      'airline': airline.trim(),
      'flightAt': flightAt.toIso8601String(),
    });
    await prefs.setString('$_flightPrefix$luggageId', payload);
  }

  static Future<FlightInfo?> loadFlightInfo(String luggageId) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_flightPrefix$luggageId');
    if (raw == null || raw.isEmpty) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final airline = (map['airline'] ?? '').toString();
      final flightAtRaw = (map['flightAt'] ?? '').toString();
      if (airline.isEmpty || flightAtRaw.isEmpty) return null;
      final flightAt = DateTime.tryParse(flightAtRaw);
      if (flightAt == null) return null;
      return FlightInfo(airline: airline, flightAt: flightAt);
    } catch (_) {
      return null;
    }
  }

  static TravelSuggestion buildSuggestion({
    required String locationName,
    required DateTime flightAt,
  }) {
    final type = _locationType(locationName);
    final minutes = _transferMinutes(type);
    final recommendation = flightAt.subtract(Duration(minutes: minutes + 45));
    return TravelSuggestion(
      transferMinutes: minutes,
      recommendedPickup: recommendation,
      typeLabel: _typeLabel(type),
    );
  }

  static String _locationType(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('havaliman') || lower.contains('airport')) {
      return 'airport';
    }
    if (lower.contains('avm') || lower.contains('mall')) {
      return 'mall';
    }
    return 'center';
  }

  static int _transferMinutes(String type) {
    switch (type) {
      case 'airport':
        return 38;
      case 'mall':
        return 20;
      default:
        return 15;
    }
  }

  static String _typeLabel(String type) {
    switch (type) {
      case 'airport':
        return 'Havalimanı';
      case 'mall':
        return 'AVM';
      default:
        return 'Merkez';
    }
  }
}

class FlightInfo {
  const FlightInfo({
    required this.airline,
    required this.flightAt,
  });

  final String airline;
  final DateTime flightAt;
}

class TravelSuggestion {
  const TravelSuggestion({
    required this.transferMinutes,
    required this.recommendedPickup,
    required this.typeLabel,
  });

  final int transferMinutes;
  final DateTime recommendedPickup;
  final String typeLabel;
}
