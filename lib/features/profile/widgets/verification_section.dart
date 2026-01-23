import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';

class VerificationSection extends StatelessWidget {
  const VerificationSection({
    super.key,
    required this.isVerified,
    required this.onManage,
  });

  final bool isVerified;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor =
        isVerified ? theme.colorScheme.primary : theme.colorScheme.error;
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
                isVerified ? Icons.verified : Icons.warning_amber_outlined,
                color: statusColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isVerified ? 'Identity verified' : 'Identity missing',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: onManage,
                child: Text(isVerified ? 'View' : 'Upload'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
