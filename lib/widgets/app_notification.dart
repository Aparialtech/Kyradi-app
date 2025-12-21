import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

enum AppNotificationType { info, success, warning, error }

class AppNotification {
  AppNotification._();

  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    AppNotificationType type = AppNotificationType.info,
    Duration duration = const Duration(seconds: 2),
    Widget? leading,
  }) {
    _currentEntry?.remove();
    final overlay = Overlay.of(context);

    final entry = OverlayEntry(
      builder: (context) => _NotificationOverlay(
        message: message,
        type: type,
        duration: duration,
        leading: leading,
        onDismissed: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);

    NotificationCenter.record(message, type);
  }
}

class AppNotificationEntry {
  final String message;
  final AppNotificationType type;
  final DateTime timestamp;

  const AppNotificationEntry({
    required this.message,
    required this.type,
    required this.timestamp,
  });
}

class NotificationCenter {
  NotificationCenter._();

  static const int _maxEntries = 50;
  static final ValueNotifier<List<AppNotificationEntry>> _notifier =
      ValueNotifier<List<AppNotificationEntry>>(<AppNotificationEntry>[]);

  static ValueListenable<List<AppNotificationEntry>> get listenable => _notifier;

  static List<AppNotificationEntry> get entries => List.unmodifiable(_notifier.value);

  static void clear() {
    _notifier.value = <AppNotificationEntry>[];
  }

  static void record(String message, AppNotificationType type) {
    final updated = List<AppNotificationEntry>.from(_notifier.value);
    updated.insert(
      0,
      AppNotificationEntry(
        message: message,
        type: type,
        timestamp: DateTime.now(),
      ),
    );
    if (updated.length > _maxEntries) {
      updated.removeRange(_maxEntries, updated.length);
    }
    _notifier.value = updated;
  }
}

class _NotificationOverlay extends StatefulWidget {
  const _NotificationOverlay({
    required this.message,
    required this.type,
    required this.duration,
    this.leading,
    required this.onDismissed,
  });

  final String message;
  final AppNotificationType type;
  final Duration duration;
  final Widget? leading;
  final VoidCallback onDismissed;

  @override
  State<_NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<_NotificationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offset;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _offset = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
    _timer = Timer(widget.duration, () {
      if (!mounted) return;
      _controller.reverse().then((value) {
        if (mounted) widget.onDismissed();
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Color get _background {
    switch (widget.type) {
      case AppNotificationType.success:
        return const Color(0xFF166866);
      case AppNotificationType.warning:
        return const Color(0xFF2C2966);
      case AppNotificationType.error:
        return const Color(0xFF2E2E2E);
      case AppNotificationType.info:
        return const Color(0xFF005C99);
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case AppNotificationType.success:
        return Icons.check_circle_rounded;
      case AppNotificationType.warning:
        return Icons.warning_rounded;
      case AppNotificationType.error:
        return Icons.error_rounded;
      case AppNotificationType.info:
        return Icons.info_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final width = media.size.width;

    return IgnorePointer(
      ignoring: true,
      child: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: width < 420 ? width - 32 : 360,
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: SlideTransition(
                position: _offset,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _background,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.14),
                          blurRadius: 22,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        widget.leading ??
                            Icon(_icon, color: Colors.white, size: 18),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
