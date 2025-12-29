import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../core/drop_locations.dart';
import '../l10n/app_localizations.dart';
import '../widgets/section_card.dart';
import '../widgets/gradient_button.dart';
import 'location_reservation_page.dart';

class LandingLocationsPage extends StatefulWidget {
  const LandingLocationsPage({super.key});

  @override
  State<LandingLocationsPage> createState() => _LandingLocationsPageState();
}

class _LandingLocationsPageState extends State<LandingLocationsPage> {
  GoogleMapController? _controller;
  bool _locating = false;
  String? _locationError;
  List<DropLocation> _nearestLocations = const [];

  List<DropLocation> get _locations => DropLocationsRepository.locations;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _openLocationDetail(DropLocation location) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LocationReservationPage(locationId: location.id),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return _locations
        .map(
          (loc) => Marker(
            markerId: MarkerId(loc.id),
            position: loc.position,
            infoWindow: InfoWindow(
              title: loc.name,
              snippet: AppLocalizations.of(context)!
                  .availableSlotsLabel(loc.availableSlots, loc.totalSlots),
              onTap: () => _openLocationDetail(loc),
            ),
            onTap: () => _openLocationDetail(loc),
          ),
        )
        .toSet();
  }

  Future<void> _locateUser() async {
    setState(() {
      _locating = true;
      _locationError = null;
    });
    try {
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        setState(() {
          _locating = false;
          _locationError =
              AppLocalizations.of(context)!.locationPermissionDenied;
        });
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final userLatLng = LatLng(position.latitude, position.longitude);
      final nearest = DropLocationsRepository.nearestTo(userLatLng, limit: 3);
      if (!mounted) return;
      setState(() {
        _nearestLocations = nearest;
        _locating = false;
      });
      await _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(userLatLng, 13.5),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _locating = false;
        _locationError =
            AppLocalizations.of(context)!.locationFailedWithDetails('$e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final initialTarget = _locations.first.position;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.landingTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          Text(
            loc.landingIntro,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SectionCard(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.landingLocateSectionTitle,
                  subtitle: loc.landingLocateSectionSubtitle,
                  icon: Icons.my_location,
                ),
                const SizedBox(height: 12),
                GradientButton(
                  text:
                      _locating ? loc.landingLocatingButton : loc.landingLocateButton,
                  onPressed: _locating ? null : _locateUser,
                  leading: const Icon(Icons.explore_outlined),
                  loading: _locating,
                ),
                if (_locationError != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _locationError!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (_nearestLocations.isNotEmpty) ...[
            const SizedBox(height: 14),
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: loc.landingNearestTitle,
                    subtitle: loc.landingNearestSubtitle,
                    icon: Icons.near_me_outlined,
                  ),
                  const SizedBox(height: 12),
                  ..._nearestLocations.map(
                    (location) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.pin_drop_outlined),
                      title: Text(location.name),
                      subtitle: Text(
                        '${loc.occupancyLabel(location.currentOccupancy, location.maxCapacity)} • ${location.address}',
                      ),
                      trailing: TextButton(
                        onPressed: () => _openLocationDetail(location),
                        child: Text(loc.landingGoButton),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            height: 320,
            child: kIsWeb
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: initialTarget,
                        zoom: 12.5,
                      ),
                      markers: _buildMarkers(),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) => _controller = controller,
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: initialTarget,
                        zoom: 12.5,
                      ),
                      markers: _buildMarkers(),
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      onMapCreated: (controller) => _controller = controller,
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          ..._locations.map(
            (location) => SectionCard(
              margin: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: location.name,
                    subtitle: location.address,
                    icon: Icons.location_on_outlined,
                    action: TextButton(
                      onPressed: () => _openLocationDetail(location),
                      child: Text(loc.landingDetailsButton),
                    ),
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: location.occupancyRate,
                    backgroundColor: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        loc.occupancyLabel(
                          location.currentOccupancy,
                          location.maxCapacity,
                        ),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
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
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
