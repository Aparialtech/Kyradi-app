import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/luggage.dart';
import '../../l10n/app_localizations.dart';
import '../../core/repositories/luggage_repository.dart';
import '../bookings/widgets/trip_timeline_sheet.dart';
import '../../widgets/app_notification.dart';
import '../../utils/crash_log.dart';
import 'package:go_router/go_router.dart';

class LuggageDetailPage extends StatefulWidget {
  const LuggageDetailPage({
    super.key,
    required this.luggageId,
    this.initial,
  });

  final String luggageId;
  final LuggageModel? initial;

  @override
  State<LuggageDetailPage> createState() => _LuggageDetailPageState();
}

class _LuggageDetailPageState extends State<LuggageDetailPage> {
  final LuggageRepository _repo = const LuggageRepository();
  LuggageModel? _luggage;
  bool _loading = true;
  String? _error;
  bool _updating = false;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _luggage = widget.initial;
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      if (userId == null || userId.isEmpty) {
        setState(() {
          _loading = false;
          _error = 'USER_ID_MISSING';
        });
        return;
      }
      _userId = userId;
      final items = await _repo.getUserLuggages(userId);
      if (items.isEmpty && widget.initial == null) {
        setState(() {
          _loading = false;
          _error = 'LUGGAGE_NOT_FOUND';
        });
        return;
      }
      final match = items.firstWhere(
        (item) => item.id == widget.luggageId,
        orElse: () => widget.initial ?? items.first,
      );
      if (!mounted) return;
      setState(() {
        _luggage = match;
        _loading = false;
      });
    } catch (e) {
      appLog('luggage', 'detail load failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  Future<void> _updateStatus(String status, {String? pin}) async {
    if (_userId == null || _userId!.isEmpty || _luggage == null) return;
    final loc = AppLocalizations.of(context)!;
    setState(() => _updating = true);
    try {
      final result = await _repo.updateStatus(
        _userId!,
        _luggage!.id,
        status,
        pin,
        null,
      );
      if (!mounted) return;
      if (result['ok'] == true && result['luggage'] is Map) {
        final next = LuggageModel.fromJson(
          Map<String, dynamic>.from(result['luggage'] as Map),
        );
        setState(() => _luggage = next);
        AppNotification.show(
          context,
          message: status == 'dropped'
              ? loc.dropConfirmedMessage
              : loc.luggagePickupAction,
          type: AppNotificationType.success,
        );
      } else {
        final msg =
            (result['error'] ?? result['message'] ?? 'STATUS_UPDATE_FAILED')
                .toString();
        AppNotification.show(
          context,
          message: msg,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      appLog('luggage', 'status update failed $e', level: AppLogLevel.error);
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.genericErrorWithDetails('$e'),
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _updating = false);
    }
  }

  void _showTimeline(LuggageModel luggage) {
    showModalBottomSheet(
      context: context,
      builder: (_) => TripTimelineSheet(luggage: luggage),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_error != null || _luggage == null) {
      return Scaffold(
        appBar: AppBar(title: Text(loc.myLuggages)),
        body: Center(
          child: Text(_error ?? loc.luggageEmptyStateNoItems),
        ),
      );
    }
    final luggage = _luggage!;
    return Scaffold(
      appBar: AppBar(
        title: Text(luggage.displayLabel),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(luggage.statusLabel),
            subtitle: Text(luggage.dropLocationName.isNotEmpty
                ? luggage.dropLocationName
                : luggage.dropLocationId),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () {
              context.push('/luggage/${luggage.id}/qr', extra: luggage);
            },
            icon: const Icon(Icons.qr_code),
            label: Text(loc.luggageShowQr),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => _showTimeline(luggage),
            icon: const Icon(Icons.timeline),
            label: const Text('Detaylar'),
          ),
          const SizedBox(height: 12),
          if (luggage.isAwaitingDrop)
            FilledButton(
              onPressed: _updating ? null : () => _updateStatus('dropped'),
              child: _updating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.luggageDropAction),
            ),
          if (luggage.isDropped)
            FilledButton(
              onPressed: _updating ? null : () => _updateStatus('picked_up'),
              child: _updating
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(loc.luggagePickupAction),
            ),
        ],
      ),
    );
  }
}
