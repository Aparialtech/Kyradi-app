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

class OpeningHoursRange {
  final String start;
  final String end;

  const OpeningHoursRange({
    required this.start,
    required this.end,
  });

  factory OpeningHoursRange.fromJson(Map<String, dynamic> json) {
    return OpeningHoursRange(
      start: (json['start'] ?? '').toString(),
      end: (json['end'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
      };
}

const Map<String, List<OpeningHoursRange>> kAlwaysOpenHours = {
  'mon': [OpeningHoursRange(start: '00:00', end: '23:59')],
  'tue': [OpeningHoursRange(start: '00:00', end: '23:59')],
  'wed': [OpeningHoursRange(start: '00:00', end: '23:59')],
  'thu': [OpeningHoursRange(start: '00:00', end: '23:59')],
  'fri': [OpeningHoursRange(start: '00:00', end: '23:59')],
  'sat': [OpeningHoursRange(start: '00:00', end: '23:59')],
  'sun': [OpeningHoursRange(start: '00:00', end: '23:59')],
};

class DropLocation {
  final String id;
  final String name;
  final String address;
  final LatLng position;
  final int totalSlots;
  final int availableSlots;
  final int usedSlots;
  final int maxCapacity;
  final int currentOccupancy;
  final Map<String, List<OpeningHoursRange>> openingHours;
  final String timezone;
  final bool isActive;
  final List<ReservationSlot> reservations;

  DropLocation({
    required this.id,
    required this.name,
    required this.address,
    required this.position,
    required this.totalSlots,
    required this.availableSlots,
    int? usedSlots,
    int? maxCapacity,
    int? currentOccupancy,
    Map<String, List<OpeningHoursRange>>? openingHours,
    String? timezone,
    bool? isActive,
    this.reservations = const [],
  })  : usedSlots = usedSlots ?? (totalSlots - availableSlots).clamp(0, totalSlots),
        maxCapacity = maxCapacity ?? totalSlots,
        currentOccupancy =
            currentOccupancy ??
            (usedSlots ?? (totalSlots - availableSlots).clamp(0, totalSlots)),
        openingHours = openingHours ?? const {},
        timezone = timezone ?? 'Europe/Istanbul',
        isActive = isActive ?? true;

  factory DropLocation.fromJson(Map<String, dynamic> json) {
    final total = _toDouble(json['totalSlots']).round();
    final available = _toDouble(json['availableSlots']).round();
    final lat = _toDouble(json['latitude'] ?? json['lat']);
    final lng = _toDouble(json['longitude'] ?? json['lng']);
    final used = _toDouble(json['usedSlots'] ?? (total - available)).round();
    final maxCapacity = _toDouble(json['maxCapacity'] ?? total).round();
    final current = _toDouble(json['currentOccupancy'] ?? used).round();
    final openingHours = _parseOpeningHours(json['openingHours']);
    return DropLocation(
      id: (json['id'] ?? json['_id'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      address: (json['address'] ?? '').toString(),
      position: LatLng(lat, lng),
      totalSlots: total,
      availableSlots: available,
      usedSlots: used,
      maxCapacity: maxCapacity,
      currentOccupancy: current,
      openingHours: openingHours,
      timezone: (json['timezone'] ?? '').toString().isNotEmpty
          ? json['timezone'].toString()
          : 'Europe/Istanbul',
      isActive: json['isActive'] == false ? false : true,
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
        'maxCapacity': maxCapacity,
        'currentOccupancy': currentOccupancy,
        'openingHours': openingHours.map(
          (key, value) => MapEntry(key, value.map((range) => range.toJson()).toList()),
        ),
        'timezone': timezone,
        'isActive': isActive,
      };

  int get occupiedSlots => usedSlots.clamp(0, totalSlots);

  double get occupancyRate {
    final capacity = maxCapacity == 0 ? totalSlots : maxCapacity;
    if (capacity == 0) return 0;
    return currentOccupancy.clamp(0, capacity) / capacity;
  }

  bool get isFull => maxCapacity > 0 && currentOccupancy >= maxCapacity;

  bool isOpenAt(DateTime when) {
    if (!isActive) return false;
    if (openingHours.isEmpty) return true;
    final dayKey = _weekdayKey(when.weekday);
    final ranges = openingHours[dayKey] ?? const [];
    if (ranges.isEmpty) return false;
    final nowMinutes = when.hour * 60 + when.minute;
    return ranges.any((range) {
      final start = _timeToMinutes(range.start);
      final end = _timeToMinutes(range.end);
      if (start == null || end == null) return false;
      return nowMinutes >= start && nowMinutes <= end;
    });
  }

  bool get isOpenNow => isOpenAt(DateTime.now());

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static Map<String, List<OpeningHoursRange>> _parseOpeningHours(dynamic value) {
    if (value is! Map) return const {};
    final result = <String, List<OpeningHoursRange>>{};
    value.forEach((key, raw) {
      final dayKey = key.toString();
      if (raw is List) {
        result[dayKey] = raw
            .whereType<Map>()
            .map((item) => OpeningHoursRange.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    });
    return result;
  }

  static String _weekdayKey(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'mon';
      case DateTime.tuesday:
        return 'tue';
      case DateTime.wednesday:
        return 'wed';
      case DateTime.thursday:
        return 'thu';
      case DateTime.friday:
        return 'fri';
      case DateTime.saturday:
        return 'sat';
      case DateTime.sunday:
        return 'sun';
      default:
        return 'mon';
    }
  }

  static int? _timeToMinutes(String value) {
    final parts = value.split(':');
    if (parts.length < 2) return null;
    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) return null;
    return hour * 60 + minute;
  }
}

class DropLocationsRepository {
  DropLocationsRepository._();

  static final List<DropLocation> _locations = [
    DropLocation(
      id: 'taksim',
      name: 'Taksim KYRADI',
      address: 'Cumhuriyet Cd. No: 1, Beyoğlu',
      position: LatLng(41.0369, 28.9856),
      totalSlots: 12,
      availableSlots: 3,
      usedSlots: 12 - 3,
      maxCapacity: 12,
      currentOccupancy: 12 - 3,
      openingHours: kAlwaysOpenHours,
      timezone: 'Europe/Istanbul',
      isActive: true,
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
      name: 'Kağıthane KYRADI',
      address: 'Merkez Mah. Kağıthane',
      position: LatLng(41.1085, 28.9722),
      totalSlots: 8,
      availableSlots: 1,
      usedSlots: 8 - 1,
      maxCapacity: 8,
      currentOccupancy: 8 - 1,
      openingHours: kAlwaysOpenHours,
      timezone: 'Europe/Istanbul',
      isActive: true,
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
      name: 'Beşiktaş KYRADI',
      address: 'Çırağan Cad., Beşiktaş',
      position: LatLng(41.041, 29.0078),
      totalSlots: 10,
      availableSlots: 4,
      usedSlots: 10 - 4,
      maxCapacity: 10,
      currentOccupancy: 10 - 4,
      openingHours: kAlwaysOpenHours,
      timezone: 'Europe/Istanbul',
      isActive: true,
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
      name: 'Kadıköy KYRADI',
      address: 'Kadıköy Rıhtım Cd.',
      position: LatLng(40.9929, 29.02799),
      totalSlots: 16,
      availableSlots: 6,
      usedSlots: 16 - 6,
      maxCapacity: 16,
      currentOccupancy: 16 - 6,
      openingHours: kAlwaysOpenHours,
      timezone: 'Europe/Istanbul',
      isActive: true,
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
      name: 'Şişli KYRADI',
      address: 'Halaskargazi Cd., Şişli',
      position: LatLng(41.0601, 28.9876),
      totalSlots: 5,
      availableSlots: 0,
      usedSlots: 5,
      maxCapacity: 5,
      currentOccupancy: 5,
      openingHours: kAlwaysOpenHours,
      timezone: 'Europe/Istanbul',
      isActive: true,
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
      name: 'Bakırköy KYRADI',
      address: 'İncirli Cd., Bakırköy',
      position: LatLng(40.978, 28.8724),
      totalSlots: 9,
      availableSlots: 2,
      usedSlots: 9 - 2,
      maxCapacity: 9,
      currentOccupancy: 9 - 2,
      openingHours: kAlwaysOpenHours,
      timezone: 'Europe/Istanbul',
      isActive: true,
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
