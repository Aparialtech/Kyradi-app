import 'package:flutter/material.dart';

class BookingsHeader extends StatelessWidget {
  const BookingsHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.onOpenClassic,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onOpenClassic;

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
        if (onOpenClassic != null)
          TextButton.icon(
            onPressed: onOpenClassic,
            icon: const Icon(Icons.list_alt_outlined),
            label: const Text('Tümü'),
          ),
      ],
    );
  }
}
