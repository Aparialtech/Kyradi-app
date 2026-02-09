import 'package:flutter/material.dart';
import '../../../ui/components/app_error_state.dart';
import '../../../ui/components/app_skeleton.dart';

class CampaignItem {
  const CampaignItem({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.icon,
    required this.gradient,
  });

  final String title;
  final String subtitle;
  final String tag;
  final IconData icon;
  final List<Color> gradient;
}

class CampaignCarousel extends StatelessWidget {
  const CampaignCarousel({
    super.key,
    required this.loading,
    required this.errorMessage,
    required this.items,
    required this.onRetry,
    required this.emptyLabel,
  });

  final bool loading;
  final String? errorMessage;
  final List<CampaignItem> items;
  final VoidCallback onRetry;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return _SkeletonRow();
    }
    if (errorMessage != null) {
      return AppErrorState(message: errorMessage!, onRetry: onRetry);
    }
    if (items.isEmpty) {
      return Text(emptyLabel);
    }
    return SizedBox(
      height: 160,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return Container(
            width: 220,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: item.gradient,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.45),
                        Colors.white.withValues(alpha: 0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Icon(
                    item.icon,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.tag,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 6),
                Expanded(
                  child: Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
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

class _SkeletonRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => const AppSkeleton(
          height: 140,
          width: 220,
          radius: 18,
        ),
      ),
    );
  }
}
