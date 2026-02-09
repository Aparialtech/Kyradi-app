import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class InviteFriendsPage extends StatelessWidget {
  const InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const inviteCode = 'KYRADI-TRAVEL';
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.inviteFriendsTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.inviteFriendsHeadline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  loc.inviteFriendsSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 18),
                SectionCard(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          inviteCode,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(
                            const ClipboardData(text: inviteCode),
                          );
                          if (!context.mounted) return;
                          AppNotification.show(
                            context,
                            message: loc.inviteCodeCopied,
                            type: AppNotificationType.success,
                          );
                        },
                        icon: const Icon(Icons.copy_outlined),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () {
                    AppNotification.show(
                      context,
                      message: loc.shareComingSoon,
                      type: AppNotificationType.info,
                    );
                  },
                  icon: const Icon(Icons.share_outlined),
                  label: Text(loc.shareAction),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
