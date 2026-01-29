import 'package:flutter/material.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../core/drop_locations.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../services/reminder_service.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';
import '../../ui/components/app_section_header.dart';
import '../../ui/components/app_error_state.dart';
import '../../core/profile_avatar_cache.dart';
import '../../core/ios/ios_config_service.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../dashboard/widgets/active_trip_card.dart';
import '../dashboard/widgets/campaign_carousel.dart';
import '../dashboard/widgets/dashboard_search_bar.dart';
import '../dashboard/widgets/dashboard_top_bar.dart';
import '../dashboard/widgets/nearby_locations_carousel.dart';
import '../dashboard/widgets/quick_actions_grid.dart';
import '../support/support_chat_page.dart';
import '../wallet/wallet_page.dart';
import '../campaigns/campaigns_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final HomeController _controller;

  String? _profileError;
  String? _luggageError;
  String? _locationError;
  bool _profileLoading = false;
  bool _homeMapReady = false;
  DropLocation? _homeMapSelected;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(_onControllerChanged);
    if (defaultTargetPlatform != TargetPlatform.iOS) {
      _homeMapReady = true;
    } else {
      _checkHomeMapKey();
    }
    _loadLocations();
    _restoreUserIdThenLoad();
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _loadLocations() async {
    if (!mounted) return;
    setState(() => _locationError = null);
    try {
      await _controller.loadLocations();
    } catch (e) {
      if (!mounted) return;
      setState(() => _locationError = e.toString());
    }
  }

  Future<void> _restoreUserIdThenLoad() async {
    if (!mounted) return;
    setState(() => _profileError = null);
    try {
      await _controller.restoreUserId();
      if (!mounted) return;
      if (_controller.userId == null || _controller.userId!.isEmpty) {
        setState(() => _profileError = 'Missing user id');
        return;
      }
      await ProfileAvatarCache.load(_controller.userId);
      await _loadProfile(_controller.userId!);
      await _loadLuggages(_controller.userId!);
    } catch (e) {
      if (!mounted) return;
      setState(() => _profileError = e.toString());
    }
  }

  Future<void> _loadProfile(String userId) async {
    if (!mounted) return;
    setState(() {
      _profileLoading = true;
      _profileError = null;
    });
    String? errorMessage;
    try {
      await _controller.loadProfile(userId);
    } catch (e) {
      errorMessage = e.toString();
    }
    if (!mounted) return;
    if (errorMessage != null) {
      setState(() => _profileError = errorMessage);
    }
    setState(() => _profileLoading = false);
  }

  Future<void> _loadLuggages(String userId) async {
    if (!mounted) return;
    setState(() => _luggageError = null);
    try {
      await _controller.loadUserLuggages(userId);
    } catch (e) {
      if (!mounted) return;
      setState(() => _luggageError = e.toString());
    }
  }

  void _snack(String message, {AppNotificationType type = AppNotificationType.info}) {
    AppNotification.show(context, message: message, type: type);
  }

  Future<void> _openAddLuggage() async {
    if (_controller.userId == null || _controller.userId!.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.loginRequired, type: AppNotificationType.warning);
      return;
    }
    final newLuggage = await context.push<LuggageModel>('/luggage/add');

    if (newLuggage != null) {
      if (!mounted) return;
      _controller.upsertLuggage(newLuggage);
      ReminderService.scheduleReminders(
        context,
        label: newLuggage.displayLabel,
        dropTime: newLuggage.scheduledDropTime,
        pickupTime: newLuggage.scheduledPickupTime,
      );
      final loc = AppLocalizations.of(context)!;
      _snack(loc.luggageCreated, type: AppNotificationType.success);
      await _loadLocations();
    }
  }

  void _openLuggageCenter() {
    context.push('/luggage');
  }

  void _openQrPreview(LuggageModel luggage) {
    context.push('/luggage/${luggage.id}/qr', extra: luggage);
  }

  void _openLocationDetails(DropLocation location) {
    context.push('/home/location/${location.id}');
  }

  Future<void> _checkHomeMapKey() async {
    if (defaultTargetPlatform != TargetPlatform.iOS) return;
    final hasKey = await IosConfigService.hasGmsApiKey();
    if (!mounted) return;
    setState(() => _homeMapReady = hasKey);
    if (!hasKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        AppNotification.show(
          context,
          message: AppLocalizations.of(context)!.mapsMissingApiKey,
          type: AppNotificationType.warning,
        );
      });
    }
  }

  List<QuickActionItem> _buildQuickActions(AppLocalizations loc) {
    return [
      QuickActionItem(
        label: loc.quickAddLuggage,
        icon: Icons.add_box_rounded,
        onTap: _openAddLuggage,
      ),
      QuickActionItem(
        label: loc.quickActionScanQr,
        icon: Icons.qr_code_rounded,
        onTap: () => context.push('/qr/scan'),
      ),
      QuickActionItem(
        label: loc.quickActionCashback,
        icon: Icons.credit_card_rounded,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WalletPage()),
        ),
      ),
      QuickActionItem(
        label: loc.quickActionReservation,
        icon: Icons.event_available_rounded,
        onTap: () {
          context.go('/explore');
        },
      ),
      QuickActionItem(
        label: loc.quickActionSupport,
        icon: Icons.support_agent_rounded,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SupportChatPage()),
          );
        },
      ),
      QuickActionItem(
        label: loc.quickActionCampaigns,
        icon: Icons.local_activity_rounded,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const CampaignsPage()),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final displayName = _controller.currentUser == null
        ? loc.travelerPlaceholder
        : '${_controller.currentUser!.name} ${_controller.currentUser!.surname}'
            .trim();
    final latestLuggage =
        _controller.luggages.isNotEmpty ? _controller.luggages.first : null;
    final nearbyLocations = _controller.locations.take(6).toList();

    final campaigns = [
      CampaignItem(
        title: loc.campaignCityWelcomeTitle,
        subtitle: loc.campaignCityWelcomeSubtitle,
        tag: loc.campaignNewTag,
      ),
      CampaignItem(
        title: loc.campaignWeekendTitle,
        subtitle: loc.campaignWeekendSubtitle,
        tag: loc.campaignHotTag,
      ),
      CampaignItem(
        title: loc.campaignAirportTitle,
        subtitle: loc.campaignAirportSubtitle,
        tag: loc.campaignBonusTag,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            if (_controller.userId != null) {
              await _loadProfile(_controller.userId!);
              await _loadLuggages(_controller.userId!);
            }
            await _loadLocations();
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            children: [
              ValueListenableBuilder<String?>(
                valueListenable: ProfileAvatarCache.notifier,
                builder: (context, avatarPath, _) {
                  return DashboardTopBar(
                    title: loc.dashboardGreeting(displayName),
                    subtitle: loc.dashboardSubtitle,
                    onAvatarTap: () => context.go('/profile'),
                    avatarPath: avatarPath,
                  );
                },
              ),
              const SizedBox(height: 16),
              DashboardSearchBar(
                hintText: loc.findLocation,
                onTap: () => context.go('/explore'),
              ),
              const SizedBox(height: 18),
              QuickActionsGrid(actions: _buildQuickActions(loc)),
              const SizedBox(height: 18),
              if (_homeMapReady)
                _HomeMapCard(
                  title: loc.map,
                  subtitle: loc.mapIntro,
                  locations: _controller.locations,
                  selected: _homeMapSelected,
                  onSelect: (location) =>
                      setState(() => _homeMapSelected = location),
                  onOpenDetails: _openLocationDetails,
                  onOpenExplore: () => context.go('/explore'),
                )
              else
                SectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.map_outlined),
                    title: Text(loc.map),
                    subtitle: Text(loc.mapsMissingApiKey),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.go('/explore'),
                  ),
                ),
              const SizedBox(height: 20),
              AppSectionHeader(
                title: loc.activeTripTitle,
                actionLabel: loc.seeAllAction,
                onAction: () => context.push('/luggage'),
              ),
              const SizedBox(height: 12),
              ActiveTripCard(
                title: loc.myLuggages,
                subtitle: loc.luggagesSectionSubtitle,
                loading: _controller.luggageLoading,
                errorMessage: _luggageError,
                onRetry: () {
                  final userId = _controller.userId;
                  if (userId != null) _loadLuggages(userId);
                },
                luggage: latestLuggage,
                onShowQr: () {
                  if (latestLuggage != null) _openQrPreview(latestLuggage);
                },
                onDetails: _openLuggageCenter,
                emptyLabel: loc.luggageEmptyStateNoItems,
                emptyActionLabel: loc.quickAddLuggage,
                onEmptyAction: _openAddLuggage,
              ),
              const SizedBox(height: 20),
              AppSectionHeader(
                title: loc.nearbyLocationsTitle,
                actionLabel: loc.seeAllAction,
                onAction: () => context.go('/explore'),
              ),
              const SizedBox(height: 12),
              NearbyLocationsCarousel(
                loading: _controller.locationsLoading,
                errorMessage: _locationError,
                locations: nearbyLocations,
                onRetry: _loadLocations,
                onLocationTap: _openLocationDetails,
                emptyLabel: loc.mapNoLocations,
              ),
              const SizedBox(height: 20),
              AppSectionHeader(
                title: loc.campaignsTitle,
                actionLabel: loc.seeAllAction,
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CampaignsPage()),
                  );
                },
              ),
              const SizedBox(height: 12),
              CampaignCarousel(
                loading: false,
                errorMessage: null,
                items: campaigns,
                onRetry: () {},
                emptyLabel: loc.campaignsEmptyState,
              ),
              const SizedBox(height: 20),
              SectionCard(
                child: _IconActionCard(
                  title: loc.myLuggages,
                  subtitle: loc.luggagesSectionSubtitle,
                  icon: Icons.luggage_outlined,
                  accent: const Color(0xFF5B7CFA),
                  onTap: _openLuggageCenter,
                ),
              ),
              if (_profileLoading)
                const SizedBox(height: 16)
              else if (_profileError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: AppErrorState(
                    message: _profileError!,
                    onRetry: () {
                      final userId = _controller.userId;
                      if (userId != null) _loadProfile(userId);
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeMapCard extends StatelessWidget {
  const _HomeMapCard({
    required this.title,
    required this.subtitle,
    required this.locations,
    required this.selected,
    required this.onSelect,
    required this.onOpenDetails,
    required this.onOpenExplore,
  });

  final String title;
  final String subtitle;
  final List<DropLocation> locations;
  final DropLocation? selected;
  final ValueChanged<DropLocation> onSelect;
  final ValueChanged<DropLocation> onOpenDetails;
  final VoidCallback onOpenExplore;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (locations.isEmpty) {
      return SectionCard(
        child: ListTile(
          leading: const Icon(Icons.map_outlined),
          title: Text(title),
          subtitle: Text(AppLocalizations.of(context)!.mapNoLocations),
          trailing: const Icon(Icons.chevron_right),
          onTap: onOpenExplore,
        ),
      );
    }
    final initial = selected?.position ?? locations.first.position;
    final markers = locations.map((location) {
      return Marker(
        markerId: MarkerId(location.id),
        position: location.position,
        infoWindow: InfoWindow(
          title: location.name,
          snippet: location.address,
          onTap: () => onOpenDetails(location),
        ),
        onTap: () => onSelect(location),
      );
    }).toSet();

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            icon: Icons.map_outlined,
            action: TextButton(
              onPressed: onOpenExplore,
              child: Text(AppLocalizations.of(context)!.seeAllAction),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: initial,
                  zoom: 12.2,
                ),
                markers: markers,
                zoomControlsEnabled: false,
                myLocationButtonEnabled: false,
                onTap: (_) => onSelect(locations.first),
                onLongPress: (_) => onOpenExplore(),
                mapToolbarEnabled: false,
              ),
            ),
          ),
          if (selected != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selected!.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          selected!.address,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => onOpenDetails(selected!),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _IconActionCard extends StatelessWidget {
  const _IconActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          children: [
            Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.2),
                    accent.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(icon, color: accent, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
