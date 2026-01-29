import 'package:flutter/material.dart';
import '../haptics/app_haptics.dart';

class AppPrimaryButton extends StatefulWidget {
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
  State<AppPrimaryButton> createState() => _AppPrimaryButtonState();
}

class _AppPrimaryButtonState extends State<AppPrimaryButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final handler = widget.onPressed == null
        ? null
        : () {
            AppHaptics.light();
            widget.onPressed?.call();
          };
    final child = widget.icon == null
        ? FilledButton(
            onPressed: handler,
            child: Text(widget.label),
          )
        : FilledButton.icon(
            onPressed: handler,
            icon: Icon(widget.icon),
            label: Text(widget.label),
          );
    if (handler == null) return child;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.98 : 1,
        child: child,
      ),
    );
  }
}
