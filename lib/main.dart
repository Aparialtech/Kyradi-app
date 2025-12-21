import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'core/app_locale.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/verify_code_page.dart';
import 'screens/forgot_password_page.dart';
import 'screens/home_page.dart';
import 'services/api_service.dart';
import 'screens/notifications_page.dart';
import 'screens/intro_splash_page.dart';
import 'screens/landing_locations_page.dart';
import 'screens/location_reservation_page.dart';

const _primaryColor = Color(0xFF005C99);
const _secondaryColor = Color(0xFF166866);
const _accentColor = Color(0xFF2C2966);
const _neutralDark = Color(0xFF2C3E50);
const _backgroundColor = Color(0xFFEFEFEF);
const _surfaceColor = Colors.white;
const _textColor = Color(0xFF2E2E2E);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ApiService.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    AppLocale.notifier.value = newLocale;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: AppLocale.notifier,
      builder: (context, currentLocale, _) {
        final baseScheme = ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: _primaryColor,
          onPrimary: Colors.white,
          primaryContainer: _accentColor,
          onPrimaryContainer: Colors.white,
          secondary: _secondaryColor,
          onSecondary: Colors.white,
          secondaryContainer: _neutralDark,
          onSecondaryContainer: Colors.white,
          tertiary: _accentColor,
          onTertiary: Colors.white,
          surface: _surfaceColor,
          onSurface: _textColor,
          surfaceContainerHighest: const Color(0xFFD8DEE6),
          onSurfaceVariant: const Color(0xFF4D5866),
          outline: const Color(0xFF9AA4AE),
          outlineVariant: const Color(0xFFC3C8CE),
          inverseSurface: _neutralDark,
          onInverseSurface: Colors.white,
          inversePrimary: const Color(0xFFA9D2F4),
        );

        return MaterialApp(
          key: ValueKey(currentLocale?.languageCode ?? 'tr'),
          title: 'KYRADI',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: baseScheme,
            scaffoldBackgroundColor: _backgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: _surfaceColor,
              foregroundColor: _textColor,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: _textColor,
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 4,
              margin: EdgeInsets.zero,
              color: _surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: _neutralDark.withValues(alpha: 0.08),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: _surfaceColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: baseScheme.outlineVariant,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: baseScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: baseScheme.primary, width: 1.6),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: baseScheme.error),
              ),
              labelStyle: TextStyle(
                color: baseScheme.onSurfaceVariant,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: baseScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: baseScheme.secondary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: _accentColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            tabBarTheme: TabBarThemeData(
              labelColor: baseScheme.primary,
              unselectedLabelColor:
                  baseScheme.onSurfaceVariant.withValues(alpha: 0.7),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: baseScheme.primary,
                  width: 3,
                ),
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            dividerTheme: DividerThemeData(
              color: baseScheme.outlineVariant,
              thickness: 1,
            ),
            textTheme: ThemeData.light().textTheme.apply(
                  bodyColor: _textColor,
                  displayColor: _textColor,
                ),
          ),
          locale: currentLocale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          builder: (context, child) {
            final content = child ?? const SizedBox.shrink();
            return Localizations.override(
              context: context,
              locale: currentLocale,
              child: content,
            );
          },
          localeResolutionCallback: (deviceLocale, supportedLocales) {
            for (var localeOption in supportedLocales) {
              if (localeOption.languageCode ==
                  AppLocale.notifier.value?.languageCode) {
                return AppLocale.notifier.value;
              }
            }
            return supportedLocales.first;
          },
          initialRoute: '/',
          routes: {
            '/': (_) => const IntroSplashPage(),
            '/landing': (_) => const LandingLocationsPage(),
            '/login': (_) => const LoginPage(),
            '/register': (_) => const RegisterPage(),
            '/verify': (_) => const VerifyCodePage(),
            '/forgot': (_) => const ForgotPasswordPage(),
            '/home': (_) => const HomePage(),
            '/notifications': (_) => const NotificationsPage(),
            '/location-detail': (context) {
              final args = ModalRoute.of(context)?.settings.arguments as String?;
              return LocationReservationPage(locationId: args ?? '');
            },
          },
        );
      },
    );
  }
}
