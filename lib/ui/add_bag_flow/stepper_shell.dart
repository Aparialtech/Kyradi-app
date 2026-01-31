import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../models/reservation_draft.dart';
import '../../payments/demo_payment_repository.dart';
import '../../payments/wallet_payment_handler.dart';
import '../../services/pricing_service.dart';
import '../../core/repositories/luggage_repository.dart';
import '../../services/api_service.dart';
import '../../utils/crash_log.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';
import '../../core/drop_locations.dart';
import 'step_bag_info.dart';
import 'step_schedule_location.dart';
import 'step_pricing_options.dart';
import 'step_payment.dart';
import 'step_success.dart';
import '../../state/reservation_flow_controller.dart';

class ReservationStepperShell extends StatefulWidget {
  const ReservationStepperShell({super.key});

  @override
  State<ReservationStepperShell> createState() =>
      _ReservationStepperShellState();
}

class _ReservationStepperShellState extends State<ReservationStepperShell> {
  final _controller = ReservationFlowController();
  final _pageController = PageController();
  final _repo = const LuggageRepository();
  final _paymentRepo = DemoPaymentRepository();
  bool _submitting = false;
  String? _userId;
  LuggageModel? _created;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('userId');
  }

  void _next() {
    final step = _controller.step;
    if (!_canContinue(step)) return;
    if (step == 1) {
      _controller.recalcPricingRemote();
    }
    final next = step + 1;
    _controller.setStep(next);
    setState(() {});
    _pageController.animateToPage(
      next,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  void _back() {
    final step = _controller.step;
    if (step == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    final prev = step - 1;
    _controller.setStep(prev);
    setState(() {});
    _pageController.animateToPage(
      prev,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
    );
  }

  bool _canContinue(int step) {
    switch (step) {
      case 0:
        return _controller.canContinueStep1;
      case 1:
        return _controller.canContinueStep2;
      case 2:
        return _controller.canContinueStep3;
      case 3:
        return true;
      default:
        return false;
    }
  }

  Future<void> _submitPayment() async {
    if (_submitting) return;
    final loc = AppLocalizations.of(context)!;
    setState(() => _submitting = true);
    try {
      final draft = _controller.draft;
      if (draft.paymentMethod == 'card') {
        final ok = _validateCard(loc, draft);
        if (!ok) {
          setState(() => _submitting = false);
          return;
        }
      }
      final pricing = draft.pricing ??
          PricingService.calculate(
            start: draft.dropAt ?? DateTime.now(),
            end: draft.pickupAt ?? DateTime.now().add(const Duration(hours: 1)),
            insurance: draft.insurance,
            paymentMethod: draft.paymentMethod,
          );
      if (draft.paymentMethod == 'wallet') {
        final balance = await WalletPaymentHandler.getBalance();
        final canPay = balance >= pricing.total;
        if (!canPay) {
          if (!mounted) return;
          _showWalletInsufficient(loc, pricing.total, balance);
          setState(() => _submitting = false);
          return;
        }
      }
      var ok = true;
      if (draft.paymentMethod != 'pay_at_hotel' &&
          draft.paymentMethod != 'transfer') {
        try {
          final checkout = await ApiService.checkoutPayment(
            amount: pricing.total,
            paymentMethod: draft.paymentMethod,
          );
          ok = checkout['ok'] == true ||
              checkout['status'] == 'success' ||
              checkout['paymentStatus'] == 'success';
        } catch (_) {
          ok = false;
        }
        if (!ok) {
          final fallback = await _paymentRepo.pay(
            amount: pricing.total,
            currency: 'TRY',
            method: draft.paymentMethod,
          );
          ok = fallback['ok'] == true || fallback['status'] == 'success';
        }
        if (!ok) {
          AppNotification.show(
            context,
            message: loc.paymentFailedMessage,
            type: AppNotificationType.error,
          );
          setState(() => _submitting = false);
          return;
        }
      }
      if (draft.paymentMethod == 'wallet') {
        final balance = await WalletPaymentHandler.getBalance();
        if (balance >= pricing.total) {
          await WalletPaymentHandler.setBalance(balance - pricing.total);
        }
      }
      final userId = _userId;
      if (userId == null || userId.isEmpty) {
        AppNotification.show(
          context,
          message: loc.userIdMissing,
          type: AppNotificationType.error,
        );
        setState(() => _submitting = false);
        return;
      }
      final payload = _buildPayload(draft, pricing);
      final luggage = await _repo.createLuggage(userId, payload);
      _created = luggage;
      _controller.setStep(4);
      _pageController.animateToPage(
        4,
        duration: const Duration(milliseconds: 240),
        curve: Curves.easeOutCubic,
      );
    } catch (e) {
      appLog('reservation', 'submit failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.paymentFailedMessage,
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  bool _validateCard(AppLocalizations loc, ReservationDraft draft) {
    final digits = _digitsOnly(draft.cardNumber);
    final name = draft.cardName.trim();
    final expiry = draft.cardExpiry.trim();
    final cvv = draft.cardCvv.trim();
    if (digits.isEmpty || name.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      AppNotification.show(
        context,
        message: loc.paymentFormIncompleteMessage,
        type: AppNotificationType.warning,
      );
      return false;
    }
    if (digits.length != 16) {
      AppNotification.show(
        context,
        message: loc.paymentCardNumberInvalidMessage,
        type: AppNotificationType.warning,
      );
      return false;
    }
    if (!_isValidExpiry(expiry)) {
      AppNotification.show(
        context,
        message: loc.paymentExpiryInvalidMessage,
        type: AppNotificationType.warning,
      );
      return false;
    }
    if (cvv.length < 3 || cvv.length > 4) {
      AppNotification.show(
        context,
        message: loc.paymentCvvInvalidMessage,
        type: AppNotificationType.warning,
      );
      return false;
    }
    return true;
  }

  String _digitsOnly(String input) =>
      input.replaceAll(RegExp(r'[^0-9]'), '');

  bool _isValidExpiry(String value) {
    final trimmed = value.trim();
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(trimmed)) return false;
    final parts = trimmed.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return false;
    final now = DateTime.now();
    final fullYear = 2000 + year;
    final expiry = DateTime(fullYear, month + 1);
    return expiry.isAfter(now);
  }

  Map<String, dynamic> _buildPayload(
    ReservationDraft draft,
    dynamic pricing,
  ) {
    final paid = draft.paymentMethod == 'wallet' || draft.paymentMethod == 'card';
    final backendMethod =
        draft.paymentMethod == 'wallet' ? 'card' : draft.paymentMethod;
    return {
      'qrCode': _generateQrCode(),
      'label': draft.label.trim().isEmpty ? 'Bavul' : draft.label.trim(),
      'weight': draft.weight.trim(),
      'size': draft.size,
      'color': draft.color,
      'note': draft.note.trim(),
      'dropLocationId': draft.location?.id ?? '',
      'dropLocationName': draft.location?.name ?? '',
      if (draft.dropAt != null) 'scheduledDropTime': draft.dropAt,
      if (draft.pickupAt != null) 'scheduledPickupTime': draft.pickupAt,
      'paymentMethod': backendMethod,
      'paymentStatus': paid ? 'paid' : 'unpaid',
      if (draft.paymentMethod == 'wallet') 'walletPayment': true,
      'totalPrice': pricing.total,
      'pricing': pricing.toJson(),
    };
  }

  String _generateQrCode() {
    final stamp = DateTime.now()
        .millisecondsSinceEpoch
        .toRadixString(36)
        .toUpperCase();
    return 'BGO-$stamp-${stamp.substring(0, 4)}';
  }

  void _showWalletInsufficient(
    AppLocalizations loc,
    int amount,
    double balance,
  ) {
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
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(
                loc.paymentWalletInsufficientMessage(
                  balance.toStringAsFixed(2),
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
                        final next = _controller.draft.copy()
                          ..paymentMethod = 'card';
                        _controller.updateDraft(next);
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final loc = AppLocalizations.of(context)!;
        final steps = [
          loc.stepBagInfoTitle,
          loc.stepScheduleTitle,
          loc.stepPricingTitle,
          loc.stepPaymentTitle,
          loc.stepSuccessTitle,
        ];
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.addLuggageTitle),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: _back,
            ),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: SectionCard(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      for (var i = 0; i < steps.length; i++) ...[
                        _StepDot(
                          active: _controller.step == i,
                          label: '${i + 1}',
                        ),
                        if (i != steps.length - 1)
                          Expanded(
                            child: Divider(
                              color: Theme.of(context)
                                  .colorScheme
                                  .outlineVariant,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StepBagInfo(
                      draft: _controller.draft,
                      onChanged: _controller.updateDraft,
                    ),
                    StepScheduleLocation(
                      draft: _controller.draft,
                      locations: DropLocationsRepository.locations,
                      onChanged: _controller.updateDraft,
                    ),
                    StepPricingOptions(
                      draft: _controller.draft,
                      loading: _controller.pricingLoading,
                      error: _controller.pricingError,
                      onRecalculate: _controller.recalcPricingRemote,
                      onChanged: (draft) {
                        _controller.updateDraft(draft);
                        _controller.recalcPricingRemote();
                      },
                    ),
                    StepPayment(
                      draft: _controller.draft,
                      onChanged: (draft) {
                        _controller.updateDraft(draft);
                        _controller.recalcPricing();
                      },
                      onPay: _submitPayment,
                      loading: _submitting,
                    ),
                    StepSuccess(
                      luggage: _created,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: _controller.step < 3
              ? SafeArea(
                  minimum: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: FilledButton(
                    onPressed: _canContinue(_controller.step) ? _next : null,
                    child: Text(loc.continueAction),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _StepDot extends StatelessWidget {
  const _StepDot({required this.active, required this.label});

  final bool active;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        color: active ? theme.colorScheme.primary : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Center(
        child: Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: active ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
