import 'package:flutter/material.dart';
import '../haptics/app_haptics.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final handler = onPressed == null
        ? null
        : () {
            AppHaptics.light();
            onPressed?.call();
          };
    if (icon == null) {
      return FilledButton(
        onPressed: handler,
        child: Text(label),
      );
    }
    return FilledButton.icon(
      onPressed: handler,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}
