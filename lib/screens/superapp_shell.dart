import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';

class SuperAppShell extends StatefulWidget {
  const SuperAppShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  State<SuperAppShell> createState() => _SuperAppShellState();
}

class _SuperAppShellState extends State<SuperAppShell> {
  Future<bool> _handleWillPop() async {
    if (widget.navigationShell.currentIndex != 0) {
      widget.navigationShell.goBranch(0);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final walletLabel = _walletLabel(context);
    final currentIndex = widget.navigationShell.currentIndex;
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final allowPop = await _handleWillPop();
        if (allowPop && context.mounted) {
          Navigator.of(context).maybePop(result);
        }
      },
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (value) => widget.navigationShell.goBranch(
            value,
            initialLocation: value == currentIndex,
          ),
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
