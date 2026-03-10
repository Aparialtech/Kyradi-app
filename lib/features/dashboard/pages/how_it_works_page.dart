import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class HowItWorksPage extends StatelessWidget {
  const HowItWorksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final steps = [
      (loc.howItWorksStep1Title, loc.howItWorksStep1Body),
      (loc.howItWorksStep2Title, loc.howItWorksStep2Body),
      (loc.howItWorksStep3Title, loc.howItWorksStep3Body),
      (loc.howItWorksStep4Title, loc.howItWorksStep4Body),
      (loc.howItWorksStep5Title, loc.howItWorksStep5Body),
      (loc.howItWorksStep6Title, loc.howItWorksStep6Body),
      (loc.howItWorksStep7Title, loc.howItWorksStep7Body),
      (loc.howItWorksStep8Title, loc.howItWorksStep8Body),
    ];
    final faq = [
      (loc.howItWorksFaq1Q, loc.howItWorksFaq1A),
      (loc.howItWorksFaq2Q, loc.howItWorksFaq2A),
      (loc.howItWorksFaq3Q, loc.howItWorksFaq3A),
      (loc.howItWorksFaq4Q, loc.howItWorksFaq4A),
      (loc.howItWorksFaq5Q, loc.howItWorksFaq5A),
      (loc.howItWorksFaq6Q, loc.howItWorksFaq6A),
      (loc.howItWorksFaq7Q, loc.howItWorksFaq7A),
      (loc.howItWorksFaq8Q, loc.howItWorksFaq8A),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(loc.howItWorksTitle),
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            children: [
              SectionCard(
                radius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const ThreeDIconBadge(
                          icon: Icons.tips_and_updates_outlined,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            loc.howItWorksTitle,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      loc.howItWorksIntro,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(height: 1.45),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ...steps.asMap().entries.map(
                (entry) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: SectionCard(
                    radius: 22,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ThreeDIconBadge(
                              icon: Icons.check_circle_outline_rounded,
                              accent: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                entry.value.$1,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.value.$2,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.copyWith(height: 1.45),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              SectionCard(
                radius: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const ThreeDIconBadge(icon: Icons.quiz_outlined),
                        const SizedBox(width: 10),
                        Text(
                          loc.howItWorksFaqTitle,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...faq.map(
                      (item) => ExpansionTile(
                        tilePadding: EdgeInsets.zero,
                        childrenPadding: const EdgeInsets.only(bottom: 10),
                        title: Text(
                          item.$1,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.$2,
                              style: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.copyWith(height: 1.45),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
