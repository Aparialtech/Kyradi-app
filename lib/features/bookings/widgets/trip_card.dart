import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
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
    final loc = AppLocalizations.of(context)!;
    final statusColor = luggage.statusColor(theme);
    final dropLabel = _formatDate(luggage.scheduledDropTime);
    final pickupLabel = _formatDate(luggage.scheduledPickupTime);
    final sizeLabel = luggage.size?.trim().isNotEmpty == true
        ? loc.luggageInfoSize(luggage.size!.trim())
        : null;
    final weightLabel = luggage.weight?.trim().isNotEmpty == true
        ? loc.luggageInfoWeight(luggage.weight!.trim())
        : null;
    final colorLabel = luggage.color?.trim().isNotEmpty == true
        ? loc.luggageInfoColor(luggage.color!.trim())
        : null;
    final totalLabel = luggage.totalPrice != null
        ? '${loc.total}: ${luggage.totalPrice} ₺'
        : null;
    final paymentStatusLabel = _paymentStatusLabel(loc, luggage.paymentStatus);
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: statusColor.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    _statusLabel(loc, luggage.status),
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
            if (sizeLabel != null ||
                weightLabel != null ||
                colorLabel != null ||
                totalLabel != null ||
                paymentStatusLabel != null) ...[
              const SizedBox(height: 10),
              Text(
                loc.luggageInfoSectionTitle,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              _InfoGrid(
                items: [
                  if (sizeLabel != null)
                    _InfoItem(
                      label: loc.luggageInfoLabelSize,
                      value: _sizeValue(loc, luggage.size),
                      icon: Icons.straighten,
                    ),
                  if (weightLabel != null)
                    _InfoItem(
                      label: loc.luggageInfoLabelWeight,
                      value: luggage.weight!.trim(),
                      icon: Icons.scale_outlined,
                    ),
                  if (colorLabel != null)
                    _InfoItem(
                      label: loc.luggageInfoLabelColor,
                      value: _colorValue(loc, luggage.color),
                      icon: Icons.palette_outlined,
                    ),
                  if (paymentStatusLabel != null)
                    _InfoItem(
                      label: loc.luggageInfoLabelPayment,
                      value: paymentStatusLabel,
                      icon: Icons.payments_outlined,
                    ),
                  if (totalLabel != null)
                    _InfoItem(
                      label: loc.luggageInfoLabelTotal,
                      value: '${luggage.totalPrice} ₺',
                      icon: Icons.receipt_long_outlined,
                    ),
                ],
              ),
            ],
            if (dropLabel.isNotEmpty || pickupLabel.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  if (dropLabel.isNotEmpty)
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.upload_rounded,
                        label: loc.dropTimeLabel(dropLabel),
                      ),
                    ),
                  if (dropLabel.isNotEmpty && pickupLabel.isNotEmpty)
                    const SizedBox(width: 8),
                  if (pickupLabel.isNotEmpty)
                    Expanded(
                      child: _MetaChip(
                        icon: Icons.download_rounded,
                        label: loc.pickupTimeLabel(pickupLabel),
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
                  label: Text(loc.qrShowAction),
                ),
                OutlinedButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.timeline),
                  label: Text(loc.detailsAction),
                ),
                _OverflowMenu(
                  onScanQr: onScanQr,
                  onSupport: onSupport,
                  onCancel: onCancel != null && luggage.isAwaitingDrop
                      ? onCancel
                      : null,
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
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
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

class _InfoItem {
  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: width,
                child: _InfoRow(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final _InfoItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Row(
        children: [
          Icon(item.icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.value,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
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

String? _paymentStatusLabel(AppLocalizations loc, String? status) {
  if (status == null || status.trim().isEmpty) return null;
  switch (status) {
    case paymentStatusPaid:
      return loc.paymentStatusPaid;
    case paymentStatusPending:
      return loc.paymentStatusPending;
    case paymentStatusFailed:
      return loc.paymentStatusFailed;
    case paymentStatusUnpaid:
      return loc.paymentStatusUnpaid;
    default:
      return status;
  }
}

String _sizeValue(AppLocalizations loc, String? size) {
  switch ((size ?? '').toLowerCase()) {
    case 'small':
      return loc.small;
    case 'large':
      return loc.large;
    case 'medium':
    default:
      return loc.medium;
  }
}

String _colorValue(AppLocalizations loc, String? color) {
  switch ((color ?? '').toLowerCase()) {
    case 'black':
      return loc.black;
    case 'grey':
      return loc.grey;
    case 'red':
      return loc.red;
    case 'blue':
      return loc.blue;
    case 'green':
      return loc.green;
    default:
      return loc.other;
  }
}

class _OverflowMenu extends StatelessWidget {
  const _OverflowMenu({
    required this.onScanQr,
    required this.onSupport,
    this.onCancel,
  });

  final VoidCallback onScanQr;
  final VoidCallback onSupport;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return PopupMenuButton<_TripMenuAction>(
      icon: const Icon(Icons.more_vert),
      onSelected: (action) {
        switch (action) {
          case _TripMenuAction.scanQr:
            onScanQr();
            break;
          case _TripMenuAction.support:
            onSupport();
            break;
          case _TripMenuAction.cancel:
            onCancel?.call();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _TripMenuAction.scanQr,
          child: Text(loc.qrScanAction),
        ),
        PopupMenuItem(
          value: _TripMenuAction.support,
          child: Text(loc.supportAction),
        ),
        if (onCancel != null)
          PopupMenuItem(
            value: _TripMenuAction.cancel,
            child: Text(loc.luggageCancelAction),
          ),
      ],
    );
  }
}

enum _TripMenuAction { scanQr, support, cancel }
