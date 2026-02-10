import 'dart:io';
import 'package:flutter/material.dart';

class AvatarImage extends StatelessWidget {
  const AvatarImage({
    super.key,
    required this.path,
    required this.size,
    required this.icon,
    required this.iconColor,
    this.backgroundColor,
  });

  final String? path;
  final double size;
  final IconData icon;
  final Color iconColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final resolved = (path ?? '').trim();
    final isRemote = resolved.startsWith('http');
    final hasLocal = resolved.isNotEmpty && File(resolved).existsSync();
    final hasAvatar = isRemote || hasLocal;
    final placeholder = Icon(icon, color: iconColor, size: size * 0.52);

    Widget child;
    if (!hasAvatar) {
      child = Center(child: placeholder);
    } else if (isRemote) {
      child = Image.network(
        resolved,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Center(child: placeholder),
      );
    } else {
      child = Image.file(
        File(resolved),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Center(child: placeholder),
      );
    }

    return ClipOval(
      child: Container(
        height: size,
        width: size,
        color: backgroundColor ?? Colors.transparent,
        child: child,
      ),
    );
  }
}
