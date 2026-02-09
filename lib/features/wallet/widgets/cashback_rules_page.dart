import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class CashbackRulesPage extends StatelessWidget {
  const CashbackRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.cashbackRulesTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: [
              _RuleTile(
                title: loc.cashbackRuleEarnTitle,
                subtitle: loc.cashbackRuleEarnSubtitle,
              ),
              _RuleTile(
                title: loc.cashbackRuleUseTitle,
                subtitle: loc.cashbackRuleUseSubtitle,
              ),
              _RuleTile(
                title: loc.cashbackRuleExpireTitle,
                subtitle: loc.cashbackRuleExpireSubtitle,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RuleTile extends StatelessWidget {
  const _RuleTile({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SectionCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
