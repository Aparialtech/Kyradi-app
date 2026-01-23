# Kyradi Mobile App – Regression Checklist

Source references use repo paths for quick lookup.

## 1) Auth (Email/Password + Social) — lib/screens/login_page.dart, register_page.dart, verify_code_page.dart, forgot_password_page.dart, reset_password_page.dart
1. Launch app → IntroSplashPage → tap “Giriş Yap” → LoginPage.
   - Expect login form fields visible (email, password), social buttons (Google/Apple).
2. Invalid credentials login:
   - Enter bad email/pass, tap login → expect error notification (AppNotification), remain on LoginPage.
3. Valid email/password login:
   - Enter valid account, tap login → expect success notification, navigation to HomePage.
   - SharedPreferences should store `userId` (check logs/devtools).
4. Social login (Google/Apple):
   - Trigger Google sign-in → expect consent then HomePage on success; if canceled, no crash.
   - Apple sign-in (on iOS) returns to HomePage or shows error on cancel.
5. Registration:
   - From LoginPage tap “Kayıt Ol” → RegisterPage.
   - Fill required fields, submit → expect verification flow start, pending verification state.
6. Email verification:
   - Navigate to VerifyCodePage, enter code → expect success message and ability to proceed/login.
7. Forgot/Reset password:
   - ForgotPasswordPage: submit email → expect code sent message.
   - ResetPasswordPage: enter email, code, new password → expect success message and ability to log in.

## 2) Locations + Map — lib/screens/home_page.dart, lib/services/locations_service.dart
1. On HomePage load, locations list populates from API; if network fails, seeded defaults appear.
2. Tap a location card → expect map focus/selection updates; available slots shown.
3. “Locations” fetch uses GET /locations; verify network call success (devtools/logs).

## 3) Luggage CRUD — lib/screens/home_page.dart, lib/services/luggage_service.dart
1. From HomePage, tap “Yeni Emanet”/add flow:
   - Fill required fields (drop location, size, timing).
   - Submit → POST /users/{id}/luggages; expect success, new luggage appears in list with QR/pin info.
2. Update luggage metadata:
   - Edit an existing luggage (label/size/time) → PUT /users/{id}/luggages/{luggageId}; expect updated values shown.
3. Change status:
   - Attempt status update without PIN when required → expect validation error.
   - Provide valid PIN/delegate code → status changes (e.g., awaiting → picked); confirm UI reflects new status.
4. List retrieval:
   - Pull-to-refresh or revisit HomePage → GET /users/{id}/luggages returns latest list without duplicates.

## 4) QR Scan/Display — lib/screens/home_page.dart
1. View QR: open luggage detail/preview → QR code renders (qr_flutter).
2. Scan QR: open scan view (_QrScanPage), point to valid QR:
   - Expect decoded content handled (navigation/log message) without crash.
3. Invalid/empty scan → expect graceful failure message or no crash.

## 5) Identity Upload — lib/screens/home_page.dart, lib/services/api_service.dart (uploadIdentityDocument)
1. From profile/identity section, pick image via ImagePicker.
2. Submit upload → POST /uploads/identity; expect success message and returned fileUrl displayed/stored.
3. Large/invalid file → expect handled error (notification) without crash.

## 6) Profile Update — lib/screens/home_page.dart, lib/services/api_service.dart (updateProfile)
1. Edit profile fields (name, phone, address, reminders toggles).
2. Submit → PUT /users/{id}; expect success notification and updated values persisted after reload (GET /users/{id}).
3. Emergency contact fields saved and reloaded correctly.

## 7) Pricing — lib/screens/payment_page.dart, lib/services/api_service.dart (estimatePricing/getPricingQuote)
1. Generate pricing estimate (POST /pricing/estimate) by selecting size/times:
   - Expect total/breakdown shown; errors for invalid date ranges.
2. Pricing quote (GET /pricing/quote) path used in flows: confirm non-zero price displayed; invalid inputs show error.

## 8) Payments (Mock/Checkout/Status) — lib/screens/payment_page.dart, payment_result_page.dart, lib/services/api_service.dart (startPaymentCheckout/mockPayment/getPaymentStatus/sendPaymentWebhook)
1. Checkout initiation:
   - Start payment → POST /payments/checkout; expect checkoutUrl or status info shown.
2. Mock payment:
   - Trigger mock payment → POST /payments/mock; expect success status update in UI.
3. Status polling:
   - Refresh status → GET /payments/status returns paid/unpaid; UI matches.
4. Payment result screen shows success/failure and handles back navigation safely.

## 9) Notifications UI — lib/screens/notifications_page.dart
1. Open NotificationsPage from HomePage menu.
2. Verify list rendering (static or fetched if implemented); no crashes when empty.
3. Toggling reminder settings in HomePage (reminder_service.dart) updates local prefs (check persisted state after restart).

## 10) Localization — lib/main.dart, lib/l10n/*
1. Switch language (AppLocale) if UI allows; verify strings update across main screens.
2. Ensure RTL/long text doesn’t break layouts on Login, Home, Payment, Add Luggage.

## 11) Resilience / Offline
1. Disable network on HomePage load:
   - Locations should fall back to seed data.
   - API calls show friendly error notifications (AppNotification) without crashing.
2. Timeouts (simulated slow network) show error messages, not spinners forever.

## 12) App Start/Navigation — lib/main.dart, lib/screens/intro_splash_page.dart
1. Cold start → IntroSplashPage animations show, then user can choose Login/Register.
2. After successful login, restarting app should navigate to HomePage if userId/token exist (shared_preferences + secure_storage).

