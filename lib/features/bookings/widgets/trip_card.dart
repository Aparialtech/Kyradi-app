import 'package:flutter/material.dart';
import '../../../models/luggage.dart';
import '../../../widgets/section_card.dart';

class TripCard extends StatelessWidget {
  const TripCard({
    super.key,
    required this.luggage,
    required this.onShowQr,
    required this.onScanQr,
    required this.onDetails,
    required this.onSupport,
    this.onCancel,
  });

  final LuggageModel luggage;
  final VoidCallback onShowQr;
  final VoidCallback onScanQr;
  final VoidCallback onDetails;
  final VoidCallback onSupport;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = luggage.statusColor(theme);
    final dropLabel = _formatDate(luggage.scheduledDropTime);
    final pickupLabel = _formatDate(luggage.scheduledPickupTime);
    return SectionCard(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    luggage.displayLabel,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    luggage.statusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              luggage.dropLocationName.isNotEmpty
                  ? luggage.dropLocationName
                  : luggage.dropLocationId,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (dropLabel.isNotEmpty || pickupLabel.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (dropLabel.isNotEmpty)
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.upload_rounded,
                        label: 'Drop • $dropLabel',
                      ),
                    ),
                  if (dropLabel.isNotEmpty && pickupLabel.isNotEmpty)
                    const SizedBox(width: 8),
                  if (pickupLabel.isNotEmpty)
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.download_rounded,
                        label: 'Pickup • $pickupLabel',
                      ),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: onShowQr,
                  icon: const Icon(Icons.qr_code_2),
                  label: const Text('QR Göster'),
                ),
                OutlinedButton.icon(
                  onPressed: onScanQr,
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text('QR Okut'),
                ),
                OutlinedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.timeline),
                  label: const Text('Detay'),
                ),
                if (onCancel != null && luggage.isAwaitingDrop)
                  OutlinedButton.icon(
                    onPressed: onCancel,
                    icon: const Icon(Icons.cancel_outlined),
                    label: const Text('İptal Et'),
                  ),
                TextButton.icon(
                  onPressed: onSupport,
                  icon: const Icon(Icons.support_agent_outlined),
                  label: const Text('Destek'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime? value) {
    if (value == null) return '';
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final min = local.minute.toString().padLeft(2, '0');
    return '$day/$month $hour:$min';
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
