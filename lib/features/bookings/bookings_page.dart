import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';
import '../../models/luggage.dart';
import '../../services/luggage_service.dart';
import '../../widgets/app_notification.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';
import '../bookings/widgets/bookings_header.dart';
import '../bookings/widgets/bookings_segmented_control.dart';
import '../bookings/widgets/trip_card.dart';
import '../bookings/widgets/trip_timeline_sheet.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage> {
  BookingSegment _segment = BookingSegment.active;
  bool _loading = false;
  String? _error;
  String? _userId;
  List<LuggageModel> _luggages = [];

  @override
  void initState() {
    super.initState();
    _restoreUser();
  }

  Future<void> _restoreUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    String? errorMessage;
    try {
      final prefs = await SharedPreferences.getInstance();
      _userId = prefs.getString('userId');
      if (_userId == null || _userId!.isEmpty) {
        errorMessage = 'User id not found';
      } else {
        await _fetchLuggages();
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    if (!mounted) return;
    if (errorMessage != null) {
      setState(() => _error = errorMessage);
    }
    setState(() => _loading = false);
  }

  Future<void> _fetchLuggages() async {
    if (_userId == null) return;
    try {
      final loaded = await LuggageService.getUserLuggages(_userId!);
      if (!mounted) return;
      setState(() => _luggages = loaded);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    }
  }

  void _showQr(LuggageModel luggage) {
    context.push('/luggage/${luggage.id}/qr', extra: luggage);
  }

  void _showTimeline(LuggageModel luggage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => TripTimelineSheet(luggage: luggage),
    );
  }

  void _showSupport() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => const _SupportSheet(),
    );
  }

  void _scanQr() {
    AppNotification.show(
      context,
      message: 'QR tarama yakında bu ekranda.',
      type: AppNotificationType.info,
    );
    context.go('/luggage');
  }

  List<LuggageModel> get _segmentItems {
    final now = DateTime.now();
    return _luggages.where((luggage) {
      switch (_segment) {
        case BookingSegment.upcoming:
          final schedule =
              luggage.scheduledDropTime ?? luggage.scheduledPickupTime;
          if (schedule != null && schedule.isAfter(now)) return true;
          return false;
        case BookingSegment.past:
          return luggage.isPickedUp || luggage.isCancelled;
        case BookingSegment.active:
          if (luggage.isPickedUp || luggage.isCancelled) return false;
          final schedule =
              luggage.scheduledDropTime ?? luggage.scheduledPickupTime;
          if (schedule != null && schedule.isAfter(now)) return false;
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final items = _segmentItems;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.myLuggages),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              children: [
                BookingsHeader(
                  title: loc.myLuggages,
                  subtitle: loc.luggagesSectionSubtitle,
                  onOpenClassic: () => context.go('/luggage'),
                ),
                const SizedBox(height: 12),
                BookingsSegmentedControl(
                  segment: _segment,
                  onChanged: (value) => setState(() => _segment = value),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: _loading
                ? ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                    itemCount: 6,
                    itemBuilder: (context, index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: AppSkeleton(height: 140, radius: 20),
                    ),
                  )
                : _error != null
                    ? AppErrorState(message: _error!, onRetry: _restoreUser)
                    : items.isEmpty
                        ? AppEmptyState(
                            title: 'No trips yet',
                            subtitle:
                                'Create a new luggage booking to get started.',
                            actionLabel: loc.quickAddLuggage,
                            onAction: () => context.push('/luggage/add'),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final luggage = items[index];
                              return TripCard(
                                luggage: luggage,
                                onShowQr: () => _showQr(luggage),
                                onScanQr: _scanQr,
                                onDetails: () => _showTimeline(luggage),
                                onSupport: _showSupport,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _SupportSheet extends StatelessWidget {
  const _SupportSheet();

  Future<void> _launch(Uri uri) async {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Support',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.chat_bubble_outline),
              title: const Text('WhatsApp'),
              onTap: () => _launch(Uri.parse('https://wa.me/905000000000')),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Call'),
              onTap: () => _launch(Uri.parse('tel:+905000000000')),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email'),
              onTap: () => _launch(Uri.parse('mailto:support@kyradi.com')),
            ),
          ],
        ),
      ),
    );
  }
}
