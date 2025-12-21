import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../widgets/app_notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.notificationsTooltip),
        actions: [
          ValueListenableBuilder<List<AppNotificationEntry>>(
            valueListenable: NotificationCenter.listenable,
            builder: (context, entries, _) {
              if (entries.isEmpty) return const SizedBox.shrink();
              return IconButton(
                tooltip: loc.notificationsClearTooltip,
                icon: const Icon(Icons.delete_outline_rounded),
                onPressed: NotificationCenter.clear,
              );
            },
          ),
        ],
      ),
      body: ValueListenableBuilder<List<AppNotificationEntry>>(
        valueListenable: NotificationCenter.listenable,
        builder: (context, entries, _) {
          if (entries.isEmpty) {
            return _EmptyState(theme: theme, loc: loc);
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final item = entries[index];
              return _NotificationCard(entry: item);
            },
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.entry});

  final AppNotificationEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final meta = _typeVisual(entry.type, loc);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2C3E50).withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: meta.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Icon(meta.icon, color: Colors.white, size: 20),
        ),
        title: Text(
          meta.title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(
              entry.message,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 6),
            Text(
              _formatRelative(context, entry.timestamp),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.theme, required this.loc});

  final ThemeData theme;
  final AppLocalizations loc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFE7EEF5),
              ),
              child: const Icon(
                Icons.notifications_off_rounded,
                size: 36,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              loc.notificationsEmptyTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              loc.notificationsEmptySubtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationVisual {
  final List<Color> colors;
  final IconData icon;
  final String title;

  const _NotificationVisual({
    required this.colors,
    required this.icon,
    required this.title,
  });
}

_NotificationVisual _typeVisual(AppNotificationType type, AppLocalizations loc) {
  switch (type) {
    case AppNotificationType.success:
      return _NotificationVisual(
        colors: const [Color(0xFF166866), Color(0xFF0D524F)],
        icon: Icons.check_circle_rounded,
        title: loc.notificationTypeSuccess,
      );
    case AppNotificationType.warning:
      return _NotificationVisual(
        colors: const [Color(0xFF2C2966), Color(0xFF4A3C88)],
        icon: Icons.warning_amber_rounded,
        title: loc.notificationTypeWarning,
      );
    case AppNotificationType.error:
      return _NotificationVisual(
        colors: const [Color(0xFF2E2E2E), Color(0xFF4A3B3B)],
        icon: Icons.error_rounded,
        title: loc.notificationTypeError,
      );
    case AppNotificationType.info:
      return _NotificationVisual(
        colors: const [Color(0xFF005C99), Color(0xFF2C3E50)],
        icon: Icons.info_rounded,
        title: loc.notificationTypeInfo,
      );
  }
}
String _formatRelative(BuildContext context, DateTime time) {
  final loc = AppLocalizations.of(context)!;
  final now = DateTime.now();
  final diff = now.difference(time);

  if (diff.inSeconds < 5) return loc.notificationsRelativeNow;
  if (diff.inSeconds < 60) {
    return loc.notificationsRelativeSeconds(diff.inSeconds);
  }
  if (diff.inMinutes < 60) {
    return loc.notificationsRelativeMinutes(diff.inMinutes);
  }
  if (diff.inHours < 24) {
    return loc.notificationsRelativeHours(diff.inHours);
  }
  if (diff.inDays < 7) {
    return loc.notificationsRelativeDays(diff.inDays);
  }
  final locale = Localizations.localeOf(context).toLanguageTag();
  return DateFormat('dd MMM yyyy HH:mm', locale).format(time);
}
