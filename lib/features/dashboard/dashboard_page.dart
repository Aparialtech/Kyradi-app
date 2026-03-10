import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../core/drop_locations.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../services/reminder_service.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';
import '../../widgets/app_mesh_background.dart';
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
  GoogleMapController? _homeMapController;
  late final HomeController _controller;

  String? _profileError;
  String? _luggageError;
  String? _locationError;
  bool _profileLoading = false;
  bool _homeMapReady = false;
  DropLocation? _homeMapSelected;
  bool _expandMap = false;
  bool _expandLuggage = false;
  bool _expandNearby = false;
  bool _expandCampaigns = false;
  double _walletBalance = 0;

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
    _loadWalletBalance();
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

  Future<void> _loadWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _walletBalance = prefs.getDouble('wallet_balance') ?? 0);
  }

  Future<void> _zoomInHomeMap() async {
    final controller = _homeMapController;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.zoomIn());
  }

  Future<void> _zoomOutHomeMap() async {
    final controller = _homeMapController;
    if (controller == null) return;
    await controller.animateCamera(CameraUpdate.zoomOut());
  }

  void _snack(
    String message, {
    AppNotificationType type = AppNotificationType.info,
  }) {
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
        onTap: () => Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const WalletPage())),
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
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const SupportChatPage()));
        },
      ),
      QuickActionItem(
        label: loc.quickActionCampaigns,
        icon: Icons.local_activity_rounded,
        onTap: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const CampaignsPage()));
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
    final latestLuggage = _controller.luggages.isNotEmpty
        ? _controller.luggages.first
        : null;
    LuggageModel? activeLuggage;
    for (final item in _controller.luggages) {
      if (item.status == LuggageStatus.awaitingDrop ||
          item.status == LuggageStatus.dropped) {
        activeLuggage = item;
        break;
      }
    }
    final nearbyLocations = _controller.locations.take(6).toList();
    final activeCount = _controller.luggages
        .where(
          (item) =>
              item.status == LuggageStatus.awaitingDrop ||
              item.status == LuggageStatus.dropped,
        )
        .length;

    final campaigns = [
      CampaignItem(
        title: 'Kahve Dünyası Hediyesi',
        subtitle: 'İlk rezervasyonuna özel 1 kahve ücretsiz.',
        tag: loc.campaignNewTag,
        icon: Icons.local_cafe_outlined,
        gradient: [const Color(0xFF8B5E34), const Color(0xFFD9A15A)],
      ),
      CampaignItem(
        title: '3+ Gün %50 İndirim',
        subtitle: '3 gün ve üzeri rezervasyonlarda yarı fiyat.',
        tag: loc.campaignHotTag,
        icon: Icons.local_offer_outlined,
        gradient: [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
      ),
      CampaignItem(
        title: 'Boyner %10 İndirim',
        subtitle: 'Boyner mağazalarında ekstra avantaj.',
        tag: loc.campaignBonusTag,
        icon: Icons.shopping_bag_outlined,
        gradient: [const Color(0xFF7C3AED), const Color(0xFFA78BFA)],
      ),
      CampaignItem(
        title: 'Kyradi Vadi & Axis',
        subtitle: 'Vadi İstanbul ve Axis AVM’de hizmetinizde.',
        tag: 'YENİ NOKTA',
        icon: Icons.location_on_outlined,
        gradient: [const Color(0xFF0F766E), const Color(0xFF5EEAD4)],
      ),
      CampaignItem(
        title: 'Öğrenci %30 İndirim',
        subtitle: 'Edu mail ile kayıt ol, %30 indirim kazan.',
        tag: 'GENÇ',
        icon: Icons.school_outlined,
        gradient: [const Color(0xFFB45309), const Color(0xFFF59E0B)],
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AppMeshBackground(),
          SafeArea(
            child: RefreshIndicator(
              onRefresh: () async {
                if (_controller.userId != null) {
                  await _loadProfile(_controller.userId!);
                  await _loadLuggages(_controller.userId!);
                }
                await _loadWalletBalance();
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
                  _PremiumHeroPanel(
                    walletBalance: _walletBalance,
                    totalCount: _controller.luggages.length,
                    activeCount: activeCount,
                    locationCount: _controller.locations.length,
                    activeLuggage: activeLuggage,
                    onTicketTap: _openLuggageCenter,
                    onTicketQrTap: () {
                      if (activeLuggage != null) {
                        _openQrPreview(activeLuggage);
                      }
                    },
                    onPrimaryTap: _openAddLuggage,
                    onSecondaryTap: () => context.go('/explore'),
                  ),
                  const SizedBox(height: 14),
                  DashboardSearchBar(
                    hintText: loc.findLocation,
                    onTap: () => context.go('/explore'),
                  ),
                  const SizedBox(height: 14),
                  QuickActionsGrid(actions: _buildQuickActions(loc)),
                  const SizedBox(height: 12),
                  _DashboardFoldSection(
                    title: loc.map,
                    subtitle: 'Harita ve rota paneli',
                    icon: Icons.map_outlined,
                    expanded: _expandMap,
                    onToggle: () => setState(() => _expandMap = !_expandMap),
                    actionLabel: loc.seeAllAction,
                    onAction: () => context.go('/explore'),
                    child: _homeMapReady
                        ? _HomeMapCard(
                            title: loc.map,
                            subtitle: loc.mapIntro,
                            locations: _controller.locations,
                            selected: _homeMapSelected,
                            onSelect: (location) =>
                                setState(() => _homeMapSelected = location),
                            onOpenDetails: _openLocationDetails,
                            onOpenExplore: () => context.go('/explore'),
                            onMapCreated: (controller) =>
                                _homeMapController = controller,
                            onZoomIn: _zoomInHomeMap,
                            onZoomOut: _zoomOutHomeMap,
                            showHeader: false,
                          )
                        : SectionCard(
                            child: ListTile(
                              leading: const Icon(Icons.map_outlined),
                              title: Text(loc.map),
                              subtitle: Text(loc.mapsMissingApiKey),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () => context.go('/explore'),
                            ),
                          ),
                  ),
                  const SizedBox(height: 12),
                  _DashboardFoldSection(
                    title: loc.activeTripTitle,
                    subtitle: 'Aktif bavul ve QR islemleri',
                    icon: Icons.luggage_outlined,
                    expanded: _expandLuggage,
                    onToggle: () =>
                        setState(() => _expandLuggage = !_expandLuggage),
                    actionLabel: loc.seeAllAction,
                    onAction: () => context.push('/luggage'),
                    child: ActiveTripCard(
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
                        if (latestLuggage != null) {
                          _openQrPreview(latestLuggage);
                        }
                      },
                      onDetails: _openLuggageCenter,
                      emptyLabel: loc.luggageEmptyStateNoItems,
                      emptyActionLabel: loc.quickAddLuggage,
                      onEmptyAction: _openAddLuggage,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DashboardFoldSection(
                    title: loc.nearbyLocationsTitle,
                    subtitle: 'Yakindaki noktalar ve uygunluk',
                    icon: Icons.place_outlined,
                    expanded: _expandNearby,
                    onToggle: () =>
                        setState(() => _expandNearby = !_expandNearby),
                    actionLabel: loc.seeAllAction,
                    onAction: () => context.go('/explore'),
                    child: NearbyLocationsCarousel(
                      loading: _controller.locationsLoading,
                      errorMessage: _locationError,
                      locations: nearbyLocations,
                      onRetry: _loadLocations,
                      onLocationTap: _openLocationDetails,
                      emptyLabel: loc.mapNoLocations,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _DashboardFoldSection(
                    title: loc.campaignsTitle,
                    subtitle: 'Avantajlar ve kampanyalar',
                    icon: Icons.local_activity_outlined,
                    expanded: _expandCampaigns,
                    onToggle: () =>
                        setState(() => _expandCampaigns = !_expandCampaigns),
                    actionLabel: loc.seeAllAction,
                    onAction: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CampaignsPage(),
                        ),
                      );
                    },
                    child: CampaignCarousel(
                      loading: false,
                      errorMessage: null,
                      items: campaigns,
                      onRetry: () {},
                      emptyLabel: loc.campaignsEmptyState,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SectionCard(
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const ThreeDIconBadge(
                        icon: Icons.auto_awesome_outlined,
                      ),
                      title: Text(
                        loc.howItWorksTitle,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      subtitle: Text(loc.howItWorksIntro, maxLines: 2),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/home/how-it-works'),
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
        ],
      ),
    );
  }
}

class _PremiumHeroPanel extends StatelessWidget {
  const _PremiumHeroPanel({
    required this.walletBalance,
    required this.totalCount,
    required this.activeCount,
    required this.locationCount,
    required this.activeLuggage,
    required this.onTicketTap,
    required this.onTicketQrTap,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final double walletBalance;
  final int totalCount;
  final int activeCount;
  final int locationCount;
  final LuggageModel? activeLuggage;
  final VoidCallback onTicketTap;
  final VoidCallback onTicketQrTap;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF0B1C34), Color(0xFF103864), Color(0xFF0F766E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0C4D84).withValues(alpha: 0.3),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -8,
              right: 16,
              child: Container(
                width: 120,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.18),
                      Colors.white.withValues(alpha: 0),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.14),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        color: Color(0xFF8FFBFF),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'SuperApp Cuzdan Bakiyesi',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.84),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${walletBalance.toStringAsFixed(2)} ₺',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onSecondaryTap,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 9,
                        ),
                      ),
                      icon: const Icon(Icons.map_outlined, size: 18),
                      label: const Text('Harita'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _HeroStat(label: 'Bavul', value: '$totalCount'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroStat(label: 'Aktif', value: '$activeCount'),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _HeroStat(
                        label: 'Lokasyon',
                        value: '$locationCount',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (activeLuggage != null) ...[
                  _ReservationTicketCard(
                    luggage: activeLuggage!,
                    onDetailsTap: onTicketTap,
                    onQrTap: onTicketQrTap,
                  ),
                  const SizedBox(height: 12),
                ],
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0E425E),
                      minimumSize: const Size.fromHeight(48),
                    ),
                    onPressed: onPrimaryTap,
                    icon: const Icon(Icons.add_box_rounded),
                    label: Text(
                      activeLuggage == null
                          ? 'Ilk Bavulunu Olustur'
                          : 'Yeni Bavul Ekle',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ReservationTicketCard extends StatelessWidget {
  const _ReservationTicketCard({
    required this.luggage,
    required this.onDetailsTap,
    required this.onQrTap,
  });

  final LuggageModel luggage;
  final VoidCallback onDetailsTap;
  final VoidCallback onQrTap;

  int get _stepIndex {
    switch (luggage.status) {
      case LuggageStatus.awaitingDrop:
        return 1;
      case LuggageStatus.dropped:
        return 2;
      case LuggageStatus.pickedUp:
        return 3;
      case LuggageStatus.cancelled:
        return 0;
    }
  }

  String _formatTime(DateTime? value) {
    if (value == null) return '--';
    final local = value.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '$day.$month $hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ticketTone = luggage.status == LuggageStatus.dropped
        ? const Color(0xFF2DD4BF)
        : const Color(0xFF60A5FA);
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF0A1628).withValues(alpha: 0.68),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Aktif Bavul Rezervasyonu',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: ticketTone.withValues(alpha: 0.22),
                ),
                child: Text(
                  luggage.statusLabel,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: ticketTone,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            luggage.displayLabel,
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            luggage.dropLocationName.isEmpty
                ? 'Lokasyon bekleniyor'
                : luggage.dropLocationName,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.white.withValues(alpha: 0.78),
            ),
          ),
          const SizedBox(height: 12),
          _TicketProgressLine(activeStep: _stepIndex),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _TicketMeta(
                  label: 'Teslim',
                  value: _formatTime(luggage.scheduledDropTime),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TicketMeta(
                  label: 'Alis',
                  value: _formatTime(luggage.scheduledPickupTime),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TicketMeta(
                  label: 'Ucret',
                  value: luggage.totalPrice == null
                      ? '--'
                      : '${luggage.totalPrice} ₺',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.28),
                    ),
                  ),
                  onPressed: onQrTap,
                  icon: const Icon(Icons.qr_code_rounded, size: 18),
                  label: const Text('QR'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF0F2744),
                  ),
                  onPressed: onDetailsTap,
                  child: const Text('Detay'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TicketProgressLine extends StatelessWidget {
  const _TicketProgressLine({required this.activeStep});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    const labels = ['Rezervasyon', 'Teslim', 'Alis'];
    return Row(
      children: List.generate(labels.length, (index) {
        final step = index + 1;
        final completed = activeStep >= step;
        final isLast = index == labels.length - 1;
        return Expanded(
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: completed ? const Color(0xFF2DD4BF) : Colors.white12,
                  border: Border.all(
                    color: completed
                        ? const Color(0xFF67E8F9)
                        : Colors.white.withValues(alpha: 0.24),
                  ),
                ),
                child: Icon(
                  completed ? Icons.check_rounded : Icons.circle,
                  size: completed ? 12 : 8,
                  color: completed ? const Color(0xFF05283B) : Colors.white30,
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(
                      alpha: completed ? 0.95 : 0.6,
                    ),
                    fontWeight: completed ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (!isLast)
                Container(
                  width: 16,
                  height: 2,
                  margin: const EdgeInsets.only(left: 4, right: 6),
                  color: completed
                      ? const Color(0xFF2DD4BF).withValues(alpha: 0.9)
                      : Colors.white24,
                ),
            ],
          ),
        );
      }),
    );
  }
}

class _TicketMeta extends StatelessWidget {
  const _TicketMeta({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white.withValues(alpha: 0.08),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardFoldSection extends StatelessWidget {
  const _DashboardFoldSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.expanded,
    required this.onToggle,
    required this.child,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final bool expanded;
  final VoidCallback onToggle;
  final Widget child;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.surface.withValues(alpha: 0.94),
            theme.colorScheme.surface.withValues(alpha: 0.86),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.72)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withValues(alpha: 0.2),
                          theme.colorScheme.primary.withValues(alpha: 0.06),
                        ],
                      ),
                    ),
                    child: Icon(
                      icon,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          subtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (actionLabel != null && onAction != null)
                    TextButton(onPressed: onAction, child: Text(actionLabel!)),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: child,
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 220),
            sizeCurve: Curves.easeOutCubic,
          ),
        ],
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
    required this.onMapCreated,
    required this.onZoomIn,
    required this.onZoomOut,
    this.showHeader = true,
  });

  final String title;
  final String subtitle;
  final List<DropLocation> locations;
  final DropLocation? selected;
  final ValueChanged<DropLocation> onSelect;
  final ValueChanged<DropLocation> onOpenDetails;
  final VoidCallback onOpenExplore;
  final ValueChanged<GoogleMapController> onMapCreated;
  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final bool showHeader;

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
          if (showHeader) ...[
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
          ],
          SizedBox(
            height: 220,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  GoogleMap(
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
                    zoomGesturesEnabled: true,
                    scrollGesturesEnabled: true,
                    onMapCreated: onMapCreated,
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Column(
                      children: [
                        _ZoomButton(icon: Icons.add, onTap: onZoomIn),
                        const SizedBox(height: 8),
                        _ZoomButton(icon: Icons.remove, onTap: onZoomOut),
                      ],
                    ),
                  ),
                ],
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
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.6,
                  ),
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
