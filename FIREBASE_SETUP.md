# Firebase Setup (Flutter)

## FlutterFire CLI (recommended)
Use FlutterFire CLI to generate `firebase_options.dart`.
- `flutterfire configure`

## Repo policy
- `GoogleService-Info.plist` (iOS) and `google-services.json` (Android) are secrets.
- They must not be committed to git.
- Place them locally or inject via CI.
 - Android template: `android/app/google-services.json.example`.

## Build expectations
- iOS Release builds fail if `GoogleService-Info.plist` is missing.
- Android Release builds fail if `google-services.json` is missing.

## firebase_options.dart
- This repo includes a stub at `lib/core/firebase/firebase_options.dart`.
- For production, replace it with the FlutterFire CLI output or inject values via CI.
