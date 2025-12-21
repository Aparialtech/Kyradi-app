import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../core/drop_locations.dart';
import '../l10n/app_localizations.dart';
import '../widgets/section_card.dart';

class LocationReservationPage extends StatelessWidget {
  final String locationId;
  const LocationReservationPage({super.key, required this.locationId});

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
                  loc.availableSlotsLabel(
                    location.availableSlots,
                    location.totalSlots,
                  ),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
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
