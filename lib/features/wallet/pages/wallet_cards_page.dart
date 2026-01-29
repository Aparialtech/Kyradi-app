import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/section_card.dart';

class WalletCardsPage extends StatelessWidget {
  const WalletCardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.walletCardsTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.walletAddCardTitle,
                  subtitle: loc.walletAddCardSubtitle,
                  icon: Icons.credit_card_outlined,
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: loc.walletCardNumberLabel,
                    hintText: '1234 5678 9012 3456',
                    prefixIcon: const Icon(Icons.credit_card_outlined),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: loc.walletCardNameLabel,
                    hintText: 'AD SOYAD',
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: loc.walletCardExpiryLabel,
                          hintText: 'MM/YY',
                          prefixIcon: const Icon(Icons.calendar_today_outlined),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: loc.walletCardCvvLabel,
                          hintText: 'CVV',
                          prefixIcon: const Icon(Icons.lock_outline),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: Text(loc.walletAddCardAction),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(loc.walletCardsEmptyTitle),
              subtitle: Text(loc.walletCardsEmptySubtitle),
            ),
          ),
        ],
      ),
    );
  }
}
