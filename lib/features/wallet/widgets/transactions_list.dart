import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../widgets/section_card.dart';
import '../models/wallet_transaction.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    required this.items,
  });

  final List<WalletTransaction> items;

  @override
  Widget build(BuildContext context) {
    final grouped = _groupByMonth(items);
    return Column(
      children: grouped.entries.map((entry) {
        return SectionCard(
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  entry.key,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              ...entry.value.map((tx) => _TransactionTile(tx: tx)),
            ],
          ),
        );
      }).toList(),
    );
  }

  Map<String, List<WalletTransaction>> _groupByMonth(
    List<WalletTransaction> items,
  ) {
    final format = DateFormat('MMMM yyyy');
    final grouped = <String, List<WalletTransaction>>{};
    final sorted = [...items]..sort((a, b) => b.date.compareTo(a.date));
    for (final item in sorted) {
      final key = format.format(item.date);
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.tx});

  final WalletTransaction tx;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEarn = tx.type == WalletTransactionType.earn;
    final isAdjust = tx.type == WalletTransactionType.adjust;
    final color = isEarn
        ? theme.colorScheme.primary
        : isAdjust
            ? theme.colorScheme.secondary
            : theme.colorScheme.error;
    final sign = isEarn
        ? '+'
        : isAdjust
            ? '+'
            : '-';
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: color.withValues(alpha: 0.12),
        child: Icon(
          isEarn ? Icons.savings_outlined : Icons.shopping_bag_outlined,
          color: color,
        ),
      ),
      title: Text(tx.title),
      subtitle: Text(tx.category),
      trailing: Text(
        '$sign${tx.amount.toStringAsFixed(2)} ₺',
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
