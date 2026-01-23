import 'package:flutter/material.dart';

class QrSection extends StatelessWidget {
  const QrSection({
    super.key,
    required this.actions,
  });

  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) {
      return const SizedBox.shrink();
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: actions,
    );
  }
}
