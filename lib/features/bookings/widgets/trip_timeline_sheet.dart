import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/luggage.dart';
import '../../../l10n/app_localizations.dart';

class TripTimelineSheet extends StatelessWidget {
  const TripTimelineSheet({
    super.key,
    required this.luggage,
  });

  final LuggageModel luggage;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final fmt = DateFormat('dd MMM HH:mm');
    final items = _buildTimeline(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              luggage.displayLabel,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              luggage.dropLocationName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.highlight
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outline,
                            shape: BoxShape.circle,
                          ),
                        ),
                        if (!item.isLast)
                          Container(
                            width: 2,
                            height: 32,
                            color: theme.colorScheme.outlineVariant,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            item.time != null ? fmt.format(item.time!) : item.subtitle,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  List<_TimelineItem> _buildTimeline(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final items = <_TimelineItem>[
      _TimelineItem(
        title: loc.luggageTimelineCreated,
        time: luggage.createdAt,
        highlight: true,
      ),
      if ((luggage.paymentStatus ?? '').isNotEmpty)
        _TimelineItem(
          title: loc.luggageTimelinePayment,
          time: luggage.paidAt,
          subtitle: _paymentStatusLabel(loc, luggage.paymentStatus),
          highlight: luggage.paymentStatus == paymentStatusPaid,
        ),
      if (luggage.scheduledDropTime != null)
        _TimelineItem(
          title: loc.luggageTimelineScheduledDrop,
          time: luggage.scheduledDropTime,
        ),
      if (luggage.dropConfirmedAt != null ||
          luggage.status == LuggageStatus.dropped ||
          luggage.status == LuggageStatus.pickedUp)
        _TimelineItem(
          title: loc.luggageTimelineDropped,
          time: luggage.dropConfirmedAt,
          subtitle: luggage.dropConfirmedAt == null
              ? loc.luggageTimelineTimeUnknown
              : '',
          highlight: luggage.status == LuggageStatus.dropped,
        ),
      if (luggage.scheduledPickupTime != null)
        _TimelineItem(
          title: loc.luggageTimelineScheduledPickup,
          time: luggage.scheduledPickupTime,
        ),
      if (luggage.pickupConfirmedAt != null ||
          luggage.status == LuggageStatus.pickedUp)
        _TimelineItem(
          title: loc.luggageTimelinePickedUp,
          time: luggage.pickupConfirmedAt,
          subtitle: luggage.pickupConfirmedAt == null
              ? loc.luggageTimelineTimeUnknown
              : '',
          highlight: luggage.status == LuggageStatus.pickedUp,
        ),
      _TimelineItem(
        title: loc.statusLabel,
        subtitle: _statusLabel(loc, luggage.status),
        time: null,
        highlight: luggage.status != LuggageStatus.awaitingDrop,
      ),
    ];
    for (var i = 0; i < items.length; i++) {
      items[i] = items[i].copyWith(isLast: i == items.length - 1);
    }
    return items;
  }
}

class _TimelineItem {
  const _TimelineItem({
    required this.title,
    this.subtitle = '',
    this.time,
    this.highlight = false,
    this.isLast = false,
  });

  final String title;
  final String subtitle;
  final DateTime? time;
  final bool highlight;
  final bool isLast;

  _TimelineItem copyWith({bool? isLast}) {
    return _TimelineItem(
      title: title,
      subtitle: subtitle,
      time: time,
      highlight: highlight,
      isLast: isLast ?? this.isLast,
    );
  }
}

String _statusLabel(AppLocalizations loc, LuggageStatus status) {
  switch (status) {
    case LuggageStatus.awaitingDrop:
      return loc.luggageStatusAwaitingDrop;
    case LuggageStatus.dropped:
      return loc.luggageStatusDropped;
    case LuggageStatus.pickedUp:
      return loc.luggageStatusPickedUp;
    case LuggageStatus.cancelled:
      return loc.luggageStatusCancelled;
  }
}

String _paymentStatusLabel(AppLocalizations loc, String? status) {
  switch (status) {
    case paymentStatusPaid:
      return loc.paymentStatusPaid;
    case paymentStatusPending:
      return loc.paymentStatusPending;
    case paymentStatusFailed:
      return loc.paymentStatusFailed;
    case paymentStatusUnpaid:
      return loc.paymentStatusUnpaid;
    default:
      return loc.paymentStatusUnknown;
  }
}
