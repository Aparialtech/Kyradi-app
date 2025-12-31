import 'package:flutter/material.dart';

const String luggageStatusAwaitingDrop = 'awaiting_drop';
const String luggageStatusDropped = 'dropped';
const String luggageStatusPickedUp = 'picked_up';
const String luggageStatusCancelled = 'cancelled';

const String paymentStatusUnpaid = 'unpaid';
const String paymentStatusPending = 'pending';
const String paymentStatusPaid = 'paid';
const String paymentStatusFailed = 'failed';

enum LuggageStatus { awaitingDrop, dropped, pickedUp, cancelled }

class LuggageModel {
  final String id;
  final String qrCode;
  final String? label;
  final String? size;
  final String? weight;
  final String? color;
  final String? note;
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerEmail;
  final LuggageStatus status;
  final String dropLocationId;
  final String dropLocationName;
  final DateTime createdAt;
  final DateTime? dropConfirmedAt;
  final DateTime? pickupConfirmedAt;
  final DateTime? scheduledDropTime;
  final DateTime? scheduledPickupTime;
  final LuggageDelegate? pickupDelegate;
  final DateTime? delegateExpiresAt;
  final DateTime? delegateUsedAt;
  final bool delegateActive;
  final String? paymentMethod;
  final String? paymentStatus;
  final int? totalPrice;
  final String? providerPaymentId;
  final String? checkoutUrl;
  final String? transactionId;
  final DateTime? paidAt;

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
    this.ownerName,
    this.ownerPhone,
    this.ownerEmail,
    this.dropConfirmedAt,
    this.pickupConfirmedAt,
    this.scheduledDropTime,
    this.scheduledPickupTime,
    this.pickupDelegate,
    this.delegateExpiresAt,
    this.delegateUsedAt,
    this.delegateActive = false,
    this.paymentMethod,
    this.paymentStatus,
    this.totalPrice,
    this.providerPaymentId,
    this.checkoutUrl,
    this.transactionId,
    this.paidAt,
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
      ownerName: (json['ownerName'] ?? '').toString(),
      ownerPhone: (json['ownerPhone'] ?? '').toString(),
      ownerEmail: (json['ownerEmail'] ?? '').toString(),
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
      pickupDelegate: json['pickupDelegate'] is Map
          ? LuggageDelegate.fromJson(
              Map<String, dynamic>.from(json['pickupDelegate'] as Map),
            )
          : null,
      delegateExpiresAt: _parseDate(json['delegateExpiresAt']),
      delegateUsedAt: _parseDate(json['delegateUsedAt']),
      delegateActive: (json['delegateActive'] ?? false) == true,
      paymentMethod: json['paymentMethod']?.toString(),
      paymentStatus: json['paymentStatus']?.toString(),
      totalPrice: _parseInt(json['totalPrice']),
      providerPaymentId: json['providerPaymentId']?.toString(),
      checkoutUrl: json['checkoutUrl']?.toString(),
      transactionId: json['transactionId']?.toString(),
      paidAt: _parseDate(json['paidAt']),
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
        'ownerName': ownerName,
        'ownerPhone': ownerPhone,
        'ownerEmail': ownerEmail,
        'status': _statusToString(status),
        'dropLocationId': dropLocationId,
        'dropLocationName': dropLocationName,
        'createdAt': createdAt.toIso8601String(),
        'dropConfirmedAt': dropConfirmedAt?.toIso8601String(),
        'pickupConfirmedAt': pickupConfirmedAt?.toIso8601String(),
        'scheduledDropTime': scheduledDropTime?.toIso8601String(),
        'scheduledPickupTime': scheduledPickupTime?.toIso8601String(),
        'pickupDelegate': pickupDelegate?.toJson(),
        'delegateExpiresAt': delegateExpiresAt?.toIso8601String(),
        'delegateUsedAt': delegateUsedAt?.toIso8601String(),
        'delegateActive': delegateActive,
        'paymentMethod': paymentMethod,
        'paymentStatus': paymentStatus,
        'totalPrice': totalPrice,
        'providerPaymentId': providerPaymentId,
        'checkoutUrl': checkoutUrl,
        'transactionId': transactionId,
        'paidAt': paidAt?.toIso8601String(),
      };

  LuggageModel copyWith({
    String? qrCode,
    String? label,
    String? size,
    String? weight,
    String? color,
    String? note,
    String? ownerName,
    String? ownerPhone,
    String? ownerEmail,
    LuggageStatus? status,
    DateTime? dropConfirmedAt,
    DateTime? pickupConfirmedAt,
    String? dropLocationId,
    String? dropLocationName,
    DateTime? scheduledDropTime,
    DateTime? scheduledPickupTime,
    LuggageDelegate? pickupDelegate,
    DateTime? delegateExpiresAt,
    DateTime? delegateUsedAt,
    bool? delegateActive,
    String? paymentMethod,
    String? paymentStatus,
    int? totalPrice,
    String? providerPaymentId,
    String? checkoutUrl,
    String? transactionId,
    DateTime? paidAt,
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
      ownerName: ownerName ?? this.ownerName,
      ownerPhone: ownerPhone ?? this.ownerPhone,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      dropLocationId: dropLocationId ?? this.dropLocationId,
      dropLocationName: dropLocationName ?? this.dropLocationName,
      dropConfirmedAt: dropConfirmedAt ?? this.dropConfirmedAt,
      pickupConfirmedAt: pickupConfirmedAt ?? this.pickupConfirmedAt,
      scheduledDropTime: scheduledDropTime ?? this.scheduledDropTime,
      scheduledPickupTime: scheduledPickupTime ?? this.scheduledPickupTime,
      pickupDelegate: pickupDelegate ?? this.pickupDelegate,
      delegateExpiresAt: delegateExpiresAt ?? this.delegateExpiresAt,
      delegateUsedAt: delegateUsedAt ?? this.delegateUsedAt,
      delegateActive: delegateActive ?? this.delegateActive,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      totalPrice: totalPrice ?? this.totalPrice,
      providerPaymentId: providerPaymentId ?? this.providerPaymentId,
      checkoutUrl: checkoutUrl ?? this.checkoutUrl,
      transactionId: transactionId ?? this.transactionId,
      paidAt: paidAt ?? this.paidAt,
    );
  }

  bool get isPaymentPaid => paymentStatus == paymentStatusPaid;

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

  bool get isDelegateActive {
    if (delegateActive) return true;
    if (delegateExpiresAt == null || delegateUsedAt != null) return false;
    return delegateExpiresAt!.isAfter(DateTime.now());
  }

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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.round();
    if (value is String && value.trim().isNotEmpty) {
      return int.tryParse(value.trim());
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

class LuggageDelegate {
  final String fullName;
  final String phone;
  final String email;

  const LuggageDelegate({
    this.fullName = '',
    this.phone = '',
    this.email = '',
  });

  factory LuggageDelegate.fromJson(Map<String, dynamic> json) {
    return LuggageDelegate(
      fullName: (json['fullName'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'phone': phone,
        'email': email,
      };
}
