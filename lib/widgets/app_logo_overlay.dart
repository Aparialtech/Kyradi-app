import 'package:flutter/material.dart';

const double appLogoHeaderHeight = 40;

class AppLogoOverlayController {
  AppLogoOverlayController._();

  static final ValueNotifier<int> notifier = ValueNotifier<int>(0);
  static final ValueNotifier<bool> showTop = ValueNotifier<bool>(false);

  static void trigger() {
    notifier.value = notifier.value + 1;
  }

  static void show() {
    showTop.value = true;
    trigger();
  }

  static void hide() {
    showTop.value = false;
  }
}

class AppLogoOverlay extends StatefulWidget {
  const AppLogoOverlay({super.key});

  @override
  State<AppLogoOverlay> createState() => _AppLogoOverlayState();
}

class _AppLogoOverlayState extends State<AppLogoOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Alignment> _alignment;
  late final Animation<double> _scale;
  late final Animation<double> _glow;
  bool _visible = false;
  bool _showAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    );
    _alignment = AlignmentTween(
      begin: Alignment.center,
      end: const Alignment(0, -0.92),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic));
    _scale = Tween<double>(begin: 1.0, end: 0.55).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );
    _glow = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 1).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1, end: 0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 60,
      ),
    ]).animate(_controller);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        setState(() => _showAnimated = false);
      }
    });
    AppLogoOverlayController.notifier.addListener(_triggerAnimation);
    AppLogoOverlayController.showTop.addListener(_handleVisibility);
    if (AppLogoOverlayController.showTop.value) {
      _visible = true;
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    AppLogoOverlayController.notifier.removeListener(_triggerAnimation);
    AppLogoOverlayController.showTop.removeListener(_handleVisibility);
    _controller.dispose();
    super.dispose();
  }

  void _handleVisibility() {
    if (!mounted) return;
    final shouldShow = AppLogoOverlayController.showTop.value;
    setState(() {
      _visible = shouldShow;
      if (shouldShow) {
        _controller.value = 1;
      }
    });
  }

  void _triggerAnimation() {
    if (!mounted) return;
    if (!AppLogoOverlayController.showTop.value) return;
    setState(() => _visible = true);
    setState(() => _showAnimated = true);
    _controller.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    if (!_visible) return const SizedBox.shrink();
    return IgnorePointer(
      ignoring: true,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _TopHeaderBar(topPadding: topPadding),
          ),
          if (_showAnimated)
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final glow = _glow.value;
                return Align(
                  alignment: _alignment.value,
                  child: Padding(
                    padding: EdgeInsets.only(top: topPadding + 6),
                    child: Transform.scale(
                      scale: _scale.value,
                      child: _LogoBadge(glowStrength: glow),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _TopHeaderBar extends StatelessWidget {
  const _TopHeaderBar({
    required this.topPadding,
  });

  final double topPadding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: topPadding + appLogoHeaderHeight,
      padding: EdgeInsets.only(top: topPadding + 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: _LogoBadge(glowStrength: 0.0, size: 36),
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({
    required this.glowStrength,
    this.size = 60,
  });

  final double glowStrength;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: glowStrength * 0.35),
            blurRadius: 18,
            spreadRadius: 2,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.7),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(size * 0.2),
        child: Image.asset(
          'assets/images/kyradi_app_icon.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
