import 'package:flutter/material.dart';

class RainbowBar extends StatelessWidget {
  const RainbowBar({
    super.key,
    this.height = 4,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF00A3FF),
            Color(0xFF12C2E9),
            Color(0xFFFCEE21),
            Color(0xFFFC466B),
          ],
        ),
      ),
    );
  }
}
