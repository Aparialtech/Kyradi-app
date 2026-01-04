import 'dart:async';

import 'package:flutter/material.dart';
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
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _goRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }

  void _showAuthButtons() {
    setState(() => _showAuthChoices = true);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0, -0.2),
            radius: 1.2,
            colors: [Color(0xFF88C09A), Color(0xFF2C3E50)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ScaleTransition(
                    scale: _scale,
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.08),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.15),
                                blurRadius: 24,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(30),
                          child: Image.asset(
                            'assets/images/kyradi_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 24),
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
                  const SizedBox(height: 42),
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
                                            leading:
                                                const Icon(Icons.login_rounded),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: GradientButton(
                                            text: l10n.registerButtonLabel,
                                            onPressed: _goRegister,
                                            leading: const Icon(
                                              Icons.person_add_alt_1_rounded,
                                            ),
                                            padding: const EdgeInsets.symmetric(
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
                              leading: const Icon(Icons.flight_takeoff_rounded),
                            ),
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
