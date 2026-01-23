import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/luggage.dart';

class TripTimelineSheet extends StatelessWidget {
  const TripTimelineSheet({
    super.key,
    required this.luggage,
  });

  final LuggageModel luggage;

  @override
  Widget build(BuildContext context) {
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
    final now = DateTime.now();
    final items = <_TimelineItem>[
      _TimelineItem(
        title: 'Created',
        time: luggage.createdAt,
        highlight: true,
      ),
      if (luggage.scheduledDropTime != null)
        _TimelineItem(
          title: 'Scheduled drop',
          time: luggage.scheduledDropTime,
        ),
      if (luggage.dropConfirmedAt != null)
        _TimelineItem(
          title: 'Dropped',
          time: luggage.dropConfirmedAt,
        ),
      if (luggage.scheduledPickupTime != null)
        _TimelineItem(
          title: 'Scheduled pickup',
          time: luggage.scheduledPickupTime,
        ),
      if (luggage.pickupConfirmedAt != null)
        _TimelineItem(
          title: 'Picked up',
          time: luggage.pickupConfirmedAt,
        ),
      _TimelineItem(
        title: 'Status',
        subtitle: luggage.statusLabel,
        time: null,
        highlight: luggage.dropConfirmedAt == null && luggage.pickupConfirmedAt == null
            ? true
            : false,
      ),
      _TimelineItem(
        title: now.isAfter(luggage.createdAt) ? 'Last update' : 'Scheduled',
        subtitle: luggage.statusLabel,
        highlight: false,
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
