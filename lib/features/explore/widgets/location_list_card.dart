import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';
import '../../../widgets/section_card.dart';
import '../../../l10n/app_localizations.dart';

const _hotelCoverUrls = <String>[
  'https://images.pexels.com/photos/258154/pexels-photo-258154.jpeg?auto=compress&cs=tinysrgb&w=1600&h=900&dpr=2',
  'https://images.pexels.com/photos/271624/pexels-photo-271624.jpeg?auto=compress&cs=tinysrgb&w=1600&h=900&dpr=2',
  'https://images.pexels.com/photos/261102/pexels-photo-261102.jpeg?auto=compress&cs=tinysrgb&w=1600&h=900&dpr=2',
  'https://images.pexels.com/photos/189296/pexels-photo-189296.jpeg?auto=compress&cs=tinysrgb&w=1600&h=900&dpr=2',
  'https://images.pexels.com/photos/1134176/pexels-photo-1134176.jpeg?auto=compress&cs=tinysrgb&w=1600&h=900&dpr=2',
  'https://images.pexels.com/photos/271618/pexels-photo-271618.jpeg?auto=compress&cs=tinysrgb&w=1600&h=900&dpr=2',
];

String _hotelCoverFor(DropLocation location) {
  final daySeed =
      DateTime.now().millisecondsSinceEpoch ~/ Duration.millisecondsPerDay;
  final index = (location.id.hashCode + daySeed).abs() % _hotelCoverUrls.length;
  return _hotelCoverUrls[index];
}

class LocationListCard extends StatelessWidget {
  const LocationListCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.distanceKm,
    required this.onDetails,
    required this.onDirections,
  });

  final DropLocation location;
  final VoidCallback onTap;
  final double? distanceKm;
  final VoidCallback onDetails;
  final VoidCallback onDirections;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final openLabel = location.isOpenNow
        ? loc.locationOpenLabel
        : loc.locationClosedLabel;
    final openColor = location.isOpenNow
        ? theme.colorScheme.primary
        : theme.colorScheme.error;
    final distanceLabel = distanceKm == null
        ? '--'
        : '${distanceKm!.toStringAsFixed(1)} km';
    final occupancyRate = location.occupancyRate.clamp(0.0, 1.0).toDouble();
    final occupancyPercent = (occupancyRate * 100).round();
    final coverUrl = _hotelCoverFor(location);

    return SectionCard(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 112,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              coverUrl,
                              fit: BoxFit.cover,
                              filterQuality: FilterQuality.medium,
                              errorBuilder: (context, _, __) => DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF121826),
                                      Color(0xFF243B5F),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withValues(alpha: 0.16),
                                    Colors.black.withValues(alpha: 0.34),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      top: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                        child: const Text(
                          'KYRADI Spot',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: Colors.white,
                        ),
                        child: Text(
                          '%$occupancyPercent dolu',
                          style: const TextStyle(
                            color: Color(0xFF0F172A),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.18),
                          theme.colorScheme.primary.withValues(alpha: 0.06),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      size: 19,
                      color: theme.colorScheme.primary.withValues(alpha: 0.9),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      location.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      color: const Color(0xFFF1F5F9),
                    ),
                    child: Text(
                      distanceLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                location.address,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _MetaPill(
                      icon: Icons.schedule_rounded,
                      label: openLabel,
                      tint: openColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _MetaPill(
                      icon: Icons.inventory_2_outlined,
                      label:
                          '${location.availableSlots}/${location.totalSlots} slot',
                      tint: location.availableSlots == 0
                          ? theme.colorScheme.error
                          : theme.colorScheme.secondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: occupancyRate,
                  backgroundColor: theme.colorScheme.primary.withValues(
                    alpha: 0.08,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Doluluk: %$occupancyPercent',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: onDetails,
                    icon: const Icon(Icons.info_outline_rounded, size: 18),
                    label: Text(loc.detailsAction),
                  ),
                  const SizedBox(width: 10),
                  FilledButton.icon(
                    onPressed: onDirections,
                    icon: const Icon(Icons.navigation_rounded),
                    label: Text(loc.directionsAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({
    required this.icon,
    required this.label,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tint.withValues(alpha: 0.28)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: tint),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: tint,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
