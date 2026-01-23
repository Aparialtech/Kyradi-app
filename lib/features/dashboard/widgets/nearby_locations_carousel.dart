import 'package:flutter/material.dart';
import '../../../core/drop_locations.dart';
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
            child: Ink(
              width: 220,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w600),
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
                  Text(
                    '${location.availableSlots}/${location.totalSlots} slots',
                    style: Theme.of(context).textTheme.labelSmall,
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
        itemBuilder: (context, index) => const AppSkeleton(
          height: 150,
          width: 220,
          radius: 18,
        ),
      ),
    );
  }
}
