import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomSafePadding = MediaQuery.viewPaddingOf(context).bottom + 96;
    final items = [
      [loc.faqQ1, loc.faqA1],
      [loc.faqQ2, loc.faqA2],
      [loc.faqQ3, loc.faqA3],
      [loc.faqQ4, loc.faqA4],
    ];
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.faqTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomSafePadding),
            children: items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item[0],
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item[1],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
