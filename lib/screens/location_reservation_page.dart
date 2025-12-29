import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/drop_locations.dart';
import '../l10n/app_localizations.dart';
import '../widgets/section_card.dart';

class LocationReservationPage extends StatelessWidget {
  final String locationId;
  const LocationReservationPage({super.key, required this.locationId});

  List<Widget> _buildOpeningHoursList(
    BuildContext context,
    DropLocation location,
  ) {
    final loc = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final dayFormatter = DateFormat('EEEE', locale);
    final baseMonday = DateTime(2024, 1, 1);
    const dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    return List.generate(dayKeys.length, (index) {
      final dayKey = dayKeys[index];
      final label = dayFormatter.format(baseMonday.add(Duration(days: index)));
      final ranges = location.openingHours[dayKey] ?? const [];
      final hoursLabel = ranges.isEmpty
          ? loc.openingHoursClosed
          : ranges.map((range) => '${range.start} - ${range.end}').join(', ');
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            Text(
              hoursLabel,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final location = DropLocationsRepository.byId(locationId);
    if (location == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.locationNotFoundTitle)),
        body: Center(child: Text(loc.locationNotFoundMessage)),
      );
    }

    final theme = Theme.of(context);
    final fmt = DateFormat('dd MMM HH:mm', Localizations.localeOf(context).toLanguageTag());

    return Scaffold(
      appBar: AppBar(
        title: Text(location.name),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: location.name,
                  subtitle: location.address,
                  icon: Icons.store_mall_directory_outlined,
                ),
                const SizedBox(height: 12),
                Text(
                  loc.occupancyLabel(
                    location.currentOccupancy,
                    location.maxCapacity,
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  location.isOpenNow
                      ? loc.locationOpenLabel
                      : loc.locationClosedLabel,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: location.isOpenNow
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: location.occupancyRate,
                  backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.08),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.openingHoursTitle,
                  subtitle: location.openingHours.isEmpty
                      ? loc.openingHoursAlwaysOpen
                      : loc.openingHoursSubtitle,
                  icon: Icons.access_time,
                ),
                const SizedBox(height: 12),
                if (location.openingHours.isEmpty)
                  Text(
                    loc.openingHoursAlwaysOpen,
                    style: theme.textTheme.bodyMedium,
                  )
                else
                  ..._buildOpeningHoursList(context, location),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.upcomingReservationsTitle,
                  subtitle: loc.upcomingReservationsSubtitle,
                  icon: Icons.calendar_today_outlined,
                ),
                const SizedBox(height: 12),
                if (location.reservations.isEmpty)
                  Text(
                    loc.upcomingReservationsEmpty,
                    style: theme.textTheme.bodyMedium,
                  )
                else
                  ...location.reservations.map(
                    (slot) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.event_available_outlined),
                      title: Text(loc.reservationTileTitle(slot.code)),
                      subtitle: Text(
                        loc.reservationSlotSummary(
                          slot.luggageCount,
                          fmt.format(slot.time),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.continueSectionTitle,
                  subtitle: loc.continueSectionSubtitle,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  icon: const Icon(Icons.lock_open),
                  label: Text(loc.loginButtonLabel),
                ),
                const SizedBox(height: 10),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: Text(loc.registerButtonLabel),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
