# Kyradi iOS Auth Setup (Google + Apple)

## Overview
This project uses Firebase Auth for Google and Apple sign-in. iOS login depends on proper
OAuth client configuration and Info.plist URL schemes.

## Required iOS Config
- `ios/Runner/Info.plist` must include `CFBundleURLTypes` with:
  - `com.googleusercontent.apps.257787138037-6deiuvca1572r0a2vi7ou1v1nk00e5kt`
- `ios/Runner/Runner.entitlements` must include:
  - `com.apple.developer.applesignin` = `Default`
- Firebase Auth providers (Console):
  - Google: Enabled
  - Apple: Enabled (if used)

## Bundle ID Check
Ensure Firebase Console iOS App Bundle ID matches:
`com.kyradi.kyradi`

## Invalid Credential Troubleshooting
If you see `firebase_auth/invalid-credential`:
1) **Wrong iOS client ID**
   - The iOS OAuth Client ID must be used for Google sign-in.
   - Web client IDs should not be used on iOS.
2) **Audience mismatch**
   - Debug/Profile builds validate `aud` in the ID token.
   - If `aud` != iOS client ID, the token was minted for a different client.
3) **Missing URL scheme**
   - `Info.plist` must contain the reversed client ID scheme.

## Logging Signals (PII-safe)
These log events help diagnose OAuth issues:
- `AUTH_GOOGLE_CLIENT platform=... clientId_used=***<tail>`
- `AUTH_GOOGLE_TOKEN idToken_present=... accessToken_present=... serverAuthCode_present=...`
- `AUTH_GOOGLE_FIREBASE_SIGNIN_START`
- `AUTH_GOOGLE_FIREBASE_SIGNIN_ERROR code=...`

## Notes
- `GoogleService-Info.plist` is NOT required for Google Sign-In client ID resolution in this setup.
- If config is missing, the app should show a user-friendly error instead of crashing.
