import 'package:flutter/material.dart';
import '../core/drop_locations.dart';
import '../l10n/app_localizations.dart';
import '../widgets/section_card.dart';
import 'home_page.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/explore/explore_page.dart';
import '../features/bookings/bookings_page.dart';
import '../features/wallet/wallet_page.dart';
import '../features/profile/profile_page.dart';

class SuperAppShell extends StatefulWidget {
  const SuperAppShell({super.key});

  @override
  State<SuperAppShell> createState() => _SuperAppShellState();
}

class _SuperAppShellState extends State<SuperAppShell> {
  int _index = 0;

  late final List<Widget> _pages = [
    const DashboardPage(),
    const ExplorePage(),
    const BookingsPage(),
    const WalletPage(),
    const ProfilePage(),
  ];

  Future<bool> _handleWillPop() async {
    if (_index != 0) {
      setState(() => _index = 0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final walletLabel = _walletLabel(context);
    return WillPopScope(
      onWillPop: _handleWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _index,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: _index,
          onDestinationSelected: (value) {
            setState(() => _index = value);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.home_outlined),
              selectedIcon: const Icon(Icons.home),
              label: loc.dashboard,
            ),
            NavigationDestination(
              icon: const Icon(Icons.map_outlined),
              selectedIcon: const Icon(Icons.map),
              label: loc.map,
            ),
            NavigationDestination(
              icon: const Icon(Icons.wallet_travel_outlined),
              selectedIcon: const Icon(Icons.wallet_travel),
              label: loc.myLuggages,
            ),
            NavigationDestination(
              icon: const Icon(Icons.account_balance_wallet_outlined),
              selectedIcon: const Icon(Icons.account_balance_wallet),
              label: walletLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.person_outline),
              selectedIcon: const Icon(Icons.person),
              label: loc.profile,
            ),
          ],
        ),
      ),
    );
  }
}

class ExploreShellPage extends StatelessWidget {
  const ExploreShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locations = DropLocationsRepository.locations;
    return Scaffold(
      appBar: AppBar(
        title: Text(loc.map),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.findLocation,
                  subtitle: loc.deliverySectionSubtitle,
                  icon: Icons.map_outlined,
                ),
                const SizedBox(height: 16),
                _SkeletonBox(height: 160),
                const SizedBox(height: 12),
                Text(
                  loc.map,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HomePage(initialTabIndex: 1),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text(loc.openInMaps),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.nearbyLocationsTitle,
                  subtitle: loc.deliverySectionSubtitle,
                  icon: Icons.apartment_outlined,
                ),
                const SizedBox(height: 12),
                ...locations.map(
                  (location) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.place_outlined),
                    title: Text(location.name),
                    subtitle: Text(location.address),
                    trailing: Text(
                      loc.deliveryPointOption(
                        location.name,
                        location.availableSlots,
                        location.totalSlots,
                      ),
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BookingsShellPage extends StatelessWidget {
  const BookingsShellPage({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.myLuggages)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.myLuggages,
                  subtitle: loc.luggagesSectionSubtitle,
                  icon: Icons.wallet_travel_outlined,
                ),
                const SizedBox(height: 16),
                _SkeletonBox(height: 88),
                const SizedBox(height: 12),
                _SkeletonBox(height: 88),
                const SizedBox(height: 12),
                _SkeletonBox(height: 88),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const HomePage(initialTabIndex: 0),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new),
                  label: Text(loc.quickAddLuggage),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

String _walletLabel(BuildContext context) {
  final languageCode = Localizations.localeOf(context).languageCode;
  switch (languageCode) {
    case 'tr':
      return 'Cuzdan';
    case 'de':
      return 'Wallet';
    case 'es':
      return 'Wallet';
    case 'ru':
      return 'Wallet';
    default:
      return 'Wallet';
  }
}
