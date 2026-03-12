import 'dart:io';

import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../widgets/avatar_image.dart';
import '../../../widgets/section_card.dart';

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
    final isVerified =
        user.identityVerified == true || user.verificationStatus == 'verified';
    return SectionCard(
      radius: 28,
      padding: const EdgeInsets.all(18),
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              height: 130,
              width: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.28),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 34,
                    backgroundColor: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(2.5),
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
                        radius: 31,
                        backgroundColor: theme.colorScheme.primary.withValues(
                          alpha: 0.12,
                        ),
                        child: AvatarImage(
                          path: resolvedPath,
                          size: 62,
                          icon: Icons.person,
                          iconColor: theme.colorScheme.primary,
                          backgroundColor: theme.colorScheme.primary.withValues(
                            alpha: 0.12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullName.isEmpty ? loc.travelerPlaceholder : fullName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          user.email,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _MiniBadge(
                          label: isVerified
                              ? loc.profileVerifiedLabel
                              : loc.profileVerificationMissing,
                          icon: isVerified
                              ? Icons.verified
                              : Icons.pending_outlined,
                          color: isVerified
                              ? const Color(0xFF0F766E)
                              : theme.colorScheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 42,
                    width: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.6),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                    child: IconButton(
                      tooltip: loc.profileEditTitle,
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: theme.colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.55,
                  ),
                  border: Border.all(
                    color: theme.colorScheme.outlineVariant.withValues(
                      alpha: 0.55,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TinyInfo(
                        label: 'Rol',
                        value: (user.role.isEmpty ? 'user' : user.role)
                            .toUpperCase(),
                      ),
                    ),
                    Expanded(
                      child: _TinyInfo(
                        label: 'Durum',
                        value: isVerified ? 'ONAYLI' : 'BEKLEME',
                      ),
                    ),
                    Expanded(
                      child: _TinyInfo(
                        label: 'Bildirim',
                        value: user.pushReminderEnabled ? 'AÇIK' : 'KAPALI',
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyInfo extends StatelessWidget {
  const _TinyInfo({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
