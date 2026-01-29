import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/repositories/luggage_repository.dart';
import '../../models/luggage.dart';
import '../../l10n/app_localizations.dart';
import '../../utils/crash_log.dart';
import 'package:go_router/go_router.dart';
import '../bookings/widgets/trip_card.dart';
import '../../widgets/app_notification.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';

class LuggageListPage extends StatefulWidget {
  const LuggageListPage({super.key});

  @override
  State<LuggageListPage> createState() => _LuggageListPageState();
}

class _LuggageListPageState extends State<LuggageListPage> {
  final LuggageRepository _repo = const LuggageRepository();
  final TextEditingController _searchCtrl = TextEditingController();
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
  LuggageView _view = LuggageView.list;
  int _page = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
      if (!mounted) return;
      setState(() {
        _items = luggages;
        _page = 1;
        _loading = false;
      });
    } catch (e) {
      appLog('luggage', 'load failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  void _openQr(LuggageModel luggage) {
    context.push('/luggage/${luggage.id}/qr', extra: luggage);
  }

  void _openDetail(LuggageModel luggage) {
    context.push('/luggage/${luggage.id}', extra: luggage);
  }

  void _showSupport() {
    final loc = AppLocalizations.of(context)!;
    AppNotification.show(
      context,
      message: loc.supportSoonMessage,
      type: AppNotificationType.info,
    );
  }

  void _showScanInfo() {
    final loc = AppLocalizations.of(context)!;
    AppNotification.show(
      context,
      message: loc.qrScanSoonMessage,
      type: AppNotificationType.info,
    );
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
        filtered.sort((a, b) =>
            a.dropLocationName.compareTo(b.dropLocationName));
        break;
      case LuggageSort.payment:
        filtered.sort((a, b) =>
            (a.paymentStatus ?? '').compareTo(b.paymentStatus ?? ''));
        break;
      case LuggageSort.date:
      default:
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
        final locations = _items
            .map((e) => e.dropLocationName.toLowerCase())
            .toSet()
            .toList()
          ..sort();
        final sizes = _items
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
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<LuggageStatus>(
                value: status,
                decoration: InputDecoration(
                  labelText: loc.luggageFilterStatus,
                ),
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(loc.allLabel),
                  ),
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
                decoration: InputDecoration(labelText: loc.luggageFilterPayment),
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
                decoration: InputDecoration(labelText: loc.luggageFilterLocation),
                items: [
                  DropdownMenuItem(value: null, child: Text(loc.allLabel)),
                  for (final locName in locations)
                    DropdownMenuItem(
                      value: locName,
                      child: Text(locName),
                    ),
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
                    DropdownMenuItem(
                      value: sizeValue,
                      child: Text(sizeValue),
                    ),
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
    appLog('luggage', 'LUGGAGE_CANCEL_TAP id=${luggage.id}', level: AppLogLevel.info);
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
    appLog('luggage', 'LUGGAGE_CANCEL_START id=${luggage.id}', level: AppLogLevel.info);
    try {
      final res = await _repo
          .cancel(_userId!, luggage.id)
          .timeout(const Duration(seconds: 20));
      if (!mounted) return;
      if (res['ok'] == true && res['luggage'] is Map) {
        final updated =
            LuggageModel.fromJson(Map<String, dynamic>.from(res['luggage'] as Map));
        setState(() {
          _items = _items.map((e) => e.id == updated.id ? updated : e).toList();
        });
        AppNotification.show(
          context,
          message: loc.reservationCancelledMessage,
          type: AppNotificationType.success,
        );
        appLog('luggage', 'LUGGAGE_CANCEL_OK id=${luggage.id}', level: AppLogLevel.info);
      } else {
        final msg = (res['error'] ?? res['message'] ?? 'CANCEL_FAILED').toString();
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
    return Scaffold(
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
          RefreshIndicator(
            onRefresh: _load,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
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
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<LuggageSort>(
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
                    ),
                    const SizedBox(width: 12),
                    SegmentedButton<LuggageView>(
                      segments: [
                        ButtonSegment(
                          value: LuggageView.list,
                          label: Text(loc.luggageViewList),
                          icon: const Icon(Icons.list_alt),
                        ),
                        ButtonSegment(
                          value: LuggageView.cards,
                          label: Text(loc.luggageViewCards),
                          icon: const Icon(Icons.view_module_outlined),
                        ),
                        ButtonSegment(
                          value: LuggageView.calendar,
                          label: Text(loc.luggageViewCalendar),
                          icon: const Icon(Icons.calendar_month_outlined),
                        ),
                      ],
                      selected: {_view},
                      onSelectionChanged: (value) {
                        final next = value.first;
                        setState(() => _view = next);
                        if (next != LuggageView.list) {
                          AppNotification.show(
                            context,
                            message: loc.comingSoonMessage,
                            type: AppNotificationType.info,
                          );
                        }
                      },
                    ),
                  ],
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
                    onAction: () => context.push('/luggage/add'),
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
                  ...paged.map(
                    (luggage) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TripCard(
                        luggage: luggage,
                        onShowQr: () => _openQr(luggage),
                        onScanQr: _showScanInfo,
                        onDetails: () => _openDetail(luggage),
                        onSupport: _showSupport,
                        onCancel: () => _cancelLuggage(luggage),
                      ),
                    ),
                  ),
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
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
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
        },
        icon: const Icon(Icons.add),
        label: Text(loc.quickAddLuggage),
      ),
    );
  }
}

enum LuggageSort { date, status, location, payment }

enum LuggageView { list, cards, calendar }
