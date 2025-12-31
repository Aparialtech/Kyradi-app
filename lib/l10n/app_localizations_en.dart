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
  String get registerKvkkDocumentBody =>
      'Personal Data Protection and Processing Notice\nThis notice explains which personal data are processed within the KYRADI platform and for what purposes, in accordance with the Turkish Personal Data Protection Law No. 6698 (\"KVKK\").\n\nTypes of Personal Data Processed\nWithin KYRADI, the following personal data groups are processed:\nCustomer data:\nName and surname, phone, QR code token, reservation and locker information, payment amount and transaction number\nStaff data:\nName and surname, email, user role, IP, transaction logs, session information\nTechnical data:\nAudit log records, browser/device information, error reports\n\nPurposes of Processing\nPersonal data are processed for providing the reservation flow, generating and verifying QR codes, managing payment intents, operating baggage drop-off and pickup processes, ensuring system security and detecting abuse, fulfilling legal retention obligations, and reporting and platform improvements.\n\nLegal Bases\nPersonal data are processed based on KVKK Article 5/2-c (establishment and performance of a contract), Article 5/2-f (legitimate interest), Article 5/2-ç (legal obligations), and explicit consent where required.\n\nRecipients of Data Transfers\nPersonal data may be transferred to payment service providers such as Stripe and Iyzico, cloud providers such as AWS, Google Cloud, Render, and Vercel for infrastructure and hosting, relevant public authorities in mandatory cases, and legal or financial advisors.\n\nRetention Periods\nPersonal data are retained for 10 years for reservation and payment records, 2 years for audit logs, and 1 year after account closure for user accounts; QR code tokens are retained for 1–24 hours.\n\nSecurity Measures\nKYRADI applies technical and administrative security measures such as tenant-based data isolation, password hashing, JWT-based security, role-based access control, rate limiting and attack prevention, and audit logs for critical actions.\n\nData Subject Rights\nUnder Article 11 of KVKK, data subjects have the rights to learn whether their personal data are processed, request deletion or correction, object to processing, and claim compensation in case of damage.\n\nApplications can be sent to kvkk@kyradi.com.';

  @override
  String get registerRestrictedDocumentBody =>
      'This document summarizes items that Aparial and general carriers do not accept for transport.\nFor safety, legal regulations, and operational risk reasons, the items listed below are not accepted for transport:\n\nDangerous and Risky Items\n- Explosives (dynamite, fireworks, grenades, etc.)\n- Flammable and combustible materials (gasoline, thinner, paint, solvents, etc.)\n- Pressurized gases (propane, butane, oxygen cylinders, etc.)\n- Toxic, poisonous, or corrosive chemicals (acid, base, bleach, etc.)\n- Radioactive materials\n- Flammable liquids or solvents containing hazardous chemicals\n- Any material or device that poses an explosion or fire risk\n\nWeapons and Hazardous Equipment\n- Weapons, ammunition, and similar firearms\n- Sharp or piercing tools (daggers, long knives, sharp metal tools, etc.)\n\nDevices and Pressurized Products\n- Devices containing gas or fuel (fuel-filled camping stoves, etc.)\n- Pressurized aerosol cans (sprays containing hazardous gas)\n- High-capacity or spare lithium batteries\n\nItems that Cause Disturbance or Safety Risk\n- Strong-smelling, smoke-emitting, or disturbing substances\n\nValuables\n- Jewelry (gold, precious stones, etc.) are not accepted for transport.\n- Cash (regardless of amount) is not accepted for transport.\n\nNote:\nSome items may be transported with specific permits, quantities, or safety measures. However, in general, such items are rejected by both Aparial and other carriers.';

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
  String occupancyLabel(Object current, Object max) {
    return 'Occupancy: $current/$max';
  }

  @override
  String get locationOpenLabel => 'Open';

  @override
  String get locationClosedLabel => 'Closed';

  @override
  String get openingHoursTitle => 'Opening Hours';

  @override
  String get openingHoursSubtitle => 'Weekly schedule';

  @override
  String get openingHoursAlwaysOpen => 'Open 24/7';

  @override
  String get openingHoursClosed => 'Closed';

  @override
  String get locationFullWarning => 'Selected location is full.';

  @override
  String get locationClosedWarning => 'Selected location is currently closed.';

  @override
  String get locationInactiveWarning => 'Selected location is inactive.';

  @override
  String get protectionLevelTitle => 'Protection Level';

  @override
  String get protectionStandard => 'Standard';

  @override
  String get protectionPremium => 'Premium protection';

  @override
  String get paymentMethodTitle => 'Payment Method';

  @override
  String get paymentMethodCard => 'Card';

  @override
  String get paymentMethodInstallment => 'Installment';

  @override
  String get paymentMethodPayAtHotel => 'Pay at hotel';

  @override
  String get paymentHotelCommissionNote =>
      'A 5% hotel commission will be added.';

  @override
  String get paymentStartAction => 'Start payment';

  @override
  String get paymentRequiredBeforeDropMessage =>
      'Drop-off cannot be completed before payment.';

  @override
  String get paymentNotCompletedMessage =>
      'Payment must be completed before drop-off.';

  @override
  String get paymentCompletedMessage =>
      'Payment completed. You can drop your luggage.';

  @override
  String get paymentPageTitle => 'Payment';

  @override
  String get paymentPageSubtitle =>
      'Enter your card details to complete payment.';

  @override
  String get paymentCardNumberLabel => 'Card number';

  @override
  String get paymentCardNameLabel => 'Name on card';

  @override
  String get paymentExpiryLabel => 'Expiry';

  @override
  String get paymentCvcLabel => 'CVC';

  @override
  String get paymentCompleteAction => 'Complete payment';

  @override
  String get paymentFormIncompleteMessage =>
      'Please complete all card details.';

  @override
  String get paymentFailedMessage => 'Payment could not be completed.';

  @override
  String get paymentPayAtHotelTitle => 'Pay at hotel';

  @override
  String get paymentPayAtHotelBody =>
      'You can complete your payment at the selected location.';

  @override
  String paymentTotalLabel(Object amount) {
    return 'Total: $amount TRY';
  }

  @override
  String get installmentCountLabel => 'Installment count';

  @override
  String get pricingEstimateTitle => 'Estimated Price';

  @override
  String get pricingEstimateLoading => 'Calculating estimate...';

  @override
  String get pricingBasePriceLabel => 'Base price';

  @override
  String get pricingPremiumFeeLabel => 'Premium protection';

  @override
  String get pricingHotelCommissionLabel => 'Hotel commission';

  @override
  String get pricingInstallmentFeeLabel => 'Installment fee';

  @override
  String get pricingTotalLabel => 'Total';

  @override
  String get pricingEstimateDisclaimer =>
      'This is an estimate and may change based on actual drop-off time.';

  @override
  String get pricingEstimateUnavailable =>
      'Select drop and pickup times to see an estimate.';

  @override
  String get pickupPinSentMessage => 'Pickup PIN was sent to your email.';

  @override
  String get pickupPinFailedMessage =>
      'PIN could not be sent. Please try again later.';

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
  String get luggageDelegateAction => 'Deliver to emergency contact';

  @override
  String get delegateInfoRequiredMessage =>
      'Please fill in the emergency contact details.';

  @override
  String get howItWorksTitle => 'How it works';

  @override
  String get howItWorksIntro =>
      'KYRADI is a self-drop, “no courier” luggage storage app. You take your luggage to a partner location, drop it off securely, and pick it up later with a PIN. The app guides you step by step with clear information throughout the process.';

  @override
  String get howItWorksStep1Title => '1) Location selection and availability';

  @override
  String get howItWorksStep1Body =>
      'Locations have working hours, maximum capacity, and live occupancy. If a location is closed, full, or inactive, adding or dropping luggage is blocked. This helps you choose a truly available point.';

  @override
  String get howItWorksStep2Title => '2) Luggage details, time, and protection';

  @override
  String get howItWorksStep2Body =>
      'Enter size (small/medium/large), drop and pickup times. These affect pricing. Choose “Standard protection” (default) or “Premium protection.” The estimate updates as you change your choices.';

  @override
  String get howItWorksStep3Title => '3) Estimated price card';

  @override
  String get howItWorksStep3Body =>
      'The estimate is calculated by size, duration tier (0–6 hours, 6–24 hours, daily), protection, and payment method. It is a preview and may change based on actual drop-off time.';

  @override
  String get howItWorksStep4Title => '4) Reservation';

  @override
  String get howItWorksStep4Body =>
      'You can create a reservation to plan ahead. However, the service is not activated until “Drop Luggage” is completed.';

  @override
  String get howItWorksStep5Title => '5) Go to the location and “Drop Luggage”';

  @override
  String get howItWorksStep5Body =>
      '“Drop Luggage” is the main action that starts the drop-off. There is no courier; you bring the luggage yourself. QR verification and payment must be completed first. Important: Drop Luggage cannot be completed without payment.';

  @override
  String get howItWorksStep6Title => '6) Payment screen and methods';

  @override
  String get howItWorksStep6Body =>
      'Three options are available: (1) Pay at hotel: payment is collected at the location, and a commission may apply. (2) Card payment: secure MagicPay checkout. (3) Installments: a fee may apply and is reflected in the total.';

  @override
  String get howItWorksStep7Title => '7) Payment success or failure';

  @override
  String get howItWorksStep7Body =>
      'If payment succeeds, drop-off is completed and a PIN is generated. If it fails, the app shows a clear error and lets you retry; drop-off is not completed.';

  @override
  String get howItWorksStep8Title => '8) Pickup with PIN';

  @override
  String get howItWorksStep8Body =>
      'After successful drop-off, a pickup PIN is generated. It is shown on screen and can also be emailed. Even if email fails, the process continues; the PIN is used for pickup verification.';

  @override
  String get howItWorksFaqTitle => 'Frequently Asked Questions';

  @override
  String get howItWorksFaq1Q => 'Why is payment required at drop-off?';

  @override
  String get howItWorksFaq1A =>
      'Payment activates the service and keeps availability accurate. Drop-off cannot be completed without payment.';

  @override
  String get howItWorksFaq2Q => 'Why can the estimate change?';

  @override
  String get howItWorksFaq2A =>
      'Estimates are based on size, duration, and times. Actual drop/pickup times can change the price.';

  @override
  String get howItWorksFaq3Q => 'What if a location is closed or full?';

  @override
  String get howItWorksFaq3A =>
      'The app will show this clearly. Choose another location or a different time.';

  @override
  String get howItWorksFaq4Q =>
      'If I choose pay at hotel, will a card screen open?';

  @override
  String get howItWorksFaq4A =>
      'No. Payment is collected at the location. A commission may be reflected in the total.';

  @override
  String get howItWorksFaq5Q => 'How do installments work?';

  @override
  String get howItWorksFaq5A =>
      'Select installments during card payment. Any installment fee is reflected in the total.';

  @override
  String get howItWorksFaq6Q => 'What does premium protection provide?';

  @override
  String get howItWorksFaq6A =>
      'It adds extra coverage beyond standard protection. The estimate card shows the fee.';

  @override
  String get howItWorksFaq7Q => 'What if I lose my PIN?';

  @override
  String get howItWorksFaq7A =>
      'You can resend it by email and view it in your profile or reservation details. Support can help if needed.';

  @override
  String get howItWorksFaq8Q =>
      'Payment succeeded but the app didn’t update. What should I do?';

  @override
  String get howItWorksFaq8A =>
      'Check your connection and refresh. Try again to confirm status. If the issue persists, contact support.';

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
  String get delegateCodeExpiredMessage => 'Delegate code has expired.';

  @override
  String get delegateCodeUsedMessage => 'Delegate code has already been used.';

  @override
  String get delegateSavedMessage => 'Delegate saved.';

  @override
  String get delegateEmergencyCodeTitle => 'Emergency Code';

  @override
  String get ownerInfoTitle => 'Owner Info';

  @override
  String get ownerNameLabel => 'Full name';

  @override
  String get ownerPhoneLabel => 'Phone';

  @override
  String get ownerEmailLabel => 'Email';

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
