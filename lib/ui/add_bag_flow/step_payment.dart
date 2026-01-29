import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../models/reservation_draft.dart';
import '../../services/pricing_service.dart';
import '../../widgets/section_card.dart';

class StepPayment extends StatefulWidget {
  const StepPayment({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.onPay,
    required this.loading,
  });

  final ReservationDraft draft;
  final ValueChanged<ReservationDraft> onChanged;
  final VoidCallback onPay;
  final bool loading;

  @override
  State<StepPayment> createState() => _StepPaymentState();
}

class _StepPaymentState extends State<StepPayment> {
  late final TextEditingController _cardNumberCtrl;
  late final TextEditingController _cardNameCtrl;
  late final TextEditingController _cardExpiryCtrl;
  late final TextEditingController _cardCvvCtrl;
  final FocusNode _cvvFocus = FocusNode();
  bool _showBack = false;
  double _walletBalance = 0;

  @override
  void initState() {
    super.initState();
    _cardNumberCtrl = TextEditingController(text: widget.draft.cardNumber);
    _cardNameCtrl = TextEditingController(text: widget.draft.cardName);
    _cardExpiryCtrl = TextEditingController(text: widget.draft.cardExpiry);
    _cardCvvCtrl = TextEditingController(text: widget.draft.cardCvv);
    _cvvFocus.addListener(_handleCvvFocus);
    _loadBalance();
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _cardCvvCtrl.dispose();
    _cvvFocus.removeListener(_handleCvvFocus);
    _cvvFocus.dispose();
    super.dispose();
  }

  void _handleCvvFocus() {
    setState(() => _showBack = _cvvFocus.hasFocus);
  }

  Future<void> _loadBalance() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getDouble('wallet_balance') ?? 0;
    if (!mounted) return;
    setState(() => _walletBalance = value);
  }

  void _updateDraft(void Function(ReservationDraft draft) apply) {
    final next = widget.draft.copy();
    apply(next);
    widget.onChanged(next);
  }

  String _formatAmount(int amount) => '$amount ₺';

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final pricing = widget.draft.pricing ??
        PricingService.calculate(
          start: widget.draft.dropAt ?? DateTime.now(),
          end: widget.draft.pickupAt ?? DateTime.now().add(const Duration(hours: 1)),
          insurance: widget.draft.insurance,
          paymentMethod: widget.draft.paymentMethod,
        );
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          loc.stepPaymentTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.paymentMethodTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                value: 'wallet',
                groupValue: widget.draft.paymentMethod,
                onChanged: (value) {
                  _updateDraft(
                    (draft) => draft.paymentMethod = value ?? 'wallet',
                  );
                  _loadBalance();
                },
                title: Text(
                  loc.paymentMethodWallet(_walletBalance.toStringAsFixed(2)),
                ),
              ),
              RadioListTile<String>(
                value: 'card',
                groupValue: widget.draft.paymentMethod,
                onChanged: (value) =>
                    _updateDraft((draft) => draft.paymentMethod = value ?? 'card'),
                title: Text(loc.paymentMethodCard),
              ),
              RadioListTile<String>(
                value: 'transfer',
                groupValue: widget.draft.paymentMethod,
                onChanged: (value) =>
                    _updateDraft((draft) => draft.paymentMethod = value ?? 'transfer'),
                title: Text(loc.paymentMethodTransfer),
              ),
              RadioListTile<String>(
                value: 'pay_at_hotel',
                groupValue: widget.draft.paymentMethod,
                onChanged: (value) =>
                    _updateDraft((draft) => draft.paymentMethod = value ?? 'pay_at_hotel'),
                title: Text(loc.paymentMethodPayAtHotel),
              ),
              if (widget.draft.paymentMethod == 'pay_at_hotel')
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    loc.paymentHotelFeeNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              if (widget.draft.paymentMethod == 'transfer')
                Padding(
                  padding: const EdgeInsets.only(left: 12, bottom: 8),
                  child: Text(
                    loc.paymentTransferNote,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (widget.draft.paymentMethod == 'card')
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.paymentPageSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                _AnimatedCardPreview(
                  showBack: _showBack,
                  cardNumber: _cardNumberCtrl.text,
                  cardName: _cardNameCtrl.text,
                  expiry: _cardExpiryCtrl.text,
                  cvv: _cardCvvCtrl.text,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cardNumberCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: loc.paymentCardNumberLabel,
                    prefixIcon: const Icon(Icons.credit_card_outlined),
                  ),
                  onChanged: (value) =>
                      _updateDraft((draft) => draft.cardNumber = value),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _cardNameCtrl,
                  decoration: InputDecoration(
                    labelText: loc.paymentCardNameLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  onChanged: (value) =>
                      _updateDraft((draft) => draft.cardName = value),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _cardExpiryCtrl,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          labelText: loc.paymentExpiryLabel,
                          prefixIcon: const Icon(Icons.date_range_outlined),
                        ),
                        onChanged: (value) =>
                            _updateDraft((draft) => draft.cardExpiry = value),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _cardCvvCtrl,
                        focusNode: _cvvFocus,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: loc.paymentCvcLabel,
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                        onChanged: (value) =>
                            _updateDraft((draft) => draft.cardCvv = value),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  loc.paymentDemoBadge,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        SectionCard(
          child: Row(
            children: [
              Text(
                loc.pricingTotalLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const Spacer(),
              Text(
                _formatAmount(pricing.total),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: widget.loading ? null : widget.onPay,
          child: widget.loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(loc.paymentCompleteAction),
        ),
      ],
    );
  }
}

class _AnimatedCardPreview extends StatelessWidget {
  const _AnimatedCardPreview({
    required this.showBack,
    required this.cardNumber,
    required this.cardName,
    required this.expiry,
    required this.cvv,
  });

  final bool showBack;
  final String cardNumber;
  final String cardName;
  final String expiry;
  final String cvv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayNumber = cardNumber.isEmpty
        ? '#### #### #### ####'
        : cardNumber.replaceAllMapped(
            RegExp(r'.{4}'),
            (m) => '${m.group(0)} ',
          );
    final displayName =
        cardName.isEmpty ? 'CARDHOLDER' : cardName.toUpperCase();
    final displayExpiry = expiry.isEmpty ? 'MM/YY' : expiry;
    final displayCvv = cvv.isEmpty ? '***' : cvv;
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 240),
      child: showBack
          ? _CardBack(
              key: const ValueKey('back'),
              cvv: displayCvv,
              theme: theme,
            )
          : _CardFront(
              key: const ValueKey('front'),
              number: displayNumber,
              name: displayName,
              expiry: displayExpiry,
              theme: theme,
            ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    super.key,
    required this.number,
    required this.name,
    required this.expiry,
    required this.theme,
  });

  final String number;
  final String name;
  final String expiry;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            number,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                expiry,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({
    super.key,
    required this.cvv,
    required this.theme,
  });

  final String cvv;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return _CardShell(
      child: Column(
        children: [
          Container(
            height: 28,
            color: Colors.black.withOpacity(0.5),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              width: 120,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              color: Colors.white.withOpacity(0.9),
              child: Text(
                cvv,
                textAlign: TextAlign.right,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      height: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF1E3A8A), Color(0xFF2563EB), Color(0xFF38BDF8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
