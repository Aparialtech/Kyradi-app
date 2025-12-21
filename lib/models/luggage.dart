import 'package:flutter/material.dart';

const String luggageStatusAwaitingDrop = 'awaiting_drop';
const String luggageStatusDropped = 'dropped';
const String luggageStatusPickedUp = 'picked_up';
const String luggageStatusCancelled = 'cancelled';

enum LuggageStatus { awaitingDrop, dropped, pickedUp, cancelled }

class LuggageModel {
  final String id;
  final String qrCode;
  final String? label;
  final String? size;
  final String? weight;
  final String? color;
  final String? note;
  final LuggageStatus status;
  final String dropLocationId;
  final String dropLocationName;
  final DateTime createdAt;
  final DateTime? dropConfirmedAt;
  final DateTime? pickupConfirmedAt;
  final DateTime? scheduledDropTime;
  final DateTime? scheduledPickupTime;

  const LuggageModel({
    required this.id,
    required this.qrCode,
    required this.status,
    required this.createdAt,
    required this.dropLocationId,
    required this.dropLocationName,
    this.label,
    this.size,
    this.weight,
    this.color,
    this.note,
    this.dropConfirmedAt,
    this.pickupConfirmedAt,
    this.scheduledDropTime,
    this.scheduledPickupTime,
  });

  factory LuggageModel.fromJson(Map<String, dynamic> json) {
    final rawId = (json['id'] ?? json['_id'])?.toString();
    return LuggageModel(
      id: rawId ?? '',
      qrCode: (json['qrCode'] ?? json['qr'] ?? '').toString(),
      label: (json['label'] ?? json['title'])?.toString(),
      size: (json['size'] ?? json['bagSize'])?.toString(),
      weight: (json['weight'] ?? json['bagWeight'])?.toString(),
      color: (json['color'] ?? json['bagColor'])?.toString(),
      note: (json['note'] ?? json['comment'])?.toString(),
      status: _parseStatus(json['status']),
      dropLocationId:
          (json['dropLocationId'] ?? json['locationId'] ?? '').toString(),
      dropLocationName: (json['dropLocationName'] ??
              json['locationName'] ??
              json['location'] ??
              '')
          .toString(),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.now(),
      dropConfirmedAt: _parseDate(json['dropConfirmedAt']),
      pickupConfirmedAt: _parseDate(json['pickupConfirmedAt']),
      scheduledDropTime: _parseDate(json['scheduledDropTime']),
      scheduledPickupTime: _parseDate(json['scheduledPickupTime']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'qrCode': qrCode,
        'label': label,
        'size': size,
        'weight': weight,
        'color': color,
        'note': note,
        'status': _statusToString(status),
        'dropLocationId': dropLocationId,
        'dropLocationName': dropLocationName,
        'createdAt': createdAt.toIso8601String(),
        'dropConfirmedAt': dropConfirmedAt?.toIso8601String(),
        'pickupConfirmedAt': pickupConfirmedAt?.toIso8601String(),
        'scheduledDropTime': scheduledDropTime?.toIso8601String(),
        'scheduledPickupTime': scheduledPickupTime?.toIso8601String(),
      };

  LuggageModel copyWith({
    String? qrCode,
    String? label,
    String? size,
    String? weight,
    String? color,
    String? note,
    LuggageStatus? status,
    DateTime? dropConfirmedAt,
    DateTime? pickupConfirmedAt,
    String? dropLocationId,
    String? dropLocationName,
    DateTime? scheduledDropTime,
    DateTime? scheduledPickupTime,
  }) {
    return LuggageModel(
      id: id,
      qrCode: qrCode ?? this.qrCode,
      status: status ?? this.status,
      createdAt: createdAt,
      label: label ?? this.label,
      size: size ?? this.size,
      weight: weight ?? this.weight,
      color: color ?? this.color,
      note: note ?? this.note,
      dropLocationId: dropLocationId ?? this.dropLocationId,
      dropLocationName: dropLocationName ?? this.dropLocationName,
      dropConfirmedAt: dropConfirmedAt ?? this.dropConfirmedAt,
      pickupConfirmedAt: pickupConfirmedAt ?? this.pickupConfirmedAt,
      scheduledDropTime: scheduledDropTime ?? this.scheduledDropTime,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
    );
  }

  String get displayLabel {
    if (label != null && label!.trim().isNotEmpty) {
      return label!;
    }
    final suffix = qrCode.length > 6 ? qrCode.substring(qrCode.length - 6) : qrCode;
    return 'Bavul $suffix';
  }

  String get statusLabel {
    switch (status) {
      case LuggageStatus.awaitingDrop:
        return 'Teslim Bekliyor';
      case LuggageStatus.dropped:
        return 'Depoda';
      case LuggageStatus.pickedUp:
        return 'Teslim Alındı';
      case LuggageStatus.cancelled:
        return 'İptal Edildi';
    }
  }

  Color statusColor(ThemeData theme) {
    switch (status) {
      case LuggageStatus.awaitingDrop:
        return theme.colorScheme.secondary;
      case LuggageStatus.dropped:
        return theme.colorScheme.primary;
      case LuggageStatus.pickedUp:
        return theme.colorScheme.outline;
      case LuggageStatus.cancelled:
        return theme.colorScheme.error;
    }
  }

  bool get isAwaitingDrop => status == LuggageStatus.awaitingDrop;
  bool get isDropped => status == LuggageStatus.dropped;
  bool get isPickedUp => status == LuggageStatus.pickedUp;
  bool get isCancelled => status == LuggageStatus.cancelled;

  static LuggageStatus _parseStatus(dynamic value) {
    final normalized = value?.toString().toLowerCase();
    switch (normalized) {
      case luggageStatusDropped:
        return LuggageStatus.dropped;
      case luggageStatusPickedUp:
        return LuggageStatus.pickedUp;
      case luggageStatusCancelled:
        return LuggageStatus.cancelled;
      default:
        return LuggageStatus.awaitingDrop;
    }
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String _statusToString(LuggageStatus status) {
    switch (status) {
      case LuggageStatus.awaitingDrop:
        return luggageStatusAwaitingDrop;
      case LuggageStatus.dropped:
        return luggageStatusDropped;
      case LuggageStatus.pickedUp:
        return luggageStatusPickedUp;
      case LuggageStatus.cancelled:
        return luggageStatusCancelled;
    }
  }
}
