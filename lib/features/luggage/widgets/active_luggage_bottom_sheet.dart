import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/luggage.dart';
import 'luggage_color_icon.dart';

class ActiveLuggageBottomSheet extends StatelessWidget {
  const ActiveLuggageBottomSheet({
    super.key,
    required this.luggage,
    required this.onDetails,
  });

  final LuggageModel luggage;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const collapsedHeight = 100.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxHeight = constraints.maxHeight;
        final minSize = (collapsedHeight / maxHeight).clamp(0.18, 0.30);
        final maxSize = 0.50;
        return DraggableScrollableSheet(
          expand: false,
          minChildSize: minSize,
          initialChildSize: minSize,
          maxChildSize: maxSize,
          snap: true,
          snapSizes: <double>[minSize, maxSize],
          builder: (context, scrollController) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.97),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.90)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.10),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 38,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        getLuggageIcon(luggage.color, size: 50),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                luggage.dropLocationName.isNotEmpty
                                    ? luggage.dropLocationName
                                    : luggage.displayLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '1 Bavul • ${luggage.statusLabel}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: const Color(0xFF475569),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          height: 36,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0F766E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: onDetails,
                            child: const Text('Detaylı Bilgi'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _SheetStatusTimeline(status: luggage.status),
                    const SizedBox(height: 14),
                    const Divider(height: 1),
                    const SizedBox(height: 14),
                    Text(
                      AppLocalizations.of(context)!.activeTripTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _SheetChip(
                          icon: Icons.local_activity_outlined,
                          label: luggage.displayLabel,
                        ),
                        _StatusChip(luggage: luggage),
                        _SheetChip(
                          icon: Icons.palette_outlined,
                          label: luggage.color?.trim().isNotEmpty == true
                              ? luggage.color!.trim()
                              : 'gray',
                        ),
                        _SheetChip(
                          icon: Icons.schedule_outlined,
                          label: _scheduleLabel(context, luggage),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF0F766E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: onDetails,
                        child: const Text('Detaylı Bilgi'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _scheduleLabel(BuildContext context, LuggageModel luggage) {
    final target =
        luggage.scheduledPickupTime ??
        luggage.scheduledDropTime ??
        luggage.createdAt;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final formatter = DateFormat('dd MMM • HH:mm', locale);
    return formatter.format(target.toLocal());
  }
}

class _SheetChip extends StatelessWidget {
  const _SheetChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: const Color(0xFF64748B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.luggage});

  final LuggageModel luggage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = luggage.statusColor(theme);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Text(
        luggage.statusLabel,
        style: theme.textTheme.labelMedium?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SheetStatusTimeline extends StatelessWidget {
  const _SheetStatusTimeline({required this.status});

  final LuggageStatus status;

  @override
  Widget build(BuildContext context) {
    final activeStep = _activeStep(status);
    const labels = <({String label, IconData icon})>[
      (label: 'Rezervasyon', icon: Icons.check_circle_outline_rounded),
      (label: 'Teslim', icon: Icons.inventory_2_outlined),
      (label: 'Alis', icon: Icons.move_to_inbox_outlined),
    ];

    return Column(
      children: [
        Row(
          children: List.generate(labels.length, (index) {
            final step = index + 1;
            final completed = activeStep >= step;
            final isLast = index == labels.length - 1;
            return Expanded(
              child: Row(
                children: [
                  _TimelineNode(completed: completed, icon: labels[index].icon),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: completed
                              ? const Color(0xFF2DD4BF)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          children: labels
              .map(
                (label) => Expanded(
                  child: Text(
                    label.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: const Color(0xFF64748B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  int _activeStep(LuggageStatus value) {
    switch (value) {
      case LuggageStatus.awaitingDrop:
        return 1;
      case LuggageStatus.dropped:
        return 2;
      case LuggageStatus.pickedUp:
        return 3;
      case LuggageStatus.cancelled:
        return 0;
    }
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.completed, required this.icon});

  final bool completed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final color = completed ? const Color(0xFF14B8A6) : const Color(0xFF94A3B8);
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.15),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Icon(icon, size: 12, color: color),
    );
  }
}
