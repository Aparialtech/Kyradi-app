import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/shell/shell_spacing.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final bottomSafePadding = shellBottomContentPadding(context, extra: -16);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.aboutKyradiTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomSafePadding),
            children: [
              Text(
                'Kyradi',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                loc.aboutKyradiDescription,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: ListTile(
                  title: Text(loc.versionLabel),
                  subtitle: const Text('1.0.0'),
                  trailing: const Icon(Icons.info_outline),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
