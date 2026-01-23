import 'dart:async';
import 'package:flutter/material.dart';
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
import '../../ui/components/app_empty_state.dart';
import '../../ui/components/app_skeleton.dart';

class WalletPage extends StatefulWidget {
  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  bool _loading = true;
  double _balance = 0;
  double _monthlyEarned = 0;
  List<WalletTransaction> _transactions = [];
  List<RewardMission> _missions = [];

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    setState(() {
      // TODO: Replace with API integration.
      _balance = 124.5;
      _monthlyEarned = 42.75;
      _transactions = [
        WalletTransaction(
          type: WalletTransactionType.earn,
          amount: 24.5,
          title: 'Taksim KYRADI',
          date: DateTime.now().subtract(const Duration(days: 2)),
          refId: 'TX-102',
          category: 'Cashback',
        ),
        WalletTransaction(
          type: WalletTransactionType.spend,
          amount: 15,
          title: 'Booking payment',
          date: DateTime.now().subtract(const Duration(days: 6)),
          refId: 'TX-093',
          category: 'Usage',
        ),
        WalletTransaction(
          type: WalletTransactionType.earn,
          amount: 18,
          title: 'Weekend campaign',
          date: DateTime.now().subtract(const Duration(days: 18)),
          refId: 'TX-081',
          category: 'Campaign',
        ),
        WalletTransaction(
          type: WalletTransactionType.adjust,
          amount: 5,
          title: 'Manual adjustment',
          date: DateTime.now().subtract(const Duration(days: 32)),
          refId: 'TX-071',
          category: 'Adjustment',
        ),
      ];
      _missions = [
        const RewardMission(
          title: 'Explore 3 locations',
          subtitle: 'Visit or reserve any 3 partner locations.',
          progress: 2,
          total: 3,
          rewardAmount: 20,
        ),
        const RewardMission(
          title: 'Weekend traveler',
          subtitle: 'Complete 2 weekend bookings.',
          progress: 1,
          total: 2,
          rewardAmount: 15,
        ),
        const RewardMission(
          title: 'Invite friends',
          subtitle: 'Invite 3 friends to earn rewards.',
          progress: 0,
          total: 3,
          rewardAmount: 30,
        ),
      ];
      _loading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
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
              onRefresh: _loadMockData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  WalletHeader(
                    title: 'Cashback',
                    subtitle: 'Earn rewards as you travel.',
                    onRulesTap: _openRules,
                  ),
                  const SizedBox(height: 16),
                  BalanceCard(
                    balance: _balance,
                    monthlyEarned: _monthlyEarned,
                  ),
                  const SizedBox(height: 16),
                  WalletQuickActions(
                    onUseCashback: _openRules,
                    onCoupons: _openCoupons,
                    onInvite: _openInvite,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Missions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  MissionCarousel(items: _missions),
                  const SizedBox(height: 20),
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 12),
                  _transactions.isEmpty
                      ? const AppEmptyState(
                          title: 'No transactions yet',
                          subtitle: 'Your cashback activity will appear here.',
                        )
                      : TransactionsList(items: _transactions),
                ],
              ),
            ),
    );
  }
}
