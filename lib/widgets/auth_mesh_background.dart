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
              colors: [Color(0xFFEDEFF5), Color(0xFFE4E8F1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -100,
          right: -60,
          child: _SoftBlob(
            size: 260,
            colors: [Color(0xFFE66D86), Color(0x00E66D86)],
          ),
        ),
        Positioned(
          top: 220,
          right: -90,
          child: _SoftBlob(
            size: 300,
            colors: [Color(0xFF7B4DFF), Color(0x007B4DFF)],
          ),
        ),
        Positioned(
          bottom: 80,
          right: -90,
          child: _SoftBlob(
            size: 300,
            colors: [Color(0xFF38BDF8), Color(0x0038BDF8)],
          ),
        ),
        Positioned(
          bottom: -120,
          left: -80,
          child: _SoftBlob(
            size: 290,
            colors: [Color(0xFFEFC2E4), Color(0x00EFC2E4)],
          ),
        ),
      ],
    );
  }
}

class _SoftBlob extends StatelessWidget {
  const _SoftBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(gradient: RadialGradient(colors: colors)),
        ),
      ),
    );
  }
}
