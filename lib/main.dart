import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'l10n/app_localizations.dart';
import 'core/app_locale.dart';
import 'core/app_theme_mode.dart';
import 'core/app_currency_mode.dart';
import 'core/background_theme_mode.dart';
import 'core/feature_flags.dart';
import 'services/api_service.dart';
import 'services/local_notification_service.dart';
import 'services/push_messaging_service.dart';
import 'ui/components/config_missing_page.dart';
import 'ui/components/error_fallback_page.dart';
import 'utils/crash_log.dart';
import 'core/firebase/firebase_bootstrap.dart';
import 'router/app_router.dart';
import 'ui/theme/app_colors.dart';
import 'ui/theme/app_typography.dart';

final _appRouter = buildAppRouter();

bool _isBenignImageError(FlutterErrorDetails details) {
  final message = details.exceptionAsString();
  if (message.contains('NetworkImageLoadException')) return true;
  if (message.contains('HTTP request failed, statusCode: 404')) return true;
  if (message.contains('Invalid statusCode')) return true;
  if (message.contains('Failed to load network image')) return true;
  if (message.contains('ImageCodecException')) return true;
  final lib = (details.library ?? '').toLowerCase();
  if (lib.contains('image resource')) return true;
  if (lib.contains('image') && message.contains('HttpException')) return true;
  return false;
}

Future<void> main() async {
  // Run app with error zone to keep crash diagnostics.
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // Global error handlers to surface iOS/TestFlight crashes with context.
      FlutterError.onError = (FlutterErrorDetails details) {
        FlutterError.presentError(details);
        if (_isBenignImageError(details)) {
          appLog(
            'flutter',
            'Non-fatal image error: ${details.exception}',
            level: AppLogLevel.warn,
          );
          return;
        }
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
      await AppCurrencyMode.load();
      await AppBackgroundThemeMode.load();
      runApp(const MyApp());
    },
    (error, stack) {
      appLog('zone', '$error\n$stack', level: AppLogLevel.fatal);
    },
  );
}

Future<void> _safeBootstrap() async {
  try {
    await FirebaseBootstrap.initFirebase().timeout(const Duration(seconds: 6));
  } catch (e) {
    appLog(
      'bootstrap',
      'firebase init timeout/error: $e',
      level: AppLogLevel.error,
    );
    CrashLogBuffer.recordFatal('bootstrap', 'firebase init failed: $e');
  }

  try {
    await ApiService.ensureInitialized().timeout(const Duration(seconds: 6));
    ApiService.logBaseUrlStatus();
    await LocalNotificationService.instance.ensureInitialized().timeout(
      const Duration(seconds: 6),
    );
    await PushMessagingService.instance.ensureInitialized().timeout(
      const Duration(seconds: 6),
    );
    if (kDebugMode) {
      appLog('flags', 'FeatureFlags: ${FeatureFlags.snapshot()}');
    }
  } catch (e) {
    appLog('bootstrap', 'api init timeout/error: $e', level: AppLogLevel.error);
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
        final overlayStyle = themeMode == ThemeMode.dark
            ? SystemUiOverlayStyle.light.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.light,
              )
            : SystemUiOverlayStyle.dark.copyWith(
                statusBarColor: Colors.transparent,
                systemNavigationBarColor: Colors.transparent,
                systemNavigationBarIconBrightness: Brightness.dark,
              );
        SystemChrome.setSystemUIOverlayStyle(overlayStyle);
        return ValueListenableBuilder<Locale?>(
          valueListenable: AppLocale.notifier,
          builder: (context, currentLocale, _) {
            final baseScheme = AppColors.lightScheme();
            final darkScheme = AppColors.darkScheme();
            final textTheme = AppTypography.build(ThemeData.light().textTheme);

            return MaterialApp.router(
              key: ValueKey(currentLocale?.languageCode ?? 'tr'),
              title: 'KYRADI',
              debugShowCheckedModeBanner: false,
              routerConfig: _appRouter,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: baseScheme,
                fontFamily: AppTypography.fontFamily,
                fontFamilyFallback: AppTypography.fontFallback,
                scaffoldBackgroundColor: AppColors.background,
                appBarTheme: AppBarTheme(
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.text,
                  surfaceTintColor: AppColors.surface,
                  elevation: 0,
                  scrolledUnderElevation: 2,
                  shadowColor: AppColors.neutralDark.withValues(alpha: 0.08),
                  centerTitle: true,
                  iconTheme: const IconThemeData(size: 22),
                  titleTextStyle: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    color: AppColors.text,
                  ),
                ),
                cardTheme: CardThemeData(
                  elevation: 4,
                  margin: EdgeInsets.zero,
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  shadowColor: AppColors.neutralDark.withValues(alpha: 0.08),
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
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                  ),
                  titleTextStyle: textTheme.titleLarge?.copyWith(
                    color: AppColors.text,
                    fontWeight: FontWeight.w700,
                  ),
                  contentTextStyle: textTheme.bodyMedium?.copyWith(
                    color: AppColors.text,
                  ),
                ),
                bottomSheetTheme: BottomSheetThemeData(
                  backgroundColor: AppColors.surface,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: baseScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: baseScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: baseScheme.primary,
                      width: 1.6,
                    ),
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
                  labelStyle: TextStyle(color: baseScheme.onSurfaceVariant),
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
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                navigationBarTheme: NavigationBarThemeData(
                  height: 70,
                  backgroundColor: AppColors.surface,
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
                iconTheme: IconThemeData(color: baseScheme.primary, size: 22),
                tabBarTheme: TabBarThemeData(
                  labelColor: baseScheme.primary,
                  unselectedLabelColor: baseScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: baseScheme.primary, width: 3),
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
                  bodyColor: AppColors.text,
                  displayColor: AppColors.text,
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
                fontFamily: AppTypography.fontFamily,
                fontFamilyFallback: AppTypography.fontFallback,
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
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
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
                    borderSide: BorderSide(color: darkScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: darkScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: darkScheme.primary,
                      width: 1.6,
                    ),
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
                  labelStyle: TextStyle(color: darkScheme.onSurfaceVariant),
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
                iconTheme: IconThemeData(color: darkScheme.primary, size: 22),
                tabBarTheme: TabBarThemeData(
                  labelColor: darkScheme.primary,
                  unselectedLabelColor: darkScheme.onSurfaceVariant.withValues(
                    alpha: 0.7,
                  ),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: darkScheme.primary, width: 3),
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
                  if (_isBenignImageError(details)) {
                    return const SizedBox.shrink();
                  }
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
