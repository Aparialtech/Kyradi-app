import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';
import '../../../ui/components/app_badge.dart';
import '../../../l10n/app_localizations.dart';

class VerificationSection extends StatelessWidget {
  const VerificationSection({
    super.key,
    required this.status,
    required this.onManage,
  });

  final String status;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final resolved = status.isEmpty ? 'unverified' : status;
    final isVerified = resolved == 'verified';
    final isPending = resolved == 'pending';
    final statusColor = isVerified
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
                isVerified
                    ? Icons.verified
                    : isPending
                        ? Icons.pending_actions
                        : Icons.warning_amber_outlined,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isVerified
                      ? loc.verificationStatusVerified
                      : isPending
                          ? loc.verificationStatusPending
                          : loc.verificationStatusRequired,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppBadge(
                label: isVerified
                    ? loc.verificationBadgeVerified
                    : isPending
                        ? loc.verificationBadgePending
                        : loc.verificationBadgeNew,
                color: statusColor,
              ),
              const SizedBox(width: 6),
              TextButton(
                onPressed: onManage,
                child: Text(isVerified ? loc.viewAction : loc.manageAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
