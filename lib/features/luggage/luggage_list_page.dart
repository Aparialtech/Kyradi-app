import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../core/repositories/luggage_repository.dart';
import '../../models/luggage.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/crash_log.dart';
import 'package:go_router/go_router.dart';
import '../../services/local_notification_service.dart';
import '../../widgets/app_notification.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';
import '../../widgets/section_card.dart';
import '../../widgets/app_mesh_background.dart';
import 'widgets/active_luggage_bottom_sheet.dart';
import 'widgets/luggage_color_icon.dart';

class LuggageListPage extends StatefulWidget {
  const LuggageListPage({super.key});

  @override
  State<LuggageListPage> createState() => _LuggageListPageState();
}

class _LuggageListPageState extends State<LuggageListPage> {
  final LuggageRepository _repo = const LuggageRepository();
  final TextEditingController _searchCtrl = TextEditingController();
  Timer? _statusRefreshTimer;
  bool _statusSnapshotInitialized = false;
  final Map<String, LuggageStatus> _knownStatuses = <String, LuggageStatus>{};
  bool _loading = true;
  String? _error;
  bool _canceling = false;
  List<LuggageModel> _items = [];
  String? _userId;
  String _query = '';
  LuggageStatus? _statusFilter;
  String? _paymentFilter;
  String? _locationFilter;
  String? _sizeFilter;
  LuggageSort _sort = LuggageSort.date;
  int _page = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _load();
    _startStatusRefresh();
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _startStatusRefresh() {
    _statusRefreshTimer?.cancel();
    _statusRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      _refreshStatusesSilently();
    });
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final id = prefs.getString('userId');
      _userId = id;
      if (id == null || id.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'USER_ID_MISSING';
        });
        return;
      }
      final luggages = await _repo.getUserLuggages(id);
      final changedItems = _captureStatusChanges(
        luggages,
        notify: _statusSnapshotInitialized,
      );
      if (!mounted) return;
      setState(() {
        _items = luggages;
        _page = 1;
        _loading = false;
      });
      _statusSnapshotInitialized = true;
      if (changedItems.isNotEmpty) {
        await _notifyStatusChanges(changedItems);
      }
    } catch (e) {
      appLog('luggage', 'load failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _refreshStatusesSilently() async {
    final id = _userId;
    if (id == null || id.isEmpty) return;
    try {
      final luggages = await _repo.getUserLuggages(id);
      final changedItems = _captureStatusChanges(
        luggages,
        notify: _statusSnapshotInitialized,
      );
      if (!mounted) return;
      setState(() => _items = luggages);
      _statusSnapshotInitialized = true;
      if (changedItems.isNotEmpty) {
        await _notifyStatusChanges(changedItems);
      }
    } catch (_) {
      // Keep UI stable; silent refresh failures should not interrupt user flow.
    }
  }

  List<LuggageModel> _captureStatusChanges(
    List<LuggageModel> nextItems, {
    required bool notify,
  }) {
    final changed = <LuggageModel>[];
    if (notify) {
      for (final item in nextItems) {
        final previous = _knownStatuses[item.id];
        if (previous != null && previous != item.status) {
          changed.add(item);
        }
      }
    }
    _knownStatuses
      ..clear()
      ..addEntries(nextItems.map((e) => MapEntry(e.id, e.status)));
    return changed;
  }

  Future<void> _notifyStatusChanges(List<LuggageModel> changedItems) async {
    for (final item in changedItems) {
      await LocalNotificationService.instance.showLuggageStatusUpdated(
        reservationLabel: item.displayLabel,
        statusLabel: item.statusLabel,
      );
    }
  }

  void _openDetail(LuggageModel luggage) {
    context.push('/luggage/${luggage.id}', extra: luggage);
  }

  List<LuggageModel> get _filteredItems {
    final q = _query.trim().toLowerCase();
    final filtered = _items.where((item) {
      if (_statusFilter != null && item.status != _statusFilter) {
        return false;
      }
      if (_paymentFilter != null &&
          (item.paymentStatus ?? '').toLowerCase() != _paymentFilter) {
        return false;
      }
      if (_locationFilter != null &&
          item.dropLocationName.toLowerCase() != _locationFilter) {
        return false;
      }
      if (_sizeFilter != null &&
          (item.size ?? '').toLowerCase() != _sizeFilter) {
        return false;
      }
      if (q.isEmpty) return true;
      return item.displayLabel.toLowerCase().contains(q) ||
          item.qrCode.toLowerCase().contains(q) ||
          item.dropLocationName.toLowerCase().contains(q);
    }).toList();

    switch (_sort) {
      case LuggageSort.status:
        filtered.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
      case LuggageSort.location:
        filtered.sort(
          (a, b) => a.dropLocationName.compareTo(b.dropLocationName),
        );
        break;
      case LuggageSort.payment:
        filtered.sort(
          (a, b) => (a.paymentStatus ?? '').compareTo(b.paymentStatus ?? ''),
        );
        break;
      case LuggageSort.date:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }
    return filtered;
  }

  List<LuggageModel> get _pagedItems {
    final items = _filteredItems;
    final max = _page * _pageSize;
    if (items.length <= max) return items;
    return items.take(max).toList();
  }

  LuggageModel? get _activeLuggage {
    final active =
        _items
            .where(
              (item) =>
                  item.status == LuggageStatus.awaitingDrop ||
                  item.status == LuggageStatus.dropped,
            )
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (active.isEmpty) return null;
    return active.first;
  }

  int get _activeCount => _items
      .where(
        (item) =>
            item.status == LuggageStatus.awaitingDrop ||
            item.status == LuggageStatus.dropped,
      )
      .length;

  Future<void> _openAddLuggageFlow() async {
    final loc = AppLocalizations.of(context)!;
    final result = await context.push('/luggage/add');
    if (!context.mounted) return;
    if (result is LuggageModel) {
      setState(() {
        _items = [result, ..._items];
      });
      AppNotification.show(
        context,
        message: loc.luggageCreated,
        type: AppNotificationType.success,
      );
    }
  }

  void _openFilters() {
    final loc = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        var status = _statusFilter;
        var payment = _paymentFilter;
        var location = _locationFilter;
        var size = _sizeFilter;
        final locations =
            _items.map((e) => e.dropLocationName.toLowerCase()).toSet().toList()
              ..sort();
        final sizes =
            _items
                .map((e) => (e.size ?? '').toLowerCase())
                .where((e) => e.isNotEmpty)
                .toSet()
                .toList()
              ..sort();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                loc.luggageFilterTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LuggageStatus>(
                value: status,
                decoration: InputDecoration(labelText: loc.luggageFilterStatus),
                items: [
                  DropdownMenuItem(value: null, child: Text(loc.allLabel)),
                  DropdownMenuItem(
                    value: LuggageStatus.awaitingDrop,
                    child: Text(loc.luggageStatusAwaitingDrop),
                  ),
                  DropdownMenuItem(
                    value: LuggageStatus.dropped,
                    child: Text(loc.luggageStatusDropped),
                  ),
                  DropdownMenuItem(
                    value: LuggageStatus.pickedUp,
                    child: Text(loc.luggageStatusPickedUp),
                  ),
                  DropdownMenuItem(
                    value: LuggageStatus.cancelled,
                    child: Text(loc.luggageStatusCancelled),
                  ),
                ],
                onChanged: (value) => status = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: payment,
                decoration: InputDecoration(
                  labelText: loc.luggageFilterPayment,
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(loc.allLabel)),
                  DropdownMenuItem(
                    value: paymentStatusPaid,
                    child: Text(loc.paymentStatusPaid),
                  ),
                  DropdownMenuItem(
                    value: paymentStatusPending,
                    child: Text(loc.paymentStatusPending),
                  ),
                  DropdownMenuItem(
                    value: paymentStatusFailed,
                    child: Text(loc.paymentStatusFailed),
                  ),
                  DropdownMenuItem(
                    value: paymentStatusUnpaid,
                    child: Text(loc.paymentStatusUnpaid),
                  ),
                ],
                onChanged: (value) => payment = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: location,
                decoration: InputDecoration(
                  labelText: loc.luggageFilterLocation,
                ),
                items: [
                  DropdownMenuItem(value: null, child: Text(loc.allLabel)),
                  for (final locName in locations)
                    DropdownMenuItem(value: locName, child: Text(locName)),
                ],
                onChanged: (value) => location = value,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: size,
                decoration: InputDecoration(labelText: loc.luggageFilterSize),
                items: [
                  DropdownMenuItem(value: null, child: Text(loc.allLabel)),
                  for (final sizeValue in sizes)
                    DropdownMenuItem(value: sizeValue, child: Text(sizeValue)),
                ],
                onChanged: (value) => size = value,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _statusFilter = null;
                        _paymentFilter = null;
                        _locationFilter = null;
                        _sizeFilter = null;
                        _page = 1;
                      });
                    },
                    child: Text(loc.luggageFilterReset),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _statusFilter = status;
                        _paymentFilter = payment;
                        _locationFilter = location;
                        _sizeFilter = size;
                        _page = 1;
                      });
                    },
                    child: Text(loc.luggageFilterApply),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _cancelLuggage(LuggageModel luggage) async {
    final loc = AppLocalizations.of(context)!;
    appLog(
      'luggage',
      'LUGGAGE_CANCEL_TAP id=${luggage.id}',
      level: AppLogLevel.info,
    );
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.cancelReservationTitle),
        content: Text(loc.cancelReservationMessage(luggage.displayLabel)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(loc.dialogDismiss),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(loc.dialogConfirmCancel),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    if (!mounted || _canceling) return;
    setState(() {
      _canceling = true;
    });
    appLog(
      'luggage',
      'LUGGAGE_CANCEL_START id=${luggage.id}',
      level: AppLogLevel.info,
    );
    try {
      final res = await _repo
          .cancel(_userId!, luggage.id)
          .timeout(const Duration(seconds: 20));
      if (!mounted) return;
      if (res['ok'] == true && res['luggage'] is Map) {
        final updated = LuggageModel.fromJson(
          Map<String, dynamic>.from(res['luggage'] as Map),
        );
        setState(() {
          _items = _items.map((e) => e.id == updated.id ? updated : e).toList();
        });
        await LocalNotificationService.instance.showReservationCancelled(
          updated.displayLabel,
        );
        AppNotification.show(
          context,
          message: loc.reservationCancelledMessage,
          type: AppNotificationType.success,
        );
        appLog(
          'luggage',
          'LUGGAGE_CANCEL_OK id=${luggage.id}',
          level: AppLogLevel.info,
        );
      } else {
        final msg = (res['error'] ?? res['message'] ?? 'CANCEL_FAILED')
            .toString();
        AppNotification.show(
          context,
          message: msg.isNotEmpty ? msg : loc.cancelFailed,
          type: AppNotificationType.error,
        );
        appLog(
          'luggage',
          'LUGGAGE_CANCEL_ERR id=${luggage.id} msg=$msg',
          level: AppLogLevel.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.cancelFailed,
        type: AppNotificationType.error,
      );
      appLog(
        'luggage',
        'LUGGAGE_CANCEL_ERR id=${luggage.id} err=$e',
        level: AppLogLevel.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _canceling = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final filtered = _filteredItems;
    final paged = _pagedItems;
    final hasMore = paged.length < filtered.length;
    final activeLuggage = _activeLuggage;
    final showActiveSheet =
        !_loading &&
        _error == null &&
        activeLuggage != null &&
        _items.isNotEmpty;
    final activeSheetBottom = MediaQuery.viewPaddingOf(context).bottom + 14;
    const activeSheetPeekHeight = 108.0;
    final listBottomPadding = showActiveSheet
        ? activeSheetBottom + activeSheetPeekHeight + 24
        : 32.0;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(loc.myLuggages),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: _items.isEmpty ? null : _openFilters,
          ),
        ],
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, listBottomPadding),
              children: [
                SectionCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchCtrl,
                        onChanged: (value) => setState(() {
                          _query = value;
                          _page = 1;
                        }),
                        decoration: InputDecoration(
                          labelText: loc.luggageSearchHint,
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _query.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    _searchCtrl.clear();
                                    setState(() {
                                      _query = '';
                                      _page = 1;
                                    });
                                  },
                                ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: [
                          DropdownButtonFormField<LuggageSort>(
                            value: _sort,
                            decoration: InputDecoration(
                              labelText: loc.luggageSortLabel,
                            ),
                            items: [
                              DropdownMenuItem(
                                value: LuggageSort.date,
                                child: Text(loc.luggageSortDate),
                              ),
                              DropdownMenuItem(
                                value: LuggageSort.status,
                                child: Text(loc.luggageSortStatus),
                              ),
                              DropdownMenuItem(
                                value: LuggageSort.location,
                                child: Text(loc.luggageSortLocation),
                              ),
                              DropdownMenuItem(
                                value: LuggageSort.payment,
                                child: Text(loc.luggageSortPayment),
                              ),
                            ],
                            onChanged: (value) {
                              if (value == null) return;
                              setState(() {
                                _sort = value;
                                _page = 1;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _LuggageQuickBar(
                  totalCount: _items.length,
                  activeCount: _activeCount,
                  onAdd: _openAddLuggageFlow,
                  onFilter: _items.isEmpty ? null : _openFilters,
                  onRefresh: _load,
                ),
                const SizedBox(height: 16),
                if (_loading) ...[
                  const SizedBox(height: 6),
                  Column(
                    children: List.generate(
                      3,
                      (index) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: AppSkeleton(height: 86, radius: 18),
                      ),
                    ),
                  ),
                ] else if (_error != null) ...[
                  AppErrorState(
                    message: _error == 'USER_ID_MISSING'
                        ? loc.userIdMissing
                        : _error!,
                    onRetry: _load,
                  ),
                ] else if (_items.isEmpty) ...[
                  AppEmptyState(
                    title: loc.myLuggages,
                    subtitle: loc.luggageEmptyStateNoItems,
                    actionLabel: loc.quickAddLuggage,
                    onAction: _openAddLuggageFlow,
                  ),
                ] else if (filtered.isEmpty) ...[
                  AppEmptyState(
                    title: loc.luggageNoResultsTitle,
                    subtitle: loc.luggageNoResultsSubtitle,
                    actionLabel: loc.luggageFilterReset,
                    onAction: () {
                      setState(() {
                        _query = '';
                        _searchCtrl.clear();
                        _statusFilter = null;
                        _paymentFilter = null;
                        _locationFilter = null;
                        _sizeFilter = null;
                        _page = 1;
                      });
                    },
                  ),
                ] else ...[
                  _buildCardView(context, loc, paged),
                  if (hasMore)
                    Center(
                      child: TextButton.icon(
                        onPressed: () => setState(() => _page += 1),
                        icon: const Icon(Icons.expand_more),
                        label: Text(loc.luggageShowMore),
                      ),
                    ),
                ],
              ],
            ),
          ),
          if (_canceling)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.15),
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
          if (showActiveSheet)
            Positioned(
              left: 12,
              right: 12,
              bottom: activeSheetBottom,
              child: SizedBox(
                height: (MediaQuery.sizeOf(context).height * 0.56).clamp(
                  360.0,
                  480.0,
                ),
                child: ActiveLuggageBottomSheet(
                  luggage: activeLuggage,
                  onDetails: () => _openDetail(activeLuggage),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardView(
    BuildContext context,
    AppLocalizations loc,
    List<LuggageModel> items,
  ) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return Column(
      children: items
          .map(
            (luggage) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _LuggageTicketCard(
                luggage: luggage,
                localeTag: locale,
                paymentLabel: _paymentStatusLabel(loc, luggage),
                onDetails: () => _openDetail(luggage),
                onCancel: () => _cancelLuggage(luggage),
                detailLabel: loc.detailsAction,
                cancelLabel: loc.luggageCancelAction,
                unknownTimeLabel: loc.luggageTimelineTimeUnknown,
              ),
            ),
          )
          .toList(),
    );
  }

  String _paymentStatusLabel(AppLocalizations loc, LuggageModel luggage) {
    final status = (luggage.paymentStatus ?? '').toLowerCase();
    switch (status) {
      case paymentStatusPaid:
        return loc.paymentStatusPaid;
      case paymentStatusPending:
        return loc.paymentStatusPending;
      case paymentStatusFailed:
        return loc.paymentStatusFailed;
      case paymentStatusUnpaid:
        return loc.paymentStatusUnpaid;
      default:
        return loc.paymentStatusUnknown;
    }
  }
}

class _LuggageQuickBar extends StatelessWidget {
  const _LuggageQuickBar({
    required this.totalCount,
    required this.activeCount,
    required this.onAdd,
    required this.onFilter,
    required this.onRefresh,
  });

  final int totalCount;
  final int activeCount;
  final VoidCallback onAdd;
  final VoidCallback? onFilter;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Hizli Islemler',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              _CountPill(
                label: 'Toplam',
                value: '$totalCount',
                accent: const Color(0xFF334155),
              ),
              const SizedBox(width: 6),
              _CountPill(
                label: 'Aktif',
                value: '$activeCount',
                accent: const Color(0xFF0F766E),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              if (compact) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _QuickBarButton.filled(
                            onPressed: onAdd,
                            icon: Icons.add_box_rounded,
                            label: 'Yeni Bavul',
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _QuickBarButton.outlined(
                            onPressed: onFilter,
                            icon: Icons.tune_rounded,
                            label: 'Filtrele',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: _QuickBarButton.outlined(
                        onPressed: () => onRefresh(),
                        icon: Icons.refresh_rounded,
                        label: 'Yenile',
                      ),
                    ),
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(
                    child: _QuickBarButton.filled(
                      onPressed: onAdd,
                      icon: Icons.add_box_rounded,
                      label: 'Yeni Bavul',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickBarButton.outlined(
                      onPressed: onFilter,
                      icon: Icons.tune_rounded,
                      label: 'Filtrele',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _QuickBarButton.outlined(
                      onPressed: () => onRefresh(),
                      icon: Icons.refresh_rounded,
                      label: 'Yenile',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _QuickBarButton extends StatelessWidget {
  const _QuickBarButton.filled({
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : _filled = true;

  const _QuickBarButton.outlined({
    required this.onPressed,
    required this.icon,
    required this.label,
  }) : _filled = false;

  final VoidCallback? onPressed;
  final IconData icon;
  final String label;
  final bool _filled;

  @override
  Widget build(BuildContext context) {
    final text = Text(
      label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontWeight: FontWeight.w700),
    );
    if (_filled) {
      return FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(46)),
        icon: Icon(icon, size: 18),
        label: text,
      );
    }
    return OutlinedButton.icon(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(46)),
      icon: Icon(icon, size: 18),
      label: text,
    );
  }
}

class _CountPill extends StatelessWidget {
  const _CountPill({
    required this.label,
    required this.value,
    required this.accent,
  });

  final String label;
  final String value;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: accent.withValues(alpha: 0.08),
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Row(
        children: [
          Text(
            '$label ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

enum LuggageSort { date, status, location, payment }

class _LuggageTicketCard extends StatelessWidget {
  const _LuggageTicketCard({
    required this.luggage,
    required this.localeTag,
    required this.paymentLabel,
    required this.onDetails,
    required this.onCancel,
    required this.detailLabel,
    required this.cancelLabel,
    required this.unknownTimeLabel,
  });

  final LuggageModel luggage;
  final String localeTag;
  final String paymentLabel;
  final VoidCallback onDetails;
  final VoidCallback onCancel;
  final String detailLabel;
  final String cancelLabel;
  final String unknownTimeLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = getLuggageColor(luggage.color);
    final softAccent = Color.lerp(accent, Colors.white, 0.2) ?? accent;
    final darkStart = Color.lerp(accent, const Color(0xFF0B1327), 0.78)!;
    final darkEnd = Color.lerp(accent, const Color(0xFF132B4A), 0.66)!;
    final headlineColor = accent.computeLuminance() > 0.8
        ? const Color(0xFF111827)
        : Colors.white;
    final dateLabel = DateFormat(
      'EEE dd MMM',
      localeTag,
    ).format(luggage.createdAt.toLocal());
    final dropTime = _formatTime(luggage.scheduledDropTime);
    final pickupTime = _formatTime(luggage.scheduledPickupTime);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
        boxShadow: [
          BoxShadow(
            color: darkStart.withValues(alpha: 0.26),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [darkStart, darkEnd],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      softAccent.withValues(alpha: 0.35),
                      softAccent.withValues(alpha: 0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      dateLabel,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: headlineColor.withValues(alpha: 0.92),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        luggage.statusLabel,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: _AirportCode(
                        code: _codeFromLocation(luggage.dropLocationName),
                        city: luggage.dropLocationName,
                      ),
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          color: Colors.white.withValues(alpha: 0.82),
                          size: 20,
                        ),
                        const SizedBox(height: 3),
                        Text(
                          _durationText(luggage),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.86),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: _AirportCode(
                        alignEnd: true,
                        code: luggage.displayLabel.length >= 3
                            ? luggage.displayLabel
                                  .replaceAll(' ', '')
                                  .toUpperCase()
                                  .substring(0, 3)
                            : 'BAG',
                        city: luggage.displayLabel,
                      ),
                    ),
                  ],
                ),
              ),
              Center(
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.04),
                        Colors.white.withValues(alpha: 0.18),
                        Colors.white.withValues(alpha: 0.04),
                      ],
                    ),
                  ),
                  child: Center(child: getLuggageIcon(luggage.color, size: 92)),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Column(
                  children: [
                    _TicketStatusTimeline(luggage: luggage),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _TicketInfoCell(
                            label: 'Drop',
                            value: dropTime,
                            valueColor: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: _TicketInfoCell(
                            label: 'Pick-up',
                            value: pickupTime,
                            valueColor: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: _TicketInfoCell(
                            label: 'Odeme',
                            value: paymentLabel,
                            valueColor: luggage.isPaymentPaid
                                ? const Color(0xFF34D399)
                                : const Color(0xFFFBBF24),
                            alignEnd: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onDetails,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.38),
                              ),
                            ),
                            icon: const Icon(Icons.info_outline, size: 18),
                            label: Text(detailLabel),
                          ),
                        ),
                        const SizedBox(width: 10),
                        IconButton(
                          tooltip: cancelLabel,
                          onPressed: onCancel,
                          icon: const Icon(Icons.delete_outline_rounded),
                          color: Colors.white70,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: Radius.circular(26),
                    bottomRight: Radius.circular(26),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFCBD5E1)),
                          ),
                          child: QrImageView(
                            data: luggage.qrCode.isNotEmpty
                                ? luggage.qrCode
                                : luggage.id,
                            version: QrVersions.auto,
                            eyeStyle: const QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: Color(0xFF0F172A),
                            ),
                            dataModuleStyle: const QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'QR Numarasi',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: const Color(0xFF64748B),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                luggage.qrCode.isEmpty ? '--' : luggage.qrCode,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  color: const Color(0xFF0F172A),
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                luggage.displayLabel,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: const Color(0xFF334155),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? value) {
    if (value == null) return unknownTimeLabel;
    return DateFormat('HH:mm', localeTag).format(value.toLocal());
  }

  String _durationText(LuggageModel item) {
    final start = item.scheduledDropTime;
    final end = item.scheduledPickupTime;
    if (start == null || end == null) return '--';
    final minutes = end.difference(start).inMinutes;
    if (minutes <= 0) return '--';
    final hours = minutes ~/ 60;
    final rest = minutes % 60;
    if (hours == 0) return '${rest}m';
    if (rest == 0) return '${hours}h';
    return '${hours}h ${rest}m';
  }

  String _codeFromLocation(String location) {
    final clean = location.trim();
    if (clean.isEmpty) return 'LOC';
    final words = clean
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (words.length >= 2) {
      final firstWord = words.first;
      final lastWord = words.last;
      final chars =
          '${firstWord[0]}${lastWord[0]}${firstWord[firstWord.length - 1]}'
              .toUpperCase();
      return chars.length >= 3 ? chars.substring(0, 3) : chars.padRight(3, 'X');
    }
    final single = words.first.toUpperCase().replaceAll(
      RegExp(r'[^A-Z0-9]'),
      '',
    );
    if (single.length >= 3) return single.substring(0, 3);
    return single.padRight(3, 'X');
  }
}

class _AirportCode extends StatelessWidget {
  const _AirportCode({
    required this.code,
    required this.city,
    this.alignEnd = false,
  });

  final String code;
  final String city;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          code,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          city,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.78),
          ),
        ),
      ],
    );
  }
}

