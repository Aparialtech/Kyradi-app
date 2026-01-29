import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

enum BookingSegment { upcoming, active, past }

class BookingsSegmentedControl extends StatelessWidget {
  const BookingsSegmentedControl({
    super.key,
    required this.segment,
    required this.onChanged,
  });

  final BookingSegment segment;
  final ValueChanged<BookingSegment> onChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SegmentedButton<BookingSegment>(
      segments: [
        ButtonSegment(
          value: BookingSegment.upcoming,
          label: Text(loc.bookingUpcomingLabel),
          icon: const Icon(Icons.event),
        ),
        ButtonSegment(
          value: BookingSegment.active,
          label: Text(loc.bookingActiveLabel),
          icon: const Icon(Icons.play_circle_outline),
        ),
        ButtonSegment(
          value: BookingSegment.past,
          label: Text(loc.bookingPastLabel),
          icon: const Icon(Icons.history),
        ),
      ],
      selected: {segment},
      onSelectionChanged: (value) {
        if (value.isEmpty) return;
        onChanged(value.first);
      },
    );
  }
}
