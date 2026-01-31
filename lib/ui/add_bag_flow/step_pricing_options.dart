import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/pricing_breakdown.dart';
import '../../models/reservation_draft.dart';
import '../../services/pricing_service.dart';
import '../../widgets/section_card.dart';

class StepPricingOptions extends StatelessWidget {
  const StepPricingOptions({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.loading,
    required this.error,
    required this.onRecalculate,
  });

  final ReservationDraft draft;
  final ValueChanged<ReservationDraft> onChanged;
  final bool loading;
  final String? error;
  final Future<void> Function() onRecalculate;

  PricingBreakdown _pricing() {
    return draft.pricing ??
        PricingService.calculate(
          start: draft.dropAt ?? DateTime.now(),
          end: draft.pickupAt ?? DateTime.now().add(const Duration(hours: 1)),
          insurance: draft.insurance,
          paymentMethod: draft.paymentMethod,
        );
  }

  void _toggleInsurance(bool value) {
    final next = draft.copy()..insurance = value;
    onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final pricing = _pricing();
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          loc.stepPricingTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        if (loading)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: const LinearProgressIndicator(minHeight: 3),
            ),
          ),
        if (!loading && error != null && error!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              error!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        SectionCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.pricingSummaryTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              _PriceRow(
                label: loc.pricingDurationLabel,
                value: loc.pricingDurationValue(
                  pricing.durationHours.toString(),
                  pricing.durationDays.toString(),
                ),
              ),
              const SizedBox(height: 6),
              _PriceRow(
                label: loc.pricingHourlyLabel,
                value: loc.pricingHourlyValue(pricing.hourlyCost.toString()),
              ),
              const SizedBox(height: 6),
              _PriceRow(
                label: loc.pricingDailyLabel,
                value: loc.pricingDailyValue(pricing.dailyCost.toString()),
              ),
              const Divider(height: 20),
              _PriceRow(
                label: loc.pricingBestPriceLabel,
                value: loc.pricingBestValue(pricing.baseCost.toString()),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          child: SwitchListTile.adaptive(
            value: draft.insurance,
            onChanged: _toggleInsurance,
            title: Text(loc.insuranceOptionTitle),
            subtitle: Text(loc.insuranceOptionSubtitle),
            contentPadding: EdgeInsets.zero,
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: loading ? null : onRecalculate,
            icon: const Icon(Icons.refresh),
            label: Text(loc.pricingRecalculateAction),
          ),
        ),
        const SizedBox(height: 12),
        SectionCard(
          child: Column(
            children: [
              _LineItem(
                label: loc.pricingBasePriceLabel,
                value: '${pricing.baseCost} ₺',
              ),
              _LineItem(
                label: loc.pricingPremiumFeeLabel,
                value: pricing.insuranceFee == 0
                    ? '—'
                    : '+${pricing.insuranceFee} ₺',
              ),
              _LineItem(
                label: loc.pricingHotelCommissionLabel,
                value: pricing.hotelFee == 0 ? '—' : '+${pricing.hotelFee} ₺',
              ),
              const Divider(height: 20),
              _LineItem(
                label: loc.pricingTotalLabel,
                value: '${pricing.total} ₺',
                strong: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          loc.pricingEstimateDisclaimer,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LineItem extends StatelessWidget {
  const _LineItem({
    required this.label,
    required this.value,
    this.strong = false,
  });

  final String label;
  final String value;
  final bool strong;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = strong
        ? theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(value, style: style),
        ],
      ),
    );
  }
}
