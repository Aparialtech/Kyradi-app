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
import 'widgets/filter_chips_row.dart';
import 'widgets/glass_search_bar.dart';
import 'widgets/explore_filter_sheet.dart';
import 'widgets/explore_toggle_bar.dart';
import 'widgets/explore_top_bar.dart';
import 'widgets/location_list_card.dart';
import 'widgets/location_bottom_sheet.dart';
import 'widgets/location_map_view.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchCtrl = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _showMap = false;
  bool _loading = false;
  String? _errorMessage;
  List<DropLocation> _locations = [];
  Position? _currentPosition;
  bool _openNow = false;
  bool _availableOnly = false;
  bool _activeOnly = true;
  bool _nearbyOnly = false;
  bool _alwaysOpenOnly = false;
  bool _sortCheapest = false; // UI stub until price data is available.
  String _query = '';
  DropLocation? _selectedLocation;
  GoogleMapController? _mapController;
  RouteMode _routeMode = RouteMode.drive;
  int _page = 1;
  static const int _pageSize = 6;
  ExploreSort _sort = ExploreSort.nearby;

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _loadPosition();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _searchFocusNode.dispose();
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
        _locations = remote.isNotEmpty
            ? remote
            : DropLocationsRepository.locations;
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
    await _ensureCurrentPosition(showError: false);
  }

  Future<bool> _ensureCurrentPosition({required bool showError}) async {
    try {
      final permission = await Geolocator.checkPermission();
      LocationPermission resolved = permission;
      if (permission == LocationPermission.denied) {
        resolved = await Geolocator.requestPermission();
      }
      if (resolved == LocationPermission.denied ||
          resolved == LocationPermission.deniedForever) {
        if (showError && mounted) {
          final loc = AppLocalizations.of(context);
          final message = resolved == LocationPermission.deniedForever
              ? (loc?.permissionDeniedForever(loc.permissionNameLocation) ??
                    'Konum izni kalici olarak kapatildi.')
              : (loc?.permissionDenied(loc.permissionNameLocation) ??
                    'Konum izni gerekli.');
          AppNotification.show(
            context,
            message: message,
            type: AppNotificationType.warning,
          );
        }
        return false;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      if (!mounted) return false;
      setState(() => _currentPosition = position);
      return true;
    } catch (_) {
      if (showError && mounted) {
        final loc = AppLocalizations.of(context);
        AppNotification.show(
          context,
          message: loc?.exploreEmptyTitle ?? 'Konum bilgisi alinamadi.',
          type: AppNotificationType.warning,
        );
      }
      return false;
    }
  }

  Future<void> _toggleNearbyFilter() async {
    if (_nearbyOnly) {
      setState(() => _nearbyOnly = false);
      return;
    }
    final hasPosition = await _ensureCurrentPosition(showError: true);
    if (!mounted) return;
    if (!hasPosition) return;
    setState(() => _nearbyOnly = true);
  }

  List<DropLocation> get _filteredLocations {
    final normalized = _query.trim().toLowerCase();
    final filtered = _locations.where((location) {
      if (_activeOnly && !location.isActive) return false;
      if (_openNow && !location.isOpenNow) return false;
      if (_availableOnly && location.availableSlots <= 0) return false;
      if (_nearbyOnly) {
        final distance = _distanceFor(location);
        if (distance == null || distance > 5) return false;
      }
      if (_alwaysOpenOnly && !_isAlwaysOpen(location)) return false;
      if (normalized.isEmpty) return true;
      return location.name.toLowerCase().contains(normalized) ||
          location.address.toLowerCase().contains(normalized);
    }).toList();

    return filtered;
  }

  List<DropLocation> _sortedLocations(List<DropLocation> items) {
    final list = List<DropLocation>.from(items);
    if (_sortCheapest) {
      list.sort((a, b) {
        final rateA = _priceProxyFor(a);
        final rateB = _priceProxyFor(b);
        return rateA.compareTo(rateB);
      });
      return list;
    }
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

  bool _isAlwaysOpen(DropLocation location) {
    if (location.openingHours.isEmpty) return true;
    const dayKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
    for (final key in dayKeys) {
      final ranges = location.openingHours[key];
      if (ranges == null || ranges.isEmpty) return false;
      final hasFullDay = ranges.any(
        (range) => range.start == '00:00' && range.end == '23:59',
      );
      if (!hasFullDay) return false;
    }
    return true;
  }

  double _priceProxyFor(DropLocation location) {
    final occupancyPenalty = location.occupancyRate * 100;
    final slotsBonus = location.availableSlots * 2.5;
    return (100 - slotsBonus) + occupancyPenalty;
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
          onApply:
              ({
                required openNow,
                required availableOnly,
                required activeOnly,
              }) {
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
        appLog(
          'map',
          'MAP_PREFLIGHT_FAIL missing_api_key',
          level: AppLogLevel.warn,
        );
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
    final appleUri = Uri.parse('http://maps.apple.com/?daddr=$lat,$lng');
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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(loc.mapsOpenFailed)));
  }

  Future<void> _centerOnMyLocation() async {
    final hasPosition = await _ensureCurrentPosition(showError: true);
    if (!mounted || !hasPosition) return;
    final controller = _mapController;
    final current = _currentPosition;
    if (controller == null || current == null) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(current.latitude, current.longitude),
          zoom: 14.2,
        ),
      ),
    );
  }

  Future<void> _focusLocation(DropLocation location) async {
    setState(() => _selectedLocation = location);
    final controller = _mapController;
    if (controller == null) return;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location.position, zoom: 14.8),
      ),
    );
  }

  Future<void> _callSupport() async {
    final uri = Uri.parse('tel:+905000000000');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Set<Marker> _buildMapMarkers(List<DropLocation> locations) {
    final selectedId = _selectedLocation?.id;
    return {
      for (final location in locations)
        Marker(
          markerId: MarkerId(location.id),
          position: location.position,
          zIndexInt: selectedId == location.id ? 2 : 1,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            selectedId == location.id
                ? BitmapDescriptor.hueAzure
                : location.availableSlots > 0
                ? BitmapDescriptor.hueCyan
                : BitmapDescriptor.hueViolet,
          ),
          infoWindow: InfoWindow(
            title: location.name,
            snippet: '${location.availableSlots} slot',
          ),
          onTap: () => _focusLocation(location),
        ),
    };
  }

  Widget _buildSearchSuggestions(List<DropLocation> locations) {
    final suggestions = _sortedLocations(locations).take(4).toList();
    if (!_searchFocusNode.hasFocus) return const SizedBox.shrink();
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Material(
        color: Colors.white.withValues(alpha: 0.90),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 260),
          child: ListView.separated(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 6),
            itemCount: suggestions.length,
            separatorBuilder: (_, __) => Divider(
              height: 1,
              color: const Color(0xFFCBD5E1).withValues(alpha: 0.5),
            ),
            itemBuilder: (context, index) {
              final location = suggestions[index];
              return ListTile(
                leading: const Icon(Icons.location_on_outlined, size: 20),
                title: Text(
                  location.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  location.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  _searchCtrl.text = location.name;
                  _searchCtrl.selection = TextSelection.collapsed(
                    offset: _searchCtrl.text.length,
                  );
                  _query = location.name;
                  _searchFocusNode.unfocus();
                  _focusLocation(location);
                },
              );
            },
          ),
        ),
      ),
    );
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
    final selected = _selectedLocation;
    final chips = <ExploreFilterChipData>[
      ExploreFilterChipData(
        label: 'Yakınımda',
        icon: Icons.near_me_outlined,
        selected: _nearbyOnly,
        onTap: _toggleNearbyFilter,
      ),
      ExploreFilterChipData(
        label: 'Müsait',
        icon: Icons.check_circle_outline_rounded,
        selected: _availableOnly,
        onTap: () => setState(() => _availableOnly = !_availableOnly),
      ),
      ExploreFilterChipData(
        label: 'En ucuz',
        icon: Icons.savings_outlined,
        selected: _sortCheapest,
        onTap: () => setState(() {
          _sortCheapest = !_sortCheapest;
          if (_sortCheapest) _sort = ExploreSort.nearby;
        }),
      ),
      ExploreFilterChipData(
        label: 'En yakın',
        icon: Icons.route_outlined,
        selected: _sort == ExploreSort.nearby && !_sortCheapest,
        onTap: () => setState(() {
          _sortCheapest = false;
          _sort = ExploreSort.nearby;
        }),
      ),
      ExploreFilterChipData(
        label: '24 saat',
        icon: Icons.schedule_outlined,
        selected: _alwaysOpenOnly,
        onTap: () => setState(() => _alwaysOpenOnly = !_alwaysOpenOnly),
      ),
      ExploreFilterChipData(
        label: 'Bagaj kapasitesi',
        icon: Icons.inventory_2_outlined,
        selected: _sort == ExploreSort.availability,
        onTap: () => setState(() {
          _sortCheapest = false;
          _sort = ExploreSort.availability;
        }),
      ),
    ];

    return Stack(
      children: [
        Positioned.fill(
          child: LocationMapView(
            markers: _buildMapMarkers(locations),
            center: center,
            showMyLocation: _currentPosition != null,
            onRecenterTap: _centerOnMyLocation,
            onMapCreated: (controller) {
              _mapController = controller;
              appLog('map', 'MAP_OPEN_START', level: AppLogLevel.info);
            },
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 8,
          child: SafeArea(
            bottom: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _MapBackButton(
                      onTap: () => setState(() => _showMap = false),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Harita',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                GlassSearchBar(
                  controller: _searchCtrl,
                  focusNode: _searchFocusNode,
                  hintText: 'Konum ara / Otel ara',
                  onChanged: (value) => setState(() {
                    _query = value;
                    _page = 1;
                  }),
                  onLocateTap: _centerOnMyLocation,
                ),
                const SizedBox(height: 10),
                FilterChipsRow(chips: chips),
                const SizedBox(height: 8),
                _buildSearchSuggestions(locations),
              ],
            ),
          ),
        ),
        if (selected != null)
          Positioned.fill(
            child: LocationBottomSheet(
              location: selected,
              distanceKm: _distanceFor(selected),
              routeMode: _routeMode,
              onRouteModeChanged: (value) => setState(() => _routeMode = value),
              onReserve: () => context.push('/luggage/add'),
              onDirections: () => _openDirections(selected),
              onCall: _callSupport,
              onDetails: () => _openLocationDetail(selected),
            ),
          )
        else
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: SafeArea(
              top: false,
              child: _MapGuideCard(
                onPickNearest: locations.isEmpty
                    ? null
                    : () => setState(() => _selectedLocation = locations.first),
                onBackToList: () => setState(() => _showMap = false),
              ),
            ),
          ),
      ],
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
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 240),
              child: _showMap
                  ? _buildMapView(sorted)
                  : Column(
                      key: const ValueKey('explore-list'),
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
                                  _sortCheapest = false;
                                  _sort = value;
                                  _page = 1;
                                }),
                              ),
                            ],
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(child: _buildListView(paged, filtered.length)),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapBackButton extends StatelessWidget {
  const _MapBackButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Material(
          color: Colors.white.withValues(alpha: 0.72),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(22),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Color(0xFF0F172A),
            ),
          ),
        ),
      ),
    );
  }
}

class _MapGuideCard extends StatelessWidget {
  const _MapGuideCard({
    required this.onPickNearest,
    required this.onBackToList,
  });

  final VoidCallback? onPickNearest;
  final VoidCallback onBackToList;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withValues(alpha: 0.86),
        border: Border.all(color: Colors.white.withValues(alpha: 0.95)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Haritada bir nokta sec',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Detaylari acip direkt rezervasyon baslatabilirsin.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          FilledButton.tonal(
            onPressed: onBackToList,
            child: const Text('Liste'),
          ),
          const SizedBox(width: 8),
          FilledButton(onPressed: onPickNearest, child: const Text('En yakin')),
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
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withValues(alpha: 0.62),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.place_outlined,
            size: 17,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            loc.exploreResultsCount(totalCount),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          DropdownButtonHideUnderline(
            child: DropdownButton<ExploreSort>(
              value: selected,
              borderRadius: BorderRadius.circular(14),
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
          ),
        ],
      ),
    );
  }
}
