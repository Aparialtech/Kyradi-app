import 'dart:io';
import 'package:flutter/material.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({
    super.key,
    required this.title,
    required this.subtitle,
    this.onAvatarTap,
    this.avatarPath,
  });

  final String title;
  final String subtitle;
  final VoidCallback? onAvatarTap;
  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedPath = avatarPath?.trim() ?? '';
    final isRemote = resolvedPath.startsWith('http');
    final hasLocal = resolvedPath.isNotEmpty && File(resolvedPath).existsSync();
    final hasAvatar = isRemote || hasLocal;
    final ImageProvider? avatarImage = isRemote
        ? NetworkImage(resolvedPath)
        : (hasLocal ? FileImage(File(resolvedPath)) : null);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        InkWell(
          onTap: onAvatarTap,
          borderRadius: BorderRadius.circular(24),
          splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
          highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.9),
                  theme.colorScheme.secondary.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: CircleAvatar(
              radius: 22,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
              backgroundImage: avatarImage,
              child: !hasAvatar
                  ? Icon(
                      Icons.person,
                      color: theme.colorScheme.primary,
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
