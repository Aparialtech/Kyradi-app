import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../core/drop_locations.dart';
import '../../../utils/crash_log.dart';

class LocationMapView extends StatefulWidget {
  const LocationMapView({
    super.key,
    required this.markers,
    required this.selectedLocation,
    required this.onMarkerTap,
    required this.onDetailsTap,
    required this.center,
    required this.showMyLocation,
    this.onMapCreated,
  });

  final Set<Marker> markers;
  final DropLocation? selectedLocation;
  final ValueChanged<DropLocation> onMarkerTap;
  final VoidCallback onDetailsTap;
  final LatLng center;
  final bool showMyLocation;
  final ValueChanged<GoogleMapController>? onMapCreated;

  @override
  State<LocationMapView> createState() => _LocationMapViewState();
}

class _LocationMapViewState extends State<LocationMapView> {
  @override
  Widget build(BuildContext context) {
    final selected = widget.selectedLocation;
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(
            target: widget.center,
            zoom: 12.5,
          ),
          markers: widget.markers,
          myLocationEnabled: widget.showMyLocation,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) {
            try {
              widget.onMapCreated?.call(controller);
              appLog('map', 'MAP_WIDGET_CREATED', level: AppLogLevel.info);
            } catch (e) {
              appLog('map', 'MAP_ERROR onMapCreated $e',
                  level: AppLogLevel.error);
            }
          },
          compassEnabled: false,
          mapToolbarEnabled: false,
        ),
        if (selected != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selected.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: widget.onDetailsTap,
                      child: const Text('Detay'),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
