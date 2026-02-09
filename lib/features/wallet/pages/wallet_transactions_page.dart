import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../models/wallet_transaction.dart';
import '../widgets/transactions_list.dart';
import '../../../ui/components/app_empty_state.dart';
import '../../../widgets/app_mesh_background.dart';

class WalletTransactionsPage extends StatefulWidget {
  const WalletTransactionsPage({
    super.key,
    required this.transactions,
  });

  final List<WalletTransaction> transactions;

  @override
  State<WalletTransactionsPage> createState() =>
      _WalletTransactionsPageState();
}

class _WalletTransactionsPageState extends State<WalletTransactionsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  DateFilter _dateFilter = DateFilter.last30;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<WalletTransaction> _applyDateFilter(
    List<WalletTransaction> input,
  ) {
    final now = DateTime.now();
    final start = switch (_dateFilter) {
      DateFilter.last7 => now.subtract(const Duration(days: 7)),
      DateFilter.last30 => now.subtract(const Duration(days: 30)),
      DateFilter.last90 => now.subtract(const Duration(days: 90)),
    };
    return input.where((tx) => tx.date.isAfter(start)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final all = _applyDateFilter(widget.transactions);
    final topups = all.where((t) => t.type == WalletTransactionType.earn).toList();
    final spends = all.where((t) => t.type == WalletTransactionType.spend).toList();
    final cashback = all
        .where((t) => t.category == loc.walletTransactionCategoryCashback)
        .toList();
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(loc.walletTransactionsTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: loc.walletTabTopUps),
            Tab(text: loc.walletTabSpends),
            Tab(text: loc.walletTabCashback),
          ],
        ),
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Row(
                  children: [
                    Text(loc.walletFilterDateLabel),
                    const Spacer(),
                    DropdownButton<DateFilter>(
                      value: _dateFilter,
                      underline: const SizedBox.shrink(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _dateFilter = value);
                      },
                      items: [
                        DropdownMenuItem(
                          value: DateFilter.last7,
                          child: Text(loc.walletFilterLast7),
                        ),
                        DropdownMenuItem(
                          value: DateFilter.last30,
                          child: Text(loc.walletFilterLast30),
                        ),
                        DropdownMenuItem(
                          value: DateFilter.last90,
                          child: Text(loc.walletFilterLast90),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _TransactionsBody(items: topups),
                    _TransactionsBody(items: spends),
                    _TransactionsBody(items: cashback),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransactionsBody extends StatelessWidget {
  const _TransactionsBody({required this.items});

  final List<WalletTransaction> items;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    if (items.isEmpty) {
      return AppEmptyState(
        title: loc.walletEmptyTransactionsTitle,
        subtitle: loc.walletEmptyTransactionsSubtitle,
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      children: [
        TransactionsList(items: items),
      ],
    );
  }
}

enum DateFilter { last7, last30, last90 }
