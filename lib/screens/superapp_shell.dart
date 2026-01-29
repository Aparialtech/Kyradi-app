import 'dart:ui';
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
    final theme = Theme.of(context);
    final items = <_NavItem>[
      _NavItem(
        label: loc.dashboard,
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        accent: theme.colorScheme.primary,
      ),
      _NavItem(
        label: loc.map,
        icon: Icons.map_outlined,
        activeIcon: Icons.map_rounded,
        accent: theme.colorScheme.secondary,
      ),
      _NavItem(
        label: loc.myLuggages,
        icon: Icons.wallet_travel_outlined,
        activeIcon: Icons.wallet_travel_rounded,
        accent: const Color(0xFFEF8B2C),
      ),
      _NavItem(
        label: walletLabel,
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet_rounded,
        accent: const Color(0xFF5B7CFA),
      ),
      _NavItem(
        label: loc.profile,
        icon: Icons.person_outline,
        activeIcon: Icons.person_rounded,
        accent: const Color(0xFF2BB673),
      ),
    ];
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
        bottomNavigationBar: _PremiumNavBar(
          items: items,
          currentIndex: currentIndex,
          onSelect: (value) => widget.navigationShell.goBranch(
            value,
            initialLocation: value == currentIndex,
          ),
        ),
      ),
    );
  }
}

String _walletLabel(BuildContext context) {
  return AppLocalizations.of(context)!.walletTitle;
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.accent,
  });

  final String label;
  final IconData icon;
  final IconData activeIcon;
  final Color accent;
}

class _PremiumNavBar extends StatelessWidget {
  const _PremiumNavBar({
    required this.items,
    required this.currentIndex,
    required this.onSelect,
  });

  final List<_NavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.75),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.12),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: NavigationBar(
                height: 68,
                backgroundColor: Colors.transparent,
                elevation: 0,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: currentIndex,
                onDestinationSelected: onSelect,
                destinations: [
                  for (var i = 0; i < items.length; i++)
                    NavigationDestination(
                      label: items[i].label,
                      icon: _NavIcon(
                        icon: items[i].icon,
                        isActive: false,
                        accent: items[i].accent,
                      ),
                      selectedIcon: _NavIcon(
                        icon: items[i].activeIcon,
                        isActive: true,
                        accent: items[i].accent,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.accent,
  });

  final IconData icon;
  final bool isActive;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: isActive ? 1.12 : 1.0,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedOpacity(
            duration: const Duration(milliseconds: 180),
            opacity: isActive ? 1 : 0,
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    accent.withValues(alpha: 0.45),
                    accent.withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Icon(
              icon,
              size: 18,
              color: isActive ? accent : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
