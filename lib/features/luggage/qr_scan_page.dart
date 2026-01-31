import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../services/luggage_service.dart';
import '../../widgets/app_notification.dart';

class QrScanPage extends StatefulWidget {
  const QrScanPage({
    super.key,
    this.autoReturn = false,
  });

  final bool autoReturn;

  @override
  State<QrScanPage> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  final MobileScannerController _controller = MobileScannerController();
  final TextEditingController _manualController = TextEditingController();
  final FocusNode _manualFocus = FocusNode();
  bool _handled = false;
  bool _loading = false;
  String? _error;
  String? _lastCode;
  LuggageModel? _matched;
  List<LuggageModel> _cache = const [];
  _QrMode _mode = _QrMode.scan;

  @override
  void dispose() {
    _manualController.dispose();
    _manualFocus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;
    final rawValue = barcodes.first.rawValue?.trim();
    if (rawValue == null || rawValue.isEmpty) return;
    _handled = true;
    _controller.stop();
    if (widget.autoReturn) {
      Navigator.of(context).pop(rawValue);
      return;
    }
    _resolveCode(rawValue);
  }

  Future<void> _resolveCode(String code) async {
    if (_loading) return;
    setState(() {
      _loading = true;
      _error = null;
      _lastCode = code;
      _matched = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        throw StateError('USER_ID_MISSING');
      }
      if (_cache.isEmpty) {
        _cache = await LuggageService.getUserLuggages(userId);
      }
      final found = _cache.firstWhere(
        (item) =>
            item.qrCode.toLowerCase() == code.toLowerCase() ||
            item.id.toLowerCase() == code.toLowerCase(),
        orElse: () => LuggageModel(
          id: '',
          qrCode: '',
          status: LuggageStatus.cancelled,
          createdAt: DateTime.now(),
          dropLocationId: '',
          dropLocationName: '',
        ),
      );
      if (found.id.isEmpty) {
        setState(() {
          _error = AppLocalizations.of(context)!.qrNotFound;
        });
      } else {
        setState(() {
          _matched = found;
        });
      }
    } catch (e) {
      setState(() {
        _error = AppLocalizations.of(context)!.qrLookupFailed;
      });
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirmDrop() async {
    final luggage = _matched;
    if (luggage == null || _loading) return;
    final loc = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.qrConfirmDropTitle),
        content: Text(loc.qrConfirmDropMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(loc.dialogDismiss),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(loc.dialogConfirm),
          ),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _loading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        throw StateError('USER_ID_MISSING');
      }
      final res = await LuggageService.updateStatus(
        userId,
        luggage.id,
        luggageStatusDropped,
        null,
        null,
      );
      if (res['ok'] == true) {
        AppNotification.show(
          context,
          message: loc.qrDropSuccess,
          type: AppNotificationType.success,
        );
        final refreshed = await LuggageService.getUserLuggages(userId);
        _cache = refreshed;
        final updated = refreshed.firstWhere(
          (item) => item.id == luggage.id,
          orElse: () => luggage,
        );
        setState(() => _matched = updated);
      } else {
        final msg =
            (res['error'] ?? res['message'] ?? loc.qrDropFailed).toString();
        AppNotification.show(
          context,
          message: msg.isNotEmpty ? msg : loc.qrDropFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (_) {
      AppNotification.show(
        context,
        message: loc.qrDropFailed,
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _resetScan() {
    setState(() {
      _handled = false;
      _loading = false;
      _error = null;
      _lastCode = null;
      _matched = null;
    });
    _controller.start();
  }

  Future<void> _manualSubmit() async {
    final code = _manualController.text.trim();
    if (code.isEmpty) return;
    if (widget.autoReturn) {
      Navigator.of(context).pop(code);
      return;
    }
    await _resolveCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.qrScanTitle),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Text(
              widget.autoReturn ? loc.qrScanTip : loc.qrScanGuide,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          if (!widget.autoReturn)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: SegmentedButton<_QrMode>(
                segments: [
                  ButtonSegment(
                    value: _QrMode.scan,
                    icon: const Icon(Icons.qr_code_scanner),
                    label: Text(loc.qrScanAction),
                  ),
                  ButtonSegment(
                    value: _QrMode.manual,
                    icon: const Icon(Icons.edit),
                    label: Text(loc.qrManualEntry),
                  ),
                ],
                selected: {_mode},
                onSelectionChanged: (value) {
                  setState(() => _mode = value.first);
                },
              ),
            ),
          Expanded(
            child: _mode == _QrMode.scan || widget.autoReturn
                ? MobileScanner(
                    controller: _controller,
                    onDetect: _onDetect,
                  )
                : _ManualEntryPanel(
                    controller: _manualController,
                    focusNode: _manualFocus,
                    onSubmit: _manualSubmit,
                  ),
          ),
          if (!widget.autoReturn)
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _loading
                  ? Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          theme.colorScheme.primary,
                        ),
                      ),
                    )
                  : _buildResultCard(context),
            ),
        ],
      ),
    );
  }

  Widget _buildResultCard(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (_lastCode == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Text(
          loc.qrAwaitingScan,
          textAlign: TextAlign.center,
        ),
      );
    }
    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          children: [
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _resetScan,
              icon: const Icon(Icons.refresh),
              label: Text(loc.qrScanAgain),
            ),
          ],
        ),
      );
    }
    final luggage = _matched;
    if (luggage == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.qrReservationInfoTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 12),
              _InfoRow(label: loc.qrCode, value: luggage.qrCode),
              _InfoRow(label: loc.statusLabel, value: _statusLabel(loc, luggage.status)),
              _InfoRow(
                label: loc.locationLabel,
                value: luggage.dropLocationName.isNotEmpty
                    ? luggage.dropLocationName
                    : '-',
              ),
              if (luggage.scheduledDropTime != null)
                _InfoRow(
                  label: loc.dropTimeTitle,
                  value: _formatDateTime(context, luggage.scheduledDropTime!),
                ),
              if (luggage.scheduledPickupTime != null)
                _InfoRow(
                  label: loc.pickupTimeTitle,
                  value: _formatDateTime(context, luggage.scheduledPickupTime!),
                ),
              if ((luggage.ownerName ?? '').isNotEmpty)
                _InfoRow(label: loc.ownerNameLabel, value: luggage.ownerName!),
              if ((luggage.ownerPhone ?? '').isNotEmpty)
                _InfoRow(label: loc.ownerPhoneLabel, value: luggage.ownerPhone!),
              if ((luggage.paymentStatus ?? '').isNotEmpty)
                _InfoRow(
                  label: loc.paymentStatusLabel,
                  value: luggage.paymentStatus!,
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetScan,
                      icon: const Icon(Icons.refresh),
                      label: Text(loc.qrScanAgain),
                    ),
                  ),
                  if (luggage.status == LuggageStatus.awaitingDrop) ...[
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _confirmDrop,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(loc.qrDropConfirmAction),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _QrMode { scan, manual }

class _ManualEntryPanel extends StatelessWidget {
  const _ManualEntryPanel({
    required this.controller,
    required this.focusNode,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onSubmit(),
            decoration: InputDecoration(
              labelText: loc.qrManualHint,
              prefixIcon: const Icon(Icons.qr_code),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text(loc.qrManualSearchAction),
          ),
          const SizedBox(height: 20),
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

String _formatDateTime(BuildContext context, DateTime date) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat('dd MMM yyyy, HH:mm', locale).format(date);
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = value.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: hasValue ? 120 : 0,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          if (hasValue)
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          else
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
