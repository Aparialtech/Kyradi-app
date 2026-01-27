# Kyradi iOS Google Sign-In Setup (Secret Policy)

## Why
Google Sign-In on iOS requires `GoogleService-Info.plist` in the app bundle.
Without it, the app must show a configuration error instead of crashing.

## Required file (secret)
- Path: `ios/Runner/GoogleService-Info.plist`
- This file must NOT be committed.
- A placeholder is provided at:
  `ios/Runner/GoogleService-Info.plist.example`

## What must be in the plist
- `REVERSED_CLIENT_ID` (must match URL scheme in Info.plist)
- `CLIENT_ID`, `API_KEY`, `PROJECT_ID`, `GOOGLE_APP_ID`

## Notes
- Ensure the plist is added to the Runner target and Copy Bundle Resources.
- If the file is missing, Google login will be blocked with a user-facing warning.
