import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import '../../models/luggage.dart';
import '../../l10n/app_localizations.dart';
import '../../core/repositories/luggage_repository.dart';
import '../../services/api_service.dart';
import '../bookings/widgets/trip_timeline_sheet.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';
import '../../utils/crash_log.dart';
import 'package:go_router/go_router.dart';
import '../../screens/payment_page.dart';

class LuggageDetailPage extends StatefulWidget {
  const LuggageDetailPage({
    super.key,
    required this.luggageId,
    this.initial,
  });

  final String luggageId;
  final LuggageModel? initial;

  @override
  State<LuggageDetailPage> createState() => _LuggageDetailPageState();
}

class _LuggageDetailPageState extends State<LuggageDetailPage> {
  final LuggageRepository _repo = const LuggageRepository();
  LuggageModel? _luggage;
  bool _loading = true;
  String? _error;
  bool _updating = false;
  String? _userId;
  String? _customerName;
  String? _customerEmail;

  @override
  void initState() {
    super.initState();
    _luggage = widget.initial;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'USER_ID_MISSING';
        });
        return;
      }
      _userId = userId;
      final profile = await ApiService.getProfile(userId);
      if (profile['profile'] is Map<String, dynamic>) {
        final raw = Map<String, dynamic>.from(profile['profile'] as Map);
        final name = (raw['name'] ?? '').toString().trim();
        final surname = (raw['surname'] ?? '').toString().trim();
        final email = (raw['email'] ?? '').toString().trim();
        _customerName = ('$name $surname').trim();
        _customerEmail = email.isNotEmpty ? email : null;
      }
      final items = await _repo.getUserLuggages(userId);
      if (items.isEmpty && widget.initial == null) {
        setState(() {
          _loading = false;
          _error = 'LUGGAGE_NOT_FOUND';
        });
        return;
      }
      final match = items.firstWhere(
        (item) => item.id == widget.luggageId,
        orElse: () => widget.initial ?? items.first,
      );
      if (!mounted) return;
      setState(() {
        _luggage = match;
        _loading = false;
      });
    } catch (e) {
      appLog('luggage', 'detail load failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _updateStatus(String status, {String? pin}) async {
    if (_userId == null || _userId!.isEmpty || _luggage == null) return;
    final loc = AppLocalizations.of(context)!;
    setState(() => _updating = true);
    try {
      final result = await _repo.updateStatus(
        _userId!,
        _luggage!.id,
        status,
        pin,
        null,
      );
      if (!mounted) return;
      if (result['ok'] == true && result['luggage'] is Map) {
        final next = LuggageModel.fromJson(
          Map<String, dynamic>.from(result['luggage'] as Map),
        );
        setState(() => _luggage = next);
        AppNotification.show(
          context,
          message: status == 'dropped'
              ? loc.dropConfirmedMessage
              : loc.luggagePickupAction,
          type: AppNotificationType.success,
        );
      } else if (_isPaymentRequired(result)) {
        await _handlePaymentRequired();
      } else {
        final msg = (result['error'] ?? result['message'] ?? '').toString();
        AppNotification.show(
          context,
          message: msg.isNotEmpty ? msg : loc.statusUpdateFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      appLog('luggage', 'status update failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.genericErrorWithDetails('$e'),
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  bool _isPaymentRequired(Map<String, dynamic> result) {
    final msg = (result['message'] ?? result['error'] ?? result['code'] ?? '')
        .toString()
        .trim();
    return msg == 'PAYMENT_REQUIRED_BEFORE_DROP';
  }

  Future<void> _handlePaymentRequired() async {
    if (!mounted || _luggage == null || _userId == null) return;
      final loc = AppLocalizations.of(context)!;
      final go = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(loc.paymentPageTitle),
          content: Text(loc.paymentRequiredBeforeDropMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(loc.dialogDismiss),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(loc.paymentStartAction),
            ),
          ],
        ),
      );
    if (go != true) return;
    final luggage = _luggage!;
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          userId: _userId!,
          reservationId: luggage.id,
          paymentMethod: luggage.paymentMethod ?? 'card',
          totalPrice: luggage.totalPrice ?? 0,
          sizeLabel: luggage.size ?? 'Orta',
          dropAt: luggage.scheduledDropTime,
          pickupAt: luggage.scheduledPickupTime,
          locationId: luggage.dropLocationId,
        ),
      ),
    );
    if (result == true) {
      await _load();
      await _updateStatus('dropped');
    }
  }

  void _showTimeline(LuggageModel luggage) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TripTimelineSheet(luggage: luggage),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _luggage == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.myLuggages)),
        body: Center(
          child: Text(
            _error == 'USER_ID_MISSING'
                ? loc.userIdMissing
                : loc.luggageEmptyStateNoItems,
          ),
        ),
      );
    }
    final luggage = _luggage!;
    return Scaffold(
      appBar: AppBar(
        title: Text(luggage.displayLabel),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 12),
                title: Text(
                  loc.reservationInfoTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                subtitle: Text(loc.reservationInfoSubtitle),
                leading: const ThreeDIconBadge(
                  icon: Icons.info_outline,
                ),
                children: [
                  _InfoRow(
                    label: loc.luggageIdLabel,
                    value: luggage.id,
                  ),
                  _InfoRow(
                    label: loc.statusLabel,
                    value: _statusLabel(loc, luggage.status),
                  ),
                  _InfoRow(
                    label: loc.paymentStatusLabel,
                    value: _paymentStatusLabel(loc, luggage.paymentStatus),
                  ),
                  _InfoRow(
                    label: loc.paymentMethodTitle,
                    value: _paymentMethodLabel(loc, luggage),
                  ),
                  _InfoRow(
                    label: loc.createdAtTitle,
                    value: _formatDateTime(luggage.createdAt, context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding: EdgeInsets.zero,
                childrenPadding: const EdgeInsets.only(top: 12),
                title: Text(
                  loc.luggageInfoSectionTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                subtitle: Text(loc.luggageInfoSectionSubtitle),
                leading: const ThreeDIconBadge(
                  icon: Icons.inventory_2_outlined,
                ),
                children: [
                  _InfoRow(
                    label: loc.luggageInfoLabelSize,
                    value: _sizeLabel(loc, luggage.size),
                  ),
                  _InfoRow(
                    label: loc.luggageInfoLabelWeight,
                    value: luggage.weight ?? '-',
                  ),
                  _InfoRow(
                    label: loc.luggageInfoLabelColor,
                    value: _colorLabel(loc, luggage.color),
                  ),
                  _InfoRow(
                    label: loc.locationLabel,
                    value: luggage.dropLocationName.isNotEmpty
                        ? luggage.dropLocationName
                        : luggage.dropLocationId,
                  ),
                  _InfoRow(
                    label: loc.dropTimeTitle,
                    value: luggage.scheduledDropTime == null
                        ? '-'
                        : _formatDateTime(luggage.scheduledDropTime!, context),
                  ),
                  _InfoRow(
                    label: loc.pickupTimeTitle,
                    value: luggage.scheduledPickupTime == null
                        ? '-'
                        : _formatDateTime(luggage.scheduledPickupTime!, context),
                  ),
                  if ((luggage.note ?? '').isNotEmpty)
                    _InfoRow(
                      label: loc.note,
                      value: luggage.note ?? '',
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(_statusLabel(loc, luggage.status)),
            subtitle: Text(luggage.dropLocationName.isNotEmpty
                ? luggage.dropLocationName
                : luggage.dropLocationId),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              context.push('/luggage/${luggage.id}/qr', extra: luggage);
            },
            icon: const Icon(Icons.qr_code),
            label: Text(loc.luggageShowQr),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showTimeline(luggage),
            icon: const Icon(Icons.timeline),
            label: Text(loc.detailsAction),
          ),
          const SizedBox(height: 12),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.invoiceSectionTitle,
                  subtitle: loc.invoiceSectionSubtitle,
                  iconWidget: const ThreeDIconBadge(
                    icon: Icons.receipt_long_outlined,
                  ),
                ),
                const SizedBox(height: 12),
                _InfoRow(
                  label: loc.invoiceAmountLabel,
                  value: luggage.totalPrice == null
                      ? '-'
                      : '${luggage.totalPrice} ₺',
                ),
                _InfoRow(
                  label: loc.invoicePaymentMethodLabel,
                  value: _paymentMethodLabel(loc, luggage),
                ),
                _InfoRow(
                  label: loc.invoicePaymentStatusLabel,
                  value: _paymentStatusLabel(loc, luggage.paymentStatus),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => _showInvoice(context, luggage),
                  icon: const Icon(Icons.picture_as_pdf_outlined),
                  label: Text(loc.invoiceShowAction),
                ),
              ],
            ),
          ),
          if (luggage.isAwaitingDrop)
            FilledButton(
              onPressed: _updating ? null : () => _updateStatus('dropped'),
              child: _updating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.luggageDropAction),
            ),
          if (luggage.isDropped)
            FilledButton(
              onPressed: _updating ? null : () => _updateStatus('picked_up'),
              child: _updating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.luggagePickupAction),
            ),
        ],
      ),
    );
  }

  void _showInvoice(BuildContext context, LuggageModel luggage) {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => _InvoiceSheet(
        luggage: luggage,
        loc: loc,
        customerName: _customerName,
        customerEmail: _customerEmail,
        onDownload: () => _downloadInvoice(luggage),
      ),
    );
  }

  Future<void> _downloadInvoice(LuggageModel luggage) async {
    final loc = AppLocalizations.of(context)!;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final safeId = luggage.id.isNotEmpty ? luggage.id.substring(0, 8) : 'KYRADI';
      final filename = 'kyradi_invoice_$safeId.pdf';
      final file = File('${dir.path}/$filename');
      final date = DateFormat('dd.MM.yyyy HH:mm').format(luggage.createdAt);
      final total = luggage.totalPrice == null ? '-' : '${luggage.totalPrice} ₺';
      final customer = (_customerName ?? '').isNotEmpty
          ? _customerName!
          : loc.invoiceCustomerFallback;
      final email = (_customerEmail ?? '').isNotEmpty ? _customerEmail! : '-';
      final paymentMethod = _paymentMethodLabel(loc, luggage);
      final paymentStatus = _paymentStatusLabel(loc, luggage.paymentStatus);
      final location = luggage.dropLocationName.isNotEmpty
          ? luggage.dropLocationName
          : luggage.dropLocationId;
      final doc = pw.Document();
      doc.addPage(
        pw.Page(
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromInt(0xFF111827),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(16)),
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'KYRADI',
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFFFFFFF),
                              fontSize: 20,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            loc.invoiceTitle,
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFCBD5F5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      pw.Text(
                        '#$safeId',
                        style: pw.TextStyle(
                          color: PdfColor.fromInt(0xFFFFFFFF),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                pw.SizedBox(height: 16),
                _pdfRow(loc.invoiceDateLabel, date),
                _pdfRow(loc.invoiceCustomerLabel, customer),
                _pdfRow(loc.invoiceEmailLabel, email),
                _pdfRow(loc.invoiceLocationLabel, location),
                pw.Divider(),
                _pdfRow(loc.invoiceItemLabel, loc.invoiceItemTitle),
                _pdfRow(loc.invoiceItemDesc, loc.invoiceItemSubtitle),
                _pdfRow(loc.invoicePaymentMethodLabel, paymentMethod),
                _pdfRow(loc.invoicePaymentStatusLabel, paymentStatus),
                _pdfRow(loc.invoiceAmountLabel, total),
                _pdfRow(loc.invoiceVatLabel, loc.invoiceVatValue),
                pw.Divider(),
                _pdfRow(loc.invoiceTotalLabel, total, bold: true),
                pw.SizedBox(height: 16),
                pw.Text(
                  loc.invoiceFooterNote,
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromInt(0xFF6B7280),
                  ),
                ),
              ],
            );
          },
        ),
      );
      await file.writeAsBytes(await doc.save());
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.invoiceSavedMessage(filename),
        type: AppNotificationType.success,
      );
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.invoiceSaveFailedMessage,
        type: AppNotificationType.error,
      );
    }
  }
}

