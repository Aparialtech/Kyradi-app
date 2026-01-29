import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'l10n/app_localizations.dart';
import 'core/app_locale.dart';
import 'core/app_theme_mode.dart';
import 'services/api_service.dart';
import 'ui/components/config_missing_page.dart';
import 'ui/components/error_fallback_page.dart';
import 'utils/crash_log.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'router/app_router.dart';

const _primaryColor = Color(0xFF005C99);
const _secondaryColor = Color(0xFF166866);
const _accentColor = Color(0xFF2C2966);
const _neutralDark = Color(0xFF2C3E50);
const _backgroundColor = Color(0xFFEFEFEF);
const _surfaceColor = Colors.white;
const _textColor = Color(0xFF2E2E2E);
const _fontFamily = 'SF Pro Display';
const _fontFallback = <String>[
  'SF Pro Text',
  'Inter',
  'Poppins',
  'Roboto',
];

Future<void> main() async {
  // Run app with error zone to keep crash diagnostics.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Global error handlers to surface iOS/TestFlight crashes with context.
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        appLog(
          'flutter',
          '${details.exception}\n${details.stack ?? ''}',
          level: AppLogLevel.fatal,
        );
      };

      PlatformDispatcher.instance.onError = (error, stack) {
        appLog('platform', '$error\n$stack', level: AppLogLevel.fatal);
        return true;
      };

      await _safeBootstrap();
      await AppThemeMode.load();
      runApp(const MyApp());
    },
    (error, stack) {
      appLog('zone', '$error\n$stack', level: AppLogLevel.fatal);
    },
  );
}

