import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAvatarTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onAvatarTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onAvatarTap,
          borderRadius: BorderRadius.circular(24),
          child: CircleAvatar(
            radius: 22,
            backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
            child: Icon(
              Icons.person,
              color: theme.colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }
}
