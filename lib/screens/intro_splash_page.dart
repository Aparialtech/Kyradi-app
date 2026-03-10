import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../l10n/app_localizations.dart';

class IntroSplashPage extends StatefulWidget {
  const IntroSplashPage({super.key});

  @override
  State<IntroSplashPage> createState() => _IntroSplashPageState();
}

class _IntroSplashPageState extends State<IntroSplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _neonController;
  late final Animation<double> _logoScale;
  late final Animation<Alignment> _logoAlign;
  late final Animation<double> _sloganOpacity;
  late final Animation<Offset> _sloganSlide;
  late final Animation<double> _buttonOpacity;
  late final Animation<double> _neonPulse;

  bool _showAuthChoices = false;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();

    _neonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _logoScale = Tween<double>(begin: 1, end: 0.44).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(0.22, 0.58, curve: Curves.easeInOutCubic),
      ),
    );
    _logoAlign =
        AlignmentTween(
          begin: Alignment.center,
          end: const Alignment(0, -0.9),
        ).animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.22, 0.58, curve: Curves.easeInOutCubic),
          ),
        );
    _sloganOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.56, 0.84, curve: Curves.easeOutCubic),
    );
    _sloganSlide = Tween<Offset>(begin: const Offset(0, 0.14), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.56, 0.84, curve: Curves.easeOutCubic),
          ),
        );
    _buttonOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.82, 1, curve: Curves.easeOutCubic),
    );
    _neonPulse = CurvedAnimation(
      parent: _neonController,
      curve: Curves.easeInOutSine,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    _introController.dispose();
    _neonController.dispose();
    super.dispose();
  }

  void _goLogin() => context.push('/login');
  void _goRegister() => context.push('/register');

  void _showAuthButtons() {
    if (_showAuthChoices) return;
    _neonController.stop();
    setState(() => _showAuthChoices = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _IntroMeshBackground(),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      height: 8,
                      width: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        color: Colors.black.withValues(alpha: 0.12),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _introController,
                        builder: (context, child) {
                          return Stack(
                            children: [
                              Align(
                                alignment: _logoAlign.value,
                                child: Transform.scale(
                                  scale: _logoScale.value,
                                  child: _IntroLogoOrb(scale: _logoScale.value),
                                ),
                              ),
                              Center(
                                child: FadeTransition(
                                  opacity: _sloganOpacity,
                                  child: SlideTransition(
                                    position: _sloganSlide,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          l10n.introTagline,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.displaySmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 52,
                                                height: 1.02,
                                                letterSpacing: -1.2,
                                                color: const Color(0xFF171923),
                                              ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text(
                                          l10n.splashSlogan,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.titleMedium
                                              ?.copyWith(
                                                color: const Color(0xFF444C5A),
                                                height: 1.45,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    FadeTransition(
                      opacity: _buttonOpacity,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        child: _showAuthChoices
                            ? Row(
                                key: const ValueKey('auth_choices'),
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: _goLogin,
                                      style: OutlinedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(54),
                                        backgroundColor: Colors.white
                                            .withValues(alpha: 0.78),
                                        side: BorderSide(
                                          color: Colors.white.withValues(
                                            alpha: 0.86,
                                          ),
                                        ),
                                      ),
                                      child: Text(l10n.loginButtonLabel),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: FilledButton(
                                      onPressed: _goRegister,
                                      style: FilledButton.styleFrom(
                                        minimumSize: const Size.fromHeight(54),
                                        backgroundColor: const Color(
                                          0xFFE96A84,
                                        ),
                                      ),
                                      child: Text(l10n.registerButtonLabel),
                                    ),
                                  ),
                                ],
                              )
                            : _NeonTrackButton(
                                key: const ValueKey('track_cta'),
                                pulse: _neonPulse,
                                label: l10n.introTrackButton,
                                onTap: _showAuthButtons,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IntroLogoOrb extends StatelessWidget {
  const _IntroLogoOrb({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.38),
        border: Border.all(color: Colors.white.withValues(alpha: 0.82)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12 + (1 - scale) * 0.08),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
          BoxShadow(
            color: const Color(0xFF7B4DFF).withValues(alpha: 0.16),
            blurRadius: 32,
          ),
        ],
      ),
      padding: const EdgeInsets.all(28),
      child: Image.asset('assets/images/kyradi_logo.png', fit: BoxFit.contain),
    );
  }
}

class _NeonTrackButton extends StatelessWidget {
  const _NeonTrackButton({
    super.key,
    required this.pulse,
    required this.label,
    required this.onTap,
  });

  final Animation<double> pulse;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: pulse,
      builder: (context, _) {
        final glow = 0.35 + (pulse.value * 0.65);
        final ringScale = 0.98 + (pulse.value * 0.06);
        return Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: Transform.scale(
                scale: ringScale,
                child: Container(
                  height: 62,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    gradient: LinearGradient(
                      colors: [
                        const Color(
                          0xFFE96A84,
                        ).withValues(alpha: 0.2 + glow * 0.35),
                        const Color(
                          0xFF7B4DFF,
                        ).withValues(alpha: 0.18 + glow * 0.3),
                        const Color(
                          0xFF38BDF8,
                        ).withValues(alpha: 0.16 + glow * 0.32),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(
                          0xFFE96A84,
                        ).withValues(alpha: 0.2 + glow * 0.25),
                        blurRadius: 14 + glow * 16,
                        spreadRadius: 1.2 + glow,
                      ),
                      BoxShadow(
                        color: const Color(
                          0xFF7B4DFF,
                        ).withValues(alpha: 0.14 + glow * 0.2),
                        blurRadius: 12 + glow * 14,
                        spreadRadius: 0.6 + glow * 0.8,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  gradient: LinearGradient(
                    colors: [
                      const Color(
                        0xFFE96A84,
                      ).withValues(alpha: 0.74 + glow * 0.18),
                      const Color(
                        0xFF7B4DFF,
                      ).withValues(alpha: 0.66 + glow * 0.16),
                      const Color(
                        0xFF38BDF8,
                      ).withValues(alpha: 0.68 + glow * 0.16),
                    ],
                  ),
                ),
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.white.withValues(alpha: 0.92),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 62,
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          gradient: const LinearGradient(
                            colors: [Color(0xFFF7A5B5), Color(0xFFE96A84)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF1D2230),
                          size: 22,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          label,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1F2430),
                              ),
                        ),
                      ),
                      const SizedBox(width: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IntroMeshBackground extends StatelessWidget {
  const _IntroMeshBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF0F2F7), Color(0xFFE9ECF3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -120,
          right: -60,
          child: _BlurBlob(
            size: 260,
            colors: [Color(0xFFE66D86), Color(0x00E66D86)],
          ),
        ),
        Positioned(
          top: 260,
          right: -90,
          child: _BlurBlob(
            size: 300,
            colors: [Color(0xFF7B4DFF), Color(0x007B4DFF)],
          ),
        ),
        Positioned(
          bottom: 70,
          right: -70,
          child: _BlurBlob(
            size: 300,
            colors: [Color(0xFF38BDF8), Color(0x0038BDF8)],
          ),
        ),
        Positioned(
          bottom: -120,
          left: -90,
          child: _BlurBlob(
            size: 280,
            colors: [Color(0xFFEFC2E4), Color(0x00EFC2E4)],
          ),
        ),
      ],
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(gradient: RadialGradient(colors: colors)),
        ),
      ),
    );
  }
}
