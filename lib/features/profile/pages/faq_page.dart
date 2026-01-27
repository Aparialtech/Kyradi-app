import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      ['How does Kyradi work?', 'Drop your luggage at a partner location and pick it up later with your QR/PIN.'],
      ['Can I pay on site?', 'Yes, pay at the location or via card checkout.'],
      ['What if a location is full?', 'Choose another location or time slot.'],
      ['How do I upload identity?', 'Open Profile → Verification → Identity.'],
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: items.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item[0],
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item[1],
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
