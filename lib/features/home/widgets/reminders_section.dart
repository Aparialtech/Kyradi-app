import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';

class RemindersSection extends StatelessWidget {
  const RemindersSection({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pushLabel,
    required this.emailLabel,
    required this.pushValue,
    required this.emailValue,
    required this.onPushChanged,
    required this.onEmailChanged,
  });

  final String title;
  final String subtitle;
  final String pushLabel;
  final String emailLabel;
  final bool pushValue;
  final bool emailValue;
  final ValueChanged<bool> onPushChanged;
  final ValueChanged<bool> onEmailChanged;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            icon: Icons.notifications_active_outlined,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(pushLabel),
            value: pushValue,
            onChanged: onPushChanged,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(emailLabel),
            value: emailValue,
            onChanged: onEmailChanged,
          ),
        ],
      ),
    );
  }
}
