# TestFlight Smoke Checklist

## Preflight
- Ensure release env vars:
  - `API_BASE_URL` (required in release)
  - `GOOGLE_MAPS_API_KEY` (iOS Info.plist uses `$(GOOGLE_MAPS_API_KEY)`)

## Install & Launch
- Install TestFlight build on a real iPhone.
- Launch app; verify no crash on startup.
- If API_BASE_URL missing, confirm ConfigMissingPage appears.

## Auth
- Login with a real account; confirm navigation to SuperAppShell.
- Logout from Profile tab; confirm session cleared and app returns to Intro.

## Dashboard
- Home tab loads; verify no jank on scroll.
- “Kyradi Classic” opens old HomePage.
- Active Trip card: open QR preview.

## Explore
- Switch to Explore; list loads and can toggle Map.
- Tap a location card/marker; open LocationReservationPage.
- Grant/deny location permission; verify no crash.

## Bookings
- Switch to Bookings; tabs show Upcoming/Active/Past.
- Tap “QR Göster” -> preview screen opens.
- Tap “QR Okut” -> classic panel opens.
 - In classic panel, open QR preview and close it; verify camera is not active afterwards.

## Wallet
- Wallet tab loads mock balance/transactions.
- Open Rules, Coupons, Invite pages; back navigation works.

## Profile
- Profile tab loads and shows user info.
- Change password screen opens.
- Identity section opens Classic panel.

## Permissions (iOS)
- Camera: QR scan page prompts and works.
- Location: Explore map prompts and works.
- Photos: Identity upload access prompts if used.
