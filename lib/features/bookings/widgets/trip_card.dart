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
  });

  final LuggageModel luggage;
  final VoidCallback onShowQr;
  final VoidCallback onScanQr;
  final VoidCallback onDetails;
  final VoidCallback onSupport;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = luggage.statusColor(theme);
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
}
