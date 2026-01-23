# Analyze Fix Report

## Files Changed
- `lib/main.dart`
- `lib/screens/home_page.dart`
- `lib/screens/payment_page.dart`
- `lib/services/api_service.dart`
- `lib/screens/login_page.dart`
- `lib/features/explore/explore_page.dart`
- `lib/features/explore/widgets/location_map_view.dart`
- `lib/screens/verify_code_page.dart`
- `lib/screens/forgot_password_page.dart`
- `lib/features/dashboard/dashboard_page.dart`
- `lib/features/home/controllers/home_controller.dart`
- `lib/features/bookings/bookings_page.dart`
- `lib/features/profile/profile_page.dart`
- `lib/features/wallet/widgets/mission_carousel.dart`
- `lib/features/wallet/widgets/invite_friends_page.dart`

## Likely Analyze Errors Prevented
- Broken imports/type resolution in `HomeController` by switching to package imports.
- `type_mismatch` in `MissionCarousel` progress value (int vs double).
- `avoid_print`: replaced raw `print` with `debugPrint` guarded by `kDebugMode`.
- `setState` after dispose: added `mounted` guards in async flows and timers.
- `use_build_context_synchronously`: added `mounted` checks before navigation/dialogs after awaits.
- `unused_field` / `unused_import`: removed unused `locations` field and unused import.
- `control_flow_in_finally`: removed `return` from `finally` blocks in async loaders.
- Controller leaks: disposed local `TextEditingController` instances created inside dialogs.

## Fixes by Category
- Logging:
  - `lib/main.dart`, `lib/screens/home_page.dart`, `lib/screens/payment_page.dart`,
    `lib/services/api_service.dart`, `lib/screens/login_page.dart`
- Async safety:
  - `lib/screens/verify_code_page.dart`, `lib/screens/forgot_password_page.dart`,
    `lib/screens/payment_page.dart`, `lib/screens/home_page.dart`, `lib/features/dashboard/dashboard_page.dart`,
    `lib/features/bookings/bookings_page.dart`, `lib/features/explore/explore_page.dart`,
    `lib/features/profile/profile_page.dart`, `lib/screens/login_page.dart`
- Dialog/controller lifecycle:
  - `lib/screens/home_page.dart` (delegate dialog + credential input)
- Map robustness:
  - `lib/features/explore/explore_page.dart` (skip invalid coordinates)
  - `lib/features/explore/widgets/location_map_view.dart` (remove unused field)
- Imports/types:
  - `lib/features/home/controllers/home_controller.dart`
  - `lib/features/wallet/widgets/mission_carousel.dart`
- Context safety:
  - `lib/features/wallet/widgets/invite_friends_page.dart`

## Remaining Suspicious Spots (UNKNOWN)
- Other debug print statements may exist outside `lib/` (not scanned).
- Any async flows inside `lib/widgets/*` not directly reviewed may still need mounted checks.