pw.Widget _pdfRow(String label, String value, {bool bold = false}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 4),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: 11,
            color: PdfColor.fromInt(0xFF6B7280),
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: bold ? 12 : 11,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    ),
  );
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

String _paymentStatusLabel(AppLocalizations loc, String? status) {
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
      return loc.paymentStatusUnknown;
  }
}

String _paymentMethodLabel(AppLocalizations loc, LuggageModel luggage) {
  if (luggage.walletPayment) {
    return loc.paymentMethodWalletShort;
  }
  final method = luggage.paymentMethod;
  switch (method) {
    case 'card':
    case 'credit_card':
      return loc.paymentMethodCard;
    case 'installment':
      return loc.paymentMethodInstallment;
    case 'pay_at_hotel':
    case 'hotel':
      return loc.paymentMethodPayAtHotel;
    default:
      return loc.paymentMethodUnknown;
  }
}

String _sizeLabel(AppLocalizations loc, String? size) {
  switch (size) {
    case 'small':
      return loc.small;
    case 'medium':
      return loc.medium;
    case 'large':
      return loc.large;
    default:
      return size?.isNotEmpty == true ? size! : '-';
  }
}

String _colorLabel(AppLocalizations loc, String? color) {
  switch (color) {
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
    case 'other':
      return loc.other;
    default:
      return color?.isNotEmpty == true ? color! : '-';
  }
}

