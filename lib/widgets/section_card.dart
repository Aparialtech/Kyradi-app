import 'package:flutter/material.dart';

/// Shared card shell with subtle gradient stroke used across screens to keep
/// sections visually consistent.
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.margin = EdgeInsets.zero,
    this.radius = 22,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double radius;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        theme.colorScheme.primary.withValues(alpha: 0.12);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius + 4),
        gradient: LinearGradient(
          colors: [
            borderColor,
            theme.colorScheme.secondary.withValues(alpha: 0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor ?? theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.06),
              blurRadius: 28,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(radius),
          clipBehavior: Clip.antiAlias,
          child: Padding(padding: padding, child: child),
        ),
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    this.action,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? iconWidget;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor =
        theme.colorScheme.primary.withValues(alpha: 0.9);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (iconWidget != null)
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 2),
            child: iconWidget!,
          )
        else if (icon != null)
          Padding(
            padding: const EdgeInsets.only(right: 10, top: 2),
            child: Icon(icon, color: iconColor),
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 4,
                width: 28,
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.9),
                      theme.colorScheme.secondary.withValues(alpha: 0.8),
                    ],
                  ),
                ),
              ),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

class ThreeDIconBadge extends StatelessWidget {
  const ThreeDIconBadge({
    super.key,
    required this.icon,
    this.accent,
  });

  final IconData icon;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolved = accent ?? theme.colorScheme.primary;
    final base = theme.colorScheme.surface;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                resolved.withValues(alpha: 0.3),
                resolved.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: resolved.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: base,
            border: Border.all(color: resolved.withValues(alpha: 0.35)),
          ),
        ),
        Icon(
          icon,
          size: 16,
          color: resolved,
          shadows: [
            Shadow(
              color: resolved.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ],
    );
  }
}

/// Icon + label pill used for quick actions on the dashboard.
class QuickActionTile extends StatelessWidget {
  const QuickActionTile({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.accentColor,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = accentColor ?? theme.colorScheme.primary;
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ThreeDActionIcon(
                icon: icon,
                accent: accent,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ThreeDActionIcon extends StatelessWidget {
  const _ThreeDActionIcon({
    required this.icon,
    required this.accent,
  });

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surface;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.3),
                accent.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        Container(
          height: 26,
          width: 26,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: base,
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
        ),
        Icon(
          icon,
          size: 16,
          color: accent,
          shadows: [
            Shadow(
              color: accent.withValues(alpha: 0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ],
    );
  }
}
