import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../l10n/app_localizations.dart';
import '../ui/shell/root_shell.dart';

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
      child: RootShell(
        extendBody: true,
        body: widget.navigationShell,
        bottomNavigationBar: _GlassBottomBar(
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

class _GlassBottomBar extends StatelessWidget {
  const _GlassBottomBar({
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
    final isDark = theme.brightness == Brightness.dark;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    final bottomOffset = (bottomInset * 0.10).clamp(2.0, 6.0).toDouble();
    return SafeArea(
      top: false,
      left: false,
      right: false,
      bottom: true,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 4, 16, bottomOffset),
        child: RepaintBoundary(
          child: SizedBox(
            height: 62,
            child: Stack(
              children: [
                Positioned.fill(
                  child: _GlassBottomBarBackground(isDark: isDark),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    child: Row(
                      children: [
                        for (var i = 0; i < items.length; i++)
                          Expanded(
                            child: _LiquidNavDestination(
                              item: items[i],
                              isActive: i == currentIndex,
                              isDark: isDark,
                              onTap: () => onSelect(i),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassBottomBarBackground extends StatelessWidget {
  const _GlassBottomBarBackground({required this.isDark});

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final baseTint = isDark ? const Color(0xFF11192B) : const Color(0xFFF8FAFC);
    final edgeTint = isDark ? const Color(0xFF0A1120) : const Color(0xFFEEF2F7);
    final glassFill = isDark
        ? Colors.white.withValues(alpha: 0.10)
        : Colors.white.withValues(alpha: 0.18);
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.22) : Colors.white.withValues(alpha: 0.56);
    final dropShadow =
        isDark ? Colors.black.withValues(alpha: 0.26) : Colors.black.withValues(alpha: 0.15);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: dropShadow,
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: const Color(0xFF14B8A6).withValues(alpha: 0.10),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: glassFill,
                  gradient: LinearGradient(
                    colors: [
                      baseTint.withValues(alpha: isDark ? 0.56 : 0.70),
                      edgeTint.withValues(alpha: isDark ? 0.50 : 0.66),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: borderColor,
                    width: 1.1,
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isDark ? 0.14 : 0.24),
                      width: 0.8,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: -6,
              top: 8,
              child: Transform.rotate(
                angle: -0.30,
                child: Container(
                  width: 88,
                  height: 15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.30 : 0.42),
                        Colors.white.withValues(alpha: isDark ? 0.02 : 0.06),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              top: 1,
              child: IgnorePointer(
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: isDark ? 0.16 : 0.24),
                        Colors.white.withValues(alpha: 0.0),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LiquidNavDestination extends StatelessWidget {
  const _LiquidNavDestination({
    required this.item,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final _NavItem item;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const deepTeal = Color(0xFF0F766E);
    const activeGlow = Color(0xFF14B8A6);
    return AnimatedScale(
      scale: isActive ? 1.04 : 1.0,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 280),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    isActive
                        ? Colors.white.withValues(alpha: isDark ? 0.22 : 0.34)
                        : Colors.white.withValues(alpha: isDark ? 0.05 : 0.12),
                    isActive
                        ? deepTeal.withValues(alpha: isDark ? 0.26 : 0.18)
                        : Colors.white.withValues(alpha: isDark ? 0.02 : 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: isActive
                      ? Colors.white.withValues(alpha: isDark ? 0.36 : 0.46)
                      : Colors.white.withValues(alpha: isDark ? 0.14 : 0.24),
                  width: 0.9,
                ),
                boxShadow: [
                  if (isActive)
                    BoxShadow(
                      color: activeGlow.withValues(alpha: isDark ? 0.24 : 0.20),
                      blurRadius: 14,
                      spreadRadius: -2,
                      offset: const Offset(0, 5),
                    ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 240),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.0, 0.16),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Icon(
                      isActive ? item.activeIcon : item.icon,
                      key: ValueKey('${item.label}-$isActive'),
                      size: 18.5,
                      color: isActive
                          ? Colors.white.withValues(alpha: 0.96)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.66)
                              : const Color(0xFF334155).withValues(alpha: 0.72)),
                    ),
                  ),
                  const SizedBox(height: 1),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    style: TextStyle(
                      fontSize: 10.2,
                      height: 1.1,
                      letterSpacing: 0.1,
                      color: isActive
                          ? Colors.white.withValues(alpha: 0.96)
                          : (isDark
                              ? Colors.white.withValues(alpha: 0.66)
                              : const Color(0xFF334155).withValues(alpha: 0.72)),
                      fontWeight: isActive ? FontWeight.w500 : FontWeight.w400,
                    ),
                    child: Text(
                      item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
