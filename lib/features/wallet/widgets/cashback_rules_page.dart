import 'package:flutter/material.dart';

class CashbackRulesPage extends StatelessWidget {
  const CashbackRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cashback Rules')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: const [
          _RuleTile(
            title: 'Earn cashback',
            subtitle: 'Earn cashback on eligible bookings and campaigns.',
          ),
          _RuleTile(
            title: 'Use cashback',
            subtitle: 'Apply cashback on checkout for supported locations.',
          ),
          _RuleTile(
            title: 'Expiration',
            subtitle: 'Cashback expires after 12 months if unused.',
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
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
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
    );
  }
}
