import 'package:flutter/foundation.dart';
import '../models/reservation_draft.dart';
import '../models/pricing_breakdown.dart';
import '../services/pricing_service.dart';

class ReservationFlowController extends ChangeNotifier {
  ReservationFlowController() : _draft = ReservationDraft();

  ReservationDraft _draft;
  int _step = 0;
  bool _busy = false;

  ReservationDraft get draft => _draft;
  int get step => _step;
  bool get busy => _busy;

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
