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
  });

  final DropLocation location;
  final VoidCallback onTap;
  final double? distanceKm;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final openLabel = location.isOpenNow ? loc.locationOpenLabel : loc.locationClosedLabel;
    final openColor =
        location.isOpenNow ? theme.colorScheme.primary : theme.colorScheme.error;
    final distanceLabel =
        distanceKm == null ? null : '${distanceKm!.toStringAsFixed(1)} km';
    final availabilityLabel = loc.locationSlotsLabel(
      location.availableSlots,
      location.totalSlots,
    );
    final availabilityColor = location.availableSlots == 0
        ? theme.colorScheme.error
        : theme.colorScheme.secondary;

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
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                          theme.colorScheme.primary.withValues(alpha: 0.05),
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
                        border: Border.all(
                          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                        ),
                      ),
                      child: Text(
                        distanceLabel,
                        style: theme.textTheme.labelSmall,
                      ),
                    ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: openColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: openColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      openLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: openColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: availabilityColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: availabilityColor.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      availabilityLabel,
                      style: theme.textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: availabilityColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: location.occupancyRate,
                  backgroundColor:
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  loc.detailsAction,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
