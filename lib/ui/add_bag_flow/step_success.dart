import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../widgets/section_card.dart';

class StepSuccess extends StatelessWidget {
  const StepSuccess({
    super.key,
    required this.luggage,
  });

  final LuggageModel? luggage;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      children: [
        SectionCard(
          child: Column(
            children: [
              const Icon(Icons.check_circle_rounded, size: 56, color: Colors.green),
              const SizedBox(height: 12),
              Text(
                loc.reservationSuccessTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                loc.reservationSuccessSubtitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.go('/luggage'),
          child: Text(loc.reservationSuccessGoLuggages),
        ),
        const SizedBox(height: 12),
        if (luggage != null)
          OutlinedButton(
            onPressed: () => context.push(
              '/luggage/${luggage!.id}',
              extra: luggage,
            ),
            child: Text(loc.reservationSuccessViewDetails),
          ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => Navigator.of(context).maybePop(luggage),
          child: Text(loc.reservationSuccessClose),
        ),
      ],
    );
  }
}