class _TicketStatusTimeline extends StatelessWidget {
  const _TicketStatusTimeline({required this.luggage});

  final LuggageModel luggage;

  @override
  Widget build(BuildContext context) {
    final activeStep = _activeStepFromStatus(luggage.status);
    final isCancelled = luggage.status == LuggageStatus.cancelled;
    final steps = const <({String label, IconData icon})>[
      (label: 'Rezervasyon', icon: Icons.check_circle_outline_rounded),
      (label: 'Teslim', icon: Icons.inventory_2_outlined),
      (label: 'Alis', icon: Icons.move_to_inbox_outlined),
    ];

    return Column(
      children: [
        Row(
          children: List.generate(steps.length, (index) {
            final done = !isCancelled && index < activeStep;
            final active =
                !isCancelled && index == activeStep && activeStep < 3;
            return Expanded(
              child: Row(
                children: [
                  _TimelineNode(
                    icon: steps[index].icon,
                    done: done,
                    active: active,
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        height: 2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          color: done
                              ? const Color(0xFF34D399)
                              : Colors.white.withValues(alpha: 0.24),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
        ),
        const SizedBox(height: 6),
        Row(
          children: steps
              .map(
                (step) => Expanded(
                  child: Text(
                    step.label,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.78),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        if (isCancelled)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(
              'Rezervasyon iptal edildi',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: const Color(0xFFFCA5A5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }

  int _activeStepFromStatus(LuggageStatus status) {
    switch (status) {
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
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({
    required this.icon,
    required this.done,
    required this.active,
  });

  final IconData icon;
  final bool done;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final Color fgColor;
    final Color bgColor;
    final Color borderColor;
    if (done) {
      fgColor = const Color(0xFF34D399);
      bgColor = const Color(0xFF34D399).withValues(alpha: 0.16);
      borderColor = const Color(0xFF34D399).withValues(alpha: 0.45);
    } else if (active) {
      fgColor = const Color(0xFF60A5FA);
      bgColor = const Color(0xFF60A5FA).withValues(alpha: 0.18);
      borderColor = const Color(0xFF60A5FA).withValues(alpha: 0.45);
    } else {
      fgColor = Colors.white.withValues(alpha: 0.62);
      bgColor = Colors.white.withValues(alpha: 0.08);
      borderColor = Colors.white.withValues(alpha: 0.22);
    }

    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: Border.all(color: borderColor),
      ),
      child: Icon(icon, size: 14, color: fgColor),
    );
  }
}

class _TicketInfoCell extends StatelessWidget {
  const _TicketInfoCell({
    required this.label,
    required this.value,
    required this.valueColor,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color valueColor;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
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
          textAlign: alignEnd ? TextAlign.end : TextAlign.start,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: valueColor,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
