import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../l10n/app_localizations.dart';
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
    final selected = widget.selectedLocation;
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
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
            _controller = controller;
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
          zoomGesturesEnabled: true,
          scrollGesturesEnabled: true,
        ),
        Positioned(
          top: 16,
          right: 16,
          child: SafeArea(
            child: Column(
              children: [
                _ZoomButton(
                  icon: Icons.add,
                  onTap: _zoomIn,
                ),
                const SizedBox(height: 8),
                _ZoomButton(
                  icon: Icons.remove,
                  onTap: _zoomOut,
                ),
              ],
            ),
          ),
        ),
        if (selected != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            selected.name,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            selected.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              _Chip(
                                label: selected.isOpenNow
                                    ? loc.locationOpenLabel
                                    : loc.locationClosedLabel,
                                color: selected.isOpenNow
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.error,
                              ),
                              _Chip(
                                label: loc.locationSlotsLabel(
                                  selected.availableSlots,
                                  selected.totalSlots,
                                ),
                                color: selected.availableSlots == 0
                                    ? theme.colorScheme.error
                                    : theme.colorScheme.secondary,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: widget.onDetailsTap,
                      child: Text(loc.detailsAction),
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

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
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
