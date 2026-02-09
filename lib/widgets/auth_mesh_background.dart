import 'dart:ui';

import 'package:flutter/material.dart';

class AuthMeshBackground extends StatelessWidget {
  const AuthMeshBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: const [
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF4F7FC), Color(0xFFE9EEF6)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -120,
          right: -80,
          child: _SoftBlob(
            size: 240,
            colors: [Color(0xFF9CD0FF), Color(0x009CD0FF)],
          ),
        ),
        Positioned(
          bottom: -120,
          left: -60,
          child: _SoftBlob(
            size: 260,
            colors: [Color(0xFFE6B3FF), Color(0x00E6B3FF)],
          ),
        ),
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
        filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
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
