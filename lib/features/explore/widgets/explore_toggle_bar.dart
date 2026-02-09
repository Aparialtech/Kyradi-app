import 'package:flutter/material.dart';
import 'dart:ui';

class ExploreToggleBar extends StatelessWidget {
  const ExploreToggleBar({
    super.key,
    required this.showMap,
    required this.onChanged,
    required this.listLabel,
    required this.mapLabel,
  });

  final bool showMap;
  final ValueChanged<bool> onChanged;
  final String listLabel;
  final String mapLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = theme.colorScheme.primary.withValues(alpha: 0.14);
    final borderColor = theme.colorScheme.outlineVariant.withValues(alpha: 0.6);

    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface.withValues(
              alpha: isDark ? 0.25 : 0.9,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor),
          ),
          child: SegmentedButton<bool>(
            segments: [
              ButtonSegment<bool>(
                value: false,
                label: Text(listLabel),
                icon: const Icon(Icons.view_list_outlined),
              ),
              ButtonSegment<bool>(
                value: true,
                label: Text(mapLabel),
                icon: const Icon(Icons.map_outlined),
              ),
            ],
            selected: {showMap},
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              backgroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? selectedColor
                    : Colors.transparent,
              ),
              foregroundColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              iconColor: WidgetStateProperty.resolveWith(
                (states) => states.contains(WidgetState.selected)
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            onSelectionChanged: (value) {
              if (value.isEmpty) return;
              onChanged(value.first);
            },
          ),
        ),
      ),
    );
  }
}
