import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';
import '../../../widgets/section_card.dart';

class LocationListCard extends StatelessWidget {
  const LocationListCard({
    super.key,
    required this.location,
    required this.onTap,
    required this.distanceKm,
  });

  final DropLocation location;
  final VoidCallback onTap;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final openLabel = location.isOpenNow ? 'Open' : 'Closed';
    final openColor =
        location.isOpenNow ? theme.colorScheme.primary : theme.colorScheme.error;
    final distanceLabel =
        distanceKm == null ? null : '${distanceKm!.toStringAsFixed(1)} km';

    return SectionCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      location.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (distanceLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        distanceLabel,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                location.address,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    openLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: openColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${location.availableSlots}/${location.totalSlots} slots',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: location.occupancyRate,
                backgroundColor:
                    theme.colorScheme.primary.withValues(alpha: 0.08),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
