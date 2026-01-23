import 'package:flutter/material.dart';

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
    return SegmentedButton<bool>(
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
      onSelectionChanged: (value) {
        if (value.isEmpty) return;
        onChanged(value.first);
      },
    );
  }
}