Future<void> _safeBootstrap() async {
  try {
    await FirebaseBootstrap.initFirebase()
        .timeout(const Duration(seconds: 6));
  } catch (e) {
    appLog('bootstrap', 'firebase init timeout/error: $e',
        level: AppLogLevel.error);
    CrashLogBuffer.recordFatal('bootstrap', 'firebase init failed: $e');
  }

  try {
    await ApiService.ensureInitialized()
        .timeout(const Duration(seconds: 6));
    ApiService.logBaseUrlStatus();
  } catch (e) {
    appLog('bootstrap', 'api init timeout/error: $e',
        level: AppLogLevel.error);
    CrashLogBuffer.recordFatal('bootstrap', 'api init failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    AppLocale.notifier.value = newLocale;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeMode.notifier,
      builder: (context, themeMode, _) {
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
            final darkScheme = ColorScheme.fromSeed(
              seedColor: _primaryColor,
              brightness: Brightness.dark,
            ).copyWith(
              primary: const Color(0xFF5AB0FF),
              onPrimary: const Color(0xFF0B1A26),
              primaryContainer: const Color(0xFF163B5C),
              onPrimaryContainer: Colors.white,
              secondary: const Color(0xFF4FAEAA),
              onSecondary: const Color(0xFF0B1A26),
              secondaryContainer: const Color(0xFF1B2E2D),
              onSecondaryContainer: Colors.white,
              tertiary: const Color(0xFF6C6AD6),
              onTertiary: const Color(0xFF0B0B1A),
              surface: const Color(0xFF111821),
              onSurface: const Color(0xFFE7EDF5),
              surfaceContainerHighest: const Color(0xFF1A2431),
              onSurfaceVariant: const Color(0xFFB5C3D4),
              outline: const Color(0xFF3B4A5A),
              outlineVariant: const Color(0xFF2A3644),
              inverseSurface: const Color(0xFFE7EDF5),
              onInverseSurface: const Color(0xFF111821),
              inversePrimary: const Color(0xFF2C4C6B),
            );

            final baseTextTheme = ThemeData.light().textTheme;
            final textTheme = baseTextTheme.copyWith(
              headlineLarge: baseTextTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
              headlineMedium: baseTextTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
              headlineSmall: baseTextTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.2,
              ),
              titleLarge: baseTextTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.1,
              ),
              titleMedium: baseTextTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              titleSmall: baseTextTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              bodyLarge: baseTextTheme.bodyLarge?.copyWith(
                height: 1.4,
              ),
              bodyMedium: baseTextTheme.bodyMedium?.copyWith(
                height: 1.4,
              ),
              bodySmall: baseTextTheme.bodySmall?.copyWith(
                height: 1.35,
              ),
              labelLarge: baseTextTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            );

            return MaterialApp.router(
              key: ValueKey(currentLocale?.languageCode ?? 'tr'),
              title: 'KYRADI',
              debugShowCheckedModeBanner: false,
              routerConfig: buildAppRouter(),
              theme: ThemeData(
            useMaterial3: true,
            colorScheme: baseScheme,
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
            scaffoldBackgroundColor: _backgroundColor,
            appBarTheme: AppBarTheme(
              backgroundColor: _surfaceColor,
              foregroundColor: _textColor,
              surfaceTintColor: _surfaceColor,
              elevation: 0,
              scrolledUnderElevation: 2,
              shadowColor: _neutralDark.withValues(alpha: 0.08),
              centerTitle: true,
              iconTheme: const IconThemeData(size: 22),
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
            listTileTheme: ListTileThemeData(
              iconColor: baseScheme.primary,
              textColor: baseScheme.onSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: const Color(0xFF1B2B3A),
              contentTextStyle: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: _surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              titleTextStyle: textTheme.titleLarge?.copyWith(
                color: _textColor,
                fontWeight: FontWeight.w700,
              ),
              contentTextStyle: textTheme.bodyMedium?.copyWith(
                color: _textColor,
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: _surfaceColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              showDragHandle: true,
            ),
            chipTheme: ChipThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              labelStyle: textTheme.labelMedium?.copyWith(
                color: baseScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: baseScheme.primary.withValues(alpha: 0.08),
              selectedColor: baseScheme.primary.withValues(alpha: 0.16),
              side: BorderSide(color: baseScheme.outlineVariant),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
                foregroundColor: baseScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
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
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: baseScheme.error, width: 1.4),
              ),
              errorStyle: TextStyle(color: baseScheme.error),
              labelStyle: TextStyle(
                color: baseScheme.onSurfaceVariant,
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: baseScheme.primary,
                foregroundColor: baseScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
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
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: baseScheme.primary,
                side: BorderSide(color: baseScheme.outlineVariant),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
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
            navigationBarTheme: NavigationBarThemeData(
              height: 70,
              backgroundColor: _surfaceColor,
              indicatorColor: baseScheme.primary.withValues(alpha: 0.12),
              labelTextStyle: WidgetStateProperty.resolveWith(
                (states) => TextStyle(
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              iconTheme: WidgetStateProperty.resolveWith(
                (states) => IconThemeData(
                  size: 22,
                  color: states.contains(WidgetState.selected)
                      ? baseScheme.primary
                      : baseScheme.onSurfaceVariant,
                ),
              ),
            ),
            iconTheme: IconThemeData(
              color: baseScheme.primary,
              size: 22,
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
            textTheme: textTheme.apply(
              bodyColor: _textColor,
              displayColor: _textColor,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkScheme,
            fontFamily: _fontFamily,
            fontFamilyFallback: _fontFallback,
            scaffoldBackgroundColor: const Color(0xFF0E141B),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF111821),
              foregroundColor: darkScheme.onSurface,
              surfaceTintColor: const Color(0xFF111821),
              elevation: 0,
              scrolledUnderElevation: 2,
              shadowColor: Colors.black.withValues(alpha: 0.4),
              centerTitle: true,
              iconTheme: const IconThemeData(size: 22),
              titleTextStyle: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Color(0xFFE7EDF5),
              ),
            ),
            cardTheme: CardThemeData(
              elevation: 2,
              margin: EdgeInsets.zero,
              color: const Color(0xFF141D28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              shadowColor: Colors.black.withValues(alpha: 0.25),
            ),
            listTileTheme: ListTileThemeData(
              iconColor: darkScheme.primary,
              textColor: darkScheme.onSurface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            ),
            snackBarTheme: SnackBarThemeData(
              backgroundColor: const Color(0xFF111821),
              contentTextStyle: textTheme.bodyMedium?.copyWith(
                color: Colors.white,
              ),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            dialogTheme: DialogThemeData(
              backgroundColor: const Color(0xFF141D28),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),
              titleTextStyle: textTheme.titleLarge?.copyWith(
                color: darkScheme.onSurface,
                fontWeight: FontWeight.w700,
              ),
              contentTextStyle: textTheme.bodyMedium?.copyWith(
                color: darkScheme.onSurface,
              ),
            ),
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: const Color(0xFF141D28),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              showDragHandle: true,
            ),
            chipTheme: ChipThemeData(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              labelStyle: textTheme.labelMedium?.copyWith(
                color: darkScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: darkScheme.primary.withValues(alpha: 0.14),
              selectedColor: darkScheme.primary.withValues(alpha: 0.24),
              side: BorderSide(color: darkScheme.outlineVariant),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: IconButton.styleFrom(
                foregroundColor: darkScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF141D28),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: darkScheme.outlineVariant,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: darkScheme.outlineVariant,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: darkScheme.primary, width: 1.6),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: darkScheme.error),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: darkScheme.error, width: 1.4),
              ),
              errorStyle: TextStyle(color: darkScheme.error),
              labelStyle: TextStyle(
                color: darkScheme.onSurfaceVariant,
              ),
            ),
            filledButtonTheme: FilledButtonThemeData(
              style: FilledButton.styleFrom(
                backgroundColor: darkScheme.primary,
                foregroundColor: darkScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: darkScheme.primary,
                foregroundColor: darkScheme.onPrimary,
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
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: darkScheme.primary,
                side: BorderSide(color: darkScheme.outlineVariant),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: darkScheme.secondary,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            floatingActionButtonTheme: FloatingActionButtonThemeData(
              backgroundColor: darkScheme.tertiary,
              foregroundColor: darkScheme.onTertiary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            navigationBarTheme: NavigationBarThemeData(
              height: 70,
              backgroundColor: const Color(0xFF111821),
              indicatorColor: darkScheme.primary.withValues(alpha: 0.18),
              labelTextStyle: WidgetStateProperty.resolveWith(
                (states) => TextStyle(
                  fontWeight: states.contains(WidgetState.selected)
                      ? FontWeight.w700
                      : FontWeight.w500,
                  fontSize: 12,
                ),
              ),
              iconTheme: WidgetStateProperty.resolveWith(
                (states) => IconThemeData(
                  size: 22,
                  color: states.contains(WidgetState.selected)
                      ? darkScheme.primary
                      : darkScheme.onSurfaceVariant,
                ),
              ),
            ),
            iconTheme: IconThemeData(
              color: darkScheme.primary,
              size: 22,
            ),
            tabBarTheme: TabBarThemeData(
              labelColor: darkScheme.primary,
              unselectedLabelColor:
                  darkScheme.onSurfaceVariant.withValues(alpha: 0.7),
              indicator: UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: darkScheme.primary,
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
              color: darkScheme.outlineVariant,
              thickness: 1,
            ),
            textTheme: textTheme.apply(
              bodyColor: darkScheme.onSurface,
              displayColor: darkScheme.onSurface,
            ),
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              },
            ),
              ),
              themeMode: themeMode,
              locale: currentLocale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              localeResolutionCallback: (locale, supportedLocales) {
                const fallback = Locale('tr', 'TR');
                if (locale == null) return fallback;
                for (final supported in supportedLocales) {
                  if (supported.languageCode == locale.languageCode) {
                    return supported;
                  }
                }
                return fallback;
              },
              builder: (context, child) {
                if (kReleaseMode && !ApiService.hasResolvedBaseUrl) {
                  appLog(
                    'config',
                    'Release build missing API base URL. Showing setup error page.',
                    level: AppLogLevel.error,
                  );
                  return const ConfigMissingPage();
                }
                // Error widget builder to avoid silent crashes on iOS/TestFlight.
                ErrorWidget.builder = (FlutterErrorDetails details) {
                  appLog(
                    'flutter',
                    '${details.exception}\n${details.stack ?? ''}',
                    level: AppLogLevel.fatal,
                  );
                  if (kDebugMode) {
                    return ErrorWidget(details.exception);
                  }
                  final entry = CrashLogBuffer.recordFatal(
                    'flutter',
                    details.exceptionAsString(),
                  );
                  return ErrorFallbackPage(entry: entry);
                };

                final content = child ?? const SizedBox.shrink();
                return ValueListenableBuilder<CrashLogEntry?>(
                  valueListenable: CrashLogBuffer.fatalNotifier,
                  builder: (context, fatalEntry, _) {
                    if (fatalEntry != null && !kDebugMode) {
                      return ErrorFallbackPage(entry: fatalEntry);
                    }
                    return Localizations.override(
                      context: context,
                      locale: currentLocale,
                      child: content,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
