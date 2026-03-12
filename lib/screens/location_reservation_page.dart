import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../core/drop_locations.dart';
import '../core/ios/ios_config_service.dart';
import '../l10n/app_localizations.dart';
import '../widgets/section_card.dart';
import '../widgets/app_mesh_background.dart';

class LocationReservationPage extends StatefulWidget {
  final String locationId;
  const LocationReservationPage({super.key, required this.locationId});

  @override
  State<LocationReservationPage> createState() =>
      _LocationReservationPageState();
}

class _LocationReservationPageState extends State<LocationReservationPage> {
  bool? _iosMapReady;
  _LocationInfoSection? _activeInfoSection;

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
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    });
  }

  Map<String, String> _locationContacts(DropLocation location) {
    const fallback = '+90 212 000 00 00';
    final id = location.id.toLowerCase();
    if (id.contains('taksim')) return {'phone': '+90 212 555 01 01'};
    if (id.contains('besiktas')) return {'phone': '+90 212 555 02 02'};
    if (id.contains('bakirkoy')) return {'phone': '+90 212 555 03 03'};
    if (id.contains('airport') || id.contains('havaliman')) {
      return {'phone': '+90 212 555 04 04'};
    }
    return {'phone': fallback};
  }

  List<String> _miniGuideFor(DropLocation location) {
    final lower = location.name.toLowerCase();
    if (lower.contains('taksim')) {
      return ['☕ Gümüşsuyu Cafe', '🍽️ Galata Restoran', '🚶 İstiklal Caddesi'];
    }
    if (lower.contains('besiktas')) {
      return ['☕ Beşiktaş Kahve', '🍽️ Çarşı Restoran', '🚶 Deniz Müzesi'];
    }
    return ['☕ Yakın kafe', '🍽️ Yakın restoran', '🚶 Gezilecek yer'];
  }

  List<String> _travelTimesFor(DropLocation location) {
    final lower = location.name.toLowerCase();
    if (lower.contains('taksim')) {
      return ['📍 Taksim Meydanı → 6 dk', '✈️ Havalimanı → 38 dk'];
    }
    if (lower.contains('besiktas')) {
      return ['📍 Sahil → 5 dk', '✈️ Havalimanı → 40 dk'];
    }
    if (lower.contains('bakirkoy')) {
      return ['📍 Metro → 7 dk', '✈️ Havalimanı → 18 dk'];
    }
    return ['📍 Merkez → 10 dk', '✈️ Havalimanı → 35 dk'];
  }

  Widget _buildInfoHubCard({
    required BuildContext context,
    required DropLocation location,
    required AppLocalizations loc,
    required ThemeData theme,
    required DateFormat fmt,
  }) {
    final sections = <_InfoHubSectionItem>[
      _InfoHubSectionItem(
        section: _LocationInfoSection.details,
        label: 'Detay',
        icon: Icons.store_mall_directory_outlined,
      ),
      _InfoHubSectionItem(
        section: _LocationInfoSection.guide,
        label: 'Rehber',
        icon: Icons.explore_rounded,
      ),
      _InfoHubSectionItem(
        section: _LocationInfoSection.trust,
        label: 'Güvence',
        icon: Icons.verified_user_outlined,
      ),
      _InfoHubSectionItem(
        section: _LocationInfoSection.support,
        label: 'Destek',
        icon: Icons.support_agent_rounded,
      ),
      _InfoHubSectionItem(
        section: _LocationInfoSection.hours,
        label: 'Saatler',
        icon: Icons.access_time_rounded,
      ),
      _InfoHubSectionItem(
        section: _LocationInfoSection.reservations,
        label: 'Rezerv.',
        icon: Icons.calendar_today_outlined,
      ),
    ];

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            title: 'Bilgi Merkezi',
            subtitle: 'Detayları görmek için ikonlara dokun.',
            iconWidget: ThreeDIconBadge(icon: Icons.widgets_outlined),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: sections.map((item) {
              final isSelected = _activeInfoSection == item.section;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () {
                  setState(() {
                    _activeInfoSection = isSelected ? null : item.section;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.colorScheme.primary.withValues(alpha: 0.14)
                        : theme.colorScheme.surfaceContainerHighest.withValues(
                            alpha: 0.55,
                          ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected
                          ? theme.colorScheme.primary.withValues(alpha: 0.45)
                          : theme.colorScheme.outlineVariant.withValues(
                              alpha: 0.45,
                            ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _MiniThreeDIcon(
                        icon: item.icon,
                        accent: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.label,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: _activeInfoSection == null
                ? Container(
                    key: const ValueKey('empty-info'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Bir ikon seç ve bilgileri görüntüle.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : Container(
                    key: ValueKey<String>('info-${_activeInfoSection!.name}'),
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: _buildInfoHubContent(
                      context: context,
                      location: location,
                      loc: loc,
                      theme: theme,
                      fmt: fmt,
                      section: _activeInfoSection!,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoHubContent({
    required BuildContext context,
    required DropLocation location,
    required AppLocalizations loc,
    required ThemeData theme,
    required DateFormat fmt,
    required _LocationInfoSection section,
  }) {
    switch (section) {
      case _LocationInfoSection.details:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: location.occupancyRate,
                backgroundColor: theme.colorScheme.primary.withValues(
                  alpha: 0.08,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _travelTimesFor(location)
                  .map(
                    (label) => _InfoChip(
                      label: label,
                      color: theme.colorScheme.primary,
                      icon: Icons.navigation_rounded,
                    ),
                  )
                  .toList(),
            ),
          ],
        );
      case _LocationInfoSection.guide:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _miniGuideFor(location)
              .map(
                (item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(item, style: theme.textTheme.bodyMedium),
                ),
              )
              .toList(),
        );
      case _LocationInfoSection.trust:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kyradi noktalarında bırakılan bavullar sigortalıdır.',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                _TrustBadge(label: 'Sigortalı Alan', icon: Icons.lock_rounded),
                _TrustBadge(
                  label: 'Kamera İzleme',
                  icon: Icons.videocam_rounded,
                ),
                _TrustBadge(
                  label: 'Yetkili Personel',
                  icon: Icons.person_pin_rounded,
                ),
                _TrustBadge(
                  label: 'KVKK Uyumlu',
                  icon: Icons.verified_outlined,
                ),
              ],
            ),
          ],
        );
      case _LocationInfoSection.support:
        return Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const ThreeDIconBadge(icon: Icons.phone_outlined),
              title: const Text('Lokasyon Telefonu'),
              subtitle: Text(_locationContacts(location)['phone'] ?? ''),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const ThreeDIconBadge(icon: Icons.chat_bubble_outline),
              title: const Text('WhatsApp Destek'),
              onTap: () => launchUrl(
                Uri.parse('https://wa.me/905000000000'),
                mode: LaunchMode.externalApplication,
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const ThreeDIconBadge(icon: Icons.email_outlined),
              title: const Text('E-posta'),
              onTap: () => launchUrl(Uri.parse('mailto:support@kyradi.com')),
            ),
          ],
        );
      case _LocationInfoSection.hours:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: location.openingHours.isEmpty
              ? [
                  Text(
                    loc.openingHoursAlwaysOpen,
                    style: theme.textTheme.bodyMedium,
                  ),
                ]
              : _buildOpeningHoursList(context, location),
        );
      case _LocationInfoSection.reservations:
        if (location.reservations.isEmpty) {
          return Text(
            loc.upcomingReservationsEmpty,
            style: theme.textTheme.bodyMedium,
          );
        }
        return Column(
          children: location.reservations
              .map(
                (slot) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const ThreeDIconBadge(
                    icon: Icons.event_available_outlined,
                  ),
                  title: Text(loc.reservationTileTitle(slot.code)),
                  subtitle: Text(
                    loc.reservationSlotSummary(
                      slot.luggageCount,
                      fmt.format(slot.time),
                    ),
                  ),
                ),
              )
              .toList(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final location = DropLocationsRepository.byId(widget.locationId);
    if (location == null) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: Text(loc.locationNotFoundTitle)),
        body: Stack(
          children: [
            const AppMeshBackground(),
            Center(child: Text(loc.locationNotFoundMessage)),
          ],
        ),
      );
    }

    final theme = Theme.of(context);
    final fmt = DateFormat(
      'dd MMM HH:mm',
      Localizations.localeOf(context).toLanguageTag(),
    );
    final bottomContentPadding = MediaQuery.viewPaddingOf(context).bottom + 108;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(location.name)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomContentPadding),
            children: [
              _HeroHeader(location: location),
              const SizedBox(height: 16),
              _MapCard(
                location: location,
                isReady: _iosMapReady,
                onDirections: () => _showDirectionsSheet(context, location),
              ),
              const SizedBox(height: 16),
              _buildInfoHubCard(
                context: context,
                location: location,
                loc: loc,
                theme: theme,
                fmt: fmt,
              ),
            ],
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
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.mapsOpenFailed)));
    }
  }

  Future<void> _openAppleMaps(DropLocation location) async {
    final loc = AppLocalizations.of(context)!;
    final uri = Uri.parse(
      'http://maps.apple.com/?daddr=${location.position.latitude},${location.position.longitude}',
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(loc.mapsOpenFailed)));
    }
  }
}

enum _LocationInfoSection {
  details,
  guide,
  trust,
  support,
  hours,
  reservations,
}

class _InfoHubSectionItem {
  const _InfoHubSectionItem({
    required this.section,
    required this.label,
    required this.icon,
  });

  final _LocationInfoSection section;
  final String label;
  final IconData icon;
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
            color: Colors.black.withValues(alpha: 0.15),
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
              color: Colors.white.withValues(alpha: 0.16),
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
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
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
  const _ZoomButton({required this.icon, required this.onTap});

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
            _MiniThreeDIcon(icon: icon, accent: color),
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

class _MiniThreeDIcon extends StatelessWidget {
  const _MiniThreeDIcon({required this.icon, required this.accent});

  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      width: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            accent.withValues(alpha: 0.28),
            accent.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Center(child: Icon(icon, size: 12, color: accent)),
    );
  }
}

class _TrustBadge extends StatelessWidget {
  const _TrustBadge({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _MiniThreeDIcon(icon: icon, accent: theme.colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
