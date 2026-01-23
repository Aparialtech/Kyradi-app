# Stability Audit Report

## Scope
Scanned StatefulWidgets and async flows in:
- `lib/screens/*`
- `lib/features/**/*`
- `lib/services/*`

## Findings and Fixes

### lib/screens/verify_code_page.dart
- Risk: Timer callbacks calling `setState` after dispose.
- Fix: Added `mounted` guard inside `_startCountdown` and periodic timer.

### lib/screens/forgot_password_page.dart
- Risk: Timer callbacks calling `setState` after dispose.
- Fix: Added `mounted` guard inside `_startCountdown` and periodic timer.

### lib/screens/payment_page.dart
- Risk: `setState` and `showTimePicker` after async without mounted guard.
- Fix: Added `mounted` checks in `_fetchQuote`, `_pickDateTime`, and onTap handlers; added `mounted` guard in `_showError`.

### lib/screens/home_page.dart
- Risk: Debounced pricing and location loaders could call `setState` after dispose.
- Fix: Added `mounted` guards at start of `_fetchPricingQuote`, `_loadNearbySuggestions`, `_loadLocations`.

### lib/features/explore/explore_page.dart
- Risk: Invalid lat/lng markers from API causing map issues.
- Fix: Skip marker creation when lat/lng are both zero.

### lib/features/dashboard/dashboard_page.dart
- Risk: Async loaders might call `setState` after dispose.
- Fix: Added `mounted` guards at start of `_loadLocations`, `_restoreUserIdThenLoad`, `_loadProfile`, `_loadLuggages`.

## Controllers/Disposables Verified
- `TextEditingController`, `FocusNode`, `AnimationController`, `Timer`, `MobileScannerController`, and `GoogleMapController` are disposed where used (notably `lib/screens/home_page.dart`, `lib/screens/payment_page.dart`, `lib/screens/verify_code_page.dart`, `lib/screens/forgot_password_page.dart`, `lib/screens/intro_splash_page.dart`, `lib/screens/splash_page.dart`).

## Network/Parsing Robustness
- API response decoding already guarded in `lib/services/api_service.dart`.
- Directions response guarded for empty/invalid JSON in `lib/screens/home_page.dart`.

## Remaining UNKNOWNs
- None detected in `lib/` scope.

## TestFlight Crash Risk Summary
- Reduced risk of `setState` after dispose (timers + async loaders).
- Reduced risk of camera/QR leaks (QR scanner controller disposed).
- Reduced risk of map marker crashes from invalid coordinates.
- Release config safety enforced (API_BASE_URL required in release).
