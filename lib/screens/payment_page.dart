import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/pricing_models.dart';
import '../l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.userId,
    required this.reservationId,
    required this.paymentMethod,
    required this.totalPrice,
    required this.sizeLabel,
    required this.dropAt,
    required this.pickupAt,
    required this.locationId,
  });

  final String userId;
  final String reservationId;
  final String paymentMethod;
  final int totalPrice;
  final String sizeLabel;
  final DateTime? dropAt;
  final DateTime? pickupAt;
  final String locationId;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _cardNumberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();
  bool _loading = false;
  bool _loadingQuote = false;
  PricingQuoteResponse? _quote;
  String? _quoteError;

  late String _paymentMethod;
  late String _protectionLevel;
  int _installmentCount = 3;

  @override
  void initState() {
    super.initState();
    _paymentMethod = widget.paymentMethod.isNotEmpty ? widget.paymentMethod : 'card';
    _protectionLevel = 'standard';
    _fetchQuote();
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvcCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchQuote() async {
    if (widget.dropAt == null || widget.pickupAt == null) {
      setState(() {
        _quote = null;
        _quoteError = null;
        _loadingQuote = false;
      });
      return;
    }
    final loc = AppLocalizations.of(context)!;
    if (!widget.pickupAt!.isAfter(widget.dropAt!)) {
      setState(() {
        _quote = null;
        _quoteError = loc.pricingInvalidRangeMessage;
      });
      return;
    }
    try {
      setState(() => _loadingQuote = true);
      final sizeClass = _sizeClassValue(widget.sizeLabel);
      final baseUrl = ApiService.apiBaseUrl;
      final uri = baseUrl.isNotEmpty
          ? Uri.parse('$baseUrl/pricing/quote').replace(queryParameters: {
              'sizeClass': sizeClass,
              'startAt': widget.dropAt!.toUtc().toIso8601String(),
              'endAt': widget.pickupAt!.toUtc().toIso8601String(),
              if (_protectionLevel.isNotEmpty) 'protectionLevel': _protectionLevel,
            })
          : null;
      final quote = await ApiService.getPricingQuote(
        sizeClass: sizeClass,
        startAt: widget.dropAt!,
        endAt: widget.pickupAt!,
        protectionLevel: _protectionLevel,
      );
      if (!mounted) return;
      setState(() {
        _quote = quote;
        _quoteError = null;
        _loadingQuote = false;
      });
      if (uri != null) {
        print(
          '[QUOTE] url=$uri response={priceTry:${quote.priceTry}, tier:${quote.tier}}',
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _quote = null;
        _quoteError = loc.pricingQuoteFailedMessage;
        _loadingQuote = false;
      });
    }
  }

  Future<void> _completePayment() async {
    final loc = AppLocalizations.of(context)!;
    if (_paymentMethod != 'pay_at_hotel') {
      if (_cardNumberCtrl.text.trim().length < 12 ||
          _nameCtrl.text.trim().isEmpty ||
          _expiryCtrl.text.trim().isEmpty ||
          _cvcCtrl.text.trim().length < 3) {
        _showError(loc.paymentFormIncompleteMessage);
        return;
      }
    }
    setState(() => _loading = true);
    try {
      final checkout = await ApiService.startPaymentCheckout(
        reservationId: widget.reservationId,
        paymentMethod: _paymentMethod,
        installmentCount: _paymentMethod == 'installment' ? _installmentCount : null,
        sizeClass: _sizeClassValue(widget.sizeLabel),
        startAt: widget.dropAt,
        endAt: widget.pickupAt,
      );
      if (checkout['ok'] != true) {
        final msg = (checkout['error'] ?? checkout['message'] ?? '').toString().trim();
        if (!mounted) return;
        setState(() => _loading = false);
        _showError(msg.isNotEmpty ? msg : loc.paymentFailedMessage);
        return;
      }
      final quotePrice = checkout['priceTry'];
      if (quotePrice is num && mounted) {
        setState(() {
          _quote = PricingQuoteResponse(
            durationHours: _quote?.durationHours ?? 0,
            tier: (checkout['tier'] ?? _quote?.tier ?? '').toString(),
            priceTry: quotePrice.round(),
            daysCharged: _quote?.daysCharged,
            breakdown: _quote?.breakdown ?? const {},
          );
        });
      }
      final providerPaymentId =
          (checkout['providerPaymentId'] ?? '').toString().trim();
      if (providerPaymentId.isEmpty) {
        if (!mounted) return;
        setState(() => _loading = false);
        _showError(loc.paymentFailedMessage);
        return;
      }
      if (_paymentMethod == 'pay_at_hotel') {
        if (!mounted) return;
        setState(() => _loading = false);
        Navigator.of(context).pop({
          'completed': false,
          'paymentMethod': _paymentMethod,
        });
        return;
      }
      final result = await ApiService.sendPaymentWebhook(
        providerPaymentId: providerPaymentId,
        status: 'success',
      );
      if (!mounted) return;
      setState(() => _loading = false);
      if (result['ok'] == true) {
        Navigator.of(context).pop({
          'completed': true,
          'paymentMethod': _paymentMethod,
        });
      } else {
        final msg =
            (result['error'] ?? result['message'] ?? '').toString().trim();
        _showError(msg.isNotEmpty ? msg : loc.paymentFailedMessage);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showError(loc.paymentFailedMessage);
    }
  }

  Future<void> _openEditReservation() async {
    if (widget.userId.isEmpty) return;
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ReservationEditPage(
          userId: widget.userId,
          reservationId: widget.reservationId,
          initialSize: widget.sizeLabel,
          initialDropAt: widget.dropAt,
          initialPickupAt: widget.pickupAt,
        ),
      ),
    );
    if (result == true && mounted) {
      await _fetchQuote();
      setState(() {});
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final quotePrice = _quote?.priceTry ?? widget.totalPrice;
    final priceLabel = _quoteError != null
        ? loc.pricingQuoteFailedMessage
        : loc.paymentTotalLabel(_formatPrice(quotePrice));
    final canSubmit = !_loading && _quoteError == null && !_loadingQuote;

    return Scaffold(
      appBar: AppBar(title: Text(loc.paymentPageTitle)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuoteSummaryCard(theme, loc, quotePrice),
                      const SizedBox(height: 16),
                      _buildProtectionSection(loc, theme),
                      const SizedBox(height: 12),
                      _buildPaymentMethodSection(loc, theme),
                      const SizedBox(height: 16),
                      if (_paymentMethod == 'pay_at_hotel') ...[
                        Text(
                          loc.paymentPayAtHotelTitle,
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(loc.paymentPayAtHotelBody),
                        const SizedBox(height: 16),
                      ] else ...[
                        Text(
                          loc.paymentPageSubtitle,
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _cardNumberCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: loc.paymentCardNumberLabel,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _nameCtrl,
                          decoration: InputDecoration(
                            labelText: loc.paymentCardNameLabel,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _expiryCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: loc.paymentExpiryLabel,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: TextField(
                                controller: _cvcCtrl,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: loc.paymentCvcLabel,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          priceLabel,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (_quoteError != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(
                              loc.pricingQuoteFailedMessage,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: FilledButton(
          onPressed: canSubmit ? _completePayment : null,
          child: _loading
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(loc.paymentCompleteAction),
        ),
      ),
    );
  }

  Widget _buildProtectionSection(AppLocalizations loc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.protectionLevelTitle, style: theme.textTheme.titleSmall),
        RadioListTile<String>(
          value: 'standard',
          groupValue: _protectionLevel,
          onChanged: (value) {
            setState(() => _protectionLevel = value ?? 'standard');
            _fetchQuote();
          },
          title: Text(loc.protectionStandard),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'premium',
          groupValue: _protectionLevel,
          onChanged: (value) {
            setState(() => _protectionLevel = value ?? 'premium');
            _fetchQuote();
          },
          title: Text(loc.protectionPremium),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(AppLocalizations loc, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.paymentMethodTitle, style: theme.textTheme.titleSmall),
        RadioListTile<String>(
          value: 'card',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 'card');
          },
          title: Text(loc.paymentMethodCard),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'installment',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 'installment');
          },
          title: Text(loc.paymentMethodInstallment),
          contentPadding: EdgeInsets.zero,
        ),
        if (_paymentMethod == 'installment')
          DropdownButtonFormField<int>(
            value: _installmentCount,
            decoration: InputDecoration(labelText: loc.installmentCountLabel),
            items: [2, 3, 6, 9, 12]
                .map(
                  (v) => DropdownMenuItem(
                    value: v,
                    child: Text('$v'),
                  ),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _installmentCount = value);
            },
          ),
        RadioListTile<String>(
          value: 'pay_at_hotel',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 'pay_at_hotel');
          },
          title: Text(loc.paymentMethodPayAtHotel),
          contentPadding: EdgeInsets.zero,
        ),
        if (_paymentMethod == 'pay_at_hotel')
          Padding(
            padding: const EdgeInsets.only(left: 8, bottom: 8),
            child: Text(
              loc.paymentHotelCommissionNote,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }

  String _formatPrice(int value) {
    return NumberFormat.decimalPattern().format(value);
  }

  Widget _buildQuoteSummaryCard(
    ThemeData theme,
    AppLocalizations loc,
    int quotePrice,
  ) {
    final sizeLabel = _displaySizeLabel(loc);
    final tierLabel = _quote != null
        ? _formatTierLabel(_quote!, loc)
        : _formatSelectedTimes(loc);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    loc.pricingSummaryTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _openEditReservation,
                  child: Text(loc.pricingSummaryEdit),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_loadingQuote)
              const LinearProgressIndicator(minHeight: 4)
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${loc.pricingSummarySizeLabel}: $sizeLabel'),
                  Text('${loc.pricingSummaryDurationLabel}: $tierLabel'),
                  Text(
                    '${loc.pricingSummaryAmountLabel}: ${_formatPrice(quotePrice)} ₺',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _displaySizeLabel(AppLocalizations loc) {
    final normalized = widget.sizeLabel.trim().toLowerCase();
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
        return widget.sizeLabel;
    }
  }

  String _formatSelectedTimes(AppLocalizations loc) {
    final drop = widget.dropAt;
    final pickup = widget.pickupAt;
    if (drop == null || pickup == null) {
      return loc.pricingEstimateUnavailable;
    }
    final dropLabel = loc.dropTimeLabel(_formatDateTime(drop));
    final pickupLabel = loc.pickupTimeLabel(_formatDateTime(pickup));
    return '$dropLabel • $pickupLabel';
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime.toLocal());
  }

  String _formatTierLabel(PricingQuoteResponse quote, AppLocalizations loc) {
    switch (quote.tier) {
      case '0_6':
        return loc.pricingTier0To6;
      case '6_24':
        return loc.pricingTier6To24;
      case 'daily':
        final days = quote.daysCharged ?? 1;
        return loc.pricingTierDaily(days);
      default:
        return quote.tier;
    }
  }

  String _sizeClassValue(String label) {
    switch (label) {
      case 'Küçük':
        return 'small';
      case 'Büyük':
        return 'large';
      case 'Orta':
      default:
        return 'medium';
    }
  }
}

class ReservationEditPage extends StatefulWidget {
  const ReservationEditPage({
    super.key,
    required this.userId,
    required this.reservationId,
    required this.initialSize,
    required this.initialDropAt,
    required this.initialPickupAt,
  });

  final String userId;
  final String reservationId;
  final String initialSize;
  final DateTime? initialDropAt;
  final DateTime? initialPickupAt;

  @override
  State<ReservationEditPage> createState() => _ReservationEditPageState();
}

class _ReservationEditPageState extends State<ReservationEditPage> {
  late String _size;
  DateTime? _dropAt;
  DateTime? _pickupAt;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _size = widget.initialSize.isNotEmpty ? widget.initialSize : 'Orta';
    _dropAt = widget.initialDropAt;
    _pickupAt = widget.initialPickupAt;
  }

  Future<DateTime?> _pickDateTime(DateTime? initial, String helpText) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: (initial ?? now).toLocal(),
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365)),
      helpText: helpText,
    );
    if (date == null) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime((initial ?? now).toLocal()),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context)!;
    if (_dropAt == null || _pickupAt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.scheduleTimesRequired)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final result = await ApiService.updateLuggageMetadata(
        widget.userId,
        widget.reservationId,
        {
          'size': _size,
          'scheduledDropTime': _dropAt,
          'scheduledPickupTime': _pickupAt,
        },
      );
      if (!mounted) return;
      setState(() => _saving = false);
      if (result['ok'] == true) {
        Navigator.of(context).pop(true);
      } else {
        final msg = (result['error'] ?? result['message'] ?? '').toString().trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.isNotEmpty ? msg : loc.operationFailed)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.operationFailedWithDetails('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final dropLabel = _dropAt == null
        ? loc.dropTimePending
        : loc.dropTimeLabel(_formatDateTime(_dropAt));
    final pickupLabel = _pickupAt == null
        ? loc.pickupTimePending
        : loc.pickupTimeLabel(_formatDateTime(_pickupAt));

    return Scaffold(
      appBar: AppBar(title: Text(loc.reservationEditTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _size,
                items: ['Küçük', 'Orta', 'Büyük']
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_localizedSizeLabel(value, loc)),
                      ),
                    )
                    .toList(),
                onChanged: _saving ? null : (value) => setState(() => _size = value ?? 'Orta'),
                decoration: InputDecoration(
                  labelText: loc.size,
                  prefixIcon: const Icon(Icons.luggage_outlined),
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_available_rounded),
                title: Text(dropLabel),
                onTap: _saving
                    ? null
                    : () async {
                        final selected =
                            await _pickDateTime(_dropAt, loc.dropDatePickerHelp);
                        if (selected != null) {
                          setState(() => _dropAt = selected);
                        }
                      },
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.event_available_rounded),
                title: Text(pickupLabel),
                onTap: _saving
                    ? null
                    : () async {
                        final selected = await _pickDateTime(
                          _pickupAt,
                          loc.pickupDatePickerHelp,
                        );
                        if (selected != null) {
                          setState(() => _pickupAt = selected);
                        }
                      },
              ),
              const Spacer(),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(loc.save),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime.toLocal());
  }

  String _localizedSizeLabel(String value, AppLocalizations loc) {
    switch (value.toLowerCase()) {
      case 'küçük':
      case 'kucuk':
        return loc.small;
      case 'orta':
        return loc.medium;
      case 'büyük':
      case 'buyuk':
        return loc.large;
      default:
        return value;
    }
  }
}
