import 'package:flutter/material.dart';

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
    return SegmentedButton<BookingSegment>(
      segments: const [
        ButtonSegment(
          value: BookingSegment.upcoming,
          label: Text('Upcoming'),
          icon: Icon(Icons.event),
        ),
        ButtonSegment(
          value: BookingSegment.active,
          label: Text('Active'),
          icon: Icon(Icons.play_circle_outline),
        ),
        ButtonSegment(
          value: BookingSegment.past,
          label: Text('Past'),
          icon: Icon(Icons.history),
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
