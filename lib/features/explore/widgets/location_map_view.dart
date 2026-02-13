import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../utils/crash_log.dart';

class LocationMapView extends StatefulWidget {
  const LocationMapView({
    super.key,
    required this.markers,
    required this.center,
    required this.showMyLocation,
    this.onMapCreated,
    this.onRecenterTap,
  });

  final Set<Marker> markers;
  final LatLng center;
  final bool showMyLocation;
  final ValueChanged<GoogleMapController>? onMapCreated;
  final VoidCallback? onRecenterTap;

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
    return Stack(
      children: [
        Positioned.fill(
          child: GoogleMap(
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
                appLog('map', 'MAP_ERROR onMapCreated $e', level: AppLogLevel.error);
              }
            },
            compassEnabled: false,
            mapToolbarEnabled: false,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
          ),
        ),
        Positioned(
          top: 116,
          right: 16,
          child: SafeArea(
            child: Column(
              children: [
                _GlassRoundButton(
                  icon: Icons.add,
                  onTap: _zoomIn,
                  semanticLabel: 'Haritayi yaklastir',
                ),
                const SizedBox(height: 8),
                _GlassRoundButton(
                  icon: Icons.remove,
                  onTap: _zoomOut,
                  semanticLabel: 'Haritayi uzaklastir',
                ),
                const SizedBox(height: 8),
                _GlassRoundButton(
                  icon: Icons.my_location_outlined,
                  onTap: widget.onRecenterTap,
                  semanticLabel: 'Konumuma git',
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GlassRoundButton extends StatelessWidget {
  const _GlassRoundButton({
    required this.icon,
    required this.onTap,
    required this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel,
      child: SizedBox(
        width: 44,
        height: 44,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: const SizedBox.expand(),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.7),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(22),
                  child: Icon(icon, size: 19, color: const Color(0xFF0F172A)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
