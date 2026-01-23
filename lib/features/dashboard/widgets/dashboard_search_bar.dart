import 'package:flutter/material.dart';

class DashboardSearchBar extends StatelessWidget {
  const DashboardSearchBar({
    super.key,
    required this.hintText,
    this.onTap,
  });

  final String hintText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }
}
