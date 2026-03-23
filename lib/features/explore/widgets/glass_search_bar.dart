import 'dart:ui';

import 'package:flutter/material.dart';

class GlassSearchBar extends StatelessWidget {
  const GlassSearchBar({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.onChanged,
    required this.onLocateTap,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final ValueChanged<String> onChanged;
  final VoidCallback onLocateTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final glassTint = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.58)
        : Colors.white.withValues(alpha: 0.74);
    final borderColor = isDark
        ? theme.colorScheme.outlineVariant.withValues(alpha: 0.55)
        : Colors.white.withValues(alpha: 0.70);
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.28 : 0.10);
    final iconColor = isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.78)
        : const Color(0xFF475569);
    final inputColor = isDark
        ? theme.colorScheme.onSurface
        : const Color(0xFF0F172A);
    final hintColor = isDark
        ? theme.colorScheme.onSurface.withValues(alpha: 0.62)
        : const Color(0xFF64748B);

    return RepaintBoundary(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: glassTint,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 56,
              child: Row(
                children: [
                  const SizedBox(width: 14),
                  Icon(Icons.search_rounded, size: 22, color: iconColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      onChanged: onChanged,
                      textInputAction: TextInputAction.search,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ).copyWith(color: inputColor),
                      decoration: InputDecoration(
                        filled: false,
                        isCollapsed: true,
                        hintText: hintText,
                        hintStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ).copyWith(color: hintColor),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _MiniGlassButton(
                    icon: Icons.my_location_rounded,
                    onTap: onLocateTap,
                    semanticLabel: 'Konumumu bul',
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniGlassButton extends StatelessWidget {
  const _MiniGlassButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final tint = isDark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.60)
        : Colors.white.withValues(alpha: 0.45);
    final iconTint = isDark
        ? theme.colorScheme.secondary
        : const Color(0xFF0F766E);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: 40,
        height: 40,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Material(
              color: tint,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(20),
                child: Icon(icon, size: 19, color: iconTint),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
