import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../ui/components/app_badge.dart';
import '../../../widgets/section_card.dart';

class VerificationSection extends StatelessWidget {
  const VerificationSection({
    super.key,
    required this.status,
    this.identityVerified = false,
    required this.onManage,
  });

  final String status;
  final bool identityVerified;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final resolved = status.isEmpty ? 'unverified' : status;
    final isEmailVerified = resolved == 'verified';
    final isPending = resolved == 'pending';
    final emailColor = isEmailVerified
        ? theme.colorScheme.primary
        : isPending
        ? theme.colorScheme.tertiary
        : theme.colorScheme.error;
    return SectionCard(
      radius: 24,
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const ThreeDIconBadge(icon: Icons.verified_user_outlined),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  loc.verificationTitle,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              FilledButton.tonal(
                onPressed: onManage,
                child: Text(loc.manageAction),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: emailColor.withValues(alpha: 0.08),
              border: Border.all(color: emailColor.withValues(alpha: 0.22)),
            ),
            child: Row(
              children: [
                Icon(
                  isEmailVerified
                      ? Icons.mark_email_read_outlined
                      : isPending
                      ? Icons.pending_actions
                      : Icons.mark_email_unread_outlined,
                  color: emailColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    isEmailVerified
                        ? loc.emailVerifiedLabel
                        : isPending
                        ? loc.emailPendingLabel
                        : loc.emailVerificationNeededLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: emailColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                AppBadge(
                  label: isEmailVerified
                      ? loc.verificationBadgeVerified
                      : isPending
                      ? loc.verificationBadgePending
                      : loc.verificationBadgeNew,
                  color: emailColor,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color:
                  (identityVerified
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant)
                      .withValues(alpha: 0.08),
              border: Border.all(
                color:
                    (identityVerified
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant)
                        .withValues(alpha: 0.22),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  identityVerified ? Icons.verified : Icons.badge_outlined,
                  color: identityVerified
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    identityVerified
                        ? loc.identityVerifiedLabel
                        : loc.identityVerificationNeededLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: identityVerified
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
