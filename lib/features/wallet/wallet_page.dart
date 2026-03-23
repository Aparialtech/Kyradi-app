import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_currency_mode.dart';
import '../../l10n/app_localizations.dart';
import '../../features/wallet/models/reward_mission.dart';
import '../../features/wallet/models/wallet_transaction.dart';
import '../../services/local_notification_service.dart';
import '../../features/wallet/widgets/balance_card.dart';
import '../../features/wallet/widgets/cashback_rules_page.dart';
import '../../features/wallet/widgets/coupons_page.dart';
import '../../features/wallet/widgets/invite_friends_page.dart';
import '../../features/wallet/widgets/mission_carousel.dart';
import '../../features/wallet/widgets/transactions_list.dart';
import '../../features/wallet/widgets/wallet_header.dart';
import '../../features/wallet/widgets/wallet_quick_actions.dart';
import 'pages/wallet_transactions_page.dart';
import 'pages/wallet_cashback_page.dart';
import 'pages/wallet_cards_page.dart';
import 'pages/wallet_topup_saved_card_page.dart';
import 'pages/wallet_topup_new_card_page.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_skeleton.dart';
import '../../widgets/app_mesh_background.dart';
import '../../utils/crash_log.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

enum _WalletPanel { none, coupon, topup, transfer }

