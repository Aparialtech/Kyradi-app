import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../core/drop_locations.dart';
import '../../l10n/app_localizations.dart';
import '../../services/locations_service.dart';
import '../../screens/location_reservation_page.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';
import 'widgets/explore_filter_sheet.dart';
import 'widgets/explore_toggle_bar.dart';
import 'widgets/explore_top_bar.dart';
import 'widgets/location_list_card.dart';
import 'widgets/location_map_view.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  bool _showMap = false;
  bool _loading = false;
  String? _errorMessage;
  List<DropLocation> _locations = [];
  Position? _currentPosition;
  bool _openNow = false;
  bool _availableOnly = false;
  bool _activeOnly = true;
  String _query = '';
  DropLocation? _selectedLocation;
  final Map<String, Marker> _markerCache = {};

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _loadPosition();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchLocations() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });
    String? errorMessage;
    try {
      final remote = await LocationsService.fetchLocations();
      if (!mounted) return;
      setState(() {
        _locations =
            remote.isNotEmpty ? remote : DropLocationsRepository.locations;
        _syncMarkers(_locations);
      });
    } catch (e) {
      errorMessage = e.toString();
    }
    if (!mounted) return;
    if (errorMessage != null) {
      setState(() => _errorMessage = errorMessage);
    }
    setState(() => _loading = false);
  }

  Future<void> _loadPosition() async {
    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission resolved = permission;
      if (permission == LocationPermission.denied) {
        resolved = await Geolocator.requestPermission();
      }
      if (resolved == LocationPermission.denied ||
          resolved == LocationPermission.deniedForever) {
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (!mounted) return;
      setState(() => _currentPosition = position);
    } catch (_) {}
  }

  List<DropLocation> get _filteredLocations {
    final normalized = _query.trim().toLowerCase();
    final filtered = _locations.where((location) {
      if (_activeOnly && !location.isActive) return false;
      if (_openNow && !location.isOpenNow) return false;
      if (_availableOnly && location.availableSlots <= 0) return false;
      if (normalized.isEmpty) return true;
      return location.name.toLowerCase().contains(normalized) ||
          location.address.toLowerCase().contains(normalized);
    }).toList();

    if (_currentPosition != null) {
      filtered.sort((a, b) {
        final distA = _distanceFor(a) ?? 0;
        final distB = _distanceFor(b) ?? 0;
        return distA.compareTo(distB);
      });
    } else {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }
    return filtered;
  }

  void _syncMarkers(List<DropLocation> locations) {
    for (final location in locations) {
      final lat = location.position.latitude;
      final lng = location.position.longitude;
      if (lat == 0 && lng == 0) {
        continue;
      }
      if (!lat.isFinite || !lng.isFinite) {
        // Prevent iOS crash by skipping invalid coordinates.
        continue;
      }
      _markerCache.putIfAbsent(
        location.id,
        () => Marker(
          markerId: MarkerId(location.id),
          position: location.position,
          onTap: () => setState(() => _selectedLocation = location),
        ),
      );
    }
  }

  double? _distanceFor(DropLocation location) {
    final pos = _currentPosition;
    if (pos == null) return null;
    final meters = Geolocator.distanceBetween(
      pos.latitude,
      pos.longitude,
      location.position.latitude,
      location.position.longitude,
    );
    return meters / 1000.0;
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) {
        return ExploreFilterSheet(
          openNow: _openNow,
          availableOnly: _availableOnly,
          activeOnly: _activeOnly,
          onApply: ({required openNow, required availableOnly, required activeOnly}) {
            Navigator.pop(context);
            setState(() {
              _openNow = openNow;
              _availableOnly = availableOnly;
              _activeOnly = activeOnly;
            });
          },
          onClear: () {
            Navigator.pop(context);
            setState(() {
              _openNow = false;
              _availableOnly = false;
              _activeOnly = true;
            });
          },
        );
      },
    );
  }

  void _openLocationDetail(DropLocation location) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocationReservationPage(locationId: location.id),
      ),
    );
  }

  Widget _buildErrorState() {
    return AppErrorState(
      message: _errorMessage ?? 'Error',
      onRetry: _fetchLocations,
    );
  }

  Widget _buildEmptyState(String message) {
    return AppEmptyState(
      title: message,
      subtitle: 'Try adjusting filters.',
    );
  }

  Widget _buildListView(List<DropLocation> locations) {
    if (_loading) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: 6,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: AppSkeleton(height: 120, radius: 20),
        ),
      );
    }
    if (_errorMessage != null) {
      return _buildErrorState();
    }
    if (locations.isEmpty) {
      return _buildEmptyState('No locations found.');
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: locations.length,
      itemBuilder: (context, index) {
        final location = locations[index];
        return LocationListCard(
          location: location,
          distanceKm: _distanceFor(location),
          onTap: () => _openLocationDetail(location),
        );
      },
    );
  }

  Widget _buildMapView(List<DropLocation> locations) {
    if (_loading) {
      return const AppSkeleton(radius: 0);
    }
    if (_errorMessage != null) {
      return _buildErrorState();
    }
    if (locations.isEmpty) {
      return _buildEmptyState('No locations found.');
    }

    final center = _currentPosition == null
        ? locations.first.position
        : LatLng(_currentPosition!.latitude, _currentPosition!.longitude);

    final markerSet = {
      for (final location in locations)
        _markerCache[location.id] ??
            Marker(
              markerId: MarkerId(location.id),
              position: location.position,
              onTap: () => setState(() => _selectedLocation = location),
            ),
    };

    return LocationMapView(
      markers: markerSet,
      selectedLocation: _selectedLocation,
      onMarkerTap: (location) => setState(() => _selectedLocation = location),
      onDetailsTap: () {
        final selected = _selectedLocation;
        if (selected != null) _openLocationDetail(selected);
      },
      center: center,
      showMyLocation: _currentPosition != null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final locations = _filteredLocations;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.findLocation),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                ExploreTopBar(
                  controller: _searchCtrl,
                  hintText: loc.findLocation,
                  onFilterTap: _openFilterSheet,
                  onChanged: (value) => setState(() => _query = value),
                ),
                const SizedBox(height: 12),
                ExploreToggleBar(
                  showMap: _showMap,
                  onChanged: (value) => setState(() => _showMap = value),
                  listLabel: 'List',
                  mapLabel: 'Map',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _showMap
                  ? _buildMapView(locations)
                  : _buildListView(locations),
            ),
          ),
        ],
      ),
    );
  }
}
