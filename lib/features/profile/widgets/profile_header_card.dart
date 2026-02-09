import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../widgets/section_card.dart';
import '../../../l10n/app_localizations.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.onEdit,
    this.avatarPath,
  });

  final UserModel user;
  final VoidCallback onEdit;
  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final fullName = '${user.name} ${user.surname}'.trim();
    final resolvedPath = _resolveAvatarUrl(avatarPath ?? '');
    final isRemote = resolvedPath.startsWith('http');
    final hasLocal = resolvedPath.isNotEmpty && File(resolvedPath).existsSync();
    final hasAvatar = isRemote || hasLocal;
    final ImageProvider? avatarImage = isRemote
        ? NetworkImage(resolvedPath)
        : (hasLocal ? FileImage(File(resolvedPath)) : null);
    // Backward compatible:
    // - Older users may be considered verified via email verificationStatus.
    // - New KYC flow sets identityVerified (and backend may also keep legacy `verified` true).
    final isVerified = user.identityVerified == true || user.verificationStatus == 'verified';
    return SectionCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
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
                radius: 28,
                backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.12),
                backgroundImage: avatarImage,
                child: !hasAvatar
                    ? Icon(
                        Icons.person,
                        color: theme.colorScheme.primary,
                        size: 28,
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isEmpty ? loc.travelerPlaceholder : fullName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.email,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                if (isVerified)
                  Row(
                    children: [
                      Icon(Icons.verified, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        loc.profileVerifiedLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          IconButton(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  String _resolveAvatarUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http')) return trimmed;
    if (File(trimmed).existsSync()) return trimmed;
    final base = ApiService.baseUrl;
    if (base.isEmpty) return trimmed;
    if (trimmed.startsWith('/')) {
      return base.endsWith('/')
          ? '${base.substring(0, base.length - 1)}$trimmed'
          : '$base$trimmed';
    }
    return trimmed;
  }
}