enum _WalletTxFilter { all, incoming, outgoing }

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  double _balance = 0;
  double _monthlyEarned = 0;
  bool _obscureBalance = false;
  List<WalletTransaction> _transactions = [];
  List<RewardMission> _missions = [];
  _WalletTxFilter _txFilter = _WalletTxFilter.all;
  bool _didSeed = false;
  _WalletPanel _openPanel = _WalletPanel.none;

  final _couponCtrl = TextEditingController();
  bool _couponLoading = false;
  String? _couponStatus;

  bool _topUpLoading = false;

  final _transferTargetCtrl = TextEditingController();
  final _transferAmountCtrl = TextEditingController();
  final _transferNoteCtrl = TextEditingController();
  bool _transferLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didSeed) return;
    _didSeed = true;
    _loadMockData(AppLocalizations.of(context)!);
  }

  @override
  void dispose() {
    _couponCtrl.dispose();
    _transferTargetCtrl.dispose();
    _transferAmountCtrl.dispose();
    _transferNoteCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadMockData(AppLocalizations loc) async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    final stored = await _readStoredBalance();
    setState(() {
      // TODO: Replace with API integration.
      _balance = stored ?? 124.5;
      _monthlyEarned = 42.75;
      _transactions = [
        WalletTransaction(
          type: WalletTransactionType.earn,
          amount: 24.5,
          title: loc.walletMockLocationTitle,
          date: DateTime.now().subtract(const Duration(days: 2)),
          refId: 'TX-102',
          category: loc.walletTransactionCategoryCashback,
        ),
        WalletTransaction(
          type: WalletTransactionType.spend,
          amount: 15,
          title: loc.walletMockPaymentTitle,
          date: DateTime.now().subtract(const Duration(days: 6)),
          refId: 'TX-093',
          category: loc.walletTransactionCategoryUsage,
        ),
        WalletTransaction(
          type: WalletTransactionType.earn,
          amount: 18,
          title: loc.walletMockCampaignTitle,
          date: DateTime.now().subtract(const Duration(days: 18)),
          refId: 'TX-081',
          category: loc.walletTransactionCategoryCampaign,
        ),
        WalletTransaction(
          type: WalletTransactionType.adjust,
          amount: 5,
          title: loc.walletMockAdjustmentTitle,
          date: DateTime.now().subtract(const Duration(days: 32)),
          refId: 'TX-071',
          category: loc.walletTransactionCategoryAdjustment,
        ),
      ];
      _missions = [
        RewardMission(
          title: loc.walletMissionExploreTitle,
          subtitle: loc.walletMissionExploreSubtitle,
          progress: 2,
          total: 3,
          rewardAmount: 20,
        ),
        RewardMission(
          title: loc.walletMissionWeekendTitle,
          subtitle: loc.walletMissionWeekendSubtitle,
          progress: 1,
          total: 2,
          rewardAmount: 15,
        ),
        RewardMission(
          title: loc.walletMissionInviteTitle,
          subtitle: loc.walletMissionInviteSubtitle,
          progress: 0,
          total: 3,
          rewardAmount: 30,
        ),
      ];
      _loading = false;
    });
  }

  String _formatMoney(
    double tryAmount, {
    int digits = 2,
    AppCurrency? currency,
  }) {
    return AppCurrencyMode.formatFromTry(
      tryAmount,
      currency: currency ?? AppCurrencyMode.notifier.value,
      fractionDigits: digits,
    );
  }

  Future<double?> _readStoredBalance() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('wallet_balance')) return null;
    return prefs.getDouble('wallet_balance');
  }

  Future<void> _storeBalance() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('wallet_balance', _balance);
  }

  void _openRules() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CashbackRulesPage()));
  }

  void _openCoupons() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const CouponsPage()));
  }

  void _openInvite() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const InviteFriendsPage()));
  }

  void _openTransactions() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WalletTransactionsPage(transactions: _transactions),
      ),
    );
  }

  void _openCashback() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => WalletCashbackPage(transactions: _transactions),
      ),
    );
  }

  void _openCards() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const WalletCardsPage()));
  }

  void _togglePanel(_WalletPanel panel) {
    setState(() {
      _openPanel = _openPanel == panel ? _WalletPanel.none : panel;
    });
  }

  Future<void> _applyCoupon() async {
    final loc = AppLocalizations.of(context)!;
    final code = _couponCtrl.text.trim().toUpperCase();
    if (code.isEmpty || _couponLoading) return;
    appLog('wallet', 'COUPON_APPLY_TAP code=$code', level: AppLogLevel.info);
    setState(() {
      _couponLoading = true;
      _couponStatus = null;
    });
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      if (code == 'KYRADI10') {
        _couponStatus = loc.couponAppliedMessage;
        AppNotification.show(
          context,
          message: loc.couponAppliedMessage,
          type: AppNotificationType.success,
        );
        appLog('wallet', 'COUPON_APPLY_OK code=$code', level: AppLogLevel.info);
      } else {
        _couponStatus = loc.couponInvalidMessage;
        AppNotification.show(
          context,
          message: loc.couponInvalidMessage,
          type: AppNotificationType.warning,
        );
        appLog(
          'wallet',
          'COUPON_APPLY_ERR code=$code',
          level: AppLogLevel.warn,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _couponStatus = loc.couponFailedMessage;
      AppNotification.show(
        context,
        message: loc.couponFailedMessage,
        type: AppNotificationType.error,
      );
      appLog(
        'wallet',
        'COUPON_APPLY_ERR code=$code err=$e',
        level: AppLogLevel.error,
      );
    } finally {
      if (mounted) setState(() => _couponLoading = false);
    }
  }

  Future<void> _applyTopUpResult({
    required double amount,
    required String label,
  }) async {
    final loc = AppLocalizations.of(context)!;
    setState(() => _topUpLoading = true);
    appLog('wallet', 'TOPUP_START amount=$amount', level: AppLogLevel.info);
    try {
      setState(() {
        _balance += amount;
        _transactions.insert(
          0,
          WalletTransaction(
            type: WalletTransactionType.earn,
            amount: amount,
            title: loc.topUpTransactionTitleWithMethod(label),
            date: DateTime.now(),
            refId: 'TP-${DateTime.now().millisecondsSinceEpoch}',
            category: loc.topUpTransactionCategory,
          ),
        );
      });
      await _storeBalance();
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.topUpSuccessMessage,
        type: AppNotificationType.success,
      );
      await LocalNotificationService.instance.showGeneric(
        title: 'Cüzdan Güncellendi',
        body:
            '${_formatMoney(amount, digits: 0)} yükleme işlemi başarıyla tamamlandı.',
        channelId: 'kyradi_wallet',
        channelName: 'Cüzdan Bildirimleri',
        channelDescription: 'Bakiye ve transfer bildirimleri',
      );
      appLog('wallet', 'TOPUP_OK amount=$amount', level: AppLogLevel.info);
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.topUpFailedMessage,
        type: AppNotificationType.error,
      );
      appLog('wallet', 'TOPUP_ERR err=$e', level: AppLogLevel.error);
    } finally {
      if (mounted) setState(() => _topUpLoading = false);
    }
  }

  Future<void> _openTopUpSaved() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const WalletTopUpSavedCardPage()),
    );
    await _handleTopUpResult(result);
  }

  Future<void> _openTopUpNew() async {
    final result = await Navigator.of(context).push<Map<String, dynamic>>(
      MaterialPageRoute(builder: (_) => const WalletTopUpNewCardPage()),
    );
    await _handleTopUpResult(result);
  }

  Future<void> _handleTopUpResult(Map<String, dynamic>? result) async {
    if (!mounted || result == null) return;
    final rawAmount = result['amount'];
    final label = result['label']?.toString() ?? '';
    if (rawAmount is num) {
      await _applyTopUpResult(amount: rawAmount.toDouble(), label: label);
    }
  }

  Future<void> _submitTransfer() async {
    final loc = AppLocalizations.of(context)!;
    if (_transferLoading) return;
    final target = _transferTargetCtrl.text.trim();
    final amount =
        double.tryParse(_transferAmountCtrl.text.replaceAll(',', '.')) ?? 0;
    if (target.isEmpty || amount <= 0) {
      AppNotification.show(
        context,
        message: loc.transferInvalidMessage,
        type: AppNotificationType.warning,
      );
      return;
    }
    if (amount > _balance) {
      AppNotification.show(
        context,
        message: loc.transferInsufficientBalanceMessage,
        type: AppNotificationType.error,
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.transferConfirmTitle),
        content: Text(loc.transferConfirmMessage(target, _formatMoney(amount))),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(loc.dialogDismiss),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(loc.dialogConfirm),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _transferLoading = true);
    appLog(
      'wallet',
      'TRANSFER_START target=$target amount=$amount',
      level: AppLogLevel.info,
    );
    try {
      await Future<void>.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;
      setState(() {
        _balance -= amount;
        _transactions.insert(
          0,
          WalletTransaction(
            type: WalletTransactionType.spend,
            amount: amount,
            title: loc.transferTransactionTitle(target),
            date: DateTime.now(),
            refId: 'TR-${DateTime.now().millisecondsSinceEpoch}',
            category: loc.transferTransactionCategory,
          ),
        );
      });
      await _storeBalance();
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.transferSuccessMessage,
        type: AppNotificationType.success,
      );
      await LocalNotificationService.instance.showGeneric(
        title: 'Transfer Tamamlandı',
        body:
            '$target hesabına ${_formatMoney(amount, digits: 0)} transfer edildi.',
        channelId: 'kyradi_wallet',
        channelName: 'Cüzdan Bildirimleri',
        channelDescription: 'Bakiye ve transfer bildirimleri',
      );
      appLog(
        'wallet',
        'TRANSFER_OK target=$target amount=$amount',
        level: AppLogLevel.info,
      );
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.transferFailedMessage,
        type: AppNotificationType.error,
      );
      appLog('wallet', 'TRANSFER_ERR err=$e', level: AppLogLevel.error);
    } finally {
      if (mounted) setState(() => _transferLoading = false);
    }
  }

  Future<void> _openQuickTopUpSheet() async {
    final loc = AppLocalizations.of(context)!;
    const presets = <double>[100, 250, 500, 1000];
    final amount = await showModalBottomSheet<double>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  loc.topUpSectionTitle,
                  style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Tek dokunuşla bakiye ekleyin',
                  style: Theme.of(sheetContext).textTheme.bodySmall,
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: presets
                      .map(
                        (value) => FilledButton.tonal(
                          onPressed: () =>
                              Navigator.of(sheetContext).pop(value),
                          child: Text(_formatMoney(value, digits: 0)),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || amount == null) return;
    await _applyTopUpResult(amount: amount, label: 'Hızlı Yükleme');
  }

  double get _earnedTotal => _transactions
      .where((t) => t.type == WalletTransactionType.earn)
      .fold<double>(0, (sum, t) => sum + t.amount);

  double get _spentTotal => _transactions
      .where((t) => t.type == WalletTransactionType.spend)
      .fold<double>(0, (sum, t) => sum + t.amount);

  List<WalletTransaction> get _visibleTransactions {
    switch (_txFilter) {
      case _WalletTxFilter.incoming:
        return _transactions
            .where((t) => t.type == WalletTransactionType.earn)
            .toList();
      case _WalletTxFilter.outgoing:
        return _transactions
            .where((t) => t.type == WalletTransactionType.spend)
            .toList();
      case _WalletTxFilter.all:
        return _transactions;
    }
  }

  List<_DailyFlow> get _weeklyFlows {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));
    final labels = ['Pzt', 'Sal', 'Car', 'Per', 'Cum', 'Cmt', 'Paz'];
    final buckets = List<_DailyFlow>.generate(7, (index) {
      final date = start.add(Duration(days: index));
      final dayLabel = labels[(date.weekday - 1) % 7];
      return _DailyFlow(label: dayLabel, incoming: 0, outgoing: 0);
    });
    for (final tx in _transactions) {
      final normalized = DateTime(tx.date.year, tx.date.month, tx.date.day);
      final diff = normalized.difference(start).inDays;
      if (diff < 0 || diff > 6) continue;
      final current = buckets[diff];
      if (tx.type == WalletTransactionType.earn) {
        buckets[diff] = current.copyWith(
          incoming: current.incoming + tx.amount,
        );
      } else if (tx.type == WalletTransactionType.spend) {
        buckets[diff] = current.copyWith(
          outgoing: current.outgoing + tx.amount,
        );
      }
    }
    return buckets;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final txPreview = _visibleTransactions.take(5).toList();
    return ValueListenableBuilder<AppCurrency>(
      valueListenable: AppCurrencyMode.notifier,
      builder: (context, currency, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(loc.walletTitle),
            actions: [
              IconButton(
                tooltip: loc.walletTransactionsTitle,
                onPressed: _openTransactions,
                icon: const Icon(Icons.receipt_long_outlined),
              ),
              IconButton(
                tooltip: loc.walletCardsTitle,
                onPressed: _openCards,
                icon: const Icon(Icons.credit_card_outlined),
              ),
            ],
          ),
          body: Stack(
            children: [
              const AppMeshBackground(),
              _loading
                  ? ListView(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                      children: const [
                        AppSkeleton(height: 110, radius: 20),
                        SizedBox(height: 16),
                        AppSkeleton(height: 90, radius: 20),
                        SizedBox(height: 16),
                        AppSkeleton(height: 120, radius: 20),
                        SizedBox(height: 16),
                        AppSkeleton(height: 260, radius: 20),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: () =>
                          _loadMockData(AppLocalizations.of(context)!),
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                        children: [
                          _WalletHeroBalance(
                            amountLabel: _obscureBalance
                                ? '••••••'
                                : _formatMoney(_balance, currency: currency),
                            obscureBalance: _obscureBalance,
                            onToggleVisibility: () => setState(
                              () => _obscureBalance = !_obscureBalance,
                            ),
                            onCardsTap: _openCards,
                          ),
                          const SizedBox(height: 14),
                          _WalletActionDock(
                            onPay: _openTransactions,
                            onTopUp: _openQuickTopUpSheet,
                            onTransfer: () =>
                                _togglePanel(_WalletPanel.transfer),
                            onRequest: () => _togglePanel(_WalletPanel.coupon),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            child: Column(
                              children: [
                                if (_openPanel == _WalletPanel.coupon)
                                  _CompactWalletPanel(
                                    title: loc.couponSectionTitle,
                                    subtitle: loc.couponSectionSubtitle,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _couponCtrl,
                                          textCapitalization:
                                              TextCapitalization.characters,
                                          decoration: InputDecoration(
                                            labelText: loc.couponInputLabel,
                                            prefixIcon: const Icon(
                                              Icons
                                                  .confirmation_number_outlined,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: _couponLoading
                                                ? null
                                                : _applyCoupon,
                                            child: _couponLoading
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : Text(loc.couponApplyAction),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_openPanel == _WalletPanel.transfer)
                                  _CompactWalletPanel(
                                    title: loc.transferSectionTitle,
                                    subtitle: loc.transferSectionSubtitle,
                                    child: Column(
                                      children: [
                                        TextFormField(
                                          controller: _transferTargetCtrl,
                                          decoration: InputDecoration(
                                            labelText: loc.transferTargetLabel,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _transferAmountCtrl,
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            labelText: loc.transferAmountLabel,
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextFormField(
                                          controller: _transferNoteCtrl,
                                          decoration: InputDecoration(
                                            labelText: loc.transferNoteLabel,
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        SizedBox(
                                          width: double.infinity,
                                          child: FilledButton(
                                            onPressed: _transferLoading
                                                ? null
                                                : _submitTransfer,
                                            child: _transferLoading
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : Text(loc.transferAction),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            children: [
                              Text(
                                loc.walletTransactionsTitle,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w800),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: _openTransactions,
                                child: Text(loc.seeAllAction),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _TransactionFilterChips(
                            value: _txFilter,
                            onChanged: (next) =>
                                setState(() => _txFilter = next),
                          ),
                          const SizedBox(height: 10),
                          txPreview.isEmpty
                              ? AppEmptyState(
                                  title: loc.walletEmptyTransactionsTitle,
                                  subtitle: loc.walletEmptyTransactionsSubtitle,
                                )
                              : _WalletTransactionPreviewList(
                                  items: txPreview,
                                  currency: currency,
                                ),
                          const SizedBox(height: 18),
                          _WalletMetricStrip(
                            earnedAmount: _earnedTotal,
                            spentAmount: _spentTotal,
                            txCount: _transactions.length,
                            currency: currency,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            loc.walletMissionsTitle,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 10),
                          MissionCarousel(items: _missions),
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: _openRules,
                            icon: const Icon(Icons.info_outline_rounded),
                            label: Text(loc.walletRulesAction),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }
}

class _WalletHeroBalance extends StatelessWidget {
  const _WalletHeroBalance({
    required this.amountLabel,
    required this.obscureBalance,
    required this.onToggleVisibility,
    required this.onCardsTap,
  });

  final String amountLabel;
  final bool obscureBalance;
  final VoidCallback onToggleVisibility;
  final VoidCallback onCardsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0E5D58), Color(0xFF0F766E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F766E).withValues(alpha: 0.28),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kullanılabilir Bakiye',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white.withValues(alpha: 0.88),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  amountLabel,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              obscureBalance ? Icons.visibility_off : Icons.visibility,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: onCardsTap,
            icon: const Icon(Icons.account_balance_wallet_outlined),
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class _WalletActionDock extends StatelessWidget {
  const _WalletActionDock({
    required this.onPay,
    required this.onTopUp,
    required this.onTransfer,
    required this.onRequest,
  });

  final VoidCallback onPay;
  final VoidCallback onTopUp;
  final VoidCallback onTransfer;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF121826),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _WalletActionButton(
            icon: Icons.payments_outlined,
            label: 'Öde',
            onTap: onPay,
          ),
          _WalletActionButton(
            icon: Icons.add_circle_outline_rounded,
            label: 'Yükle',
            onTap: onTopUp,
          ),
          _WalletActionButton(
            icon: Icons.sync_alt_rounded,
            label: 'Transfer',
            onTap: onTransfer,
          ),
          _WalletActionButton(
            icon: Icons.request_page_outlined,
            label: 'Talep',
            onTap: onRequest,
          ),
        ],
      ),
    );
  }
}

class _WalletActionButton extends StatelessWidget {
  const _WalletActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
                color: Colors.white.withValues(alpha: 0.06),
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.88),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompactWalletPanel extends StatelessWidget {
  const _CompactWalletPanel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SectionCard(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}

class _WalletTransactionPreviewList extends StatelessWidget {
  const _WalletTransactionPreviewList({
    required this.items,
    required this.currency,
  });

  final List<WalletTransaction> items;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            _WalletPreviewTile(item: items[i], currency: currency),
            if (i != items.length - 1) const Divider(height: 16),
          ],
        ],
      ),
    );
  }
}

class _WalletPreviewTile extends StatelessWidget {
  const _WalletPreviewTile({required this.item, required this.currency});

  final WalletTransaction item;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    final isIncoming = item.type == WalletTransactionType.earn;
    final icon = isIncoming
        ? Icons.south_west_rounded
        : Icons.north_east_rounded;
    final amountPrefix = isIncoming ? '+' : '-';
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFF1F5F9),
          ),
          child: Icon(icon, size: 20, color: const Color(0xFF334155)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 2),
              Text(
                DateFormat('dd MMM yyyy').format(item.date),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        Text(
          '$amountPrefix${AppCurrencyMode.formatFromTry(item.amount, currency: currency)}',
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: isIncoming
                ? const Color(0xFF0F766E)
                : const Color(0xFF111827),
          ),
        ),
      ],
    );
  }
}

class _DailyFlow {
  const _DailyFlow({
    required this.label,
    required this.incoming,
    required this.outgoing,
  });

  final String label;
  final double incoming;
  final double outgoing;

  _DailyFlow copyWith({String? label, double? incoming, double? outgoing}) {
    return _DailyFlow(
      label: label ?? this.label,
      incoming: incoming ?? this.incoming,
      outgoing: outgoing ?? this.outgoing,
    );
  }
}

class _WalletStartCard extends StatelessWidget {
  const _WalletStartCard({
    required this.onTopUp,
    required this.onTransactions,
    required this.onCards,
  });

  final VoidCallback onTopUp;
  final VoidCallback onTransactions;
  final VoidCallback onCards;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hızlı Başlangıç',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'En sık kullanılan işlemler tek dokunuşla.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onTopUp,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: const Text('Para Yükle'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onTransactions,
                  icon: const Icon(Icons.receipt_long_outlined, size: 18),
                  label: const Text('İşlemler'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCards,
                  icon: const Icon(Icons.credit_card_outlined, size: 18),
                  label: const Text('Kartlar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WeeklyFlowCard extends StatelessWidget {
  const _WeeklyFlowCard({required this.items});

  final List<_DailyFlow> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final peak = items.fold<double>(
      1,
      (maxVal, item) =>
          math.max(maxVal, math.max(item.incoming, item.outgoing)),
    );
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Haftalık Akış',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Son 7 gun gelir ve gider dagilimi',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: items
                  .map(
                    (item) => Expanded(
                      child: _DayFlowBar(item: item, maxValue: peak),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _FlowLegendDot(color: Color(0xFF0EA5E9), label: 'Gelen'),
              _FlowLegendDot(color: Color(0xFFF97316), label: 'Giden'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayFlowBar extends StatelessWidget {
  const _DayFlowBar({required this.item, required this.maxValue});

  final _DailyFlow item;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final inHeight = item.incoming <= 0
        ? 3.0
        : (item.incoming / maxValue * 70).clamp(3.0, 70.0);
    final outHeight = item.outgoing <= 0
        ? 3.0
        : (item.outgoing / maxValue * 70).clamp(3.0, 70.0);
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    width: 7,
                    height: inHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0EA5E9),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(width: 4),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 260),
                    curve: Curves.easeOutCubic,
                    width: 7,
                    height: outHeight,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF97316),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.label,
            style: textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowLegendDot extends StatelessWidget {
  const _FlowLegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

class _WalletMetricStrip extends StatelessWidget {
  const _WalletMetricStrip({
    required this.earnedAmount,
    required this.spentAmount,
    required this.txCount,
    required this.currency,
  });

  final double earnedAmount;
  final double spentAmount;
  final int txCount;
  final AppCurrency currency;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: _MetricItem(
            icon: Icons.arrow_downward_rounded,
            label: 'Gelen',
            value: AppCurrencyMode.formatFromTry(
              earnedAmount,
              currency: currency,
              fractionDigits: 0,
            ),
            accent: const Color(0xFF0EA5E9),
            tint: colorScheme.primary.withValues(alpha: 0.08),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricItem(
            icon: Icons.arrow_upward_rounded,
            label: 'Giden',
            value: AppCurrencyMode.formatFromTry(
              spentAmount,
              currency: currency,
              fractionDigits: 0,
            ),
            accent: const Color(0xFFF97316),
            tint: const Color(0xFFF97316).withValues(alpha: 0.08),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricItem(
            icon: Icons.receipt_long_outlined,
            label: 'İşlem',
            value: '$txCount adet',
            accent: const Color(0xFF8B5CF6),
            tint: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
          ),
        ),
      ],
    );
  }
}

class _MetricItem extends StatelessWidget {
  const _MetricItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.accent,
    required this.tint,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color accent;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: tint,
        border: Border.all(color: accent.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: accent),
          const SizedBox(height: 6),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _TransactionFilterChips extends StatelessWidget {
  const _TransactionFilterChips({required this.value, required this.onChanged});

  final _WalletTxFilter value;
  final ValueChanged<_WalletTxFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _TxChip(
          label: 'Tüm İşlem',
          selected: value == _WalletTxFilter.all,
          onTap: () => onChanged(_WalletTxFilter.all),
        ),
        _TxChip(
          label: 'Gelen',
          selected: value == _WalletTxFilter.incoming,
          onTap: () => onChanged(_WalletTxFilter.incoming),
        ),
        _TxChip(
          label: 'Giden',
          selected: value == _WalletTxFilter.outgoing,
          onTap: () => onChanged(_WalletTxFilter.outgoing),
        ),
      ],
    );
  }
}

class _TxChip extends StatelessWidget {
  const _TxChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.16)
              : colorScheme.surface.withValues(alpha: 0.92),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.42)
                : colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: selected
                ? colorScheme.primary
                : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _PanelTile extends StatefulWidget {
  const _PanelTile({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
    required this.active,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback onTap;
  final bool active;

  @override
  State<_PanelTile> createState() => _PanelTileState();
}

class _PanelTileState extends State<_PanelTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isActive = widget.active;
    final baseColor = theme.colorScheme.surface;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: widget.accent.withValues(alpha: 0.12),
        highlightColor: widget.accent.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(16),
            gradient: (isActive || _hovered)
                ? LinearGradient(
                    colors: [
                      widget.accent.withValues(alpha: 0.12),
                      widget.accent.withValues(alpha: 0.04),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isActive ? 0.12 : 0.06),
                blurRadius: isActive ? 16 : 12,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: widget.accent.withValues(alpha: isActive ? 0.45 : 0.25),
            ),
          ),
          child: Column(
            children: [
              _PanelIcon(accent: widget.accent, icon: widget.icon),
              const SizedBox(height: 8),
              Text(
                widget.label,
                textAlign: TextAlign.center,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PanelIcon extends StatelessWidget {
  const _PanelIcon({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surface;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 44,
          width: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: 0.25),
                accent.withValues(alpha: 0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        Container(
          height: 34,
          width: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: base,
            border: Border.all(color: accent.withValues(alpha: 0.35)),
          ),
        ),
        Icon(
          icon,
          size: 18,
          color: accent,
          shadows: [
            Shadow(
              color: accent.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ],
    );
  }
}

class _TopUpMethodTile extends StatelessWidget {
  const _TopUpMethodTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: theme.colorScheme.surface,
          border: Border.all(color: accent.withValues(alpha: 0.25)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            _PanelIcon(accent: accent, icon: icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}
