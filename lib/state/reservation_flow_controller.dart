import 'package:flutter/foundation.dart';
import '../models/reservation_draft.dart';
import '../models/pricing_breakdown.dart';
import '../services/pricing_service.dart';
import '../services/api_service.dart';

class ReservationFlowController extends ChangeNotifier {
  ReservationFlowController() : _draft = ReservationDraft();

  ReservationDraft _draft;
  int _step = 0;
  bool _busy = false;
  bool _pricingLoading = false;
  String? _pricingError;

  ReservationDraft get draft => _draft;
  int get step => _step;
  bool get busy => _busy;
  bool get pricingLoading => _pricingLoading;
  String? get pricingError => _pricingError;

  void setStep(int value) {
    _step = value;
    notifyListeners();
  }

  void updateDraft(ReservationDraft next) {
    _draft = next;
    notifyListeners();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }

  PricingBreakdown recalcPricing() {
    final start = _draft.dropAt ?? DateTime.now();
    final end = _draft.pickupAt ?? start.add(const Duration(hours: 1));
    final pricing = PricingService.calculate(
      start: start,
      end: end,
      insurance: _draft.insurance,
      paymentMethod: _draft.paymentMethod,
    );
    _draft.pricing = pricing;
    notifyListeners();
    return pricing;
  }

  Future<void> recalcPricingRemote() async {
    final start = _draft.dropAt ?? DateTime.now();
    final end = _draft.pickupAt ?? start.add(const Duration(hours: 1));
    _pricingLoading = true;
    _pricingError = null;
    notifyListeners();
    try {
      final result = await ApiService.calculatePayment(
        startAt: start,
        endAt: end,
        insurance: _draft.insurance,
        paymentMethod: _draft.paymentMethod,
      );
      final ok = result['ok'] == true;
      if (ok && result['pricing'] is Map) {
        _draft.pricing = PricingBreakdown.fromJson(
          Map<String, dynamic>.from(result['pricing'] as Map),
        );
      } else {
        _pricingError = (result['error'] ?? result['message'] ?? '').toString();
        _draft.pricing = recalcPricing();
      }
    } catch (e) {
      _pricingError = e.toString();
      _draft.pricing = recalcPricing();
    } finally {
      _pricingLoading = false;
      notifyListeners();
    }
  }

  bool get canContinueStep1 {
    return _draft.label.trim().isNotEmpty ||
        _draft.size.isNotEmpty ||
        _draft.color.isNotEmpty;
  }

  bool get canContinueStep2 {
    if (_draft.location == null) return false;
    final drop = _draft.dropAt;
    final pickup = _draft.pickupAt;
    if (drop == null || pickup == null) return false;
    if (!pickup.isAfter(drop)) return false;
    final minMinutes = pickup.difference(drop).inMinutes;
    return minMinutes >= 60;
  }

  bool get canContinueStep3 => _draft.pricing != null;
}
