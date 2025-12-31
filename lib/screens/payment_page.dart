import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/pricing_models.dart';
import '../l10n/app_localizations.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.reservationId,
    required this.paymentMethod,
    required this.totalPrice,
    required this.sizeLabel,
    required this.dropAt,
    required this.pickupAt,
    required this.locationId,
  });

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
  Timer? _estimateDebounce;
  PricingEstimateResponse? _estimate;
  String? _estimateError;

  late String _paymentMethod;
  late String _protectionLevel;
  int _installmentCount = 3;

  @override
  void initState() {
    super.initState();
    _paymentMethod = widget.paymentMethod.isNotEmpty ? widget.paymentMethod : 'card';
    _protectionLevel = 'standard';
    _fetchEstimate();
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvcCtrl.dispose();
    _estimateDebounce?.cancel();
    super.dispose();
  }

  void _scheduleEstimate() {
    _estimateDebounce?.cancel();
    _estimateDebounce = Timer(const Duration(milliseconds: 350), _fetchEstimate);
  }

  Future<void> _fetchEstimate() async {
    final loc = AppLocalizations.of(context)!;
    if (widget.dropAt == null || widget.pickupAt == null) {
      setState(() {
        _estimate = null;
        _estimateError = loc.pricingEstimateUnavailable;
      });
      return;
    }
    try {
      final req = PricingEstimateRequest(
        sizeClass: _sizeClassValue(widget.sizeLabel),
        dropAt: widget.dropAt!,
        pickupAt: widget.pickupAt!,
        protectionLevel: _protectionLevel,
        paymentMethod: _paymentMethod,
        installmentCount: _paymentMethod == 'installment' ? _installmentCount : null,
        locationId: widget.locationId,
      );
      final estimate = await ApiService.estimatePricing(req);
      if (!mounted) return;
      setState(() {
        _estimate = estimate;
        _estimateError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _estimate = null;
        _estimateError = e.toString();
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
      );
      if (checkout['ok'] != true) {
        final msg = (checkout['error'] ?? checkout['message'] ?? '').toString().trim();
        if (!mounted) return;
        setState(() => _loading = false);
        _showError(msg.isNotEmpty ? msg : loc.paymentFailedMessage);
        return;
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final total = _estimate?.total ?? widget.totalPrice;
    final priceLabel = loc.paymentTotalLabel(_formatPrice(total));

    return Scaffold(
      appBar: AppBar(title: Text(loc.paymentPageTitle)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
            const Spacer(),
            _buildEstimate(theme, loc),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _completePayment,
              child: _loading
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.paymentCompleteAction),
            ),
          ],
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
            _scheduleEstimate();
          },
          title: Text(loc.protectionStandard),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'premium',
          groupValue: _protectionLevel,
          onChanged: (value) {
            setState(() => _protectionLevel = value ?? 'premium');
            _scheduleEstimate();
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
            _scheduleEstimate();
          },
          title: Text(loc.paymentMethodCard),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'installment',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 'installment');
            _scheduleEstimate();
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
              _scheduleEstimate();
            },
          ),
        RadioListTile<String>(
          value: 'pay_at_hotel',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 'pay_at_hotel');
            _scheduleEstimate();
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

  Widget _buildEstimate(ThemeData theme, AppLocalizations loc) {
    if (_estimateError != null && _estimate == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          _estimateError ?? '',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.error,
          ),
        ),
      );
    }
    final estimate = _estimate;
    if (estimate == null) {
      return const SizedBox.shrink();
    }
    int valueFor(String key) {
      final raw = estimate.breakdown[key];
      if (raw is num) return raw.round();
      if (raw is String) return int.tryParse(raw) ?? 0;
      return 0;
    }

    String row(String label, int value) {
      final formatted = _formatPrice(value);
      return '$label: $formatted ₺';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.pricingEstimateTitle, style: theme.textTheme.titleSmall),
        const SizedBox(height: 8),
        Text(row(loc.pricingBasePriceLabel, valueFor('basePrice'))),
        Text(row(loc.pricingPremiumFeeLabel, valueFor('premiumProtectionFee'))),
        Text(row(loc.pricingHotelCommissionLabel, valueFor('hotelCommissionFee'))),
        Text(row(loc.pricingInstallmentFeeLabel, valueFor('installmentFee'))),
        const SizedBox(height: 6),
        Text(
          '${loc.pricingTotalLabel}: ${_formatPrice(estimate.total)} ₺',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  String _formatPrice(int value) {
    return NumberFormat.decimalPattern().format(value);
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