String _formatDateTime(DateTime date, BuildContext context) {
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.isEmpty ? '-' : value,
              textAlign: TextAlign.right,
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

class _InvoiceSheet extends StatelessWidget {
  const _InvoiceSheet({
    required this.luggage,
    required this.loc,
    required this.customerName,
    required this.customerEmail,
    required this.onDownload,
  });

  final LuggageModel luggage;
  final AppLocalizations loc;
  final String? customerName;
  final String? customerEmail;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final invoiceNo = luggage.id.isNotEmpty
        ? luggage.id.substring(0, luggage.id.length > 8 ? 8 : luggage.id.length)
        : 'KYRADI';
    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.86,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF111827), Color(0xFF1E40AF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'KYRADI',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        loc.invoiceTitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                SectionCard(
                  child: Column(
                    children: [
                      _InfoRow(
                        label: loc.invoiceNumberLabel,
                        value: invoiceNo,
                      ),
                      _InfoRow(
                        label: loc.invoiceDateLabel,
                        value: _formatDateTime(luggage.createdAt, context),
                      ),
                      _InfoRow(
                        label: loc.invoiceCustomerLabel,
                        value: (customerName ?? '').isNotEmpty
                            ? customerName!
                            : loc.invoiceCustomerFallback,
                      ),
                      _InfoRow(
                        label: loc.invoiceEmailLabel,
                        value: (customerEmail ?? '').isNotEmpty
                            ? customerEmail!
                            : '-',
                      ),
                      _InfoRow(
                        label: loc.invoiceLocationLabel,
                        value: luggage.dropLocationName.isNotEmpty
                            ? luggage.dropLocationName
                            : luggage.dropLocationId,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  child: Column(
                    children: [
                      _InfoRow(
                        label: loc.invoiceItemLabel,
                        value: loc.invoiceItemTitle,
                      ),
                      _InfoRow(
                        label: loc.invoiceItemDesc,
                        value: loc.invoiceItemSubtitle,
                      ),
                      _InfoRow(
                        label: loc.invoicePaymentMethodLabel,
                        value: _paymentMethodLabel(loc, luggage),
                      ),
                      _InfoRow(
                        label: loc.invoicePaymentStatusLabel,
                        value: _paymentStatusLabel(loc, luggage.paymentStatus),
                      ),
                      _InfoRow(
                        label: loc.invoiceAmountLabel,
                        value: luggage.totalPrice == null
                            ? '-'
                            : '${luggage.totalPrice} ₺',
                      ),
                      _InfoRow(
                        label: loc.invoiceVatLabel,
                        value: loc.invoiceVatValue,
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        label: loc.invoiceTotalLabel,
                        value: luggage.totalPrice == null
                            ? '-'
                            : '${luggage.totalPrice} ₺',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: onDownload,
                  icon: const Icon(Icons.download_rounded),
                  label: Text(loc.invoiceDownloadAction),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.invoiceFooterNote,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(loc.closeAction),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
