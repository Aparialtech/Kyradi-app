import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../widgets/gradient_button.dart';
import '../l10n/app_localizations.dart';

class IntroSplashPage extends StatefulWidget {
  const IntroSplashPage({super.key});

  @override
  State<IntroSplashPage> createState() => _IntroSplashPageState();
}

class _IntroSplashPageState extends State<IntroSplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _glow;
  late final Animation<double> _fade;
  late final Animation<double> _orbit;
  bool _showButton = false;
  bool _showAuthChoices = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.easeOutBack);
    _glow = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _orbit = CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic);
    _controller.forward();
    _timer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showButton = true);
      }
    });
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _goLogin() {
    context.push('/login');
  }

  void _goRegister() {
    context.push('/register');
  }

  void _showAuthButtons() {
    setState(() => _showAuthChoices = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    const warmGradient = LinearGradient(
      colors: [
        Color(0xFF0B1220),
        Color(0xFF1B2A4A),
        Color(0xFF163B5C),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            const _IntroMeshBackground(),
            SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: ScaleTransition(
                          scale: _scale,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _glow,
                                builder: (context, child) {
                                  final glow = 0.6 + (_glow.value * 0.4);
                                  return Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      RotationTransition(
                                        turns: _orbit,
                                        child: Container(
                                          height: 210,
                                          width: 210,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: SweepGradient(
                                              colors: [
                                                Colors.white.withValues(
                                                  alpha: 0.16,
                                                ),
                                                Colors.transparent,
                                                Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 200,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: RadialGradient(
                                            colors: [
                                              Colors.white.withValues(
                                                alpha: 0.2 * glow,
                                              ),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      child!,
                                    ],
                                  );
                                },
                                child: FadeTransition(
                                  opacity: _fade,
                                  child: Container(
                                    height: 150,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white.withValues(
                                        alpha: 0.1,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.22,
                                          ),
                                          blurRadius: 32,
                                          offset: const Offset(0, 18),
                                        ),
                                      ],
                                    ),
                                    padding: const EdgeInsets.all(28),
                                    child: Image.asset(
                                      'assets/images/kyradi_logo.png',
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                l10n.appTitle,
                                style: theme.textTheme.headlineLarge?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 6,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.introTagline,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  letterSpacing: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    AnimatedSlide(
                      duration: const Duration(milliseconds: 400),
                      offset: _showButton ? Offset.zero : const Offset(0, 0.2),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 400),
                        opacity: _showButton ? 1 : 0,
                        child: _showAuthChoices
                            ? LayoutBuilder(
                                builder: (context, constraints) {
                                  final width = constraints.maxWidth > 560
                                      ? 560.0
                                      : constraints.maxWidth;
                                  return Align(
                                    child: SizedBox(
                                      width: width,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GradientButton(
                                              text: l10n.loginButtonLabel,
                                              onPressed: _goLogin,
                                              gradient: warmGradient,
                                              glass: true,
                                              leading: const _IconBadge(
                                                icon: Icons.login_rounded,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: GradientButton(
                                              text: l10n.registerButtonLabel,
                                              onPressed: _goRegister,
                                              gradient: warmGradient,
                                              glass: true,
                                              leading: const _IconBadge(
                                                icon: Icons.person_add_alt_1_rounded,
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : GradientButton(
                                text: l10n.introTrackButton,
                                onPressed: _showAuthButtons,
                                gradient: warmGradient,
                                glass: true,
                                leading: const _IconBadge(
                                  icon: Icons.luggage_rounded,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: _showButton ? 1 : 0,
                      child: Text(
                        l10n.splashSlogan,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.85),
                          letterSpacing: 0.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
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

class _IntroMeshBackground extends StatelessWidget {
  const _IntroMeshBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF0B1220),
                Color(0xFF1B2A4A),
                Color(0xFF163B5C),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SizedBox.expand(),
        ),
        Positioned(
          top: -180,
          left: -100,
          child: _BlurBlob(
            size: 320,
            colors: [Color(0xFF3B82F6), Color(0x003B82F6)],
          ),
        ),
        Positioned(
          top: 120,
          right: -180,
          child: _BlurBlob(
            size: 380,
            colors: [Color(0xFF38BDF8), Color(0x0038BDF8)],
          ),
        ),
        Positioned(
          bottom: -200,
          left: -80,
          child: _BlurBlob(
            size: 360,
            colors: [Color(0xFF8B5CF6), Color(0x008B5CF6)],
          ),
        ),
      ],
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({
    required this.size,
    required this.colors,
  });

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: size,
          width: size,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: colors,
            ),
          ),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      width: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.32),
            Colors.white.withValues(alpha: 0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 4,
            left: 4,
            right: 4,
            child: Container(
              height: 6,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.white.withValues(alpha: 0.25),
              ),
            ),
          ),
          Icon(icon, color: Colors.white, size: 18),
        ],
      ),
    );
  }
}
