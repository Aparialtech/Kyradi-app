import 'package:flutter/material.dart';
import '../models/reward_mission.dart';

class MissionCarousel extends StatelessWidget {
  const MissionCarousel({
    super.key,
    required this.items,
  });

  final List<RewardMission> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          final progress = item.total == 0 ? 0.0 : item.progress / item.total;
          return Container(
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
                  item.title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  item.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const Spacer(),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                ),
                const SizedBox(height: 8),
                Text(
                  '${item.progress}/${item.total} • +${item.rewardAmount.toStringAsFixed(0)} ₺',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
