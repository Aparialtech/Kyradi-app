import 'dart:async';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _logoCtrl;
  late final Animation<double> _scaleIn;
  bool _showContent = false; // 1 sn sonra slogan + buton görünsün

  @override
  void initState() {
    super.initState();

    // Logo scale animasyonu (0.8 → 1.0 ~ 900ms)
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();

    _scaleIn = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutCubic),
    );

    // 1 sn sonra buton + sloganı göster
    Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _showContent = true);
    });
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    super.dispose();
  }

  void _goLogin() {
    // rotanı burada ayarlıyorsun (örn: '/login' ya da '/home')
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF2C3E50), // koyu arka plan
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            // LOGO + marka
            Expanded(
              child: Center(
                child: ScaleTransition(
                  scale: _scaleIn,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // LOGO DOSYAN: assets/images/kyradi_logo.png
                      Image.asset(
                        'assets/images/kyradi_logo.png',
                        height: 120,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'KYRADI',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEFEFEF),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // SLOGAN + BUTON (1sn sonra fade/slide ile gelsin)
            AnimatedOpacity(
              opacity: _showContent ? 1 : 0,
              duration: const Duration(milliseconds: 350),
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 350),
                offset: _showContent ? Offset.zero : const Offset(0, 0.1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      // SLOGAN (renk sitendeki muted tona yakın)
                      Text(
                        ' Yükünü bize bırak, şehri keşfet',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.82),
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 🔥 GRADIENT BUTON (turuncu → pembe → sarı)
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF2C2966),
                                Color(0xFF005C99),
                                Color(0xFF166866),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(28),
                              onTap: _goLogin,
                              child: const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child: Center(
                                  child: Text(
                                    'Bavulumu Takip Et',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // FOOTER (her zaman görünsün)
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                '2025 © aparial.com',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.65),
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
