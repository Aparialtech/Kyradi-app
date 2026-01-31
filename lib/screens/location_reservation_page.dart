import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/drop_locations.dart';
import '../core/ios/ios_config_service.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../widgets/section_card.dart';

class LocationReservationPage extends StatefulWidget {
  final String locationId;
  const LocationReservationPage({super.key, required this.locationId});

  @override
  State<LocationReservationPage> createState() =>
      _LocationReservationPageState();
}

class _LocationReservationPageState extends State<LocationReservationPage> {
  bool? _iosMapReady;

  @override
  void initState() {
    super.initState();
    _checkMapKey();
  }

  Future<void> _checkMapKey() async {
    if (!Platform.isIOS) {
      setState(() => _iosMapReady = true);
      return;
    }
    final hasKey = await IosConfigService.hasGmsApiKey();
    if (!mounted) return;
    setState(() => _iosMapReady = hasKey);
  }

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
    final location = DropLocationsRepository.byId(widget.locationId);
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
          _HeroHeader(location: location),
          const SizedBox(height: 16),
          _MapCard(
            location: location,
            isReady: _iosMapReady,
            onDirections: () => _showDirectionsSheet(context, location),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.locationDetailsTitle,
                  subtitle: loc.locationDetailsSubtitle,
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
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: location.occupancyRate,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.08),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _InfoChip(
                      label: location.isOpenNow
                          ? loc.locationOpenLabel
                          : loc.locationClosedLabel,
                      color: location.isOpenNow
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error,
                      icon: Icons.access_time_rounded,
                    ),
                    _InfoChip(
                      label: loc.locationSlotsLabel(
                        location.availableSlots,
                        location.totalSlots,
                      ),
                      color: location.availableSlots == 0
                          ? theme.colorScheme.error
                          : theme.colorScheme.secondary,
                      icon: Icons.inventory_2_outlined,
                    ),
                    _InfoChip(
                      label: loc.directionsAction,
                      color: theme.colorScheme.primary,
                      icon: Icons.navigation_rounded,
                      onTap: () => _showDirectionsSheet(context, location),
                    ),
                  ],
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
                FutureBuilder<bool>(
                  future: ApiService.isAuthenticatedAsync(),
                  builder: (context, snapshot) {
                    final authed = snapshot.data == true;
                    if (authed) {
                      return Text(
                        loc.locationAuthReadyMessage,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FilledButton.icon(
                          onPressed: () => context.push('/login'),
                          icon: const Icon(Icons.lock_open),
                          label: Text(loc.loginButtonLabel),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () => context.push('/register'),
                          icon: const Icon(Icons.person_add_alt_1),
                          label: Text(loc.registerButtonLabel),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDirectionsSheet(
    BuildContext context,
    DropLocation location,
  ) async {
    final loc = AppLocalizations.of(context)!;
    if (!Platform.isIOS) {
      await _openGoogleMaps(location);
      return;
    }
    if (!context.mounted) return;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              loc.directionsSheetTitle,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              loc.directionsSheetSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _openAppleMaps(location);
              },
              icon: const Icon(Icons.map_rounded),
              label: Text(loc.directionsAppleMaps),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _openGoogleMaps(location);
              },
              icon: const Icon(Icons.navigation_rounded),
              label: Text(loc.directionsGoogleMaps),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openGoogleMaps(DropLocation location) async {
    final loc = AppLocalizations.of(context)!;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${location.position.latitude},${location.position.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(loc.mapsOpenFailed)));
    }
  }

  Future<void> _openAppleMaps(DropLocation location) async {
    final loc = AppLocalizations.of(context)!;
    final uri = Uri.parse(
      'http://maps.apple.com/?daddr=${location.position.latitude},${location.position.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(loc.mapsOpenFailed)));
    }
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.location});

  final DropLocation location;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.95),
            theme.colorScheme.secondary.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.location_on_rounded, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  location.address,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapCard extends StatefulWidget {
  const _MapCard({
    required this.location,
    required this.isReady,
    required this.onDirections,
  });

  final DropLocation location;
  final bool? isReady;
  final VoidCallback onDirections;

  @override
  State<_MapCard> createState() => _MapCardState();
}

class _MapCardState extends State<_MapCard> {
  GoogleMapController? _controller;

  Future<void> _zoomIn() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOut() async {
    final controller = _controller;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SectionCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 200,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: widget.isReady == false
                  ? Center(
                      child: Text(
                        loc.mapsMissingApiKey,
                        style: theme.textTheme.bodySmall,
                      ),
                    )
                  : Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: CameraPosition(
                            target: widget.location.position,
                            zoom: 13,
                          ),
                          markers: {
                            Marker(
                              markerId: MarkerId(widget.location.id),
                              position: widget.location.position,
                              infoWindow: InfoWindow(
                                title: widget.location.name,
                                snippet: widget.location.address,
                              ),
                            ),
                          },
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          zoomGesturesEnabled: true,
                          scrollGesturesEnabled: true,
                          onMapCreated: (controller) =>
                              _controller = controller,
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: Column(
                            children: [
                              _ZoomButton(icon: Icons.add, onTap: _zoomIn),
                              const SizedBox(height: 8),
                              _ZoomButton(icon: Icons.remove, onTap: _zoomOut),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    loc.directionsPreviewTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                FilledButton.icon(
                  onPressed: widget.onDirections,
                  icon: const Icon(Icons.directions_rounded),
                  label: Text(loc.directionsAction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ZoomButton extends StatelessWidget {
  const _ZoomButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface.withValues(alpha: 0.9),
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.label,
    required this.color,
    required this.icon,
    this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: color.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
