import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';
import '../../../ui/components/app_badge.dart';
import '../../../l10n/app_localizations.dart';

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            loc.verificationTitle,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
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
                    fontWeight: FontWeight.w600,
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
          const SizedBox(height: 8),
          Row(
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
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onManage,
                child: Text(loc.manageAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
