import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../models/wallet_transaction.dart';
import '../widgets/transactions_list.dart';
import '../../../ui/components/app_empty_state.dart';

class WalletCashbackPage extends StatelessWidget {
  const WalletCashbackPage({
    super.key,
    required this.transactions,
  });

  final List<WalletTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final cashback = transactions
        .where((tx) => tx.category == loc.walletTransactionCategoryCashback)
        .toList();
    final total = cashback.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );
    return Scaffold(
      appBar: AppBar(title: Text(loc.walletCashbackTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.walletCashbackTotalLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${total.toStringAsFixed(2)} ₺',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
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
    );
  }
}
