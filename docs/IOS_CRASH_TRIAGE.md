# iOS Crash Triage Checklist

## Required release defines
- `API_BASE_URL` (required in release)
- `GOOGLE_MAPS_API_KEY` (required if maps are enabled)

## Required Info.plist keys (Runner target)
- `NSCameraUsageDescription`
- `NSLocationWhenInUseUsageDescription`
- `NSPhotoLibraryUsageDescription`
- `NSPhotoLibraryAddUsageDescription`

## Repro steps (real device)
1) Launch app -> login -> open Dashboard.
2) Explore tab -> open map -> grant location -> toggle List/Map -> switch tabs and back.
3) QR scan flow -> open scanner -> grant camera -> scan -> back -> reopen.
4) Identity upload -> open camera/photo picker -> grant photos -> cancel and retry.
5) Bookings/Wallet/Profile -> open -> back to Dashboard -> repeat.

## Where to get logs
- iPhone Analytics: Settings -> Privacy & Security -> Analytics & Improvements -> Analytics Data.
- Xcode: Window -> Devices and Simulators -> select device -> Open Console.
- In-app debug logs: long-press Profile title (debug builds only) to view/copy logs.

## Notes
- If crash appears immediately on open, verify `API_BASE_URL` is set and Info.plist usage strings are present.
- If crash happens on camera/map usage, confirm permission prompts were shown and accepted.
