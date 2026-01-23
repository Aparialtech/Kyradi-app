import 'package:flutter/material.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({
    super.key,
    this.height,
    this.width,
    this.radius = 16,
  });

  final double? height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
