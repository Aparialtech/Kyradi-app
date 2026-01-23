import 'package:flutter/material.dart';

class CouponsPage extends StatelessWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coupons')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: const [
          _CouponTile(
            title: 'WELCOME10',
            subtitle: '10% off on your next booking.',
          ),
          _CouponTile(
            title: 'CITY5',
            subtitle: '5 ₺ cashback on city center locations.',
          ),
          _CouponTile(
            title: 'WEEKEND15',
            subtitle: '15% off weekend drop-off.',
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
