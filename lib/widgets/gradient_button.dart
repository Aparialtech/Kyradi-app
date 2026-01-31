import 'dart:ui';
import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
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
  final bool glass;

  const GradientButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.radius = 26,
    this.loading = false,
    this.gradient,
    this.leading,
    this.glass = false,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveGradient = widget.gradient ?? GradientButton._defaultGradient;

    final childContent = widget.loading
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
              if (widget.leading != null) ...[
                IconTheme(
                  data: const IconThemeData(color: Colors.white, size: 18),
                  child: widget.leading!,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                widget.text,
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
      opacity: widget.onPressed == null ? 0.55 : 1,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 120),
        scale: _pressed ? 0.98 : 1,
        child: SizedBox(
          width: double.infinity,
          child: _buildSurface(
            radius: widget.radius,
            gradient: effectiveGradient,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(widget.radius),
                onTap: widget.loading ? null : widget.onPressed,
                onTapDown: (_) {
                  if (widget.onPressed == null) return;
                  setState(() => _pressed = true);
                },
                onTapCancel: () => setState(() => _pressed = false),
                onTapUp: (_) => setState(() => _pressed = false),
                splashColor: Colors.white.withValues(alpha: 0.08),
                highlightColor: Colors.white.withValues(alpha: 0.05),
                child: Padding(
                  padding: widget.padding,
                  child: Center(child: childContent),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSurface({
    required double radius,
    required Gradient gradient,
    required Widget child,
  }) {
    if (!widget.glass) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2C3E50).withValues(alpha: 0.16),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.18),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.28),
                Colors.white.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.55),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 22,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.35),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
