import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  static const LinearGradient _defaultGradient = LinearGradient(
    colors: [Color(0xFF2C2966), Color(0xFF005C99)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  final String text;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry padding;
  final double radius;
  final bool loading;
  final Gradient? gradient;
  final Widget? leading;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.radius = 26,
    this.loading = false,
    this.gradient,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveGradient = gradient ?? _defaultGradient;

    final childContent = loading
        ? const SizedBox(
            height: 18,
            width: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                IconTheme(
                  data: const IconThemeData(color: Colors.white, size: 18),
                  child: leading!,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ],
          );

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: onPressed == null ? 0.55 : 1,
      child: SizedBox(
        width: double.infinity,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: effectiveGradient,
            borderRadius: BorderRadius.circular(radius),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2C3E50).withValues(alpha: 0.12),
                blurRadius: 26,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(radius),
              onTap: loading ? null : onPressed,
              splashColor: Colors.white.withValues(alpha: 0.08),
              highlightColor: Colors.white.withValues(alpha: 0.05),
              child: Padding(
                padding: padding,
                child: Center(child: childContent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
