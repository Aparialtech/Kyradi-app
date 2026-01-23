# Kyradi Mobile App – Environment Setup

## API base URL
- The app reads `API_BASE_URL` from `--dart-define`. If missing, it falls back to a hardcoded production URL in code; avoid relying on that for local/testing.
- Recommended:
  - Local backend: `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000` (Android emulator) or `http://localhost:3000` (iOS simulator/desktop).
  - Staging: `flutter run --dart-define=API_BASE_URL=https://staging-api.kyradi.com`
  - Production: `flutter run --dart-define=API_BASE_URL=https://api.kyradi.com`

## Security note
- Do NOT ship builds that rely on the hardcoded prod URL; always set `API_BASE_URL` explicitly per build flavor/environment.
- Keep credentials/tokens out of logs; ensure `flutter_secure_storage` is available on devices for token persistence.

## Other optional dart-defines
- `API_PORT` (fallback for local dev), `IOS_SIMULATOR` (to force localhost), `GOOGLE_MAPS_API_KEY` for Maps.
