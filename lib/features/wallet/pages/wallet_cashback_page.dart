import 'package:flutter/material.dart';
import '../../../core/app_currency_mode.dart';
import '../../../l10n/app_localizations.dart';
import '../models/wallet_transaction.dart';
import '../widgets/transactions_list.dart';
import '../../../ui/components/app_empty_state.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class WalletCashbackPage extends StatelessWidget {
  const WalletCashbackPage({super.key, required this.transactions});

  final List<WalletTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cashback = transactions
        .where((tx) => tx.category == loc.walletTransactionCategoryCashback)
        .toList();
    final total = cashback.fold<double>(0, (sum, tx) => sum + tx.amount);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.walletCashbackTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SectionCard(
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: ValueListenableBuilder<AppCurrency>(
                    valueListenable: AppCurrencyMode.notifier,
                    builder: (context, currency, _) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          loc.walletCashbackTotalLabel,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppCurrencyMode.formatFromTry(
                            total,
                            currency: currency,
                          ),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (cashback.isEmpty)
                AppEmptyState(
                  title: loc.walletEmptyTransactionsTitle,
                  subtitle: loc.walletEmptyTransactionsSubtitle,
                )
              else
                TransactionsList(items: cashback),
            ],
          ),
        ],
      ),
    );
  }
}
