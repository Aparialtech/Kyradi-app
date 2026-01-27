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
  bool _loading = true;
  String? _error;
  List<LuggageModel> _items = [];
  String? _userId;

  @override
  void initState() {
    super.initState();
    _load();
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
    AppNotification.show(
      context,
      message: 'Destek yakında.',
      type: AppNotificationType.info,
    );
  }

  void _showScanInfo() {
    AppNotification.show(
      context,
      message: 'QR tarama yakında.',
      type: AppNotificationType.info,
    );
  }

  Future<void> _cancelLuggage(LuggageModel luggage) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Rezervasyonu iptal et'),
        content: const Text('Bu rezervasyonu iptal etmek istiyor musunuz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Vazgeç'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    final res = await _repo.cancel(_userId!, luggage.id);
    if (!mounted) return;
    if (res['ok'] == true && res['luggage'] is Map) {
      final updated =
          LuggageModel.fromJson(Map<String, dynamic>.from(res['luggage'] as Map));
      setState(() {
        _items = _items.map((e) => e.id == updated.id ? updated : e).toList();
      });
      AppNotification.show(
        context,
        message: 'Rezervasyon iptal edildi',
        type: AppNotificationType.success,
      );
    } else {
      final msg = (res['error'] ?? res['message'] ?? 'CANCEL_FAILED').toString();
      AppNotification.show(
        context,
        message: msg,
        type: AppNotificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myLuggages),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
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
            ] else ...[
              ..._items.map(
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
            ],
          ],
        ),
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
