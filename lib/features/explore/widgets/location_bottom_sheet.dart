import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';

enum RouteMode { drive, walk }

class LocationBottomSheet extends StatefulWidget {
  const LocationBottomSheet({
    super.key,
    required this.location,
    required this.distanceKm,
    required this.routeMode,
    required this.onRouteModeChanged,
    required this.onReserve,
    required this.onDirections,
    required this.onCall,
    required this.onDetails,
  });

  final DropLocation location;
  final double? distanceKm;
  final RouteMode routeMode;
  final ValueChanged<RouteMode> onRouteModeChanged;
  final VoidCallback onReserve;
  final VoidCallback onDirections;
  final VoidCallback onCall;
  final VoidCallback onDetails;

  @override
  State<LocationBottomSheet> createState() => _LocationBottomSheetState();
}

class _LocationBottomSheetState extends State<LocationBottomSheet> {
  double _extent = 0.18;

  @override
  Widget build(BuildContext context) {
    final expanded = _extent > 0.30;
    return NotificationListener<DraggableScrollableNotification>(
      onNotification: (notification) {
        final next = notification.extent;
        if ((next - _extent).abs() > 0.01) {
          setState(() => _extent = next);
        }
        return false;
      },
      child: DraggableScrollableSheet(
        minChildSize: 0.16,
        maxChildSize: 0.55,
        initialChildSize: 0.18,
        snap: true,
        snapSizes: const [0.18, 0.55],
        builder: (context, controller) {
          return RepaintBoundary(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                      child: const SizedBox.expand(),
                    ),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.88),
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(28)),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.70),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.14),
                            blurRadius: 28,
                            offset: const Offset(0, -6),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListView(
                    controller: controller,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                    children: [
                      Center(
                        child: Container(
                          width: 42,
                          height: 5,
                          decoration: BoxDecoration(
                            color: const Color(0xFF94A3B8).withValues(alpha: 0.56),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CollapsedHeader(
                        location: widget.location,
                        onDetails: widget.onDetails,
                      ),
                      if (expanded) ...[
                        const SizedBox(height: 12),
                        Text(
                          widget.location.address,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF475569),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _StatsRow(location: widget.location),
                        const SizedBox(height: 14),
                        _RouteCard(
                          distanceKm: widget.distanceKm,
                          mode: widget.routeMode,
                          onChanged: widget.onRouteModeChanged,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: widget.onReserve,
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Rezervasyon yap'),
                                style: FilledButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                  backgroundColor: const Color(0xFF0F766E),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: widget.onDirections,
                                icon: const Icon(Icons.navigation_outlined),
                                label: const Text('Yol tarifi'),
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(48),
                                  foregroundColor: const Color(0xFF0F766E),
                                  side: BorderSide(
                                    color: const Color(0xFF0F766E).withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            _CircleCta(
                              icon: Icons.support_agent_outlined,
                              onTap: widget.onCall,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CollapsedHeader extends StatelessWidget {
  const _CollapsedHeader({
    required this.location,
    required this.onDetails,
  });

  final DropLocation location;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0F766E).withValues(alpha: 0.12),
            border: Border.all(
              color: const Color(0xFF0F766E).withValues(alpha: 0.26),
            ),
          ),
          child: const Icon(Icons.luggage_outlined, color: Color(0xFF0F766E)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                location.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${location.availableSlots} slot • ${location.isOpenNow ? 'Müsait' : 'Kapalı'}',
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          onPressed: onDetails,
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(86, 36),
            side: BorderSide(color: const Color(0xFF0F766E).withValues(alpha: 0.26)),
            foregroundColor: const Color(0xFF0F766E),
          ),
          child: const Text('Detay'),
        ),
      ],
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.location});

  final DropLocation location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatItem(
            label: 'Müsait',
            value: '${location.availableSlots}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatItem(
            label: 'Toplam',
            value: '${location.totalSlots}',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _StatItem(
            label: 'Kapasite',
            value: '${location.maxCapacity}',
          ),
        ),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.distanceKm,
    required this.mode,
    required this.onChanged,
  });

  final double? distanceKm;
  final RouteMode mode;
  final ValueChanged<RouteMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final distance = distanceKm == null ? '--' : '${distanceKm!.toStringAsFixed(1)} km';
    final durationMinutes = distanceKm == null
        ? 0
        : mode == RouteMode.walk
            ? math.max(4, (distanceKm! * 12).round())
            : math.max(2, (distanceKm! * 2.2).round());
    final eta = distanceKm == null ? '-- dk' : '$durationMinutes dk';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.76),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rota',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$eta • $distance',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
          SegmentedButton<RouteMode>(
            segments: const [
              ButtonSegment<RouteMode>(
                value: RouteMode.drive,
                icon: Icon(Icons.directions_car_outlined, size: 16),
                label: Text('Araç'),
              ),
              ButtonSegment<RouteMode>(
                value: RouteMode.walk,
                icon: Icon(Icons.directions_walk_outlined, size: 16),
                label: Text('Yürüyüş'),
              ),
            ],
            selected: {mode},
            showSelectedIcon: false,
            onSelectionChanged: (value) {
              if (value.isEmpty) return;
              onChanged(value.first);
            },
          ),
        ],
      ),
    );
  }
}

class _CircleCta extends StatelessWidget {
  const _CircleCta({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: const Color(0xFF0F766E).withValues(alpha: 0.90),
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    );
  }
}
