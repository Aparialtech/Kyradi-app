import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/components/app_error_state.dart';
import '../../../ui/components/app_skeleton.dart';

class NearbyLocationsCarousel extends StatelessWidget {
  const NearbyLocationsCarousel({
    super.key,
    required this.loading,
    required this.errorMessage,
    required this.locations,
    required this.onRetry,
    required this.onLocationTap,
    required this.emptyLabel,
  });

  final bool loading;
  final String? errorMessage;
  final List<DropLocation> locations;
  final VoidCallback onRetry;
  final ValueChanged<DropLocation> onLocationTap;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (loading) {
      return _SkeletonRow();
    }
    if (errorMessage != null) {
      return AppErrorState(message: errorMessage!, onRetry: onRetry);
    }
    if (locations.isEmpty) {
      return Text(emptyLabel);
    }
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: locations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final location = locations[index];
          return InkWell(
            onTap: () => onLocationTap(location),
            borderRadius: BorderRadius.circular(18),
            splashColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.08),
            highlightColor: Theme.of(
              context,
            ).colorScheme.primary.withValues(alpha: 0.04),
            child: Ink(
              width: 220,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.95),
                    Theme.of(
                      context,
                    ).colorScheme.surface.withValues(alpha: 0.85),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.white.withValues(alpha: 0.75)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.22),
                              Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.06),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.location_on_outlined,
                          size: 18,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    location.name,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    location.address,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      loc.locationSlotsLabel(
                        location.availableSlots,
                        location.totalSlots,
                      ),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

class _SkeletonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) =>
            const AppSkeleton(height: 150, width: 220, radius: 18),
      ),
    );
  }
}
