import 'package:flutter/material.dart';
import '../../../models/luggage.dart';
import '../../../ui/components/app_empty_state.dart';
import '../../../ui/components/app_error_state.dart';
import '../../../ui/components/app_skeleton.dart';

class ActiveTripCard extends StatelessWidget {
  const ActiveTripCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.loading,
    required this.errorMessage,
    required this.onRetry,
    required this.luggage,
    required this.onShowQr,
    required this.onDetails,
    required this.emptyLabel,
    required this.emptyActionLabel,
    required this.onEmptyAction,
  });

  final String title;
  final String subtitle;
  final bool loading;
  final String? errorMessage;
  final VoidCallback onRetry;
  final LuggageModel? luggage;
  final VoidCallback onShowQr;
  final VoidCallback onDetails;
  final String emptyLabel;
  final String emptyActionLabel;
  final VoidCallback onEmptyAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            if (loading)
              const AppSkeleton(height: 80)
            else if (errorMessage != null)
              AppErrorState(
                message: errorMessage!,
                onRetry: onRetry,
              )
            else if (luggage == null)
              AppEmptyState(
                title: emptyLabel,
                subtitle: '',
                actionLabel: emptyActionLabel,
                onAction: onEmptyAction,
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    luggage!.displayLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    luggage!.statusLabel,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: onShowQr,
                        icon: const Icon(Icons.qr_code_2),
                        label: const Text('QR'),
                      ),
                      OutlinedButton.icon(
                        onPressed: onDetails,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Details'),
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
