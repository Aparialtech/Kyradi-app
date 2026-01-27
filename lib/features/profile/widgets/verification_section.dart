import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';
import '../../../ui/components/app_badge.dart';

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
          const Text(
            'Verification',
            style: TextStyle(fontWeight: FontWeight.w700),
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
                      ? 'Hesap onaylı'
                      : isPending
                          ? 'Doğrulama bekliyor'
                          : 'Doğrulama gerekli',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              AppBadge(
                label: isVerified ? 'Verified' : isPending ? 'Pending' : 'New',
                color: statusColor,
              ),
              const SizedBox(width: 6),
              TextButton(
                onPressed: onManage,
                child: Text(isVerified ? 'Görüntüle' : 'Yönet'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
