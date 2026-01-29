import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';

class CampaignsPage extends StatelessWidget {
  const CampaignsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.campaignsTitle)),
      body: Center(
        child: Text(loc.campaignsComingSoon),
      ),
    );
  }
}
