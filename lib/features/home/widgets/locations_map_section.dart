import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/drop_locations.dart';

class LocationsMapSection extends StatelessWidget {
  const LocationsMapSection({
    super.key,
    required this.locations,
    required this.locationsLoading,
    required this.selectedLocation,
    required this.currentLat,
    required this.currentLng,
    required this.polylines,
    required this.activeRoute,
    required this.fetchingRoute,
    required this.mapIntro,
    required this.mapNoLocations,
    required this.onMapCreated,
    required this.onSelectLocation,
    required this.onShowLocationSheet,
    required this.onClearSelection,
    required this.onMyLocation,
    required this.onClearRoute,
    required this.buildLocationCard,
  });

  final List<DropLocation> locations;
  final bool locationsLoading;
  final DropLocation? selectedLocation;
  final double? currentLat;
  final double? currentLng;
  final Set<Polyline> polylines;
  final Polyline? activeRoute;
  final bool fetchingRoute;
  final String mapIntro;
  final String mapNoLocations;
  final ValueChanged<GoogleMapController> onMapCreated;
  final ValueChanged<DropLocation> onSelectLocation;
  final ValueChanged<DropLocation> onShowLocationSheet;
  final VoidCallback onClearSelection;
  final VoidCallback onMyLocation;
  final VoidCallback onClearRoute;
  final Widget Function(DropLocation location, bool isActive) buildLocationCard;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (locationsLoading && locations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (locations.isEmpty) {
      return Center(child: Text(mapNoLocations));
    }

    final markers = locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: location.position,
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.address,
          onTap: () => onShowLocationSheet(location),
        ),
        onTap: () => onSelectLocation(location),
      );
    }).toSet();

    final combinedPolylines = <Polyline>{
      ...polylines,
      if (activeRoute != null) activeRoute!,
    };

    final initialTarget = selectedLocation?.position ?? locations.first.position;

    final googleMap = GoogleMap(
      initialCameraPosition: CameraPosition(
        target: initialTarget,
        zoom: 12.5,
      ),
      myLocationEnabled: currentLat != null && currentLng != null,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      markers: markers,
      polylines: combinedPolylines,
      onMapCreated: onMapCreated,
      onTap: (_) => onClearSelection(),
    );

    final mapSurface = _buildMapSurface(context, googleMap);

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          mapSurface,
          Positioned(
            top: 16,
            left: 16,
            child: SafeArea(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Card(
                  color: theme.colorScheme.surface.withValues(alpha: 0.9),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      mapIntro,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (fetchingRoute)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    color: theme.colorScheme.primary,
                    backgroundColor:
                        theme.colorScheme.primary.withValues(alpha: 0.2),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 16,
            right: 16,
            child: SafeArea(
              child: Column(
                children: [
                  FloatingActionButton.small(
                    heroTag: 'map-my-location',
                    onPressed: onMyLocation,
                    child: const Icon(Icons.my_location),
                  ),
                  if (activeRoute != null) ...[
                    const SizedBox(height: 12),
                    FloatingActionButton.small(
                      heroTag: 'map-clear-route',
                      backgroundColor: theme.colorScheme.surface,
                      foregroundColor: theme.colorScheme.onSurface,
                      onPressed: onClearRoute,
                      child: const Icon(Icons.clear),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 140,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  final isActive = selectedLocation?.id == location.id;
                  return buildLocationCard(location, isActive);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemCount: locations.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapSurface(BuildContext context, Widget map) {
    final borderRadius = BorderRadius.circular(24);
    if (kIsWeb) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ),
        child: map,
      );
    }
    return ClipRRect(
      borderRadius: borderRadius,
      child: map,
    );
  }
}
