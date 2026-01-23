import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/drop_locations.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../services/reminder_service.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';
import '../../ui/components/app_section_header.dart';
import '../../ui/components/app_error_state.dart';
import '../dashboard/widgets/active_trip_card.dart';
import '../dashboard/widgets/campaign_carousel.dart';
import '../dashboard/widgets/dashboard_search_bar.dart';
import '../dashboard/widgets/dashboard_top_bar.dart';
import '../dashboard/widgets/nearby_locations_carousel.dart';
import '../dashboard/widgets/quick_actions_grid.dart';
import '../../screens/home_page.dart';
import '../../screens/location_reservation_page.dart';
import '../wallet/wallet_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final Random _random = Random();
  late final HomeController _controller;

  String? _profileError;
  String? _luggageError;
  String? _locationError;
  bool _profileLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(_onControllerChanged);
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

  String _generateQrCode() {
    final stamp =
        DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    final suffix = (_random.nextInt(9000) + 1000).toString();
    return 'BGO-$stamp-$suffix';
  }

  String _generatePickupPin() {
    return (_random.nextInt(9000) + 1000).toString();
  }

  Future<void> _openAddLuggage() async {
    if (_controller.userId == null || _controller.userId!.isEmpty) {
      final loc = AppLocalizations.of(context)!;
      _snack(loc.loginRequired, type: AppNotificationType.warning);
      return;
    }
    final newLuggage = await Navigator.push<LuggageModel?>(
      context,
      MaterialPageRoute(
        builder: (_) => AddLuggagePage(
          userId: _controller.userId!,
          qrGenerator: _generateQrCode,
          pickupPinGenerator: _generatePickupPin,
          ownerName:
              '${_controller.currentUser?.name ?? ''} ${_controller.currentUser?.surname ?? ''}'
                  .trim(),
          ownerPhone: _controller.currentUser?.phone,
          ownerEmail: _controller.currentUser?.email,
        ),
      ),
    );

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

  void _openClassicPanel() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const HomePage(),
      ),
    );
  }

  void _openQrPreview(LuggageModel luggage) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QrPreviewPage(luggage: luggage),
        fullscreenDialog: true,
      ),
    );
  }

  void _openLocationDetails(DropLocation location) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LocationReservationPage(locationId: location.id),
      ),
    );
  }

  List<QuickActionItem> _buildQuickActions(AppLocalizations loc) {
    return [
      QuickActionItem(
        label: loc.quickAddLuggage,
        icon: Icons.add_box_outlined,
        onTap: _openAddLuggage,
      ),
      QuickActionItem(
        label: 'Scan QR',
        icon: Icons.qr_code_scanner,
        onTap: _openClassicPanel,
      ),
      QuickActionItem(
        label: 'Cashback',
        icon: Icons.savings_outlined,
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const WalletPage()),
        ),
      ),
      QuickActionItem(
        label: 'Reservation',
        icon: Icons.event_available_outlined,
        onTap: () {
          final location = _controller.locations.isNotEmpty
              ? _controller.locations.first
              : DropLocationsRepository.locations.first;
          _openLocationDetails(location);
        },
      ),
      QuickActionItem(
        label: 'Support',
        icon: Icons.support_agent_outlined,
        onTap: () {
          _snack('Support is coming soon', type: AppNotificationType.info);
        },
      ),
      QuickActionItem(
        label: 'Campaigns',
        icon: Icons.local_offer_outlined,
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
      const CampaignItem(
        title: 'City Welcome',
        subtitle: 'Get 10% back on your first booking.',
        tag: 'NEW',
      ),
      const CampaignItem(
        title: 'Weekend Storage',
        subtitle: 'Save on weekend drop-offs.',
        tag: 'HOT',
      ),
      const CampaignItem(
        title: 'Airport Drop',
        subtitle: 'Extra points for airport locations.',
        tag: 'BONUS',
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
              DashboardTopBar(
                title: loc.dashboardGreeting(displayName),
                subtitle: loc.dashboardSubtitle,
                onAvatarTap: _openClassicPanel,
              ),
              const SizedBox(height: 16),
              DashboardSearchBar(
                hintText: loc.findLocation,
                onTap: _openClassicPanel,
              ),
              const SizedBox(height: 18),
              QuickActionsGrid(actions: _buildQuickActions(loc)),
              const SizedBox(height: 20),
              AppSectionHeader(
                title: 'Active trip',
                actionLabel: 'See all',
                onAction: _openClassicPanel,
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
                onDetails: _openClassicPanel,
                emptyLabel: loc.luggageEmptyStateNoItems,
                emptyActionLabel: loc.quickAddLuggage,
                onEmptyAction: _openAddLuggage,
              ),
              const SizedBox(height: 20),
              AppSectionHeader(
                title: loc.nearbyLocationsTitle,
                actionLabel: 'See all',
                onAction: _openClassicPanel,
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
                title: 'Campaigns',
                actionLabel: 'See all',
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
                emptyLabel: 'No campaigns available.',
              ),
              const SizedBox(height: 20),
              SectionCard(
                child: ListTile(
                  leading: const Icon(Icons.dashboard_customize_outlined),
                  title: const Text('Kyradi Classic'),
                  subtitle: const Text('Open the detailed panel'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _openClassicPanel,
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

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Campaigns')),
      body: const Center(
        child: Text('Campaigns are coming soon.'),
      ),
    );
  }
}
