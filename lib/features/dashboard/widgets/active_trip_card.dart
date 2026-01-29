import 'package:flutter/material.dart';
import '../../../models/luggage.dart';
import '../../../l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 4,
              width: 26,
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.9),
                    theme.colorScheme.secondary.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
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
                    _statusLabel(loc, luggage!.status),
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
                        label: Text(loc.qrShowAction),
                      ),
                      OutlinedButton.icon(
                        onPressed: onDetails,
                        icon: const Icon(Icons.open_in_new),
                        label: Text(loc.detailsAction),
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

String _statusLabel(AppLocalizations loc, LuggageStatus status) {
  switch (status) {
    case LuggageStatus.awaitingDrop:
      return loc.luggageStatusAwaitingDrop;
    case LuggageStatus.dropped:
      return loc.luggageStatusDropped;
    case LuggageStatus.pickedUp:
      return loc.luggageStatusPickedUp;
    case LuggageStatus.cancelled:
      return loc.luggageStatusCancelled;
  }
}
