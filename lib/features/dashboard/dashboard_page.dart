import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home/controllers/home_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../services/reminder_service.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';
import '../../widgets/app_mesh_background.dart';
import '../../ui/components/app_error_state.dart';
import '../../core/profile_avatar_cache.dart';
import 'package:go_router/go_router.dart';
import '../dashboard/widgets/dashboard_top_bar.dart';
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
  bool _profileLoading = false;
  double _walletBalance = 0;

  @override
  void initState() {
    super.initState();
    _controller = HomeController();
    _controller.addListener(_onControllerChanged);
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
    try {
      await _controller.loadLocations();
    } catch (_) {}
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
    try {
      await _controller.loadUserLuggages(userId);
    } catch (e) {
      // Home page should stay resilient; luggages are optional here.
    }
  }

  Future<void> _loadWalletBalance() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() => _walletBalance = prefs.getDouble('wallet_balance') ?? 0);
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
    LuggageModel? activeLuggage;
    for (final item in _controller.luggages) {
      if (item.status == LuggageStatus.awaitingDrop ||
          item.status == LuggageStatus.dropped) {
        activeLuggage = item;
        break;
      }
    }
    final activeCount = _controller.luggages
        .where(
          (item) =>
              item.status == LuggageStatus.awaitingDrop ||
              item.status == LuggageStatus.dropped,
        )
        .length;

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
                  const SizedBox(height: 16),
                  QuickActionsGrid(actions: _buildQuickActions(loc)),
                  const SizedBox(height: 14),
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
                            'SuperApp Cüzdan Bakiyesi',
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
                          ? 'İlk Bavulunu Oluştur'
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
