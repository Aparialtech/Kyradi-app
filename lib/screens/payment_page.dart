// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../core/payment_method_prefs.dart';
import '../services/api_service.dart';
import '../services/local_notification_service.dart';
import '../models/pricing_models.dart';
import '../l10n/app_localizations.dart';
import 'payment_result_page.dart';
import '../utils/crash_log.dart';
import '../widgets/section_card.dart';
import '../widgets/app_mesh_background.dart';

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
  static const int _premiumFee = 15;

  final _cardNumberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvcCtrl = TextEditingController();
  final _cardNumberFocus = FocusNode();
  final _nameFocus = FocusNode();
  final _expiryFocus = FocusNode();
  final _cvcFocus = FocusNode();
  bool _loading = false;
  bool _loadingQuote = false;
  PricingQuoteResponse? _quote;
  String? _quoteError;
  Future<PricingQuoteResponse?>? _quoteFuture;
  int? _basePriceValue;
  int? _totalPriceValue;
  double _walletBalance = 0;
  PaymentMethodAvailability _methodAvailability =
      const PaymentMethodAvailability.defaults();

  late String _paymentMethod;
  late String _protectionLevel;
  late String _sizeLabel;
  DateTime? _dropAt;
  DateTime? _pickupAt;
  int _installmentCount = 3;

  @override
  void initState() {
    super.initState();
    _paymentMethod = widget.paymentMethod.isNotEmpty
        ? widget.paymentMethod
        : 'card';
    _protectionLevel = 'standard';
    _sizeLabel = widget.sizeLabel.isNotEmpty ? widget.sizeLabel : 'Orta';
    _dropAt = widget.dropAt;
    _pickupAt = widget.pickupAt;
    if (_dropAt != null && _pickupAt != null) {
      _loadingQuote = true;
      _quoteError = null;
      _quoteFuture = _fetchQuote();
    }
    _loadWalletBalance();
    _loadPaymentMethods();
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvcCtrl.dispose();
    _cardNumberFocus.dispose();
    _nameFocus.dispose();
    _expiryFocus.dispose();
    _cvcFocus.dispose();
    super.dispose();
  }

  Future<void> _loadWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final balance = prefs.getDouble('wallet_balance') ?? 0;
    if (!mounted) return;
    setState(() => _walletBalance = balance);
  }

  Future<void> _loadPaymentMethods() async {
    final methods = await PaymentMethodPrefs.load();
    if (!mounted) return;
    setState(() {
      _methodAvailability = methods;
      _paymentMethod = _fallbackPaymentMethod(_paymentMethod);
    });
  }

  bool _isMethodEnabled(String method) {
    if (method == 'card' || method == 'installment') {
      return _methodAvailability.cardEnabled;
    }
    if (method == 'pay_at_hotel') {
      return _methodAvailability.hotelPayEnabled;
    }
    return true;
  }

  String _fallbackPaymentMethod(String current) {
    if (_isMethodEnabled(current)) return current;
    if (_isMethodEnabled('wallet')) return 'wallet';
    if (_isMethodEnabled('card')) return 'card';
    if (_isMethodEnabled('pay_at_hotel')) return 'pay_at_hotel';
    return current;
  }

  Future<PricingQuoteResponse?> _fetchQuote() async {
    if (!mounted) return null;
    if (_dropAt == null || _pickupAt == null) {
      setState(() {
        _quote = null;
        _quoteError = null;
        _loadingQuote = false;
      });
      return null;
    }
    final loc = AppLocalizations.of(context)!;
    if (!_pickupAt!.isAfter(_dropAt!)) {
      setState(() {
        _quote = null;
        _quoteError = loc.pricingInvalidRangeMessage;
      });
      return null;
    }
    try {
      setState(() => _loadingQuote = true);
      final sizeClass = _sizeClassValue(_sizeLabel);
      final baseUrl = ApiService.apiBaseUrl;
      final uri = baseUrl.isNotEmpty
          ? Uri.parse('$baseUrl/pricing/quote').replace(
              queryParameters: {
                'sizeClass': sizeClass,
                'startAt': _dropAt!.toUtc().toIso8601String(),
                'endAt': _pickupAt!.toUtc().toIso8601String(),
                if (_protectionLevel.isNotEmpty)
                  'protectionLevel': _protectionLevel,
              },
            )
          : null;
      if (kDebugMode) {
        appLog(
          'pay_quote',
          'start url=${uri?.toString() ?? 'unset'}',
          level: AppLogLevel.debug,
        );
      }
      final quote = await ApiService.getPricingQuote(
        sizeClass: sizeClass,
        startAt: _dropAt!,
        endAt: _pickupAt!,
        protectionLevel: _protectionLevel,
      );
      if (!mounted) return null;
      setState(() {
        _quote = quote;
        _quoteError = null;
        _basePriceValue = _basePriceFromQuote(quote);
        _totalPriceValue =
            (_basePriceValue ?? 0) +
            (_protectionLevel == 'premium' ? _premiumFee : 0);
      });
      final basePrice = _basePriceFromQuote(quote);
      if (kDebugMode) {
        appLog(
          'pay_quote',
          'done status=200 body={priceTry:${quote.priceTry}, tier:${quote.tier}, base:$basePrice}',
          level: AppLogLevel.debug,
        );
      }
      return quote;
    } catch (e) {
      if (!mounted) return null;
      setState(() {
        _quote = null;
        _quoteError = 'Fiyat hesaplanamadı, tekrar dene';
      });
      if (kDebugMode) {
        appLog('pay_quote', 'error $e', level: AppLogLevel.debug);
      }
      return null;
    } finally {
      if (mounted) {
        setState(() => _loadingQuote = false);
      }
    }
  }

  Future<void> _completePayment() async {
    final loc = AppLocalizations.of(context)!;
    if (!_isMethodEnabled(_paymentMethod)) {
      _showError('Seçilen ödeme yöntemi profil ayarlarında kapalı.');
      return;
    }
    if (_paymentMethod != 'pay_at_hotel' && _paymentMethod != 'wallet') {
      final cardDigits = _digitsOnly(_cardNumberCtrl.text);
      final name = _nameCtrl.text.trim();
      final expiry = _expiryCtrl.text.trim();
      final cvv = _digitsOnly(_cvcCtrl.text);

      if (cardDigits.isEmpty || name.isEmpty || expiry.isEmpty || cvv.isEmpty) {
        _showError(loc.paymentFormIncompleteMessage);
        return;
      }
      if (cardDigits.length != 16) {
        _showError(loc.paymentCardNumberInvalidMessage);
        return;
      }
      if (!_isValidExpiry(expiry)) {
        _showError(loc.paymentExpiryInvalidMessage);
        return;
      }
      if (cvv.length < 3 || cvv.length > 4) {
        _showError(loc.paymentCvvInvalidMessage);
        return;
      }
    }
    final amount = _totalPrice();
    if (amount <= 0) {
      _showError(loc.paymentFailedMessage);
      return;
    }
    if (_paymentMethod == 'wallet') {
      if (_walletBalance < amount) {
        _showWalletInsufficient(loc, amount);
        return;
      }
    }
    setState(() => _loading = true);
    try {
      final result = await ApiService.mockPayment(
        amount: amount,
        currency: 'TRY',
        protectionLevel: _protectionLevel,
        bookingId: widget.reservationId,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      final ok = result['ok'] == true || result['status'] == 'success';
      if (!ok) {
        final msg = (result['error'] ?? result['message'] ?? '')
            .toString()
            .trim();
        _showError(msg.isNotEmpty ? msg : loc.paymentFailedMessage);
        return;
      }
      _cardNumberCtrl.clear();
      _nameCtrl.clear();
      _expiryCtrl.clear();
      _cvcCtrl.clear();
      await LocalNotificationService.instance.showPaymentSuccess(
        reservationLabel: widget.reservationId,
        amountTry: amount,
      );
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => PaymentResultPage(
            success: true,
            amount: amount,
            paymentId: result['paymentId']?.toString(),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _showError('Bağlantı hatası');
    }
  }

  Future<void> _openEditReservation() async {
    if (widget.userId.isEmpty) return;
    final result = await Navigator.of(context).push<Map<String, dynamic>?>(
      MaterialPageRoute(
        builder: (_) => ReservationEditPage(
          userId: widget.userId,
          reservationId: widget.reservationId,
          initialSize: _sizeLabel,
          initialDropAt: _dropAt,
          initialPickupAt: _pickupAt,
        ),
      ),
    );
    if (result != null && mounted) {
      if (result['size'] is String) {
        _sizeLabel = result['size'] as String;
      }
      _dropAt = result['dropAt'] as DateTime?;
      _pickupAt = result['pickupAt'] as DateTime?;
      await _fetchQuote();
      if (!mounted) return;
      setState(() {});
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final quotePrice = _totalPrice();
    final priceLabel = _quoteError != null
        ? loc.pricingQuoteFailedMessage
        : loc.paymentTotalLabel(_formatPrice(quotePrice));
    final canSubmit = !_loading && _quoteError == null && !_loadingQuote;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.paymentPageTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildQuoteSummaryCard(theme, loc, quotePrice),
                      const SizedBox(height: 16),
                      SectionCard(
                        backgroundColor: theme.colorScheme.surface.withValues(
                          alpha: 0.95,
                        ),
                        child: _buildProtectionSection(loc, theme),
                      ),
                      const SizedBox(height: 12),
                      SectionCard(
                        backgroundColor: theme.colorScheme.surface.withValues(
                          alpha: 0.95,
                        ),
                        child: _buildPaymentMethodSection(loc, theme),
                      ),
                      const SizedBox(height: 16),
                      if (_paymentMethod == 'pay_at_hotel') ...[
                        SectionCard(
                          backgroundColor: theme.colorScheme.surface.withValues(
                            alpha: 0.92,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.paymentPayAtHotelTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Text(loc.paymentPayAtHotelBody),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        SectionCard(
                          backgroundColor: theme.colorScheme.surface.withValues(
                            alpha: 0.95,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.paymentPageSubtitle,
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  _CardBrandPill(
                                    label: 'VISA',
                                    color: const Color(0xFF1A1F71),
                                  ),
                                  const SizedBox(width: 8),
                                  _CardBrandPill(
                                    label: 'MC',
                                    color: const Color(0xFFEB001B),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _cardNumberCtrl,
                                focusNode: _cardNumberFocus,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                maxLength: 19,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CardNumberInputFormatter(),
                                ],
                                decoration: InputDecoration(
                                  labelText: loc.paymentCardNumberLabel,
                                  hintText: '1234 5678 9012 3456',
                                  prefixIcon: const Icon(
                                    Icons.credit_card_outlined,
                                  ),
                                ),
                                onSubmitted: (_) => _nameFocus.requestFocus(),
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _nameCtrl,
                                focusNode: _nameFocus,
                                textCapitalization:
                                    TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r"[A-Za-zÀ-ÖØ-öø-ÿ\s]"),
                                  ),
                                  UpperCaseTextFormatter(),
                                ],
                                decoration: InputDecoration(
                                  labelText: loc.paymentCardNameLabel,
                                  hintText: 'AD SOYAD',
                                  prefixIcon: const Icon(Icons.person_outline),
                                ),
                                onSubmitted: (_) => _expiryFocus.requestFocus(),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _expiryCtrl,
                                      focusNode: _expiryFocus,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.next,
                                      maxLength: 5,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        ExpiryDateInputFormatter(),
                                      ],
                                      decoration: InputDecoration(
                                        labelText: loc.paymentExpiryLabel,
                                        hintText: 'MM/YY',
                                        prefixIcon: const Icon(
                                          Icons.calendar_today_outlined,
                                        ),
                                      ),
                                      onSubmitted: (_) =>
                                          _cvcFocus.requestFocus(),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextField(
                                      controller: _cvcCtrl,
                                      focusNode: _cvcFocus,
                                      keyboardType: TextInputType.number,
                                      textInputAction: TextInputAction.done,
                                      maxLength: 4,
                                      obscureText: true,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      decoration: InputDecoration(
                                        labelText: loc.paymentCvcLabel,
                                        hintText: 'CVV',
                                        prefixIcon: const Icon(
                                          Icons.lock_outline,
                                        ),
                                      ),
                                      onSubmitted: (_) => _completePayment(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  loc.paymentDemoBadge,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: canSubmit ? _completePayment : null,
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
            setState(() {
              _protectionLevel = value ?? 'standard';
              _quoteFuture = _fetchQuote();
              _totalPriceValue =
                  _basePrice() +
                  (_protectionLevel == 'premium' ? _premiumFee : 0);
            });
            if (kDebugMode) {
              appLog(
                'price',
                'level=$_protectionLevel base=${_basePrice()} premiumFee=${_premiumFeeValue()} total=${_totalPrice()}',
                level: AppLogLevel.debug,
              );
            }
          },
          title: Text(loc.protectionStandard),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'premium',
          groupValue: _protectionLevel,
          onChanged: (value) {
            setState(() {
              _protectionLevel = value ?? 'premium';
              _quoteFuture = _fetchQuote();
              _totalPriceValue =
                  _basePrice() +
                  (_protectionLevel == 'premium' ? _premiumFee : 0);
            });
            if (kDebugMode) {
              appLog(
                'price',
                'level=$_protectionLevel base=${_basePrice()} premiumFee=${_premiumFeeValue()} total=${_totalPrice()}',
                level: AppLogLevel.debug,
              );
            }
          },
          title: Text(loc.protectionPremium),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(AppLocalizations loc, ThemeData theme) {
    final cardMethodsEnabled = _methodAvailability.cardEnabled;
    final hotelEnabled = _methodAvailability.hotelPayEnabled;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(loc.paymentMethodTitle, style: theme.textTheme.titleSmall),
        RadioListTile<String>(
          value: 'wallet',
          groupValue: _paymentMethod,
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 'wallet');
          },
          title: Text(
            loc.paymentMethodWallet(_walletBalance.toStringAsFixed(2)),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'card',
          groupValue: _paymentMethod,
          onChanged: cardMethodsEnabled
              ? (value) {
                  setState(() => _paymentMethod = value ?? 'card');
                }
              : null,
          title: Text(loc.paymentMethodCard),
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          value: 'installment',
          groupValue: _paymentMethod,
          onChanged: cardMethodsEnabled
              ? (value) {
                  setState(() => _paymentMethod = value ?? 'installment');
                }
              : null,
          title: Text(loc.paymentMethodInstallment),
          contentPadding: EdgeInsets.zero,
        ),
        if (_paymentMethod == 'installment')
          DropdownButtonFormField<int>(
            value: _installmentCount,
            decoration: InputDecoration(labelText: loc.installmentCountLabel),
            items: [2, 3, 6, 9, 12]
                .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              setState(() => _installmentCount = value);
            },
          ),
        RadioListTile<String>(
          value: 'pay_at_hotel',
          groupValue: _paymentMethod,
          onChanged: hotelEnabled
              ? (value) {
                  setState(() => _paymentMethod = value ?? 'pay_at_hotel');
                }
              : null,
          title: Text(loc.paymentMethodPayAtHotel),
          contentPadding: EdgeInsets.zero,
        ),
        if (!cardMethodsEnabled || !hotelEnabled)
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            child: Text(
              'Kapalı yöntemleri Profil > Ödeme Yöntemleri alanından açabilirsin.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
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

  void _showWalletInsufficient(AppLocalizations loc, int amount) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                loc.paymentWalletInsufficientTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                loc.paymentWalletInsufficientMessage(
                  _walletBalance.toStringAsFixed(2),
                  amount.toString(),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() => _paymentMethod = 'card');
                      },
                      child: Text(loc.paymentWalletUseCardAction),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        Navigator.pop(context);
                        if (context.mounted) {
                          context.go('/wallet');
                        }
                      },
                      child: Text(loc.paymentWalletTopUpAction),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatPrice(int value) {
    return NumberFormat.decimalPattern().format(value);
  }

  int _basePriceFromQuote(PricingQuoteResponse quote) {
    final unit = quote.breakdown['unitPrice'];
    final days = quote.breakdown['daysCharged'];
    final unitPrice = unit is num ? unit.round() : quote.priceTry;
    final daysCharged = days is num ? days.round() : 1;
    return unitPrice * (daysCharged <= 0 ? 1 : daysCharged);
  }

  int _basePrice() {
    if (_basePriceValue != null) return _basePriceValue!;
    if (_quote != null) return _basePriceFromQuote(_quote!);
    return widget.totalPrice;
  }

  int _premiumFeeValue() {
    return _protectionLevel == 'premium' ? _premiumFee : 0;
  }

  int _totalPrice() {
    if (_totalPriceValue != null) return _totalPriceValue!;
    return _basePrice() + _premiumFeeValue();
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
    final basePrice = _basePrice();
    final premiumFee = _premiumFeeValue();
    final total = _totalPrice();

    return SectionCard(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.95),
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
          FutureBuilder<PricingQuoteResponse?>(
            future: _quoteFuture,
            builder: (context, snapshot) {
              final waiting =
                  _loadingQuote ||
                  snapshot.connectionState == ConnectionState.waiting;
              if (waiting) {
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Row(
                    children: [
                      const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      const SizedBox(width: 8),
                      Text(loc.pricingEstimateLoading),
                    ],
                  ),
                );
              }
              if (_quoteError != null) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _quoteError!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton.icon(
                      onPressed: () {
                        setState(() => _quoteFuture = _fetchQuote());
                      },
                      icon: const Icon(Icons.refresh),
                      label: Text(loc.refreshAction),
                    ),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${loc.pricingSummarySizeLabel}: $sizeLabel'),
                  Text('${loc.pricingSummaryDurationLabel}: $tierLabel'),
                  const SizedBox(height: 6),
                  Text(
                    '${loc.pricingBasePriceLabel}: ${_formatPrice(basePrice)} ₺',
                  ),
                  if (premiumFee > 0)
                    Text(
                      '${loc.pricingPremiumFeeLabel}: +${_formatPrice(premiumFee)} ₺',
                    ),
                  Text(
                    '${loc.pricingSummaryAmountLabel}: ${_formatPrice(total)} ₺',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  String _displaySizeLabel(AppLocalizations loc) {
    final normalized = _sizeLabel.trim().toLowerCase();
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
        return _sizeLabel;
    }
  }

  String _formatSelectedTimes(AppLocalizations loc) {
    final drop = _dropAt;
    final pickup = _pickupAt;
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

  String _digitsOnly(String input) {
    return input.replaceAll(RegExp(r'\D'), '');
  }

  bool _isValidExpiry(String input) {
    final parts = input.split('/');
    if (parts.length != 2) return false;
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? -1;
    if (month < 1 || month > 12) return false;
    if (year < 0) return false;
    return true;
  }
}

class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length && i < 4; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final upper = newValue.text.toUpperCase();
    return TextEditingValue(text: upper, selection: newValue.selection);
  }
}

class _CardBrandPill extends StatelessWidget {
  const _CardBrandPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
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
  static const List<String> _sizeOptions = <String>['small', 'medium', 'large'];

  late String _size;
  DateTime? _dropAt;
  DateTime? _pickupAt;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _size = _normalizeSizeValue(widget.initialSize);
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
    if (!mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime((initial ?? now).toLocal()),
    );
    if (time == null) return null;
    if (!mounted) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<String?> _askReservationChangeOtp() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('E-posta Onayı'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            maxLength: 6,
            decoration: const InputDecoration(
              labelText: '6 haneli doğrulama kodu',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(context).pop(controller.text.trim()),
              child: const Text('Onayla'),
            ),
          ],
        );
      },
    );
    controller.dispose();
    return code;
  }

  Future<void> _save() async {
    final loc = AppLocalizations.of(context)!;
    if (_dropAt == null || _pickupAt == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.scheduleTimesRequired)));
      return;
    }
    setState(() => _saving = true);
    try {
      final request = await ApiService.requestLuggageMetadataChange(
        widget.userId,
        widget.reservationId,
        {
          'size': _size,
          'scheduledDropTime': _dropAt,
          'scheduledPickupTime': _pickupAt,
        },
      );
      if (!mounted) return;
      if (request['ok'] != true) {
        setState(() => _saving = false);
        final msg = (request['error'] ?? request['message'] ?? '')
            .toString()
            .trim();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg.isNotEmpty ? msg : loc.operationFailed)),
        );
        return;
      }

      final otp = await _askReservationChangeOtp();
      if (!mounted) return;
      if (otp == null || otp.isEmpty) {
        setState(() => _saving = false);
        return;
      }

      final result = await ApiService.confirmLuggageMetadataChange(
        widget.userId,
        widget.reservationId,
        otp,
      );
      if (!mounted) return;
      setState(() => _saving = false);
      if (result['ok'] == true) {
        await LocalNotificationService.instance.showGeneric(
          title: 'Rezervasyon Güncellendi',
          body:
              '${widget.reservationId} için tarih/boyut güncellemesi kaydedildi.',
          channelId: 'kyradi_reservations',
          channelName: 'Rezervasyon Bildirimleri',
          channelDescription: 'Rezervasyon değişiklikleri',
        );
        if (!mounted) return;
        Navigator.of(
          context,
        ).pop({'size': _size, 'dropAt': _dropAt, 'pickupAt': _pickupAt});
        return;
      }
      final msg = (result['error'] ?? result['message'] ?? '')
          .toString()
          .trim();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg.isNotEmpty ? msg : loc.operationFailed)),
      );
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
    final dropLabel = _dropAt == null
        ? loc.dropTimePending
        : loc.dropTimeLabel(_formatDateTime(_dropAt));
    final pickupLabel = _pickupAt == null
        ? loc.pickupTimePending
        : loc.pickupTimeLabel(_formatDateTime(_pickupAt));

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.reservationEditTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _size,
                    items: _sizeOptions
                        .map(
                          (value) => DropdownMenuItem(
                            value: value,
                            child: Text(_localizedSizeLabel(value, loc)),
                          ),
                        )
                        .toList(),
                    onChanged: _saving
                        ? null
                        : (value) => setState(
                            () => _size = _normalizeSizeValue(value ?? ''),
                          ),
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
                            final selected = await _pickDateTime(
                              _dropAt,
                              loc.dropDatePickerHelp,
                            );
                            if (!mounted) return;
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
                            if (!mounted) return;
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
        ],
      ),
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '-';
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime.toLocal());
  }

  String _localizedSizeLabel(String value, AppLocalizations loc) {
    switch (_normalizeSizeValue(value)) {
      case 'small':
        return loc.small;
      case 'medium':
        return loc.medium;
      case 'large':
        return loc.large;
      default:
        return loc.medium;
    }
  }

  String _normalizeSizeValue(String value) {
    switch (value.toLowerCase().trim()) {
      case 'küçük':
      case 'kucuk':
      case 'small':
        return 'small';
      case 'orta':
      case 'medium':
        return 'medium';
      case 'büyük':
      case 'buyuk':
      case 'large':
        return 'large';
      default:
        return 'medium';
    }
  }
}
