import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';
import '../../../widgets/section_card.dart';
import '../../../l10n/app_localizations.dart';

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
    final openLabel =
        location.isOpenNow ? loc.locationOpenLabel : loc.locationClosedLabel;
    final openColor =
        location.isOpenNow ? theme.colorScheme.primary : theme.colorScheme.error;
    final distanceLabel =
        distanceKm == null ? null : '${distanceKm!.toStringAsFixed(1)} km';
    final availabilityLabel =
        'Kapasite: ${location.availableSlots}/${location.totalSlots}';
    final availabilityColor = location.availableSlots == 0
        ? theme.colorScheme.error
        : theme.colorScheme.secondary;
    final occupancyRate = location.occupancyRate.clamp(0.0, 1.0).toDouble();
    final occupancyPercent = (occupancyRate * 100).round();

    return SectionCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
        highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 46,
                    width: 52,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.22),
                          theme.colorScheme.primary.withValues(alpha: 0.08),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      location.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                location.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _StatusChip(
                    label: openLabel,
                    color: openColor,
                  ),
                  _StatusChip(
                    label: availabilityLabel,
                    color: availabilityColor,
                  ),
                  if (distanceLabel != null)
                    _StatusChip(
                      label: distanceLabel,
                      color: theme.colorScheme.tertiary,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: occupancyRate,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.08),
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
                  OutlinedButton(
                    onPressed: onDetails,
                    child: Text(loc.detailsAction),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.color,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color.withValues(alpha: 0.35),
        ),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
