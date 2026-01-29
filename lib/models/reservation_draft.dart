import '../core/drop_locations.dart';
import 'pricing_breakdown.dart';

class ReservationDraft {
  ReservationDraft({
    this.label = '',
    this.size = 'medium',
    this.weight = '',
    this.color = 'black',
    this.note = '',
    this.location,
    this.dropAt,
    this.pickupAt,
    this.insurance = false,
    this.paymentMethod = 'card',
    this.paymentStatus = 'unpaid',
    this.pricing,
    this.cardNumber = '',
    this.cardName = '',
    this.cardExpiry = '',
    this.cardCvv = '',
  });

  String label;
  String size;
  String weight;
  String color;
  String note;
  DropLocation? location;
  DateTime? dropAt;
  DateTime? pickupAt;
  bool insurance;
  String paymentMethod;
  String paymentStatus;
  PricingBreakdown? pricing;
  String cardNumber;
  String cardName;
  String cardExpiry;
  String cardCvv;

  ReservationDraft copy() => ReservationDraft(
        label: label,
        size: size,
        weight: weight,
        color: color,
        note: note,
        location: location,
        dropAt: dropAt,
        pickupAt: pickupAt,
        insurance: insurance,
        paymentMethod: paymentMethod,
        paymentStatus: paymentStatus,
        pricing: pricing,
        cardNumber: cardNumber,
        cardName: cardName,
        cardExpiry: cardExpiry,
        cardCvv: cardCvv,
      );
}
