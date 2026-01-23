enum WalletTransactionType { earn, spend, adjust }

class WalletTransaction {
  const WalletTransaction({
    required this.type,
    required this.amount,
    required this.title,
    required this.date,
    required this.refId,
    required this.category,
  });

  final WalletTransactionType type;
  final double amount;
  final String title;
  final DateTime date;
  final String refId;
  final String category;
}
