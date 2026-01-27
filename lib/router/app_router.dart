import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/intro_splash_page.dart';
import '../screens/login_page.dart';
import '../screens/register_page.dart';
import '../screens/verify_code_page.dart';
import '../screens/forgot_password_page.dart';
import '../screens/notifications_page.dart';
import '../screens/location_reservation_page.dart';
import '../screens/superapp_shell.dart';
import '../features/dashboard/dashboard_page.dart';
import '../features/explore/explore_page.dart';
import '../features/bookings/bookings_page.dart';
import '../features/wallet/wallet_page.dart';
import '../features/profile/profile_page.dart';
import '../features/luggage/luggage_list_page.dart';
import '../features/luggage/luggage_add_page.dart';
import '../features/luggage/luggage_detail_page.dart';
import '../features/luggage/qr_preview_page.dart';
import '../features/luggage/qr_scan_page.dart';
import '../models/luggage.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildAppRouter() {
  final legacyPaths = <String>{
    '/home_page',
    '/home-page',
    '/main_home',
    '/legacy',
    '/classic',
    '/kyradi',
  };
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/intro',
    redirect: (context, state) {
      final path = state.uri.path;
      if (legacyPaths.contains(path)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/home',
      ),
      GoRoute(
        path: '/app',
        redirect: (_, __) => '/home',
      ),
      GoRoute(
        path: '/intro',
        builder: (_, __) => const IntroSplashPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterPage(),
      ),
      GoRoute(
        path: '/verify',
        builder: (context, state) =>
            VerifyCodePage(email: state.extra as String? ?? ''),
      ),
      GoRoute(
        path: '/forgot',
        builder: (_, __) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/location/:id',
        builder: (context, state) =>
            LocationReservationPage(locationId: state.pathParameters['id'] ?? ''),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            SuperAppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (_, __) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/explore',
                builder: (_, __) => const ExplorePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/bookings',
                builder: (_, __) => const BookingsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                builder: (_, __) => const WalletPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (_, __) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/luggage',
        builder: (_, __) => const LuggageListPage(),
      ),
      GoRoute(
        path: '/luggage/add',
        builder: (_, __) => const LuggageAddPage(),
      ),
      GoRoute(
        path: '/luggage/:id',
        builder: (context, state) => LuggageDetailPage(
          luggageId: state.pathParameters['id'] ?? '',
          initial: state.extra as LuggageModel?,
        ),
      ),
      GoRoute(
        path: '/luggage/:id/qr',
        builder: (context, state) => QrPreviewPage(
          luggage: state.extra as LuggageModel,
        ),
      ),
      GoRoute(
        path: '/qr/scan',
        builder: (_, __) => const QrScanPage(),
      ),
    ],
  );
}
