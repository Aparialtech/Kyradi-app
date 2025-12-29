// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'KYRADI';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get findLocation => 'Find My Location';

  @override
  String get destination => 'Destination';

  @override
  String get transitRoute => 'Public Transit Route';

  @override
  String get myLuggages => 'My Luggages';

  @override
  String get total => 'Total';

  @override
  String get addLuggageQr => 'Add Luggage (QR)';

  @override
  String get newLuggageAdded => 'New luggage added ✅';

  @override
  String get save => 'Save';

  @override
  String get saveProfile => 'Profile saved ✅';

  @override
  String get saveProfileError => 'Save failed';

  @override
  String get userInfo => 'User Information';

  @override
  String get map => 'Map';

  @override
  String get mapIntro =>
      'See KYRADI spots on the map and build your best route.';

  @override
  String get walkingRoute => 'Walking Route';

  @override
  String get drivingRoute => 'Driving Route';

  @override
  String get openInMaps => 'Open in Google Maps';

  @override
  String get routeOptions => 'Route options';

  @override
  String get firstName => 'First Name';

  @override
  String get lastName => 'Last Name';

  @override
  String get fullNameLabel => 'Full Name';

  @override
  String get phone => 'Phone';

  @override
  String get email => 'Email';

  @override
  String get address => 'Address';

  @override
  String get birthDate => 'Birth Date';

  @override
  String get gender => 'Gender';

  @override
  String get emergencyContact => 'Emergency Contact';

  @override
  String get note => 'Note / Description';

  @override
  String get cameraPermission => 'Camera Permission';

  @override
  String get cameraPermissionDesc => 'Required for QR scanning';

  @override
  String get locationPermission => 'Location Permission';

  @override
  String get locationPermissionDesc =>
      'Required for public transit and location features';

  @override
  String get notificationPermission => 'Notification Permission';

  @override
  String get notificationPermissionDesc => 'For reminders and updates';

  @override
  String get inAppNotifications => 'In-App Notifications';

  @override
  String get notificationSound => 'Notification Sound';

  @override
  String get notificationVibrate => 'Vibration';

  @override
  String get account => 'Account';

  @override
  String get changePassword => 'Change Password';

  @override
  String get logout => 'Logout';

  @override
  String get about => 'About';

  @override
  String get aboutApp => 'This app was developed by KYRADI.';

  @override
  String get qrCode => 'QR Code';

  @override
  String get weight => 'Weight (kg)';

  @override
  String get size => 'Size';

  @override
  String get color => 'Color';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get black => 'Black';

  @override
  String get red => 'Red';

  @override
  String get blue => 'Blue';

  @override
  String get grey => 'Grey';

  @override
  String get other => 'Other';

  @override
  String get saveLuggage => 'Save Luggage';

  @override
  String get qrEmptyError => 'QR code cannot be empty ❌';

  @override
  String get oldPassword => 'Old Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get passwordChanged => 'Password changed ✅';

  @override
  String get passwordMismatch => 'New passwords do not match ❌';

  @override
  String get languageChanged => 'Language changed to English ✅';

  @override
  String permissionGranted(Object permission) {
    return '$permission permission granted ✅';
  }

  @override
  String permissionDenied(Object permission) {
    return '$permission permission denied ❌';
  }

  @override
  String permissionDeniedForever(Object permission) {
    return '$permission permission permanently denied, enable from settings ⚙️';
  }

  @override
  String locationReceived(Object lat, Object lng) {
    return 'Location received 📍 $lat, $lng';
  }

  @override
  String get locationFailed => 'Failed to get location ❌';

  @override
  String get profileSaved => 'Profile saved ✅';

  @override
  String get profileSaveError => 'Profile could not be saved ❌';

  @override
  String get logoutSuccess => 'Logged out successfully 👋';

  @override
  String get copyrightNotice => '© 2025 KYRADI. All rights reserved.';

  @override
  String get demoMapComingSoon => 'Map module will open soon.';

  @override
  String demoLuggageButton(Object number) {
    return 'Luggage $number';
  }

  @override
  String demoLuggageSelected(Object label) {
    return '$label selected.';
  }

  @override
  String get demoFirstNameValue => 'Deniz';

  @override
  String get demoLastNameValue => 'Gezensoy';

  @override
  String get demoNationalIdValue => '12345678901';

  @override
  String get demoAddressValue => 'Istanbul, Türkiye';

  @override
  String get demoEmergencyNameValue => 'Merve Sönmez';

  @override
  String get demoEmergencyAddressValue => 'Kadıköy, Istanbul';

  @override
  String get demoEmergencyEmailValue => 'merve@example.com';

  @override
  String get demoEmergencyRelationValue => 'Sibling / Close Relative';

  @override
  String get emergencyContactNote =>
      'This person will be contacted in emergencies.';

  @override
  String get introTagline => 'Global luggage system';

  @override
  String get introTrackButton => 'Track';

  @override
  String get serverButtonLabel => 'Server';

  @override
  String serverStatus(Object host) {
    return 'Server: $host';
  }

  @override
  String get loginHeroSubtitle => 'Manage your luggage after signing in.';

  @override
  String get loginFormTitle => 'Sign-in details';

  @override
  String get loginFormSubtitle => 'Connect to the latest server to sign in.';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••';

  @override
  String get validationEmailRequired => 'Email is required';

  @override
  String get validationEmailInvalid => 'Enter a valid email';

  @override
  String get validationPasswordRequired => 'Password is required';

  @override
  String validationMinChars(Object count) {
    return 'Enter at least $count characters';
  }

  @override
  String get loginForgotPassword => 'Forgot password';

  @override
  String get clearButton => 'Clear';

  @override
  String get loginButtonLabel => 'Sign in';

  @override
  String get loginSocialDivider => 'or';

  @override
  String get loginContinueWithGoogle => 'Continue with Google';

  @override
  String get loginContinueWithApple => 'Continue with Apple';

  @override
  String loginSocialComingSoon(Object provider) {
    return '$provider will be available soon.';
  }

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get registerButtonLabel => 'Register';

  @override
  String get loginSuccess => 'Signed in successfully ✅';

  @override
  String get loginInvalidCredentials => 'Email or password is incorrect ❌';

  @override
  String get loginTooManyAttempts =>
      'Too many attempts, please try again in a few minutes ⚠️';

  @override
  String get loginFailed => 'Sign-in failed, please try again ❌';

  @override
  String genericErrorWithDetails(Object details) {
    return 'An error occurred: $details';
  }

  @override
  String get loginVerificationRequired => 'Please verify your account 📨';

  @override
  String verificationSendFailedWithDetails(Object details) {
    return 'Verification code could not be sent: $details';
  }

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerPersonalSectionTitle => 'Personal information';

  @override
  String get registerPersonalSectionSubtitle =>
      'Share your identity and birth date.';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderUndisclosed => 'Prefer not to say';

  @override
  String get registerContactSectionTitle => 'Contact information';

  @override
  String get registerContactSectionSubtitle => 'Email and verification details';

  @override
  String get nationalIdLabel => 'National ID number';

  @override
  String get phoneHint => '+90 5xx xxx xx xx';

  @override
  String get registerSecuritySectionTitle => 'Security';

  @override
  String get registerSecuritySectionSubtitle => 'Set and confirm your password';

  @override
  String get registerPasswordRepeatLabel => 'Repeat password';

  @override
  String get registerCaptchaLabel => 'I\'m not a robot';

  @override
  String get registerCaptchaWarning => 'Please check \"I\'m not a robot\"';

  @override
  String get registerKvkkAgreementLabel =>
      'I have read and accept the KYRADI KVKK Disclosure.';

  @override
  String get registerKvkkAgreementWarning =>
      'Please accept the KVKK disclosure.';

  @override
  String get registerRestrictedAgreementLabel =>
      'I have read and accept the items rejected by Aparial and general transport companies.';

  @override
  String get registerRestrictedAgreementWarning =>
      'Please confirm the restricted items document.';

  @override
  String get registerAgreementView => 'View document';

  @override
  String get registerKvkkDialogTitle => 'KYRADI – KVKK Disclosure';

  @override
  String get registerRestrictedDialogTitle =>
      'Items Rejected by Aparial and General Transport Companies';

  @override
  String get registerSuccessMessage =>
      'Registration successful ✅ Verification email sent.';

  @override
  String get registerEmailExistsMessage => 'This email is already registered ❌';

  @override
  String get registerGenericErrorMessage => 'Registration failed ❌';

  @override
  String get validationRequired => 'Required';

  @override
  String get validationPasswordNeedsLetter => 'Include at least one letter';

  @override
  String get validationPasswordNeedsNumber => 'Include at least one number';

  @override
  String get validationPasswordRepeatRequired => 'Repeat your password';

  @override
  String get validationNationalIdRequired => 'National ID is required';

  @override
  String get validationNationalIdLength => 'ID must be 11 digits';

  @override
  String get validationNationalIdChecksumTen => 'ID is invalid (10th digit)';

  @override
  String get validationNationalIdChecksumEleven => 'ID is invalid (11th digit)';

  @override
  String get validationNationalIdInvalid => 'ID is invalid';

  @override
  String get validationPhoneRequired => 'Phone number is required';

  @override
  String get validationPhoneFormat => 'Format: +90 5xx xxx xx xx';

  @override
  String get validationBirthDateRequired => 'Select a birth date';

  @override
  String get validationAgeRequirement => 'You must be older than 18';

  @override
  String get formNotSelected => 'Not selected';

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get forgotIntro =>
      'Let\'s send a code to your registered email to reset your password.';

  @override
  String get forgotEmailSectionTitle => 'Email verification';

  @override
  String get forgotEmailSectionSubtitle =>
      'A one-time code will be sent to your registered address.';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get forgotSendButton => 'Send code';

  @override
  String forgotResendCountdown(int seconds) {
    return 'Send again (${seconds}s)';
  }

  @override
  String get forgotAlreadyHaveCode => 'I already have a code';

  @override
  String get forgotNeedValidEmail => 'Please enter a valid email first 💌';

  @override
  String get forgotCodeSent => 'Code sent 📩';

  @override
  String get forgotEmailNotFound => 'This email is not registered ❌';

  @override
  String get forgotTooManyAttempts =>
      'Too many attempts, please try again in 1 minute ⚠️';

  @override
  String get forgotCodeFailed => 'Code could not be sent ❌';

  @override
  String get resetTitle => 'Reset password';

  @override
  String get resetSubtitle =>
      'Enter the code sent to this email and create a new password.';

  @override
  String get verificationCodeLabel => 'Verification code';

  @override
  String get resetNewPasswordLabel => 'New password';

  @override
  String get resetConfirmPasswordLabel => 'New password (repeat)';

  @override
  String get resetSubmitButton => 'Reset password';

  @override
  String get unknownError => 'Unknown error';

  @override
  String get verificationTitle => 'Email verification';

  @override
  String verificationInstructions(Object email) {
    return 'Enter the 6-digit code sent to $email.';
  }

  @override
  String get verifyButtonLabel => 'Verify code';

  @override
  String get verificationResendButton => 'Send code again';

  @override
  String verificationCountdownLabel(int seconds) {
    return 'Send again in ${seconds}s';
  }

  @override
  String get verificationResentMessage => 'Code sent again';

  @override
  String get verificationSendErrorMessage => 'Sending failed';

  @override
  String get verificationMissingEmailMessage => 'Email could not be retrieved';

  @override
  String get verificationSuccessMessage => 'Account verified ✅';

  @override
  String get verificationErrorMessage => 'Verification error';

  @override
  String get verificationCodeInvalidMessage => 'Code must be 6 digits';

  @override
  String get validationVerificationCodeRequired => 'Code is required';

  @override
  String get validationVerificationCodeLength => 'Enter a 6-digit code';

  @override
  String dashboardGreeting(Object name) {
    return 'Hello, $name';
  }

  @override
  String get dashboardSubtitle =>
      'Share your location and manage your luggage.';

  @override
  String dashboardTotalCount(Object count) {
    return 'Total $count';
  }

  @override
  String get travelerPlaceholder => 'Traveler';

  @override
  String get quickAddLuggage => 'Add Luggage';

  @override
  String get quickTransit => 'Transit';

  @override
  String get dashboardMetricAwaiting => 'Awaiting Drop';

  @override
  String get dashboardMetricStored => 'Stored';

  @override
  String get dashboardMetricPicked => 'Picked Up';

  @override
  String get dashboardMetricCancelled => 'Cancelled';

  @override
  String get deliverySectionTitle => 'Delivery & Route';

  @override
  String get deliverySectionSubtitle =>
      'Choose a drop point and open the route.';

  @override
  String get deliveryPointLabel => 'Drop Point';

  @override
  String deliveryPointOption(Object name, int available, int total) {
    return '$name • $available/$total free';
  }

  @override
  String deliveryPointSelected(Object name) {
    return 'Drop point selected: $name ✅';
  }

  @override
  String get routeNeedLocation => 'Use \"Find My Location\" first.';

  @override
  String get routeNeedDestination => 'Please enter a destination.';

  @override
  String get mapsOpenFailed => 'Google Maps could not be opened.';

  @override
  String get reservationSectionTitle => 'Reservation Statuses';

  @override
  String get reservationSectionSubtitle =>
      'Check availability and occupancy details.';

  @override
  String get luggagesSectionSubtitle =>
      'Show QR codes and complete drop/pickup steps.';

  @override
  String get newLuggageButton => 'New Luggage';

  @override
  String get luggageFilterAll => 'All';

  @override
  String get luggageFilterAwaiting => 'Awaiting Drop';

  @override
  String get luggageFilterStored => 'Stored';

  @override
  String get luggageFilterPicked => 'Picked Up';

  @override
  String get luggageEmptyStateNoItems => 'No luggage yet. Add your first bag!';

  @override
  String get luggageEmptyStateFiltered => 'No luggage found for this filter.';

  @override
  String get profileInfoSubtitle => 'Keep your contact information up to date.';

  @override
  String get emergencySectionSubtitle => 'Add a trusted contact to stay safe.';

  @override
  String get relationLabel => 'Relation';

  @override
  String get emergencyRegisteredPerson => 'Registered contact';

  @override
  String get identitySectionTitle => 'ID / Passport';

  @override
  String get identitySectionSubtitle =>
      'Upload the document that will be shown during deliveries.';

  @override
  String get identityPreviewHint => 'Document preview will appear here';

  @override
  String get identityDocIdCard => 'ID Card';

  @override
  String get identityDocPassport => 'Passport';

  @override
  String identityUploaded(Object file) {
    return 'Uploaded document: $file';
  }

  @override
  String get identityMissing =>
      'No document uploaded yet. ID or passport photo is required for deliveries.';

  @override
  String get identityTakePhoto => 'Capture from camera';

  @override
  String get identityPickFromGallery => 'Choose from gallery';

  @override
  String get identityDelete => 'Delete document';

  @override
  String identityPhotoSaved(Object docType) {
    return '$docType photo saved ✅';
  }

  @override
  String identityUploadFailed(Object details) {
    return 'Document upload failed: $details';
  }

  @override
  String get identityRemoved => 'Document removed.';

  @override
  String get identityProofRequired =>
      'Upload an ID or passport photo before proceeding.';

  @override
  String get profileDataMissing => 'Profile data could not be loaded.';

  @override
  String profileLoadFailed(Object details) {
    return 'Profile could not be loaded: $details';
  }

  @override
  String get profileUserMissing => 'User not found. Please sign in again.';

  @override
  String get luggageLocationMissing =>
      'No location information available for this luggage.';

  @override
  String luggageInfoSize(Object value) {
    return 'Size: $value';
  }

  @override
  String luggageInfoWeight(Object value) {
    return 'Weight: $value kg';
  }

  @override
  String luggageInfoColor(Object value) {
    return 'Color: $value';
  }

  @override
  String noteLabel(Object note) {
    return 'Note: $note';
  }

  @override
  String scheduledDropLabel(Object date) {
    return 'Planned drop: $date';
  }

  @override
  String scheduledPickupLabel(Object date) {
    return 'Planned pickup: $date';
  }

  @override
  String get reservationCancelledLabel =>
      'This reservation has been cancelled.';

  @override
  String get luggageShowQr => 'Show QR Code';

  @override
  String get luggageDropAction => 'I dropped the luggage';

  @override
  String get luggagePickupAction => 'Pick up luggage';

  @override
  String get luggageCancelAction => 'Cancel reservation';

  @override
  String get luggageOpenLocation => 'Open location';

  @override
  String createdAtLabel(Object date) {
    return 'Created: $date';
  }

  @override
  String dropConfirmedAtLabel(Object date) {
    return 'Drop confirmed: $date';
  }

  @override
  String pickupConfirmedAtLabel(Object date) {
    return 'Pickup confirmed: $date';
  }

  @override
  String get loginRequired => 'Please sign in first.';

  @override
  String get luggageCreated => 'New luggage created ✅';

  @override
  String get dropConfirmedMessage => 'Drop confirmed ✅';

  @override
  String get pickupConfirmedMessage => 'Pickup completed ✅';

  @override
  String get operationFailed => 'Operation could not be completed.';

  @override
  String operationFailedWithDetails(Object details) {
    return 'Operation could not be completed: $details';
  }

  @override
  String get reservationCancelledMessage => 'Reservation cancelled.';

  @override
  String get cancelFailed => 'Cancellation failed.';

  @override
  String cancelFailedWithDetails(Object details) {
    return 'Cancellation failed: $details';
  }

  @override
  String get cancelReservationTitle => 'Cancel reservation';

  @override
  String cancelReservationMessage(Object label) {
    return 'Are you sure you want to cancel the reservation for “$label”?';
  }

  @override
  String get dialogDismiss => 'Cancel';

  @override
  String get dialogConfirmCancel => 'Cancel it';

  @override
  String get dialogConfirm => 'Yes';

  @override
  String reservationTileTitle(Object code) {
    return 'Reservation $code';
  }

  @override
  String reservationTileSubtitle(Object code, Object time) {
    return '$code • $time';
  }

  @override
  String reservationSlotSummary(int count, Object time) {
    return '$count bags • $time';
  }

  @override
  String get notificationsTooltip => 'Notifications';

  @override
  String get notificationsClearTooltip => 'Clear';

  @override
  String get notificationsEmptyTitle => 'No notifications yet';

  @override
  String get notificationsEmptySubtitle =>
      'Your notifications will appear here once you sign in or start using the app.';

  @override
  String get notificationTypeSuccess => 'Success';

  @override
  String get notificationTypeWarning => 'Warning';

  @override
  String get notificationTypeError => 'Error';

  @override
  String get notificationTypeInfo => 'Info';

  @override
  String get notificationsRelativeNow => 'Just now';

  @override
  String notificationsRelativeSeconds(int count) {
    return '${count}s ago';
  }

  @override
  String notificationsRelativeMinutes(int count) {
    return '${count}m ago';
  }

  @override
  String notificationsRelativeHours(int count) {
    return '${count}h ago';
  }

  @override
  String notificationsRelativeDays(int count) {
    return '${count}d ago';
  }

  @override
  String get mapNoLocations => 'No locations found.';

  @override
  String get locationServiceDisabled => 'Location service is turned off.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied. Enable it from settings.';

  @override
  String locationFailedWithDetails(Object details) {
    return 'Location could not be obtained: $details';
  }

  @override
  String get locationNotFoundTitle => 'Location not found';

  @override
  String get locationNotFoundMessage =>
      'The selected location is no longer available.';

  @override
  String get permissionManageButton => 'Manage';

  @override
  String get settingsPermissionsTitle => 'Permissions';

  @override
  String get settingsPermissionsSubtitle =>
      'Control camera, location, and notification access.';

  @override
  String get privacySectionTitle => 'Privacy';

  @override
  String get privacySectionSubtitle =>
      'Adjust in-app notification preferences.';

  @override
  String get remindersSectionTitle => 'Reminders';

  @override
  String get remindersSectionSubtitle =>
      'Choose alerts for drop-off and pickup.';

  @override
  String get pushRemindersLabel => 'Push notifications';

  @override
  String get emailRemindersLabel => 'Email reminders';

  @override
  String get languageSectionTitle => 'Language';

  @override
  String get languageSectionSubtitle => 'Choose the language of the app.';

  @override
  String get languageNameTr => 'Turkish';

  @override
  String get languageNameEn => 'English';

  @override
  String get languageNameDe => 'German';

  @override
  String get languageNameEs => 'Spanish';

  @override
  String get languageNameRu => 'Russian';

  @override
  String languageChangedTo(Object language) {
    return 'Language changed to $language ✅';
  }

  @override
  String get upcomingReservationsTitle => 'Upcoming Reservations';

  @override
  String get upcomingReservationsSubtitle =>
      'Names stay hidden; only codes and capacity are shown.';

  @override
  String get upcomingReservationsEmpty =>
      'No reservations are planned for this location.';

  @override
  String get continueSectionTitle => 'Continue';

  @override
  String get continueSectionSubtitle =>
      'If you already have an account, sign in; otherwise register quickly.';

  @override
  String get accountSectionSubtitle => 'Change your password or sign out.';

  @override
  String get logoutDialogTitle => 'Sign out';

  @override
  String get logoutDialogMessage => 'Do you want to sign out of the account?';

  @override
  String get changePasswordIntro => 'Set a new password to stay secure.';

  @override
  String get changePasswordRequirementHint =>
      'At least 8 characters, include letters and numbers.';

  @override
  String get userIdMissing => 'Not signed in: userId not found.';

  @override
  String userIdReadFailed(Object details) {
    return 'Could not read userId: $details';
  }

  @override
  String get mapsMissingApiKey => 'Google Maps API key is not configured.';

  @override
  String routeFetchFailedWithDetails(Object details) {
    return 'Route could not be fetched: $details';
  }

  @override
  String get routeNotFound => 'No route found.';

  @override
  String get routeDataMissing => 'Route data could not be obtained.';

  @override
  String directionsApiError(Object status) {
    return 'Google Directions API failed: $status. Ensure the key has Directions API access.';
  }

  @override
  String get reservationEmptyState => 'No scheduled reservations.';

  @override
  String availableSlotsLabel(int available, int total) {
    return 'Free $available/$total';
  }

  @override
  String get qrDropTitle => 'Confirm drop with QR';

  @override
  String get qrPickupTitle => 'Confirm pickup with QR';

  @override
  String get qrManualEntryHint =>
      'If you cannot scan the QR code, enter it manually.';

  @override
  String get qrVerifyButton => 'Verify';

  @override
  String get qrMismatchMessage => 'QR code does not match. Try again.';

  @override
  String get qrCopied => 'QR code copied.';

  @override
  String get qrTextCopied => 'Text copied.';

  @override
  String get qrCopyCode => 'Copy code';

  @override
  String get qrCopyPrintable => 'Copy printer-friendly text';

  @override
  String get qrShareInstructions =>
      'Share this code with staff to print the sticker. Customers must scan the same code during drop-off and pickup.';

  @override
  String get qrDuplicateWarning =>
      'This QR code is already in use. We generated a new one—please try again.';

  @override
  String get qrScanTip => 'Ensure the code is sharp inside the frame.';

  @override
  String get locationFetching => 'Fetching location...';

  @override
  String get refreshNearbyButton => 'Update nearby locations';

  @override
  String get nearbyLocationsTitle => 'Nearby locations';

  @override
  String get commonSelect => 'Select';

  @override
  String get landingTitle => 'KYRADI Track';

  @override
  String get landingIntro =>
      'Choose where to drop your luggage. Tap a point on the map to see its occupancy and open reservation details.';

  @override
  String get landingLocateSectionTitle => 'Find the closest points';

  @override
  String get landingLocateSectionSubtitle =>
      'Share your location to list recommendations.';

  @override
  String get landingLocateButton => 'Find my location';

  @override
  String get landingLocatingButton => 'Fetching location...';

  @override
  String get landingNearestTitle => 'Closest points';

  @override
  String get landingNearestSubtitle =>
      'Recommended 3 spots based on your location';

  @override
  String get landingGoButton => 'Go';

  @override
  String get landingDetailsButton => 'Details';

  @override
  String get dropTimePending => 'Drop time not selected';

  @override
  String dropTimeLabel(Object time) {
    return 'Drop time: $time';
  }

  @override
  String get pickupTimePending => 'Pickup time not selected';

  @override
  String pickupTimeLabel(Object time) {
    return 'Pickup time: $time';
  }

  @override
  String get scheduleTimesRequired => 'Drop-off and pickup times are required.';

  @override
  String get notesHint => 'Lock, fragile, special instructions...';

  @override
  String get luggageNameHint => 'Give the luggage a name (optional)';

  @override
  String get luggageRegistrationNote =>
      'After saving, your staff can print the QR sticker. Customers must scan the code when dropping off and picking up.';

  @override
  String get luggageDelegateAction => 'Delegate';

  @override
  String get pickupPinTitle => 'Pickup PIN';

  @override
  String get pickupPinLabel => 'Pickup PIN';

  @override
  String get pickupPinHint => '4-digit PIN';

  @override
  String pickupPinGenerated(Object pin) {
    return 'Pickup PIN: $pin';
  }

  @override
  String get pickupPinRequiredMessage => 'Pickup PIN is required.';

  @override
  String get pickupPinInvalidMessage => 'PIN is incorrect. Try again.';

  @override
  String get delegateSetupTitle => 'Delegate';

  @override
  String get delegateNameLabel => 'Full name';

  @override
  String get delegatePhoneLabel => 'Phone';

  @override
  String get delegateEmailLabel => 'Email';

  @override
  String get delegateCodeTitle => 'Delegate Code';

  @override
  String get delegateCodeLabel => 'Delegate code';

  @override
  String get delegateCodeHint => '6-digit code';

  @override
  String delegateCodeGenerated(Object code) {
    return 'Delegate code: $code';
  }

  @override
  String get delegateCodeRequiredMessage => 'Delegate code is required.';

  @override
  String get delegateCodeInvalidMessage => 'Delegate code is invalid.';

  @override
  String get delegateSavedMessage => 'Delegate saved.';

  @override
  String get pickupPinSafetyWarning =>
      'Save your PIN and do not share it. This PIN will be required during pickup.';

  @override
  String get pickupPinCopiedMessage => 'PIN copied — keep it in a safe place.';

  @override
  String get copy => 'Copy';

  @override
  String get luggageCreateFailed => 'Luggage could not be created.';

  @override
  String get savingInProgress => 'Saving...';

  @override
  String get statusLabel => 'Status';

  @override
  String get permissionNameCamera => 'Camera';

  @override
  String get permissionNameLocation => 'Location';

  @override
  String get permissionNameNotifications => 'Notifications';

  @override
  String get footerCopyright => '@2025 aparial.com';

  @override
  String get green => 'Green';

  @override
  String get qrRegenerate => 'Regenerate';

  @override
  String get locationPermissionDenied => 'Location permission not granted.';

  @override
  String get dropDatePickerHelp => 'Drop-off date';

  @override
  String get pickupDatePickerHelp => 'Pickup date';

  @override
  String get addLuggageTitle => 'Create luggage';

  @override
  String get apiSettingsTitle => 'Server Settings';

  @override
  String get apiSettingsBaseUrlLabel => 'Base URL';

  @override
  String apiSettingsActiveLabel(Object url) {
    return 'Active: $url';
  }

  @override
  String get apiSettingsEnvLockedNote =>
      'This value is locked at build time. Update your dart-define parameters to change it.';

  @override
  String get apiSettingsDeviceNote =>
      'Tip: when testing on a device, enter your computer\'s local IP address.';

  @override
  String get apiSettingsResetButton => 'Reset';

  @override
  String get apiSettingsInvalidUrl => 'Please enter a valid URL.';

  @override
  String get apiSettingsResetSuccess => 'Server address reset to default.';

  @override
  String get apiSettingsUpdatedSuccess => 'Server address updated.';
}
