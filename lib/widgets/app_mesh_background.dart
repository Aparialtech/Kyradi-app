import 'dart:ui';

import 'package:flutter/material.dart';
import '../core/background_theme_mode.dart';

class AppMeshBackground extends StatelessWidget {
  const AppMeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return ValueListenableBuilder<AppBackgroundTheme>(
      valueListenable: AppBackgroundThemeMode.notifier,
      builder: (context, bgTheme, _) {
        final palette = _palette(bgTheme, isDark);
        return Stack(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [palette.baseTop, palette.baseBottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: const SizedBox.expand(),
            ),
            Positioned(
              top: -180,
              right: -120,
              child: _SoftBlob(
                size: 320,
                colors: palette.blobA,
              ),
            ),
            Positioned(
              bottom: -200,
              left: -120,
              child: _SoftBlob(
                size: 360,
                colors: palette.blobB,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _MeshPalette {
  const _MeshPalette({
    required this.baseTop,
    required this.baseBottom,
    required this.blobA,
    required this.blobB,
  });

  final Color baseTop;
  final Color baseBottom;
  final List<Color> blobA;
  final List<Color> blobB;
}

_MeshPalette _palette(AppBackgroundTheme theme, bool isDark) {
  switch (theme) {
    case AppBackgroundTheme.ocean:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF0F172A) : const Color(0xFFF5F7FC),
        baseBottom: isDark ? const Color(0xFF111827) : const Color(0xFFE9EFF7),
        blobA: [
          (isDark ? const Color(0xFF2563EB) : const Color(0xFF9CCBFF)),
          const Color(0x002563EB),
        ],
        blobB: [
          (isDark ? const Color(0xFF8B5CF6) : const Color(0xFFE7B6FF)),
          const Color(0x008B5CF6),
        ],
      );
    case AppBackgroundTheme.aurora:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF0B1220) : const Color(0xFFF6FFFD),
        baseBottom: isDark ? const Color(0xFF0F1B2D) : const Color(0xFFEAF7F5),
        blobA: [
          (isDark ? const Color(0xFF22C55E) : const Color(0xFFB7F7D3)),
          const Color(0x0022C55E),
        ],
        blobB: [
          (isDark ? const Color(0xFF38BDF8) : const Color(0xFFBFEAFF)),
          const Color(0x0038BDF8),
        ],
      );
    case AppBackgroundTheme.sunset:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF140B12) : const Color(0xFFFFF6F1),
        baseBottom: isDark ? const Color(0xFF1A0F1A) : const Color(0xFFFFE9E1),
        blobA: [
          (isDark ? const Color(0xFFF97316) : const Color(0xFFFFC9A6)),
          const Color(0x00F97316),
        ],
        blobB: [
          (isDark ? const Color(0xFFEC4899) : const Color(0xFFFFC0DA)),
          const Color(0x00EC4899),
        ],
      );
    case AppBackgroundTheme.citrus:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF11120B) : const Color(0xFFFFFBEA),
        baseBottom: isDark ? const Color(0xFF171A10) : const Color(0xFFFFF1C9),
        blobA: [
          (isDark ? const Color(0xFFEAB308) : const Color(0xFFFFE58A)),
          const Color(0x00EAB308),
        ],
        blobB: [
          (isDark ? const Color(0xFF84CC16) : const Color(0xFFD6F4A3)),
          const Color(0x0084CC16),
        ],
      );
    case AppBackgroundTheme.graphite:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF0B0F16) : const Color(0xFFF7F8FA),
        baseBottom: isDark ? const Color(0xFF0F1622) : const Color(0xFFECEFF4),
        blobA: [
          (isDark ? const Color(0xFF64748B) : const Color(0xFFC9D3E2)),
          const Color(0x0064748B),
        ],
        blobB: [
          (isDark ? const Color(0xFF334155) : const Color(0xFFD9DEE7)),
          const Color(0x00334155),
        ],
      );
    case AppBackgroundTheme.sakura:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF130A12) : const Color(0xFFFFF5F8),
        baseBottom: isDark ? const Color(0xFF1B0D16) : const Color(0xFFFFE7EF),
        blobA: [
          (isDark ? const Color(0xFFF472B6) : const Color(0xFFFFB6D8)),
          const Color(0x00F472B6),
        ],
        blobB: [
          (isDark ? const Color(0xFFA78BFA) : const Color(0xFFE6CCFF)),
          const Color(0x00A78BFA),
        ],
      );
    case AppBackgroundTheme.mint:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF07131A) : const Color(0xFFF2FFFB),
        baseBottom: isDark ? const Color(0xFF071C1D) : const Color(0xFFE6FFF5),
        blobA: [
          (isDark ? const Color(0xFF2DD4BF) : const Color(0xFFB4F5E9)),
          const Color(0x002DD4BF),
        ],
        blobB: [
          (isDark ? const Color(0xFF38BDF8) : const Color(0xFFBFEAFF)),
          const Color(0x0038BDF8),
        ],
      );
    case AppBackgroundTheme.midnight:
      return _MeshPalette(
        baseTop: isDark ? const Color(0xFF070A12) : const Color(0xFFF6F7FF),
        baseBottom: isDark ? const Color(0xFF0B1220) : const Color(0xFFE9ECFF),
        blobA: [
          (isDark ? const Color(0xFF60A5FA) : const Color(0xFFBFD7FF)),
          const Color(0x0060A5FA),
        ],
        blobB: [
          (isDark ? const Color(0xFF818CF8) : const Color(0xFFD9DEFF)),
          const Color(0x00818CF8),
        ],
      );
  }
}

class _SoftBlob extends StatelessWidget {
  const _SoftBlob({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: colors),
          ),
        ),
      ),
    );
  }
}
