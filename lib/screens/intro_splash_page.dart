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
  late final Animation<double> _logoScale;
  late final Animation<Alignment> _logoAlign;
  late final Animation<double> _brandOpacity;
  late final Animation<Offset> _brandSlide;
  late final Animation<double> _sloganOpacity;
  late final Animation<Offset> _sloganSlide;
  late final Animation<double> _buttonOpacity;

  @override
  void initState() {
    super.initState();
    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..forward();

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
    _brandOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0.5, 0.78, curve: Curves.easeOutCubic),
    );
    _brandSlide = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _introController,
            curve: const Interval(0.5, 0.78, curve: Curves.easeOutCubic),
          ),
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
    super.dispose();
  }

  void _goLogin() => context.push('/login');
  void _goRegister() => context.push('/register');

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
                              Align(
                                alignment: const Alignment(0, -0.42),
                                child: FadeTransition(
                                  opacity: _brandOpacity,
                                  child: SlideTransition(
                                    position: _brandSlide,
                                    child: const _NeonBrandWord(),
                                  ),
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
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _goLogin,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size.fromHeight(54),
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.78,
                                ),
                                side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.86),
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
                                backgroundColor: const Color(0xFFE96A84),
                              ),
                              child: Text(l10n.registerButtonLabel),
                            ),
                          ),
                        ],
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

class _NeonBrandWord extends StatelessWidget {
  const _NeonBrandWord();

  @override
  Widget build(BuildContext context) {
    return Text(
      'KYRADI',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w900,
        fontSize: 28,
        letterSpacing: 4.2,
        color: const Color(0xFFF4F8FF),
        shadows: [
          Shadow(
            color: const Color(0xFF36CFFF).withValues(alpha: 0.82),
            blurRadius: 18,
          ),
          Shadow(
            color: const Color(0xFFE96A84).withValues(alpha: 0.58),
            blurRadius: 24,
          ),
          Shadow(color: Colors.white.withValues(alpha: 0.72), blurRadius: 6),
        ],
      ),
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
