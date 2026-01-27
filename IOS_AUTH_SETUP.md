# Kyradi iOS Auth Setup (Google + Apple)

## Google Sign-In (secret file)
- Place `GoogleService-Info.plist` at `ios/Runner/GoogleService-Info.plist`.
- Do NOT commit this file; it is ignored by git.
- A template is provided: `ios/Runner/GoogleService-Info.plist.example`.

## Firebase initialization
- Run `flutterfire configure` to generate `lib/firebase_options.dart` when possible.
- This repo provides a placeholder `lib/firebase_options.dart` that reads values
  from dart-defines (`FIREBASE_API_KEY`, `FIREBASE_APP_ID`, etc.) and otherwise
  falls back to platform defaults (GoogleService-Info.plist on iOS).
- `main.dart` calls `FirebaseBootstrap.initialize()` before auth.

## Required Info.plist scheme
- `CFBundleURLTypes` must include `$(REVERSED_CLIENT_ID)`.

## Apple Sign-In
- `Runner.entitlements` must contain:
  - `com.apple.developer.applesignin = Default`

## Release guard
- Release builds will fail if:
  - `GoogleService-Info.plist` missing
  - `REVERSED_CLIENT_ID` missing
  - URL scheme mismatch
  - Apple Sign-In entitlement missing

## Troubleshooting
- If buttons are disabled, configuration is missing.
- The app will show a user-facing error instead of crashing.

## Backend token strategy (future)
- After Firebase login, send the Firebase ID token to the backend.
- Backend should validate the Firebase ID token and exchange for a session if needed.
