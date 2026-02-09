import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/drop_locations.dart';
import '../../l10n/app_localizations.dart';
import '../../services/locations_service.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';
import '../../widgets/app_notification.dart';
import '../../utils/crash_log.dart';
import '../../core/ios/ios_config_service.dart';
import '../../widgets/app_mesh_background.dart';
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
  int _page = 1;
  static const int _pageSize = 6;
  ExploreSort _sort = ExploreSort.nearby;

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

    return filtered;
  }

  List<DropLocation> _sortedLocations(List<DropLocation> items) {
    final list = List<DropLocation>.from(items);
    switch (_sort) {
      case ExploreSort.nearby:
        list.sort((a, b) {
          final distA = _distanceFor(a) ?? double.infinity;
          final distB = _distanceFor(b) ?? double.infinity;
          return distA.compareTo(distB);
        });
        break;
      case ExploreSort.name:
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case ExploreSort.availability:
        list.sort((a, b) => b.availableSlots.compareTo(a.availableSlots));
        break;
    }
    return list;
  }

  List<DropLocation> _pagedLocations(List<DropLocation> items) {
    final max = _page * _pageSize;
    if (items.length <= max) return items;
    return items.take(max).toList();
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
              _page = 1;
            });
          },
          onClear: () {
            Navigator.pop(context);
            setState(() {
              _openNow = false;
              _availableOnly = false;
              _activeOnly = true;
              _page = 1;
            });
          },
        );
      },
    );
  }

  Future<void> _handleMapToggle(bool value) async {
    appLog('map', 'MAP_TAP', level: AppLogLevel.info);
    if (!value) {
      setState(() => _showMap = false);
      return;
    }
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      final hasKey = await IosConfigService.hasGmsApiKey();
      if (!mounted) return;
      if (!hasKey) {
        appLog('map', 'MAP_PREFLIGHT_FAIL missing_api_key',
            level: AppLogLevel.warn);
        AppNotification.show(
          context,
          message: AppLocalizations.of(context)!.mapsMissingApiKey,
          type: AppNotificationType.warning,
        );
        setState(() => _showMap = false);
        return;
      }
    }
    appLog('map', 'MAP_PREFLIGHT_OK', level: AppLogLevel.info);
    setState(() => _showMap = true);
  }

  void _openLocationDetail(DropLocation location) {
    context.push('/explore/location/${location.id}');
  }

  Widget _buildErrorState() {
    final loc = AppLocalizations.of(context)!;
    return AppErrorState(
      message: _errorMessage ?? loc.genericErrorMessage,
      onRetry: _fetchLocations,
    );
  }

  Widget _buildEmptyState(String message) {
    final loc = AppLocalizations.of(context)!;
    return AppEmptyState(
      title: message,
      subtitle: loc.exploreEmptySubtitle,
      actionLabel: loc.retryAction,
      onAction: _fetchLocations,
    );
  }

  Widget _buildListView(List<DropLocation> locations, int totalCount) {
    final loc = AppLocalizations.of(context)!;
    if (_loading) {
      return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        itemCount: 3,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: AppSkeleton(height: 140, radius: 20),
        ),
      );
    }
    if (_errorMessage != null) {
      return _buildErrorState();
    }
    if (locations.isEmpty) {
      return _buildEmptyState(loc.exploreEmptyTitle);
    }
    final hasMore = locations.length < totalCount;
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: locations.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (hasMore && index == locations.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Center(
              child: OutlinedButton.icon(
                onPressed: () => setState(() => _page += 1),
                icon: const Icon(Icons.expand_more),
                label: Text(loc.exploreShowMore),
              ),
            ),
          );
        }
        final location = locations[index];
        return LocationListCard(
          location: location,
          distanceKm: _distanceFor(location),
          onTap: () => _openLocationDetail(location),
          onDetails: () => _openLocationDetail(location),
          onDirections: () => _openDirections(location),
        );
      },
    );
  }

  Future<void> _openDirections(DropLocation location) async {
    final loc = AppLocalizations.of(context)!;
    final lat = location.position.latitude;
    final lng = location.position.longitude;
    final googleUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng',
    );
    final appleUri = Uri.parse(
      'http://maps.apple.com/?daddr=$lat,$lng',
    );
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;

    if (isIos) {
      if (await launchUrl(appleUri, mode: LaunchMode.externalApplication)) {
        return;
      }
      if (await launchUrl(googleUri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } else {
      if (await launchUrl(googleUri, mode: LaunchMode.externalApplication)) {
        return;
      }
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(loc.mapsOpenFailed)));
  }

  Widget _buildMapView(List<DropLocation> locations) {
    final loc = AppLocalizations.of(context)!;
    if (_loading) {
      return const AppSkeleton(radius: 0);
    }
    if (_errorMessage != null) {
      return _buildErrorState();
    }
    if (locations.isEmpty) {
      return _buildEmptyState(loc.exploreEmptyTitle);
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
      onMapCreated: (_) {
        appLog('map', 'MAP_OPEN_START', level: AppLogLevel.info);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final filtered = _filteredLocations;
    final sorted = _sortedLocations(filtered);
    final paged = _pagedLocations(sorted);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                  child: Column(
                    children: [
                      ExploreTopBar(
                        controller: _searchCtrl,
                        hintText: loc.findLocation,
                        title: loc.findLocation,
                        subtitle: 'Yakındaki KYRADI noktalarını keşfet',
                        onFilterTap: _openFilterSheet,
                        onChanged: (value) => setState(() {
                          _query = value;
                          _page = 1;
                        }),
                      ),
                      const SizedBox(height: 12),
                      ExploreToggleBar(
                        showMap: _showMap,
                        onChanged: _handleMapToggle,
                        listLabel: 'Liste',
                        mapLabel: 'Harita',
                      ),
                      const SizedBox(height: 12),
                      _SortBar(
                        selected: _sort,
                        totalCount: filtered.length,
                        onChanged: (value) => setState(() {
                          _sort = value;
                          _page = 1;
                        }),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: _showMap
                        ? _buildMapView(sorted)
                        : _buildListView(paged, filtered.length),
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

enum ExploreSort { nearby, name, availability }

class _SortBar extends StatelessWidget {
  const _SortBar({
    required this.selected,
    required this.totalCount,
    required this.onChanged,
  });

  final ExploreSort selected;
  final int totalCount;
  final ValueChanged<ExploreSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Row(
      children: [
        Text(
          loc.exploreResultsCount(totalCount),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const Spacer(),
        DropdownButton<ExploreSort>(
          value: selected,
          underline: const SizedBox.shrink(),
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
          items: [
            DropdownMenuItem(
              value: ExploreSort.nearby,
              child: Text(loc.exploreSortNearby),
            ),
            DropdownMenuItem(
              value: ExploreSort.name,
              child: Text(loc.exploreSortName),
            ),
            DropdownMenuItem(
              value: ExploreSort.availability,
              child: Text(loc.exploreSortAvailability),
            ),
          ],
        ),
      ],
    );
  }
}
