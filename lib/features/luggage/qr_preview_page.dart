import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../widgets/app_notification.dart';

class QrPreviewPage extends StatelessWidget {
  const QrPreviewPage({super.key, required this.luggage});

  final LuggageModel luggage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final infoItems = <String>[];
    if ((luggage.size ?? '').isNotEmpty) {
      infoItems.add(
        loc.luggageInfoSize(_localizedSizeLabel(luggage.size, loc)),
      );
    }
    if ((luggage.weight ?? '').isNotEmpty) {
      infoItems.add(loc.luggageInfoWeight(luggage.weight ?? ''));
    }
    if ((luggage.color ?? '').isNotEmpty) {
      infoItems.add(
        loc.luggageInfoColor(_localizedColorLabel(luggage.color, loc)),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(luggage.displayLabel),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: 260,
                  height: 260,
                  child: QrImageView(
                    data: luggage.qrCode,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SelectableText(
                luggage.qrCode,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              if (infoItems.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(infoItems.join(' · '), style: theme.textTheme.bodyMedium),
              ],
              if ((luggage.note ?? '').isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(loc.noteLabel(luggage.note ?? ''),
                    style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: 20),
              Text(
                loc.pickupPinSentMessage,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: luggage.qrCode));
                  AppNotification.show(
                    context,
                    message: loc.qrCopied,
                    type: AppNotificationType.success,
                  );
                },
                icon: const Icon(Icons.copy),
                label: Text(loc.qrCopyCode),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () {
                  final text = 'Bavul QR Kodu: ${luggage.qrCode}';
                  Clipboard.setData(ClipboardData(text: text));
                  AppNotification.show(
                    context,
                    message: loc.qrTextCopied,
                    type: AppNotificationType.success,
                  );
                },
                icon: const Icon(Icons.print_outlined),
                label: Text(loc.qrCopyPrintable),
              ),
              const SizedBox(height: 24),
              _InfoRow(
                icon: Icons.info_outline,
                label: loc.statusLabel,
                value: luggage.statusLabel,
              ),
              const SizedBox(height: 8),
              Text(
                loc.createdAtLabel(
                  DateFormat('dd.MM.yyyy HH:mm').format(luggage.createdAt.toLocal()),
                ),
                style: theme.textTheme.bodySmall,
              ),
              if (luggage.dropConfirmedAt != null)
                Text(
                  loc.dropConfirmedAtLabel(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(luggage.dropConfirmedAt!.toLocal()),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              if (luggage.pickupConfirmedAt != null)
                Text(
                  loc.pickupConfirmedAtLabel(
                    DateFormat('dd.MM.yyyy HH:mm')
                        .format(luggage.pickupConfirmedAt!.toLocal()),
                  ),
                  style: theme.textTheme.bodySmall,
                ),
              const SizedBox(height: 12),
              Text(
                loc.qrShareInstructions,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

String _localizedSizeLabel(String? raw, AppLocalizations loc) {
  final normalized = raw?.toLowerCase().trim();
  switch (normalized) {
    case 'küçük':
    case 'kucuk':
    case 'small':
      return loc.small;
    case 'orta':
    case 'medium':
      return loc.medium;
    case 'büyük':
    case 'buyuk':
    case 'large':
      return loc.large;
    default:
      return raw ?? '';
  }
}

String _localizedColorLabel(String? raw, AppLocalizations loc) {
  final normalized = raw?.toLowerCase().trim();
  switch (normalized) {
    case 'siyah':
    case 'black':
      return loc.black;
    case 'gri':
    case 'gray':
    case 'grey':
      return loc.grey;
    case 'kırmızı':
    case 'kirmizi':
    case 'red':
      return loc.red;
    case 'mavi':
    case 'blue':
      return loc.blue;
    case 'yeşil':
    case 'yesil':
    case 'green':
      return loc.green;
    case 'diğer':
    case 'diger':
    case 'other':
      return loc.other;
    default:
      return raw ?? '';
  }
}
