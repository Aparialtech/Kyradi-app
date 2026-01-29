import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.couponsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          _CouponTile(
            title: 'WELCOME10',
            subtitle: loc.couponWelcomeSubtitle,
          ),
          _CouponTile(
            title: 'CITY5',
            subtitle: loc.couponCitySubtitle,
          ),
          _CouponTile(
            title: 'WEEKEND15',
            subtitle: loc.couponWeekendSubtitle,
          ),
        ],
      ),
    );
  }
}

class _CouponTile extends StatelessWidget {
  const _CouponTile({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.copy_outlined),
      ),
    );
  }
}
