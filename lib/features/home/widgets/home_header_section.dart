import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({
    super.key,
    required this.greeting,
    required this.subtitle,
    required this.totalLabel,
    required this.findLocationLabel,
    required this.quickAddLabel,
    required this.quickTransitLabel,
    required this.howItWorksLabel,
    required this.onHowItWorks,
    required this.onLocateMe,
    required this.onQuickAdd,
    required this.onQuickTransit,
  });

  final String greeting;
  final String subtitle;
  final String totalLabel;
  final String findLocationLabel;
  final String quickAddLabel;
  final String quickTransitLabel;
  final String howItWorksLabel;
  final VoidCallback onHowItWorks;
  final VoidCallback onLocateMe;
  final VoidCallback onQuickAdd;
  final VoidCallback onQuickTransit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: greeting,
          subtitle: subtitle,
          icon: Icons.dashboard_customize_outlined,
          action: Chip(
            label: Text(totalLabel),
            backgroundColor: const Color(0xFFFF7A00),
            labelStyle: theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF4B2400),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: onHowItWorks,
            icon: const Icon(Icons.info_outline),
            label: Text(howItWorksLabel),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            QuickActionTile(
              label: findLocationLabel,
              icon: Icons.my_location,
              onTap: onLocateMe,
            ),
            QuickActionTile(
              label: quickAddLabel,
              icon: Icons.qr_code_2,
              onTap: onQuickAdd,
            ),
            QuickActionTile(
              label: quickTransitLabel,
              icon: Icons.directions_transit,
              onTap: onQuickTransit,
            ),
          ],
        ),
      ],
    );
  }
}
