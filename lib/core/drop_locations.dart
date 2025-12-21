import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class ReservationSlot {
  final String code;
  final DateTime time;
  final int luggageCount;

  ReservationSlot({
    required this.code,
    required this.time,
    required this.luggageCount,
  });
}

class DropLocation {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final int totalSlots;
  final int availableSlots;
  final int usedSlots;
  final List<ReservationSlot> reservations;

  DropLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.totalSlots,
    required this.availableSlots,
    int? usedSlots,
    this.reservations = const [],
  }) : usedSlots = usedSlots ??
            (totalSlots - availableSlots).clamp(0, totalSlots);

  factory DropLocation.fromJson(Map<String, dynamic> json) {
    final total = _toDouble(json['totalSlots']).round();
    final available = _toDouble(json['availableSlots']).round();
    final lat = _toDouble(json['latitude'] ?? json['lat']);
    final lng = _toDouble(json['longitude'] ?? json['lng']);
    return DropLocation(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      position: LatLng(lat, lng),
      totalSlots: total,
      availableSlots: available,
      usedSlots: _toDouble(json['usedSlots'] ?? (total - available)).round(),
      reservations: const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'address': address,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'totalSlots': totalSlots,
        'availableSlots': availableSlots,
        'usedSlots': usedSlots,
      };

  int get occupiedSlots => usedSlots.clamp(0, totalSlots);

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  double get occupancyRate {
    if (totalSlots == 0) return 0;
    return occupiedSlots / totalSlots;
  }
}

class DropLocationsRepository {
  DropLocationsRepository._();

  static final List<DropLocation> _locations = [
    DropLocation(
      id: 'taksim',
      name: 'Taksim BavulGO',
      address: 'Cumhuriyet Cd. No: 1, Beyoğlu',
      position: LatLng(41.0369, 28.9856),
      totalSlots: 12,
      availableSlots: 3,
      usedSlots: 12 - 3,
      reservations: [
        ReservationSlot(
          code: 'BG-4521',
          time: DateTime(2025, 2, 16, 10, 30),
          luggageCount: 2,
        ),
        ReservationSlot(
          code: 'BG-4529',
          time: DateTime(2025, 2, 16, 12, 0),
          luggageCount: 1,
        ),
      ],
    ),
    DropLocation(
      id: 'kagithane',
      name: 'Kağıthane BavulGO',
      address: 'Merkez Mah. Kağıthane',
      position: LatLng(41.1085, 28.9722),
      totalSlots: 8,
      availableSlots: 1,
      usedSlots: 8 - 1,
      reservations: [
        ReservationSlot(
          code: 'BG-4610',
          time: DateTime(2025, 2, 16, 9, 15),
          luggageCount: 3,
        ),
      ],
    ),
    DropLocation(
      id: 'besiktas',
      name: 'Beşiktaş BavulGO',
      address: 'Çırağan Cad., Beşiktaş',
      position: LatLng(41.041, 29.0078),
      totalSlots: 10,
      availableSlots: 4,
      usedSlots: 10 - 4,
      reservations: [
        ReservationSlot(
          code: 'BG-4622',
          time: DateTime(2025, 2, 16, 15, 0),
          luggageCount: 1,
        ),
      ],
    ),
    DropLocation(
      id: 'kadikoy',
      name: 'Kadıköy BavulGO',
      address: 'Kadıköy Rıhtım Cd.',
      position: LatLng(40.9929, 29.02799),
      totalSlots: 16,
      availableSlots: 6,
      usedSlots: 16 - 6,
      reservations: [
        ReservationSlot(
          code: 'BG-4631',
          time: DateTime(2025, 2, 16, 11, 30),
          luggageCount: 2,
        ),
        ReservationSlot(
          code: 'BG-4637',
          time: DateTime(2025, 2, 16, 14, 45),
          luggageCount: 1,
        ),
      ],
    ),
    DropLocation(
      id: 'sisli',
      name: 'Şişli BavulGO',
      address: 'Halaskargazi Cd., Şişli',
      position: LatLng(41.0601, 28.9876),
      totalSlots: 5,
      availableSlots: 0,
      usedSlots: 5,
      reservations: [
        ReservationSlot(
          code: 'BG-4701',
          time: DateTime(2025, 2, 16, 13, 15),
          luggageCount: 1,
        ),
        ReservationSlot(
          code: 'BG-4705',
          time: DateTime(2025, 2, 16, 17, 0),
          luggageCount: 2,
        ),
      ],
    ),
    DropLocation(
      id: 'bakirkoy',
      name: 'Bakırköy BavulGO',
      address: 'İncirli Cd., Bakırköy',
      position: LatLng(40.978, 28.8724),
      totalSlots: 9,
      availableSlots: 2,
      usedSlots: 9 - 2,
      reservations: [
        ReservationSlot(
          code: 'BG-4800',
          time: DateTime(2025, 2, 16, 8, 45),
          luggageCount: 1,
        ),
      ],
    ),
  ];

  static List<DropLocation> get locations => List.unmodifiable(_locations);

  static DropLocation? byId(String? id) {
    if (id == null) return null;
    try {
      return _locations.firstWhere((loc) => loc.id == id);
    } catch (_) {
      return null;
    }
  }

  static DropLocation? byName(String? name) {
    if (name == null || name.isEmpty) return null;
    try {
      return _locations.firstWhere((loc) => loc.name == name);
    } catch (_) {
      return null;
    }
  }

  static List<DropLocation> nearestTo(
    LatLng position, {
    int limit = 3,
  }) {
    final sorted = List<DropLocation>.from(_locations)
      ..sort(
        (a, b) =>
            _distance(a.position, position).compareTo(_distance(b.position, position)),
      );
    return sorted.take(limit).toList();
  }

  static double _distance(LatLng a, LatLng b) {
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLon = _degToRad(b.longitude - a.longitude);
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);

    final hav =
        (sin(dLat / 2) * sin(dLat / 2)) +
        (sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2));
    final c = 2 * atan2(sqrt(hav), sqrt(1 - hav));
    const earthRadius = 6371; // km
    return earthRadius * c;
  }

  static double _degToRad(double deg) => deg * (pi / 180);
}
