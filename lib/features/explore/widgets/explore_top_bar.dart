import 'package:flutter/material.dart';

class ExploreTopBar extends StatelessWidget {
  const ExploreTopBar({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onFilterTap,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String hintText;
  final VoidCallback onFilterTap;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: const Icon(Icons.search),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: onFilterTap,
          icon: const Icon(Icons.tune),
          tooltip: 'Filter',
        ),
      ],
    );
  }
}
