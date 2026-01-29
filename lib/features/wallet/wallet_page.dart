import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../features/wallet/models/reward_mission.dart';
import '../../features/wallet/models/wallet_transaction.dart';
import '../../features/wallet/widgets/balance_card.dart';
import '../../features/wallet/widgets/cashback_rules_page.dart';
import '../../features/wallet/widgets/coupons_page.dart';
import '../../features/wallet/widgets/invite_friends_page.dart';
import '../../features/wallet/widgets/mission_carousel.dart';
import '../../features/wallet/widgets/transactions_list.dart';
import '../../features/wallet/widgets/wallet_header.dart';
import '../../features/wallet/widgets/wallet_quick_actions.dart';
import '../../features/campaigns/campaigns_page.dart';
import 'pages/wallet_transactions_page.dart';
import 'pages/wallet_cashback_page.dart';
import 'pages/wallet_cards_page.dart';
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_skeleton.dart';
import '../../utils/crash_log.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/section_card.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

enum _WalletPanel { none, coupon, topup, transfer }

class _WalletPageState extends State<WalletPage>
    with SingleTickerProviderStateMixin {
  bool _loading = true;
  double _balance = 0;
  double _monthlyEarned = 0;
  List<WalletTransaction> _transactions = [];
  List<RewardMission> _missions = [];
  bool _didSeed = false;
  _WalletPanel _openPanel = _WalletPanel.none;

  final _couponCtrl = TextEditingController();
  bool _couponLoading = false;
  String? _couponStatus;

  final _topUpAmountCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _cardExpiryCtrl = TextEditingController();
  final _cardCvvCtrl = TextEditingController();
  final FocusNode _cvvFocus = FocusNode();
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
    _topUpAmountCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _cardCvvCtrl.dispose();
    _cvvFocus.dispose();
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CashbackRulesPage()),
    );
  }

  void _openCoupons() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CouponsPage()),
    );
  }

  void _openInvite() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const InviteFriendsPage()),
    );
  }

  void _openCampaigns() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CampaignsPage()),
    );
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
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const WalletCardsPage()),
    );
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
        appLog('wallet', 'COUPON_APPLY_ERR code=$code', level: AppLogLevel.warn);
      }
    } catch (e) {
      if (!mounted) return;
      _couponStatus = loc.couponFailedMessage;
      AppNotification.show(
        context,
        message: loc.couponFailedMessage,
        type: AppNotificationType.error,
      );
      appLog('wallet', 'COUPON_APPLY_ERR code=$code err=$e', level: AppLogLevel.error);
    } finally {
      if (mounted) setState(() => _couponLoading = false);
    }
  }

  Future<void> _submitTopUp() async {
    final loc = AppLocalizations.of(context)!;
    if (_topUpLoading) return;
    final amount = double.tryParse(_topUpAmountCtrl.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0) {
      AppNotification.show(
        context,
        message: loc.topUpInvalidAmountMessage,
        type: AppNotificationType.warning,
      );
      return;
    }
    if (_cardNumberCtrl.text.trim().length < 12 ||
        _cardNameCtrl.text.trim().isEmpty ||
        _cardExpiryCtrl.text.trim().length < 4 ||
        _cardCvvCtrl.text.trim().length < 3) {
      AppNotification.show(
        context,
        message: loc.topUpInvalidCardMessage,
        type: AppNotificationType.warning,
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.topUpConfirmTitle),
        content: Text(
          loc.topUpConfirmMessage(
            amount.toStringAsFixed(2),
            _maskCardNumber(_cardNumberCtrl.text),
          ),
        ),
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
    setState(() => _topUpLoading = true);
    appLog('wallet', 'TOPUP_START amount=$amount', level: AppLogLevel.info);
    try {
      await _showTopUpProcessingDialog(loc);
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (!mounted) return;
      setState(() {
        _balance += amount;
        _transactions.insert(
          0,
          WalletTransaction(
            type: WalletTransactionType.earn,
            amount: amount,
            title: loc.topUpTransactionTitle,
            date: DateTime.now(),
            refId: 'TP-${DateTime.now().millisecondsSinceEpoch}',
            category: loc.topUpTransactionCategory,
          ),
        );
      });
      await _storeBalance();
      AppNotification.show(
        context,
        message: loc.topUpSuccessMessage,
        type: AppNotificationType.success,
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

  String _maskCardNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'\s+'), '');
    if (digits.length < 4) return '****';
    final tail = digits.substring(digits.length - 4);
    return '**** **** **** $tail';
  }

  Future<void> _showTopUpProcessingDialog(AppLocalizations loc) async {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(loc.topUpProcessingTitle),
        content: Row(
          children: [
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(loc.topUpProcessingSubtitle)),
          ],
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  Future<void> _submitTransfer() async {
    final loc = AppLocalizations.of(context)!;
    if (_transferLoading) return;
    final target = _transferTargetCtrl.text.trim();
    final amount = double.tryParse(_transferAmountCtrl.text.replaceAll(',', '.')) ?? 0;
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
        content: Text(loc.transferConfirmMessage(target, amount.toStringAsFixed(2))),
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
    appLog('wallet', 'TRANSFER_START target=$target amount=$amount', level: AppLogLevel.info);
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
      AppNotification.show(
        context,
        message: loc.transferSuccessMessage,
        type: AppNotificationType.success,
      );
      appLog('wallet', 'TRANSFER_OK target=$target amount=$amount', level: AppLogLevel.info);
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.walletTitle)),
      body: _loading
          ? ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
              children: const [
                AppSkeleton(height: 110, radius: 20),
                SizedBox(height: 16),
                AppSkeleton(height: 90, radius: 20),
                SizedBox(height: 16),
                AppSkeleton(height: 160, radius: 20),
                SizedBox(height: 16),
                AppSkeleton(height: 220, radius: 20),
              ],
            )
          : RefreshIndicator(
              onRefresh: () => _loadMockData(AppLocalizations.of(context)!),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  WalletHeader(
                    title: loc.walletHeaderTitle,
                    subtitle: loc.walletHeaderSubtitle,
                    onRulesTap: _openRules,
                  ),
                  const SizedBox(height: 16),
                  BalanceCard(
                    balance: _balance,
                    monthlyEarned: _monthlyEarned,
                  ),
                  const SizedBox(height: 16),
                  WalletQuickActions(
                    onTopUp: () => _togglePanel(_WalletPanel.topup),
                    onTransactions: _openTransactions,
                    onCashback: _openCashback,
                    onCoupons: _openCoupons,
                    onCards: _openCards,
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: loc.walletActionsTitle,
                          subtitle: loc.walletActionsSubtitle,
                          icon: Icons.bolt_outlined,
                        ),
                        const SizedBox(height: 12),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final tileWidth = (constraints.maxWidth - 24) / 3;
                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                SizedBox(
                                  width: tileWidth,
                                  child: _PanelTile(
                                    label: loc.couponSectionTitle,
                                    icon: Icons.discount_outlined,
                                    accent: Theme.of(context).colorScheme.primary,
                                    active: _openPanel == _WalletPanel.coupon,
                                    onTap: () => _togglePanel(_WalletPanel.coupon),
                                  ),
                                ),
                                SizedBox(
                                  width: tileWidth,
                                  child: _PanelTile(
                                    label: loc.topUpSectionTitle,
                                    icon: Icons.account_balance_wallet_outlined,
                                    accent: const Color(0xFFE53935),
                                    active: _openPanel == _WalletPanel.topup,
                                    onTap: () => _togglePanel(_WalletPanel.topup),
                                  ),
                                ),
                                SizedBox(
                                  width: tileWidth,
                                  child: _PanelTile(
                                    label: loc.transferSectionTitle,
                                    icon: Icons.compare_arrows_outlined,
                                    accent: const Color(0xFF2E7D32),
                                    active: _openPanel == _WalletPanel.transfer,
                                    onTap: () => _togglePanel(_WalletPanel.transfer),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: _openPanel == _WalletPanel.coupon
                        ? SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionHeader(
                                  title: loc.couponSectionTitle,
                                  subtitle: loc.couponSectionSubtitle,
                                  icon: Icons.discount_outlined,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _couponCtrl,
                                  textCapitalization: TextCapitalization.characters,
                                  decoration: InputDecoration(
                                    labelText: loc.couponInputLabel,
                                    prefixIcon:
                                        const Icon(Icons.confirmation_number_outlined),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: FilledButton(
                                        onPressed:
                                            _couponLoading ? null : _applyCoupon,
                                        child: _couponLoading
                                            ? const SizedBox(
                                                height: 18,
                                                width: 18,
                                                child: CircularProgressIndicator(
                                                    strokeWidth: 2),
                                              )
                                            : Text(loc.couponApplyAction),
                                      ),
                                    ),
                                  ],
                                ),
                                if (_couponStatus != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    _couponStatus!,
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: _openPanel == _WalletPanel.topup
                        ? SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionHeader(
                                  title: loc.topUpSectionTitle,
                                  subtitle: loc.topUpSectionSubtitle,
                                  icon: Icons.account_balance_wallet_outlined,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _AmountChip(
                                      label: '100 ₺',
                                      onTap: () => _topUpAmountCtrl.text = '100',
                                    ),
                                    const SizedBox(width: 8),
                                    _AmountChip(
                                      label: '250 ₺',
                                      onTap: () => _topUpAmountCtrl.text = '250',
                                    ),
                                    const SizedBox(width: 8),
                                    _AmountChip(
                                      label: '500 ₺',
                                      onTap: () => _topUpAmountCtrl.text = '500',
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _topUpAmountCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: loc.topUpAmountLabel),
                                ),
                                const SizedBox(height: 16),
                                _AnimatedCardPreview(
                                  cardNumber: _cardNumberCtrl.text,
                                  cardName: _cardNameCtrl.text,
                                  expiry: _cardExpiryCtrl.text,
                                  cvv: _cardCvvCtrl.text,
                                  showBack: _cvvFocus.hasFocus,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _cardNumberCtrl,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  decoration:
                                      InputDecoration(labelText: loc.cardNumberLabel),
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _cardNameCtrl,
                                  decoration:
                                      InputDecoration(labelText: loc.cardHolderNameLabel),
                                  onChanged: (_) => setState(() {}),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                        controller: _cardExpiryCtrl,
                                        keyboardType: TextInputType.number,
                                        decoration:
                                            InputDecoration(labelText: loc.cardExpiryLabel),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _cardCvvCtrl,
                                        focusNode: _cvvFocus,
                                        keyboardType: TextInputType.number,
                                        obscureText: true,
                                        decoration:
                                            InputDecoration(labelText: loc.cardCvvLabel),
                                        onChanged: (_) => setState(() {}),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: _topUpLoading ? null : _submitTopUp,
                                  child: _topUpLoading
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : Text(loc.topUpPayAction),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 16),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    child: _openPanel == _WalletPanel.transfer
                        ? SectionCard(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionHeader(
                                  title: loc.transferSectionTitle,
                                  subtitle: loc.transferSectionSubtitle,
                                  icon: Icons.compare_arrows_outlined,
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _transferTargetCtrl,
                                  decoration:
                                      InputDecoration(labelText: loc.transferTargetLabel),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _transferAmountCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration:
                                      InputDecoration(labelText: loc.transferAmountLabel),
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _transferNoteCtrl,
                                  decoration:
                                      InputDecoration(labelText: loc.transferNoteLabel),
                                ),
                                const SizedBox(height: 16),
                                FilledButton(
                                  onPressed: _transferLoading ? null : _submitTransfer,
                                  child: _transferLoading
                                      ? const SizedBox(
                                          height: 18,
                                          width: 18,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : Text(loc.transferAction),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    loc.walletMissionsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  MissionCarousel(items: _missions),
                  const SizedBox(height: 20),
                  Text(
                    loc.walletTransactionsTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _transactions.isEmpty
                      ? AppEmptyState(
                          title: loc.walletEmptyTransactionsTitle,
                          subtitle: loc.walletEmptyTransactionsSubtitle,
                        )
                      : TransactionsList(items: _transactions),
                ],
              ),
            ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
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
  const _PanelIcon({
    required this.accent,
    required this.icon,
  });

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

class _AnimatedCardPreview extends StatelessWidget {
  const _AnimatedCardPreview({
    required this.cardNumber,
    required this.cardName,
    required this.expiry,
    required this.cvv,
    required this.showBack,
  });

  final String cardNumber;
  final String cardName;
  final String expiry;
  final String cvv;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayNumber = cardNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : cardNumber.replaceAllMapped(RegExp(r'.{4}'), (m) => '${m.group(0)} ');
    final displayName = cardName.isEmpty ? 'CARDHOLDER' : cardName.toUpperCase();
    final displayExpiry = expiry.isEmpty ? 'MM/YY' : expiry;
    final displayCvv = cvv.isEmpty ? '•••' : cvv;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final rotate = Tween<double>(begin: 1, end: 0).animate(animation);
        return AnimatedBuilder(
          animation: rotate,
          child: child,
          builder: (context, child) {
            final angle = showBack ? 3.1416 * rotate.value : -3.1416 * rotate.value;
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()..rotateY(angle),
              child: child,
            );
          },
        );
      },
      child: showBack
          ? _CardBack(
              key: const ValueKey('back'),
              cvv: displayCvv,
            )
          : _CardFront(
              key: const ValueKey('front'),
              number: displayNumber,
              name: displayName,
              expiry: displayExpiry,
            ),
    );
  }
}

class _CardFront extends StatelessWidget {
  const _CardFront({
    super.key,
    required this.number,
    required this.name,
    required this.expiry,
  });

  final String number;
  final String name;
  final String expiry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF005C99), Color(0xFF2C2966)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'KYRADI',
            style: theme.textTheme.titleSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const Spacer(),
          Text(
            number.trim(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                expiry,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardBack extends StatelessWidget {
  const _CardBack({super.key, required this.cvv});

  final String cvv;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2966), Color(0xFF005C99)],
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 36,
            color: Colors.black.withValues(alpha: 0.6),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      cvv,
                      style: theme.textTheme.labelMedium?.copyWith(
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'CVV',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
