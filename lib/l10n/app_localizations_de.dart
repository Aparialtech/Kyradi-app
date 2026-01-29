// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'KYRADI';

  @override
  String get dashboard => 'Startseite';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Einstellungen';

  @override
  String get findLocation => 'Meinen Standort finden';

  @override
  String exploreResultsCount(Object count) {
    return '$count locations';
  }

  @override
  String get exploreSortNearby => 'Nearby';

  @override
  String get exploreSortName => 'A-Z';

  @override
  String get exploreSortAvailability => 'Availability';

  @override
  String get exploreShowMore => 'Show More';

  @override
  String get destination => 'Ziel';

  @override
  String get transitRoute => 'Öffentliche Verkehrsroute';

  @override
  String get myLuggages => 'Mein Gepäck';

  @override
  String get total => 'Gesamt';

  @override
  String get addLuggageQr => 'Gepäck hinzufügen (QR)';

  @override
  String get newLuggageAdded => 'Neues Gepäck hinzugefügt ✅';

  @override
  String get save => 'Speichern';

  @override
  String get saveProfile => 'Profil gespeichert ✅';

  @override
  String get saveProfileError => 'Speichern fehlgeschlagen';

  @override
  String get userInfo => 'Benutzerinformationen';

  @override
  String get map => 'Karte';

  @override
  String get mapIntro =>
      'Sieh dir die KYRADI-Standorte auf der Karte an und plane die beste Route.';

  @override
  String get walkingRoute => 'Fußweg';

  @override
  String get drivingRoute => 'Fahrtroute';

  @override
  String get openInMaps => 'In Google Maps öffnen';

  @override
  String get routeOptions => 'Routenoptionen';

  @override
  String get firstName => 'Vorname';

  @override
  String get lastName => 'Nachname';

  @override
  String get fullNameLabel => 'Vollständiger Name';

  @override
  String get phone => 'Telefon';

  @override
  String get email => 'E-Mail';

  @override
  String get address => 'Adresse';

  @override
  String get birthDate => 'Geburtsdatum';

  @override
  String get gender => 'Geschlecht';

  @override
  String get emergencyContact => 'Notfallkontakt';

  @override
  String get note => 'Notiz / Beschreibung';

  @override
  String get cameraPermission => 'Kamerazugriff';

  @override
  String get cameraPermissionDesc => 'Erforderlich zum QR-Scannen';

  @override
  String get locationPermission => 'Standortzugriff';

  @override
  String get locationLabel => 'Location';

  @override
  String get locationPermissionDesc =>
      'Für Routen und Standortfunktionen erforderlich';

  @override
  String get notificationPermission => 'Benachrichtigungszugriff';

  @override
  String get notificationPermissionDesc => 'Für Erinnerungen und Updates';

  @override
  String get inAppNotifications => 'In-App-Benachrichtigungen';

  @override
  String get notificationSound => 'Benachrichtigungston';

  @override
  String get notificationVibrate => 'Vibration';

  @override
  String get account => 'Konto';

  @override
  String get changePassword => 'Passwort ändern';

  @override
  String get logout => 'Abmelden';

  @override
  String get about => 'Über';

  @override
  String get aboutApp => 'Diese App wurde von KYRADI entwickelt.';

  @override
  String get qrCode => 'QR-Code';

  @override
  String get weight => 'Gewicht (kg)';

  @override
  String get size => 'Größe';

  @override
  String get sizeSmallDimensions => 'max. 55x40x20 cm';

  @override
  String get sizeMediumDimensions => 'max. 65x45x25 cm';

  @override
  String get sizeLargeDimensions => 'über 65x45x25 cm';

  @override
  String get sizeSmallNote => 'Geeignet für Kabinengepäck und Rucksäcke';

  @override
  String get sizeSelectionNote =>
      'Die Größe wird bei der Abgabe geprüft; bei falscher Auswahl kann der Preis angepasst werden.';

  @override
  String get color => 'Farbe';

  @override
  String get small => 'Klein';

  @override
  String get medium => 'Mittel';

  @override
  String get large => 'Groß';

  @override
  String get black => 'Schwarz';

  @override
  String get red => 'Rot';

  @override
  String get blue => 'Blau';

  @override
  String get grey => 'Grau';

  @override
  String get other => 'Andere';

  @override
  String get saveLuggage => 'Gepäck speichern';

  @override
  String get qrEmptyError => 'QR-Code darf nicht leer sein ❌';

  @override
  String get oldPassword => 'Altes Passwort';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get passwordChanged => 'Passwort geändert ✅';

  @override
  String get passwordMismatch => 'Neue Passwörter stimmen nicht überein ❌';

  @override
  String get languageChanged => 'Sprache geändert ✅';

  @override
  String permissionGranted(Object permission) {
    return '$permission-Berechtigung erteilt ✅';
  }

  @override
  String permissionDenied(Object permission) {
    return '$permission-Berechtigung verweigert ❌';
  }

  @override
  String permissionDeniedForever(Object permission) {
    return '$permission-Berechtigung dauerhaft verweigert, in den Einstellungen aktivieren ⚙️';
  }

  @override
  String locationReceived(Object lat, Object lng) {
    return 'Standort erhalten 📍 $lat, $lng';
  }

  @override
  String get locationFailed => 'Standort konnte nicht abgerufen werden ❌';

  @override
  String get profileSaved => 'Profil gespeichert ✅';

  @override
  String get profileSaveError => 'Profil konnte nicht gespeichert werden ❌';

  @override
  String get logoutSuccess => 'Erfolgreich abgemeldet 👋';

  @override
  String get copyrightNotice => '© 2025 KYRADI. Alle Rechte vorbehalten.';

  @override
  String get demoMapComingSoon => 'Das Kartenmodul wird in Kürze geöffnet.';

  @override
  String demoLuggageButton(Object number) {
    return 'Gepäck $number';
  }

  @override
  String demoLuggageSelected(Object label) {
    return '$label ausgewählt.';
  }

  @override
  String get demoFirstNameValue => 'Deniz';

  @override
  String get demoLastNameValue => 'Gezensoy';

  @override
  String get demoNationalIdValue => '12345678901';

  @override
  String get demoAddressValue => 'Istanbul, Türkei';

  @override
  String get demoEmergencyNameValue => 'Merve Sönmez';

  @override
  String get demoEmergencyAddressValue => 'Kadıköy, Istanbul';

  @override
  String get demoEmergencyEmailValue => 'merve@example.com';

  @override
  String get demoEmergencyRelationValue => 'Geschwister / naher Verwandter';

  @override
  String get emergencyContactNote =>
      'Diese Person wird im Notfall kontaktiert.';

  @override
  String get introTagline => 'Globales Gepäcksystem';

  @override
  String get splashSlogan => 'Leave your luggage, explore the city';

  @override
  String get introTrackButton => 'Verfolgen';

  @override
  String get serverButtonLabel => 'Server';

  @override
  String serverStatus(Object host) {
    return 'Server: $host';
  }

  @override
  String get loginHeroSubtitle => 'Verwalte dein Gepäck nach dem Anmelden.';

  @override
  String get loginFormTitle => 'Anmeldedaten';

  @override
  String get loginFormSubtitle =>
      'Verbinde dich mit dem neuesten Server, um dich anzumelden.';

  @override
  String get emailHint => 'beispiel@mail.com';

  @override
  String get passwordLabel => 'Passwort';

  @override
  String get passwordHint => '••••••';

  @override
  String get validationEmailRequired => 'E-Mail ist erforderlich';

  @override
  String get validationEmailInvalid => 'Gib eine gültige E-Mail ein';

  @override
  String get validationPasswordRequired => 'Passwort ist erforderlich';

  @override
  String validationMinChars(Object count) {
    return 'Mindestens $count Zeichen eingeben';
  }

  @override
  String get loginForgotPassword => 'Passwort vergessen';

  @override
  String get clearButton => 'Leeren';

  @override
  String get loginButtonLabel => 'Anmelden';

  @override
  String get loginSocialDivider => 'oder';

  @override
  String get loginContinueWithGoogle => 'Weiter mit Google';

  @override
  String get loginContinueWithApple => 'Weiter mit Apple';

  @override
  String loginSocialComingSoon(Object provider) {
    return '$provider ist bald verfügbar.';
  }

  @override
  String get loginNoAccount => 'Kein Konto?';

  @override
  String get registerButtonLabel => 'Registrieren';

  @override
  String get loginSuccess => 'Erfolgreich angemeldet ✅';

  @override
  String get loginInvalidCredentials => 'E-Mail oder Passwort falsch ❌';

  @override
  String get loginTooManyAttempts =>
      'Zu viele Versuche, bitte in ein paar Minuten erneut versuchen ⚠️';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen, versuch es erneut ❌';

  @override
  String genericErrorWithDetails(Object details) {
    return 'Es ist ein Fehler aufgetreten: $details';
  }

  @override
  String get genericErrorMessage => 'Es ist ein Fehler aufgetreten.';

  @override
  String get loginVerificationRequired => 'Bitte bestätige dein Konto 📨';

  @override
  String verificationSendFailedWithDetails(Object details) {
    return 'Bestätigungscode konnte nicht gesendet werden: $details';
  }

  @override
  String get registerTitle => 'Konto erstellen';

  @override
  String get registerPersonalSectionTitle => 'Persönliche Angaben';

  @override
  String get registerPersonalSectionSubtitle =>
      'Gib Identität und Geburtsdatum an.';

  @override
  String get genderMale => 'Männlich';

  @override
  String get genderFemale => 'Weiblich';

  @override
  String get genderUndisclosed => 'Möchte ich nicht sagen';

  @override
  String get registerContactSectionTitle => 'Kontaktinformationen';

  @override
  String get registerContactSectionSubtitle => 'E-Mail und Verifizierungsdaten';

  @override
  String get nationalIdLabel => 'Personalausweisnummer';

  @override
  String get phoneHint => '+90 5xx xxx xx xx';

  @override
  String get registerSecuritySectionTitle => 'Sicherheit';

  @override
  String get registerSecuritySectionSubtitle =>
      'Passwort festlegen und bestätigen';

  @override
  String get registerPasswordRepeatLabel => 'Passwort wiederholen';

  @override
  String get registerCaptchaLabel => 'Ich bin kein Roboter';

  @override
  String get registerCaptchaWarning =>
      'Bitte \"Ich bin kein Roboter\" markieren';

  @override
  String get registerKvkkAgreementLabel =>
      'Ich habe den KYRADI-KVKK-Aufklärungstext gelesen und akzeptiere ihn.';

  @override
  String get registerKvkkAgreementWarning =>
      'Bitte akzeptiere den KVKK-Aufklärungstext.';

  @override
  String get registerRestrictedAgreementLabel =>
      'Ich habe die von Aparial und allgemeinen Transportunternehmen abgelehnten Gegenstände gelesen und akzeptiere sie.';

  @override
  String get registerRestrictedAgreementWarning =>
      'Bitte bestätige das Dokument zu abgelehnten Gegenständen.';

  @override
  String get registerAgreementView => 'Dokument anzeigen';

  @override
  String get registerKvkkDialogTitle => 'KYRADI – KVKK-Aufklärungstext';

  @override
  String get registerRestrictedDialogTitle =>
      'Von Aparial und allgemeinen Transportunternehmen abgelehnte Gegenstände';

  @override
  String get registerKvkkDocumentBody =>
      'Information zur Verarbeitung personenbezogener Daten\nDieser Text erläutert, welche personenbezogenen Daten im Rahmen der KYRADI-Plattform nach dem türkischen Datenschutzgesetz Nr. 6698 (\"KVKK\") in welchem Umfang und zu welchen Zwecken verarbeitet werden.\n\nArten der verarbeiteten personenbezogenen Daten\nIm Rahmen von KYRADI werden folgende Datenkategorien verarbeitet:\nKundendaten:\nVor- und Nachname, Telefon, QR-Code-Token, Reservierungs- und Schließfachinformationen, Zahlungsbetrag und Transaktionsnummer\nMitarbeiterdaten:\nVor- und Nachname, E-Mail, Benutzerrolle, IP, Transaktionslogs, Sitzungsinformationen\nTechnische Daten:\nAudit-Log-Einträge, Browser-/Geräteinformationen, Fehlerberichte\n\nZwecke der Verarbeitung\nPersonenbezogene Daten werden verarbeitet, um den Reservierungsablauf bereitzustellen, QR-Codes zu erzeugen und zu verifizieren, Zahlungs-Intents zu verwalten, die Gepäckabgabe und -abholung durchzuführen, die Systemsicherheit zu gewährleisten und Missbrauch zu erkennen, gesetzliche Aufbewahrungspflichten zu erfüllen sowie für Reporting und Plattformverbesserungen.\n\nRechtsgrundlagen\nPersonenbezogene Daten werden gemäß KVKK Art. 5/2-c (Vertragsschluss und -erfüllung), Art. 5/2-f (berechtigtes Interesse), Art. 5/2-ç (gesetzliche Pflichten) sowie auf Basis ausdrücklicher Einwilligung verarbeitet, soweit erforderlich.\n\nEmpfänger der Datenübermittlung\nPersonenbezogene Daten können an Zahlungsdienstleister wie Stripe und Iyzico, Cloud-Anbieter wie AWS, Google Cloud, Render und Vercel, zuständige Behörden in zwingenden Fällen sowie an rechtliche oder finanzielle Berater übermittelt werden.\n\nAufbewahrungsfristen\nPersonenbezogene Daten werden für Reservierungs- und Zahlungsdaten 10 Jahre, für Audit-Logs 2 Jahre und für Benutzerkonten 1 Jahr nach Kontoschließung aufbewahrt; QR-Code-Tokens werden 1–24 Stunden gespeichert.\n\nSicherheitsmaßnahmen\nKYRADI setzt technische und organisatorische Sicherheitsmaßnahmen wie mandantenbasierte Datenisolierung, Passwort-Hashing, JWT-basierte Sicherheit, rollenbasierte Zugriffskontrolle, Rate Limiting und Angriffsprävention sowie Audit-Logs für kritische Vorgänge ein.\n\nRechte der betroffenen Person\nGemäß Art. 11 der KVKK haben betroffene Personen das Recht, Auskunft über die Verarbeitung zu erhalten, Löschung oder Berichtigung zu verlangen, der Verarbeitung zu widersprechen und bei Schadenersatzansprüchen geltend zu machen.\n\nAnträge können an kvkk@kyradi.com gesendet werden.';

  @override
  String get registerRestrictedDocumentBody =>
      'Dieses Dokument fasst Gegenstände zusammen, die Aparial und allgemeine Transportunternehmen nicht zur Beförderung annehmen.\nAus Sicherheits-, gesetzlichen und betrieblichen Risikogründen werden die folgenden Gegenstände nicht angenommen:\n\nGefährliche und riskante Gegenstände\n- Explosivstoffe (Dynamit, Feuerwerk, Handgranaten usw.)\n- Entzündliche und brennbare Stoffe (Benzin, Verdünner, Farbe, Lösungsmittel usw.)\n- Druckgase (Propan, Butan, Sauerstoffflaschen usw.)\n- Giftige oder ätzende Chemikalien (Säure, Lauge, Bleichmittel usw.)\n- Radioaktive Stoffe\n- Entzündliche Flüssigkeiten oder Lösungsmittel mit gefährlichen Chemikalien\n- Jeglicher Stoff oder jedes Gerät mit Explosions- oder Brandrisiko\n\nWaffen und gefährliche Ausrüstung\n- Waffen, Munition und ähnliche Schusswaffen\n- Schneid- oder Stichwerkzeuge (Dolche, lange Messer, spitze Metallwerkzeuge usw.)\n\nGeräte und Druckprodukte\n- Geräte mit Gas oder Treibstoff (Campingkocher mit Brennstoff usw.)\n- Druckaerosoldosen (Sprays mit gefährlichem Gas)\n- Hochkapazitäts- oder Ersatz-Lithiumbatterien\n\nStörende oder sicherheitsrelevante Gegenstände\n- Stark riechende, rauchende oder störende Stoffe\n\nWertsachen\n- Schmuck (Gold, Edelsteine usw.) wird nicht angenommen.\n- Bargeld (unabhängig von der Höhe) wird nicht angenommen.\n\nHinweis:\nEinige Gegenstände können mit bestimmten Genehmigungen, Mengen oder Sicherheitsmaßnahmen transportiert werden. Im Allgemeinen werden solche Gegenstände jedoch sowohl von Aparial als auch von anderen Transportunternehmen abgelehnt.';

  @override
  String get registerSuccessMessage =>
      'Registrierung erfolgreich ✅ Bestätigungs-E-Mail gesendet.';

  @override
  String get registerEmailExistsMessage =>
      'Diese E-Mail ist bereits registriert ❌';

  @override
  String get registerGenericErrorMessage => 'Registrierung fehlgeschlagen ❌';

  @override
  String get validationRequired => 'Pflichtfeld';

  @override
  String get validationPasswordNeedsLetter =>
      'Mindestens einen Buchstaben eingeben';

  @override
  String get validationPasswordNeedsNumber => 'Mindestens eine Zahl eingeben';

  @override
  String get validationPasswordRepeatRequired => 'Passwort erneut eingeben';

  @override
  String get validationNationalIdRequired =>
      'Personalausweisnummer erforderlich';

  @override
  String get validationNationalIdLength => 'Die ID muss 11 Ziffern haben';

  @override
  String get validationNationalIdChecksumTen => 'ID ungültig (10. Stelle)';

  @override
  String get validationNationalIdChecksumEleven => 'ID ungültig (11. Stelle)';

  @override
  String get validationNationalIdInvalid => 'ID ungültig';

  @override
  String get validationPhoneRequired => 'Telefonnummer ist erforderlich';

  @override
  String get validationPhoneFormat => 'Format: +90 5xx xxx xx xx';

  @override
  String get validationBirthDateRequired => 'Geburtsdatum auswählen';

  @override
  String get validationAgeRequirement => 'Du musst älter als 18 sein';

  @override
  String get formNotSelected => 'Nicht ausgewählt';

  @override
  String get forgotTitle => 'Passwort vergessen';

  @override
  String get forgotIntro =>
      'Wir senden einen Code an deine registrierte E-Mail, um dein Passwort zurückzusetzen.';

  @override
  String get forgotEmailSectionTitle => 'E-Mail-Bestätigung';

  @override
  String get forgotEmailSectionSubtitle =>
      'An deine registrierte Adresse wird ein Einmalcode gesendet.';

  @override
  String get emailAddressLabel => 'E-Mail-Adresse';

  @override
  String get forgotSendButton => 'Code senden';

  @override
  String forgotResendCountdown(int seconds) {
    return 'Erneut senden (${seconds}s)';
  }

  @override
  String get forgotAlreadyHaveCode => 'Ich habe bereits einen Code';

  @override
  String get forgotNeedValidEmail =>
      'Bitte gib zuerst eine gültige E-Mail ein 💌';

  @override
  String get forgotCodeSent => 'Code gesendet 📩';

  @override
  String get forgotEmailNotFound => 'Diese E-Mail ist nicht registriert ❌';

  @override
  String get forgotTooManyAttempts =>
      'Zu viele Versuche, bitte in 1 Minute erneut versuchen ⚠️';

  @override
  String get forgotCodeFailed => 'Code konnte nicht gesendet werden ❌';

  @override
  String get resetTitle => 'Passwort zurücksetzen';

  @override
  String get resetSubtitle =>
      'Gib den an diese E-Mail gesendeten Code ein und erstelle ein neues Passwort.';

  @override
  String get verificationCodeLabel => 'Bestätigungscode';

  @override
  String get resetNewPasswordLabel => 'Neues Passwort';

  @override
  String get resetConfirmPasswordLabel => 'Neues Passwort (wiederholen)';

  @override
  String get resetSubmitButton => 'Passwort zurücksetzen';

  @override
  String get unknownError => 'Unbekannter Fehler';

  @override
  String get verificationTitle => 'Verifizierung';

  @override
  String verificationInstructions(Object email) {
    return 'Gib den 6-stelligen Code ein, der an $email gesendet wurde.';
  }

  @override
  String get verifyButtonLabel => 'Code bestätigen';

  @override
  String get verificationResendButton => 'Code erneut senden';

  @override
  String verificationCountdownLabel(int seconds) {
    return 'In ${seconds}s erneut senden';
  }

  @override
  String get verificationResentMessage => 'Code erneut gesendet';

  @override
  String get verificationSendErrorMessage => 'Senden fehlgeschlagen';

  @override
  String get verificationMissingEmailMessage =>
      'E-Mail konnte nicht abgerufen werden';

  @override
  String get verificationSuccessMessage => 'Konto verifiziert ✅';

  @override
  String get verificationErrorMessage => 'Verifizierungsfehler';

  @override
  String get verificationCodeInvalidMessage => 'Der Code muss 6 Stellen haben';

  @override
  String get validationVerificationCodeRequired => 'Code ist erforderlich';

  @override
  String get validationVerificationCodeLength => '6-stelligen Code eingeben';

  @override
  String dashboardGreeting(Object name) {
    return 'Hallo, $name';
  }

  @override
  String get dashboardSubtitle =>
      'Teile deinen Standort und verwalte dein Gepäck.';

  @override
  String dashboardTotalCount(Object count) {
    return 'Insgesamt $count';
  }

  @override
  String get travelerPlaceholder => 'Reisender';

  @override
  String get quickAddLuggage => 'Gepäck hinzufügen';

  @override
  String get quickTransit => 'ÖPNV';

  @override
  String get dashboardMetricAwaiting => 'Wartet auf Abgabe';

  @override
  String get dashboardMetricStored => 'Eingelagert';

  @override
  String get dashboardMetricPicked => 'Abgeholt';

  @override
  String get dashboardMetricCancelled => 'Storniert';

  @override
  String get deliverySectionTitle => 'Abgabe & Route';

  @override
  String get deliverySectionSubtitle =>
      'Wähle einen Abgabeort und öffne die Route.';

  @override
  String get deliveryPointLabel => 'Abgabepunkt';

  @override
  String deliveryPointOption(Object name, int available, int total) {
    return '$name • Frei $available/$total';
  }

  @override
  String deliveryPointSelected(Object name) {
    return 'Abgabepunkt ausgewählt: $name ✅';
  }

  @override
  String get routeNeedLocation => 'Nutze zuerst \"Meinen Standort finden\".';

  @override
  String get routeNeedDestination => 'Bitte gib ein Ziel ein.';

  @override
  String get mapsOpenFailed => 'Google Maps konnte nicht geöffnet werden.';

  @override
  String get reservationSectionTitle => 'Reservierungsstatus';

  @override
  String get reservationSectionSubtitle =>
      'Sieh dir Verfügbarkeit und Auslastung an.';

  @override
  String get reservationEditTitle => 'Reservierung bearbeiten';

  @override
  String get luggagesSectionSubtitle =>
      'Zeige QR-Codes und schließe Abgabe- bzw. Abholschritte ab.';

  @override
  String get newLuggageButton => 'Neues Gepäck';

  @override
  String get luggageFilterAll => 'Alle';

  @override
  String get luggageFilterAwaiting => 'Wartet auf Abgabe';

  @override
  String get luggageFilterStored => 'Eingelagert';

  @override
  String get luggageFilterPicked => 'Abgeholt';

  @override
  String get luggageFilterCancelled => 'Storniert';

  @override
  String get luggageEmptyStateNoItems =>
      'Noch kein Gepäck. Füge jetzt eines hinzu!';

  @override
  String get luggageSearchHint => 'Search by name, QR, or location';

  @override
  String get luggageSortLabel => 'Sort';

  @override
  String get luggageSortDate => 'By Date';

  @override
  String get luggageSortStatus => 'By Status';

  @override
  String get luggageSortLocation => 'By Location';

  @override
  String get luggageSortPayment => 'By Payment';

  @override
  String get luggageViewList => 'List';

  @override
  String get luggageViewCards => 'Cards';

  @override
  String get luggageViewCalendar => 'Calendar';

  @override
  String get luggageShowMore => 'Load More';

  @override
  String get luggageNoResultsTitle => 'No results';

  @override
  String get luggageNoResultsSubtitle => 'Try changing your search or filters.';

  @override
  String get luggageFilterTitle => 'Filters';

  @override
  String get luggageFilterStatus => 'Status';

  @override
  String get luggageFilterPayment => 'Payment';

  @override
  String get luggageFilterLocation => 'Location';

  @override
  String get luggageFilterSize => 'Size';

  @override
  String get luggageFilterReset => 'Reset';

  @override
  String get luggageFilterApply => 'Apply';

  @override
  String get comingSoonMessage => 'Coming soon.';

  @override
  String get luggageEmptyStateFiltered =>
      'Für diesen Filter wurde kein Gepäck gefunden.';

  @override
  String get profileInfoSubtitle => 'Halte deine Kontaktdaten aktuell.';

  @override
  String get emergencySectionSubtitle =>
      'Füge eine Vertrauensperson hinzu, um sicher zu bleiben.';

  @override
  String get relationLabel => 'Beziehung';

  @override
  String get emergencyRegisteredPerson => 'Gespeicherter Kontakt';

  @override
  String get identitySectionTitle => 'Ausweis / Reisepass';

  @override
  String get identitySectionSubtitle =>
      'Lade das Dokument hoch, das bei Übergaben gezeigt wird.';

  @override
  String get identityPreviewHint => 'Hier erscheint die Dokumentvorschau';

  @override
  String get identityDocIdCard => 'Ausweis';

  @override
  String get identityDocPassport => 'Reisepass';

  @override
  String identityUploaded(Object file) {
    return 'Hochgeladenes Dokument: $file';
  }

  @override
  String get identityMissing =>
      'Noch kein Dokument hochgeladen. Für Übergaben ist ein Ausweis- oder Passfoto erforderlich.';

  @override
  String get identityTakePhoto => 'Mit Kamera aufnehmen';

  @override
  String get identityPickFromGallery => 'Aus Galerie wählen';

  @override
  String get identityDelete => 'Dokument löschen';

  @override
  String identityPhotoSaved(Object docType) {
    return '$docType-Foto gespeichert ✅';
  }

  @override
  String identityUploadFailed(Object details) {
    return 'Dokument konnte nicht hochgeladen werden: $details';
  }

  @override
  String get identityRemoved => 'Dokument entfernt.';

  @override
  String get identityProofRequired =>
      'Lade vor dem Fortfahren ein Ausweis- oder Passfoto hoch.';

  @override
  String get profileDataMissing => 'Profildaten konnten nicht geladen werden.';

  @override
  String profileLoadFailed(Object details) {
    return 'Profil konnte nicht geladen werden: $details';
  }

  @override
  String get profileUserMissing =>
      'Benutzer nicht gefunden. Bitte melde dich erneut an.';

  @override
  String get luggageLocationMissing =>
      'Für dieses Gepäck sind keine Standortdaten vorhanden.';

  @override
  String luggageInfoSize(Object value) {
    return 'Größe: $value';
  }

  @override
  String luggageInfoWeight(Object value) {
    return 'Gewicht: $value kg';
  }

  @override
  String get luggageInfoSectionTitle => 'Luggage Details';

  @override
  String get luggageInfoLabelSize => 'Size';

  @override
  String get luggageInfoLabelWeight => 'Weight';

  @override
  String get luggageInfoLabelColor => 'Color';

  @override
  String get luggageInfoLabelPayment => 'Payment';

  @override
  String get luggageInfoLabelTotal => 'Total';

  @override
  String luggageInfoColor(Object value) {
    return 'Farbe: $value';
  }

  @override
  String noteLabel(Object note) {
    return 'Notiz: $note';
  }

  @override
  String scheduledDropLabel(Object date) {
    return 'Geplante Abgabe: $date';
  }

  @override
  String scheduledPickupLabel(Object date) {
    return 'Geplante Abholung: $date';
  }

  @override
  String get reservationCancelledLabel => 'Diese Reservierung wurde storniert.';

  @override
  String get luggageShowQr => 'QR-Code anzeigen';

  @override
  String get luggageDropAction => 'Gepäck abgegeben';

  @override
  String get luggagePickupAction => 'Gepäck abholen';

  @override
  String get luggageCancelAction => 'Reservierung stornieren';

  @override
  String get luggageOpenLocation => 'Standort öffnen';

  @override
  String createdAtLabel(Object date) {
    return 'Erstellt: $date';
  }

  @override
  String dropConfirmedAtLabel(Object date) {
    return 'Abgabe bestätigt: $date';
  }

  @override
  String pickupConfirmedAtLabel(Object date) {
    return 'Abholung bestätigt: $date';
  }

  @override
  String get loginRequired => 'Bitte melde dich zuerst an.';

  @override
  String get luggageCreated => 'Neues Gepäck erstellt ✅';

  @override
  String get dropConfirmedMessage => 'Abgabe bestätigt ✅';

  @override
  String get pickupConfirmedMessage => 'Abholung abgeschlossen ✅';

  @override
  String get operationFailed => 'Vorgang konnte nicht abgeschlossen werden.';

  @override
  String operationFailedWithDetails(Object details) {
    return 'Vorgang konnte nicht abgeschlossen werden: $details';
  }

  @override
  String get reservationCancelledMessage => 'Reservierung storniert.';

  @override
  String get cancelFailed => 'Stornierung fehlgeschlagen.';

  @override
  String cancelFailedWithDetails(Object details) {
    return 'Stornierung fehlgeschlagen: $details';
  }

  @override
  String get cancelReservationTitle => 'Reservierung stornieren';

  @override
  String cancelReservationMessage(Object label) {
    return 'Möchtest du die Reservierung für „$label“ wirklich stornieren?';
  }

  @override
  String get dialogDismiss => 'Abbrechen';

  @override
  String get dialogConfirmCancel => 'Stornieren';

  @override
  String get dialogConfirm => 'Ja';

  @override
  String reservationTileTitle(Object code) {
    return 'Reservierung $code';
  }

  @override
  String reservationTileSubtitle(Object code, Object time) {
    return '$code • $time';
  }

  @override
  String reservationSlotSummary(int count, Object time) {
    return '$count Gepäckstücke • $time';
  }

  @override
  String get notificationsTooltip => 'Benachrichtigungen';

  @override
  String get notificationsClearTooltip => 'Temizle';

  @override
  String get notificationsEmptyTitle => 'Henüz bildirim yok';

  @override
  String get notificationsEmptySubtitle =>
      'Bildirimler burada görünecek. Giriş yapınca veya işlemler yaptıkça güncellenecek.';

  @override
  String get notificationTypeSuccess => 'Başarılı';

  @override
  String get notificationTypeWarning => 'Uyarı';

  @override
  String get notificationTypeError => 'Hata';

  @override
  String get notificationTypeInfo => 'Bilgi';

  @override
  String get notificationsRelativeNow => 'Şimdi';

  @override
  String notificationsRelativeSeconds(int count) {
    return '$count sn önce';
  }

  @override
  String notificationsRelativeMinutes(int count) {
    return '$count dk önce';
  }

  @override
  String notificationsRelativeHours(int count) {
    return '$count sa önce';
  }

  @override
  String notificationsRelativeDays(int count) {
    return '$count gün önce';
  }

  @override
  String get mapNoLocations => 'Keine Standorte gefunden.';

  @override
  String get locationServiceDisabled => 'Der Standortdienst ist deaktiviert.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Standortberechtigung dauerhaft verweigert. Bitte in den Einstellungen aktivieren.';

  @override
  String locationFailedWithDetails(Object details) {
    return 'Standort konnte nicht ermittelt werden: $details';
  }

  @override
  String get locationNotFoundTitle => 'Standort nicht gefunden';

  @override
  String get locationNotFoundMessage =>
      'Der ausgewählte Standort ist nicht mehr verfügbar.';

  @override
  String get permissionManageButton => 'Verwalten';

  @override
  String get settingsPermissionsTitle => 'Berechtigungen';

  @override
  String get settingsPermissionsSubtitle =>
      'Verwalte Kamera-, Standort- und Benachrichtigungszugriffe.';

  @override
  String get privacySectionTitle => 'Datenschutz';

  @override
  String get privacySectionSubtitle =>
      'Passe die In-App-Benachrichtigungen an.';

  @override
  String get remindersSectionTitle => 'Erinnerungen';

  @override
  String get remindersSectionSubtitle =>
      'Wähle Warnungen für Abgabe und Abholung.';

  @override
  String get pushRemindersLabel => 'Push-Benachrichtigungen';

  @override
  String get emailRemindersLabel => 'E-Mail-Erinnerungen';

  @override
  String get languageSectionTitle => 'Sprache';

  @override
  String get languageSectionSubtitle => 'Wähle die Sprache der App.';

  @override
  String get languageNameTr => 'Türkisch';

  @override
  String get languageNameEn => 'Englisch';

  @override
  String get languageNameDe => 'Deutsch';

  @override
  String get languageNameEs => 'Spanisch';

  @override
  String get languageNameRu => 'Russisch';

  @override
  String languageChangedTo(Object language) {
    return 'Sprache wurde zu $language geändert ✅';
  }

  @override
  String get upcomingReservationsTitle => 'Bevorstehende Reservierungen';

  @override
  String get upcomingReservationsSubtitle =>
      'Namen bleiben verborgen; nur Codes und Auslastung werden angezeigt.';

  @override
  String get upcomingReservationsEmpty =>
      'Für diesen Standort sind keine Reservierungen geplant.';

  @override
  String get continueSectionTitle => 'Fortfahren';

  @override
  String get continueSectionSubtitle =>
      'Wenn du bereits ein Konto hast, melde dich an – ansonsten registriere dich schnell.';

  @override
  String get locationAuthReadyMessage =>
      'Du bist angemeldet und kannst mit der Reservierung fortfahren.';

  @override
  String get exploreEmptyTitle => 'Keine Standorte gefunden.';

  @override
  String get exploreEmptySubtitle => 'Versuche, die Filter anzupassen.';

  @override
  String get accountSectionSubtitle =>
      'Ändere dein Passwort oder melde dich ab.';

  @override
  String get logoutDialogTitle => 'Abmelden';

  @override
  String get logoutDialogMessage => 'Möchtest du dich abmelden?';

  @override
  String get changePasswordIntro => 'Güvenliğin için yeni şifreni belirle.';

  @override
  String get changePasswordRequirementHint =>
      'En az 8 karakter, harf ve rakam içermeli.';

  @override
  String get userIdMissing => 'Nicht angemeldet: userId wurde nicht gefunden.';

  @override
  String userIdReadFailed(Object details) {
    return 'userId konnte nicht gelesen werden: $details';
  }

  @override
  String get mapsMissingApiKey =>
      'Google-Maps-API-Schlüssel ist nicht konfiguriert.';

  @override
  String routeFetchFailedWithDetails(Object details) {
    return 'Route konnte nicht geladen werden: $details';
  }

  @override
  String get routeNotFound => 'Keine Route gefunden.';

  @override
  String get routeDataMissing => 'Routendaten konnten nicht abgerufen werden.';

  @override
  String directionsApiError(Object status) {
    return 'Google Directions meldete einen Fehler: $status. Stelle sicher, dass der Schlüssel Zugriff auf Directions hat.';
  }

  @override
  String get reservationEmptyState => 'Keine geplanten Reservierungen.';

  @override
  String availableSlotsLabel(int available, int total) {
    return 'Frei $available/$total';
  }

  @override
  String get qrDropTitle => 'Abgabe mit QR bestätigen';

  @override
  String get qrPickupTitle => 'Abholung mit QR bestätigen';

  @override
  String get qrManualEntryHint =>
      'Wenn du den QR-Code nicht scannen kannst, gib ihn manuell ein.';

  @override
  String get qrVerifyButton => 'Prüfen';

  @override
  String get qrMismatchMessage =>
      'Der QR-Code stimmt nicht überein. Bitte erneut versuchen.';

  @override
  String get qrCopied => 'QR-Code kopiert.';

  @override
  String get qrTextCopied => 'Text kopiert.';

  @override
  String get qrCopyCode => 'Code kopieren';

  @override
  String get qrCopyPrintable => 'Text für den Druck kopieren';

  @override
  String get qrShareInstructions =>
      'Teile diesen Code mit dem Personal, um den Sticker zu drucken. Kund:innen müssen denselben Code bei Abgabe und Abholung scannen.';

  @override
  String get qrDuplicateWarning =>
      'Dieser QR-Code wird bereits verwendet. Wir haben einen neuen erzeugt – bitte erneut versuchen.';

  @override
  String get qrScanTip =>
      'Achte darauf, dass der Code scharf innerhalb des Rahmens sichtbar ist.';

  @override
  String get qrScanTitle => 'Scan QR';

  @override
  String get qrScanGuide =>
      'Scan a QR or enter the code manually to see reservation details.';

  @override
  String get qrManualEntry => 'Manual Entry';

  @override
  String get qrManualHint => 'Enter QR or reservation code';

  @override
  String get qrManualSearchAction => 'Lookup Code';

  @override
  String get qrAwaitingScan =>
      'Reservation details will appear here after scanning.';

  @override
  String get qrNotFound => 'No record found for this QR code.';

  @override
  String get qrLookupFailed => 'QR lookup failed. Please try again.';

  @override
  String get qrReservationInfoTitle => 'Reservation Details';

  @override
  String get qrScanAgain => 'Scan Again';

  @override
  String get qrDropConfirmAction => 'Confirm Drop';

  @override
  String get qrConfirmDropTitle => 'Luggage Drop';

  @override
  String get qrConfirmDropMessage => 'Confirm that you received this luggage?';

  @override
  String get qrDropSuccess => 'Luggage drop confirmed.';

  @override
  String get qrDropFailed => 'Luggage drop failed.';

  @override
  String get locationFetching => 'Standort wird ermittelt...';

  @override
  String get refreshNearbyButton => 'Nahe Standorte aktualisieren';

  @override
  String get nearbyLocationsTitle => 'Nahe Standorte';

  @override
  String get commonSelect => 'Auswählen';

  @override
  String get landingTitle => 'KYRADI Track';

  @override
  String get landingIntro =>
      'Wähle, wo du dein Gepäck abgeben möchtest. Tippe einen Punkt auf der Karte an, um Auslastung und Reservierungsdetails zu sehen.';

  @override
  String occupancyLabel(Object current, Object max) {
    return 'Auslastung: $current/$max';
  }

  @override
  String get locationOpenLabel => 'Geöffnet';

  @override
  String get locationClosedLabel => 'Geschlossen';

  @override
  String get openingHoursTitle => 'Öffnungszeiten';

  @override
  String get openingHoursSubtitle => 'Wöchentlicher Plan';

  @override
  String get openingHoursAlwaysOpen => 'Rund um die Uhr geöffnet';

  @override
  String get openingHoursClosed => 'Geschlossen';

  @override
  String get locationFullWarning => 'Der ausgewählte Standort ist voll.';

  @override
  String get locationClosedWarning =>
      'Der ausgewählte Standort ist derzeit geschlossen.';

  @override
  String get locationInactiveWarning => 'Der ausgewählte Standort ist inaktiv.';

  @override
  String get protectionLevelTitle => 'Schutzstufe';

  @override
  String get protectionStandard => 'Standard';

  @override
  String get protectionPremium => 'Premium-Schutz';

  @override
  String get paymentMethodTitle => 'Zahlungsmethode';

  @override
  String paymentMethodWallet(Object balance) {
    return 'Pay with Kyradi Wallet (Balance: ₺$balance)';
  }

  @override
  String get paymentWalletInsufficientTitle => 'Insufficient Balance';

  @override
  String paymentWalletInsufficientMessage(Object balance, Object amount) {
    return 'Your wallet balance is ₺$balance. Total is ₺$amount. Please top up or pay by card.';
  }

  @override
  String get paymentWalletTopUpAction => 'Top Up';

  @override
  String get paymentWalletUseCardAction => 'Pay by Card';

  @override
  String get paymentMethodCard => 'Karte';

  @override
  String get paymentMethodInstallment => 'Ratenzahlung';

  @override
  String get paymentMethodPayAtHotel => 'Im Hotel zahlen';

  @override
  String get paymentMethodUnknown => 'Unbekannt';

  @override
  String get paymentStatusLabel => 'Zahlungsstatus';

  @override
  String get paymentStatusUnknown => 'Unbekannt';

  @override
  String get luggageDetailsTitle => 'Gepäckdetails';

  @override
  String get luggageDetailsSubtitle =>
      'Reservierungs- und Zahlungsinformationen anzeigen.';

  @override
  String get luggageIdLabel => 'Gepäck-ID';

  @override
  String get createdAtTitle => 'Erstellt am';

  @override
  String get statusUpdateFailed =>
      'Status konnte nicht aktualisiert werden. Bitte erneut versuchen.';

  @override
  String get inviteFriendsTitle => 'Freunde einladen';

  @override
  String get inviteFriendsHeadline => 'Teile deinen Einladungscode';

  @override
  String get inviteFriendsSubtitle =>
      'Lade Freunde ein und erhalte Cashback, wenn sie buchen.';

  @override
  String get inviteCodeCopied => 'Einladungscode kopiert';

  @override
  String get shareComingSoon => 'Teilen folgt bald.';

  @override
  String get shareAction => 'Teilen';

  @override
  String get cashbackRulesTitle => 'Cashback-Regeln';

  @override
  String get cashbackRuleEarnTitle => 'Cashback verdienen';

  @override
  String get cashbackRuleEarnSubtitle =>
      'Cashback für berechtigte Buchungen und Kampagnen.';

  @override
  String get cashbackRuleUseTitle => 'Cashback nutzen';

  @override
  String get cashbackRuleUseSubtitle =>
      'Cashback beim Checkout für unterstützte Standorte anwenden.';

  @override
  String get cashbackRuleExpireTitle => 'Ablauf';

  @override
  String get cashbackRuleExpireSubtitle =>
      'Cashback verfällt nach 12 Monaten, wenn es nicht genutzt wird.';

  @override
  String get couponsTitle => 'Gutscheine';

  @override
  String get couponWelcomeSubtitle => '10 % Rabatt auf deine nächste Buchung.';

  @override
  String get couponCitySubtitle =>
      '5 ₺ Cashback für Standorte im Stadtzentrum.';

  @override
  String get couponWeekendSubtitle => '15 % Rabatt auf Wochenend-Abgabe.';

  @override
  String get crashLogsTitle => 'Absturzprotokolle';

  @override
  String get crashLogsCopied => 'Protokolle kopiert';

  @override
  String get crashLogsEmpty => 'Noch keine Protokolle erfasst.';

  @override
  String get allLabel => 'Alle';

  @override
  String get bookingUpcomingLabel => 'Bevorstehend';

  @override
  String get bookingActiveLabel => 'Aktiv';

  @override
  String get bookingPastLabel => 'Vergangen';

  @override
  String get supportSectionTitle => 'Support';

  @override
  String get faqTitle => 'FAQ';

  @override
  String get aboutKyradiTitle => 'Über Kyradi';

  @override
  String get whatsappLabel => 'WhatsApp';

  @override
  String get callLabel => 'Anrufen';

  @override
  String get emailLabel => 'E-Mail';

  @override
  String get securitySectionTitle => 'Sicherheit';

  @override
  String get changePasswordTitle => 'Passwort ändern';

  @override
  String get languageTurkish => 'Türkçe';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageGerman => 'Deutsch';

  @override
  String get languageSpanish => 'Español';

  @override
  String get languageRussian => 'Русский';

  @override
  String get filtersTitle => 'Filter';

  @override
  String get resetAction => 'Zurücksetzen';

  @override
  String get filterOpenNow => 'Jetzt geöffnet';

  @override
  String get filterAvailableSlots => 'Verfügbare Slots';

  @override
  String get filterActiveLocations => 'Aktive Standorte';

  @override
  String get applyAction => 'Anwenden';

  @override
  String get refreshAction => 'Aktualisieren';

  @override
  String get faqQ1 => 'Wie funktioniert Kyradi?';

  @override
  String get faqA1 =>
      'Gib dein Gepäck an einem Partnerstandort ab und hole es später mit QR/PIN ab.';

  @override
  String get faqQ2 => 'Kann ich vor Ort bezahlen?';

  @override
  String get faqA2 => 'Ja, vor Ort oder per Karte bezahlen.';

  @override
  String get faqQ3 => 'Was, wenn ein Standort voll ist?';

  @override
  String get faqA3 => 'Wähle einen anderen Standort oder eine andere Zeit.';

  @override
  String get faqQ4 => 'Wie lade ich einen Ausweis hoch?';

  @override
  String get faqA4 => 'Profil → Verifizierung → Ausweis öffnen.';

  @override
  String get aboutKyradiDescription =>
      'Kyradi ist eine Gepäckaufbewahrungs-Superapp, die Reisende mit vertrauenswürdigen Partnerstandorten verbindet.';

  @override
  String get versionLabel => 'Version';

  @override
  String get accountVerificationTitle => 'Kontoverifizierung';

  @override
  String get requiredFieldLabel => 'Pflichtfeld';

  @override
  String get birthDateSelectLabel => 'Geburtsdatum auswählen';

  @override
  String get birthDateRequiredMessage => 'Geburtsdatum ist erforderlich';

  @override
  String get firebaseConfigMissing => 'Firebase-Konfiguration fehlt.';

  @override
  String get googleTokenInvalid =>
      'Google-Token konnte nicht verifiziert werden. Bitte erneut versuchen.';

  @override
  String get tokenInvalidMessage => 'Ungültiges Token.';

  @override
  String get socialTokenFormatInvalid => 'Google-Token-Format ist ungültig.';

  @override
  String get socialTokenInvalid =>
      'Google-Sitzung konnte nicht verifiziert werden. Bitte erneut versuchen.';

  @override
  String get authFlowWrong => 'Falscher Anmeldeablauf.';

  @override
  String get socialLoginCancelled => 'Anmeldung abgebrochen.';

  @override
  String get authBusyMessage => 'Vorgang läuft, bitte warten.';

  @override
  String get googleConfigMissing => 'Google-Anmeldekonfiguration fehlt.';

  @override
  String get googleConfigMissingIosScheme =>
      'Google-Anmeldekonfiguration fehlt (iOS-URL-Scheme).';

  @override
  String get appleSignInUnavailable => 'Apple Sign-In ist nicht verfügbar.';

  @override
  String get appleConfigMissing => 'Apple-Anmeldekonfiguration fehlt.';

  @override
  String get retryAction => 'Erneut versuchen';

  @override
  String get verificationStatusVerified => 'Konto verifiziert';

  @override
  String get verificationStatusPending => 'Verifizierung ausstehend';

  @override
  String get verificationStatusRequired => 'Verifizierung erforderlich';

  @override
  String get verificationBadgeVerified => 'Verifiziert';

  @override
  String get verificationBadgePending => 'Ausstehend';

  @override
  String get verificationBadgeNew => 'Neu';

  @override
  String get viewAction => 'Ansehen';

  @override
  String get manageAction => 'Verwalten';

  @override
  String locationSlotsLabel(Object available, Object total) {
    return '$available/$total Plätze';
  }

  @override
  String get quickActionScanQr => 'QR scannen';

  @override
  String get quickActionCashback => 'Cashback';

  @override
  String get quickActionReservation => 'Reservierung';

  @override
  String get quickActionSupport => 'Support';

  @override
  String get quickActionCampaigns => 'Kampagnen';

  @override
  String get paymentHotelCommissionNote =>
      'Eine Hotelprovision von 5 % wird hinzugefügt.';

  @override
  String get paymentStartAction => 'Zahlung starten';

  @override
  String get paymentRequiredBeforeDropMessage =>
      'Ohne Zahlung kann die Abgabe nicht abgeschlossen werden.';

  @override
  String get paymentNotCompletedMessage =>
      'Die Zahlung muss vor der Abgabe abgeschlossen sein.';

  @override
  String get paymentCompletedMessage =>
      'Zahlung abgeschlossen. Du kannst das Gepäck abgeben.';

  @override
  String get paymentPageTitle => 'Zahlung';

  @override
  String get paymentPageSubtitle =>
      'Gib deine Kartendaten ein, um die Zahlung abzuschließen.';

  @override
  String get paymentCardNumberLabel => 'Kartennummer';

  @override
  String get paymentCardNameLabel => 'Name auf der Karte';

  @override
  String get paymentExpiryLabel => 'Gültig bis';

  @override
  String get paymentCvcLabel => 'CVC';

  @override
  String get paymentCompleteAction => 'Zahlung abschließen';

  @override
  String get paymentDemoBadge => 'Demo payment (gateway not connected)';

  @override
  String get paymentFormIncompleteMessage =>
      'Bitte alle Kartendaten ausfüllen.';

  @override
  String get paymentFailedMessage =>
      'Zahlung konnte nicht abgeschlossen werden.';

  @override
  String get paymentSuccessMessage => 'Zahlung erfolgreich erhalten';

  @override
  String get paymentCardNumberInvalidMessage =>
      'Kartennummer muss 16 Ziffern haben.';

  @override
  String get paymentExpiryInvalidMessage =>
      'Ablaufdatum muss im Format MM/JJ sein.';

  @override
  String get paymentCvvInvalidMessage => 'CVV muss 3 oder 4 Ziffern haben.';

  @override
  String get paymentPayAtHotelTitle => 'Im Hotel zahlen';

  @override
  String get paymentPayAtHotelBody =>
      'Du kannst die Zahlung am ausgewählten Standort abschließen.';

  @override
  String paymentTotalLabel(Object amount) {
    return 'Gesamt: $amount TRY';
  }

  @override
  String get installmentCountLabel => 'Anzahl der Raten';

  @override
  String get pricingEstimateTitle => 'Preisvorschau';

  @override
  String get pricingEstimateLoading => 'Preis wird berechnet...';

  @override
  String get pricingBasePriceLabel => 'Basispreis';

  @override
  String get pricingPremiumFeeLabel => 'Premium-Schutz';

  @override
  String get pricingHotelCommissionLabel => 'Hotelprovision';

  @override
  String get pricingInstallmentFeeLabel => 'Ratenaufschlag';

  @override
  String get pricingTotalLabel => 'Gesamt';

  @override
  String get pricingTierLabel => 'Zeitraum';

  @override
  String get pricingPriceLabel => 'Geschätzter Preis';

  @override
  String get pricingTier0To6 => '0–6 Stunden';

  @override
  String get pricingTier6To24 => '6–24 Stunden';

  @override
  String pricingTierDaily(Object days) {
    return '$days Tage';
  }

  @override
  String get pricingInvalidRangeMessage =>
      'Die Abholzeit muss nach der Abgabe liegen.';

  @override
  String get pricingQuoteFailedMessage => 'Preis konnte nicht berechnet werden';

  @override
  String get pricingSummaryTitle => 'Preisübersicht';

  @override
  String get pricingSummaryEdit => 'Bearbeiten';

  @override
  String get pricingSummarySizeLabel => 'Größe';

  @override
  String get pricingSummaryDurationLabel => 'Dauer';

  @override
  String get pricingSummaryAmountLabel => 'Betrag';

  @override
  String get pricingEstimateDisclaimer =>
      'Dies ist eine Schätzung und kann sich je nach tatsächlicher Abgabezeit ändern.';

  @override
  String get pricingEstimateUnavailable =>
      'Wähle Abgabe- und Abholzeit, um eine Schätzung zu sehen.';

  @override
  String get pickupPinSentMessage =>
      'Die Abhol-PIN wurde an deine E-Mail gesendet.';

  @override
  String get pickupPinFailedMessage =>
      'PIN konnte nicht gesendet werden. Bitte später erneut versuchen.';

  @override
  String get landingLocateSectionTitle => 'Finde die nächsten Punkte';

  @override
  String get landingLocateSectionSubtitle =>
      'Teile deinen Standort, um Empfehlungen zu erhalten.';

  @override
  String get landingLocateButton => 'Meinen Standort finden';

  @override
  String get landingLocatingButton => 'Standort wird ermittelt...';

  @override
  String get landingNearestTitle => 'Nächste Punkte';

  @override
  String get landingNearestSubtitle =>
      '3 Empfehlungen basierend auf deinem Standort';

  @override
  String get landingGoButton => 'Los';

  @override
  String get landingDetailsButton => 'Details';

  @override
  String get dropTimePending => 'Abgabezeit nicht gewählt';

  @override
  String dropTimeLabel(Object time) {
    return 'Abgabezeit: $time';
  }

  @override
  String get pickupTimePending => 'Abholzeit nicht gewählt';

  @override
  String pickupTimeLabel(Object time) {
    return 'Abholzeit: $time';
  }

  @override
  String get scheduleTimesRequired => 'Bitte Abgabe- und Abholzeit auswählen.';

  @override
  String get notesHint => 'Schloss, zerbrechlich, besondere Hinweise...';

  @override
  String get luggageNameHint => 'Gib dem Gepäck einen Namen (optional)';

  @override
  String get luggageRegistrationNote =>
      'Nach dem Speichern kann dein Team den QR-Sticker drucken. Kund:innen müssen ihn beim Abgeben und Abholen scannen.';

  @override
  String get luggageDelegateAction => 'An Notfallkontakt übergeben';

  @override
  String get delegateInfoRequiredMessage =>
      'Bitte die Daten der Notfallperson ausfüllen.';

  @override
  String get howItWorksTitle => 'So funktioniert’s';

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
  String get pickupPinTitle => 'Abhol-PIN';

  @override
  String get pickupPinLabel => 'Abhol-PIN';

  @override
  String get pickupPinHint => '4-stellige PIN';

  @override
  String pickupPinGenerated(Object pin) {
    return 'Abhol-PIN: $pin';
  }

  @override
  String get pickupPinRequiredMessage => 'Abhol-PIN ist erforderlich.';

  @override
  String get pickupPinInvalidMessage =>
      'PIN ist falsch. Bitte erneut versuchen.';

  @override
  String get delegateSetupTitle => 'Bevollmächtigte Person';

  @override
  String get delegateNameLabel => 'Vollständiger Name';

  @override
  String get delegatePhoneLabel => 'Telefon';

  @override
  String get delegateEmailLabel => 'E-Mail';

  @override
  String get delegateCodeTitle => 'Bevollmächtigten-Code';

  @override
  String get delegateCodeLabel => 'Bevollmächtigten-Code';

  @override
  String get delegateCodeHint => '6-stelliger Code';

  @override
  String delegateCodeGenerated(Object code) {
    return 'Bevollmächtigten-Code: $code';
  }

  @override
  String get delegateCodeRequiredMessage =>
      'Bevollmächtigten-Code erforderlich.';

  @override
  String get delegateCodeInvalidMessage =>
      'Bevollmächtigten-Code ist ungültig.';

  @override
  String get delegateCodeExpiredMessage =>
      'Bevollmächtigten-Code ist abgelaufen.';

  @override
  String get delegateCodeUsedMessage =>
      'Bevollmächtigten-Code wurde bereits verwendet.';

  @override
  String get delegateSavedMessage => 'Bevollmächtigte Person gespeichert.';

  @override
  String get delegateEmergencyCodeTitle => 'Notfallcode';

  @override
  String get ownerInfoTitle => 'Besitzerinfo';

  @override
  String get ownerNameLabel => 'Name';

  @override
  String get ownerPhoneLabel => 'Telefon';

  @override
  String get ownerEmailLabel => 'E-Mail';

  @override
  String get pickupPinSafetyWarning =>
      'Speichere deine PIN und teile sie nicht. Diese PIN wird bei der Abholung benötigt.';

  @override
  String get pickupPinCopiedMessage => 'PIN kopiert — bewahre sie sicher auf.';

  @override
  String get copy => 'Kopieren';

  @override
  String get luggageCreateFailed => 'Gepäck konnte nicht erstellt werden.';

  @override
  String get savingInProgress => 'Wird gespeichert...';

  @override
  String get statusLabel => 'Status';

  @override
  String get permissionNameCamera => 'Kamera';

  @override
  String get permissionNameLocation => 'Standort';

  @override
  String get permissionNameNotifications => 'Benachrichtigungen';

  @override
  String get footerCopyright => '@2025 aparial.com';

  @override
  String get green => 'Grün';

  @override
  String get qrRegenerate => 'Neu erzeugen';

  @override
  String get locationPermissionDenied => 'Standorterlaubnis nicht erteilt.';

  @override
  String get dropDatePickerHelp => 'Abgabedatum';

  @override
  String get pickupDatePickerHelp => 'Abholdatum';

  @override
  String get addLuggageTitle => 'Gepäck anlegen';

  @override
  String get apiSettingsTitle => 'Sunucu Ayarları';

  @override
  String get apiSettingsBaseUrlLabel => 'Taban URL';

  @override
  String apiSettingsActiveLabel(Object url) {
    return 'Aktif: $url';
  }

  @override
  String get apiSettingsEnvLockedNote =>
      'Bu değer uygulama derlenirken sabitlenmiş. Değişiklik yapmak için dart-define parametrelerini güncellemelisiniz.';

  @override
  String get apiSettingsDeviceNote =>
      'Not: Telefon veya fiziksel cihazdan test ederken bilgisayarınızın yerel IP adresini girin.';

  @override
  String get apiSettingsResetButton => 'Varsayılan';

  @override
  String get apiSettingsInvalidUrl => 'Lütfen geçerli bir URL girin';

  @override
  String get apiSettingsResetSuccess => 'Sunucu adresi varsayılan ayara döndü.';

  @override
  String get apiSettingsUpdatedSuccess => 'Sunucu adresi güncellendi.';

  @override
  String get rememberMeLabel => 'Remember me';

  @override
  String get qrShowAction => 'Show QR';

  @override
  String get qrScanAction => 'Scan QR';

  @override
  String get detailsAction => 'Details';

  @override
  String get supportAction => 'Support';

  @override
  String get luggageStatusAwaitingDrop => 'Awaiting drop';

  @override
  String get luggageStatusDropped => 'Stored';

  @override
  String get luggageStatusPickedUp => 'Picked up';

  @override
  String get luggageStatusCancelled => 'Cancelled';

  @override
  String get paymentStatusPaid => 'Paid';

  @override
  String get paymentStatusPending => 'Pending';

  @override
  String get paymentStatusFailed => 'Failed';

  @override
  String get paymentStatusUnpaid => 'Unpaid';

  @override
  String get luggageTimelineCreated => 'Created';

  @override
  String get luggageTimelineScheduledDrop => 'Scheduled drop';

  @override
  String get luggageTimelineDropped => 'Dropped';

  @override
  String get luggageTimelineScheduledPickup => 'Scheduled pickup';

  @override
  String get luggageTimelinePickedUp => 'Picked up';

  @override
  String get luggageTimelineLastUpdate => 'Last update';

  @override
  String get luggageTimelineScheduled => 'Scheduled';

  @override
  String get activeTripTitle => 'Active trip';

  @override
  String get seeAllAction => 'See all';

  @override
  String get campaignsTitle => 'Campaigns';

  @override
  String get campaignsEmptyState => 'No campaigns available.';

  @override
  String get campaignsComingSoon => 'Campaigns are coming soon.';

  @override
  String get campaignCityWelcomeTitle => 'City Welcome';

  @override
  String get campaignCityWelcomeSubtitle =>
      'Get 10% back on your first booking.';

  @override
  String get campaignWeekendTitle => 'Weekend Storage';

  @override
  String get campaignWeekendSubtitle => 'Save on weekend drop-offs.';

  @override
  String get campaignAirportTitle => 'Airport Drop';

  @override
  String get campaignAirportSubtitle => 'Extra points for airport locations.';

  @override
  String get campaignNewTag => 'NEW';

  @override
  String get campaignHotTag => 'HOT';

  @override
  String get campaignBonusTag => 'BONUS';

  @override
  String get profileVerifiedLabel => 'Verified';

  @override
  String get profileEditTitle => 'Edit Profile';

  @override
  String get profileSaveAction => 'Save';

  @override
  String get profilePhotoSectionTitle => 'Profile photo';

  @override
  String get profilePhotoSectionSubtitle =>
      'Personalize your profile and build trust.';

  @override
  String get profilePhotoUploadTitle => 'Upload a photo';

  @override
  String get profilePhotoUploadHint =>
      'PNG or JPG, a clear face photo is recommended.';

  @override
  String get profilePhotoSelectAction => 'Choose photo';

  @override
  String get profilePersonalSectionTitle => 'Personal details';

  @override
  String get profilePersonalSectionSubtitle =>
      'Update your name and identity details.';

  @override
  String get profileFirstNameLabel => 'First name';

  @override
  String get profileLastNameLabel => 'Last name';

  @override
  String get profileBirthDateLabel => 'Birth date';

  @override
  String get profileNationalIdLabel => 'National ID';

  @override
  String get profileContactSectionTitle => 'Contact';

  @override
  String get profileContactSectionSubtitle => 'Update your phone and address.';

  @override
  String get profilePhoneLabel => 'Phone';

  @override
  String get profileAddressLabel => 'Address';

  @override
  String get profileSavedMessage => 'Profile updated.';

  @override
  String get profileSaveFailed => 'Profile update failed.';

  @override
  String profileSaveFailedWithDetails(Object details) {
    return 'Profile update failed: $details';
  }

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsInAppNotifications => 'In-app notifications';

  @override
  String get settingsEmailReminders => 'Email reminders';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsThemeLight => 'Light';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get profileDetailsTitle => 'Profile Details';

  @override
  String get profileDetailsSubtitle => 'Your account and contact info';

  @override
  String get profileEmailLabel => 'Email';

  @override
  String get profileGenderLabel => 'Gender';

  @override
  String get profileGenderFemale => 'Female';

  @override
  String get profileGenderMale => 'Male';

  @override
  String get profileGenderUnspecified => 'Not specified';

  @override
  String get profileVerificationStatus => 'Verification Status';

  @override
  String get profileVerificationPending => 'Pending Review';

  @override
  String get profileVerificationMissing => 'Not Verified';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletHeaderTitle => 'Cashback';

  @override
  String get walletHeaderSubtitle => 'Earn rewards as you travel.';

  @override
  String get walletCashbackTitle => 'Cashback';

  @override
  String get walletCashbackTotalLabel => 'Total Cashback';

  @override
  String get walletCardsTitle => 'My Cards';

  @override
  String get walletAddCardTitle => 'Add Card';

  @override
  String get walletAddCardSubtitle => 'Save your card for faster payments.';

  @override
  String get walletCardNumberLabel => 'Card Number';

  @override
  String get walletCardNameLabel => 'Cardholder Name';

  @override
  String get walletCardExpiryLabel => 'Expiry';

  @override
  String get walletCardCvvLabel => 'CVV';

  @override
  String get walletAddCardAction => 'Save Card';

  @override
  String get walletCardsEmptyTitle => 'No cards yet';

  @override
  String get walletCardsEmptySubtitle => 'You can add your cards here.';

  @override
  String get walletTabTopUps => 'Top-ups';

  @override
  String get walletTabSpends => 'Spends';

  @override
  String get walletTabCashback => 'Cashback';

  @override
  String get walletFilterDateLabel => 'Date Range';

  @override
  String get walletFilterLast7 => 'Last 7 days';

  @override
  String get walletFilterLast30 => 'Last 30 days';

  @override
  String get walletFilterLast90 => 'Last 90 days';

  @override
  String get walletRulesAction => 'Rules';

  @override
  String get walletBalanceLabel => 'Cashback balance';

  @override
  String walletMonthlyEarnedLabel(Object amount) {
    return '+$amount ₺ this month';
  }

  @override
  String get walletUseCashbackAction => 'Use cashback';

  @override
  String get walletCouponsAction => 'Coupons';

  @override
  String get walletInviteAction => 'Invite';

  @override
  String get couponSectionTitle => 'Coupon code';

  @override
  String get couponSectionSubtitle => 'Apply a code for benefits or discounts.';

  @override
  String get couponInputLabel => 'Coupon code';

  @override
  String get couponApplyAction => 'Apply';

  @override
  String get couponAppliedMessage => 'Coupon applied.';

  @override
  String get couponInvalidMessage => 'Invalid coupon code.';

  @override
  String get couponFailedMessage => 'Coupon could not be applied.';

  @override
  String get topUpSectionTitle => 'Top up';

  @override
  String get topUpSectionSubtitle => 'Add money to your wallet securely.';

  @override
  String get topUpAmountLabel => 'Top-up amount (₺)';

  @override
  String get cardNumberLabel => 'Card number';

  @override
  String get cardHolderNameLabel => 'Cardholder name';

  @override
  String get cardExpiryLabel => 'Expiry (MM/YY)';

  @override
  String get cardCvvLabel => 'CVV';

  @override
  String get topUpPayAction => 'Pay';

  @override
  String get topUpConfirmTitle => 'Payment Confirmation';

  @override
  String topUpConfirmMessage(Object amount, Object card) {
    return 'Confirm adding ₺$amount. Card: $card';
  }

  @override
  String get topUpProcessingTitle => 'Processing Payment';

  @override
  String get topUpProcessingSubtitle => 'Verifying payment details securely.';

  @override
  String get topUpInvalidAmountMessage => 'Enter a valid amount.';

  @override
  String get topUpInvalidCardMessage => 'Enter valid card details.';

  @override
  String get topUpSuccessMessage => 'Top-up successful.';

  @override
  String get topUpFailedMessage => 'Top-up failed. Please try again.';

  @override
  String get topUpTransactionTitle => 'Wallet top-up';

  @override
  String get topUpTransactionCategory => 'Top-up';

  @override
  String get transferSectionTitle => 'Transfer';

  @override
  String get walletActionsTitle => 'Schnellaktionen';

  @override
  String get walletActionsSubtitle =>
      'Coupon-, Auflade- oder Transfer-Schritte öffnen.';

  @override
  String get transferSectionSubtitle => 'Send money to another user.';

  @override
  String get transferTargetLabel => 'Recipient (phone/email/ID)';

  @override
  String get transferAmountLabel => 'Amount';

  @override
  String get transferNoteLabel => 'Note (optional)';

  @override
  String get transferAction => 'Transfer';

  @override
  String get transferInvalidMessage => 'Enter recipient and amount.';

  @override
  String get transferInsufficientBalanceMessage => 'Insufficient balance.';

  @override
  String get transferConfirmTitle => 'Confirm transfer';

  @override
  String transferConfirmMessage(Object target, Object amount) {
    return 'Send $amount ₺ to $target?';
  }

  @override
  String get transferSuccessMessage => 'Transfer successful.';

  @override
  String get transferFailedMessage => 'Transfer failed.';

  @override
  String transferTransactionTitle(Object target) {
    return 'Transfer to $target';
  }

  @override
  String get transferTransactionCategory => 'Transfer';

  @override
  String get walletMissionsTitle => 'Missions';

  @override
  String get walletTransactionsTitle => 'Transactions';

  @override
  String get walletEmptyTransactionsTitle => 'No transactions yet';

  @override
  String get walletEmptyTransactionsSubtitle =>
      'Your cashback activity will appear here.';

  @override
  String get walletMockLocationTitle => 'Taksim KYRADI';

  @override
  String get walletMockPaymentTitle => 'Booking payment';

  @override
  String get walletMockCampaignTitle => 'Weekend campaign';

  @override
  String get walletMockAdjustmentTitle => 'Manual adjustment';

  @override
  String get walletTransactionCategoryCashback => 'Cashback';

  @override
  String get walletTransactionCategoryUsage => 'Usage';

  @override
  String get walletTransactionCategoryCampaign => 'Campaign';

  @override
  String get walletTransactionCategoryAdjustment => 'Adjustment';

  @override
  String get walletMissionExploreTitle => 'Explore 3 locations';

  @override
  String get walletMissionExploreSubtitle =>
      'Visit or reserve any 3 partner locations.';

  @override
  String get walletMissionWeekendTitle => 'Weekend traveler';

  @override
  String get walletMissionWeekendSubtitle => 'Complete 2 weekend bookings.';

  @override
  String get walletMissionInviteTitle => 'Invite friends';

  @override
  String get walletMissionInviteSubtitle => 'Invite 3 friends to earn rewards.';

  @override
  String get supportSoonMessage => 'Support is coming soon.';

  @override
  String get supportChatTitle => 'Kyradi Support';

  @override
  String get supportChatGreeting =>
      'Hi! Welcome to Kyradi Virtual Support. How can I help you?';

  @override
  String get supportChatHint => 'Type your message...';

  @override
  String get supportChatTyping => 'Typing...';

  @override
  String get supportChatFallback =>
      'I couldn\'t fully understand. Could you share a bit more detail?';

  @override
  String get supportChatHelpCancel =>
      'To cancel luggage: My Luggages > Details > Cancel.';

  @override
  String get supportChatHelpPayment =>
      'If you see a payment error, share the error message and card activity so we can help.';

  @override
  String get supportChatHelpReservation =>
      'You can create a reservation by choosing a location and date range.';

  @override
  String get supportChatHelpPickup =>
      'You\'ll receive reminders near pickup time. If there is a delay, let support know.';

  @override
  String get supportChatHelpLocation =>
      'You can view location availability on the Explore/Map screen.';

  @override
  String get supportChatHelpWallet => 'To top up, go to Wallet > Top Up.';

  @override
  String get qrScanSoonMessage => 'QR scanning is coming soon.';

  @override
  String get stepBagInfoTitle => 'Bavul Bilgileri';

  @override
  String get stepScheduleTitle => 'Lokasyon & Zaman';

  @override
  String get stepPricingTitle => 'Ücret & Opsiyonlar';

  @override
  String get stepPaymentTitle => 'Ödeme';

  @override
  String get stepSuccessTitle => 'Başarılı';

  @override
  String get continueAction => 'Devam Et';

  @override
  String get pricingDurationLabel => 'Süre';

  @override
  String pricingDurationValue(Object hours, Object days) {
    return '$hours saat ($days gün)';
  }

  @override
  String get pricingHourlyLabel => 'Saatlik hesap';

  @override
  String pricingHourlyValue(Object amount) {
    return '$amount ₺';
  }

  @override
  String get pricingDailyLabel => 'Günlük hesap';

  @override
  String pricingDailyValue(Object amount) {
    return '$amount ₺';
  }

  @override
  String get pricingBestPriceLabel => 'En iyi fiyat';

  @override
  String pricingBestValue(Object amount) {
    return '$amount ₺';
  }

  @override
  String get insuranceOptionTitle => 'Sigorta paketi';

  @override
  String get insuranceOptionSubtitle => 'Opsiyonel koruma (+99 ₺)';

  @override
  String get paymentMethodTransfer => 'Havale / EFT';

  @override
  String get paymentTransferNote => 'Dekont yükleyerek ödeme tamamlanır.';

  @override
  String get paymentHotelFeeNote =>
      'Otelde ödeme seçilirse +%10 hizmet bedeli eklenir.';

  @override
  String get reservationSuccessTitle => 'Rezervasyon oluşturuldu';

  @override
  String get reservationSuccessSubtitle =>
      'Bavulunuz için rezervasyon oluşturduk. Detayları Bavullarım’da görebilirsiniz.';

  @override
  String get reservationSuccessGoLuggages => 'Bavullarım’a git';

  @override
  String get reservationSuccessViewDetails => 'Detayları gör';

  @override
  String get reservationSuccessClose => 'Kapat';

  @override
  String get dropTimeTitle => 'Bırakma zamanı';

  @override
  String get pickupTimeTitle => 'Teslim alma zamanı';

  @override
  String get dropTimePlaceholder => 'Tarih ve saat seçin';

  @override
  String get pickupTimePlaceholder => 'Tarih ve saat seçin';

  @override
  String get paymentMethodWalletShort => 'Kyradi Cüzdan';

  @override
  String get invoiceSectionTitle => 'Fatura';

  @override
  String get invoiceSectionSubtitle => 'Ödeme özeti ve e-fatura görüntüle.';

  @override
  String get invoiceShowAction => 'Faturayı Göster';

  @override
  String get invoiceTitle => 'E-Fatura';

  @override
  String get invoiceNumberLabel => 'Fatura No';

  @override
  String get invoiceDateLabel => 'Tarih';

  @override
  String get invoiceCustomerLabel => 'Müşteri';

  @override
  String get invoiceCustomerFallback => 'Kyradi Misafiri';

  @override
  String get invoiceEmailLabel => 'E-posta';

  @override
  String get invoiceLocationLabel => 'Lokasyon';

  @override
  String get invoiceItemLabel => 'Hizmet';

  @override
  String get invoiceItemTitle => 'Bavul Rezervasyonu';

  @override
  String get invoiceItemDesc => 'Açıklama';

  @override
  String get invoiceItemSubtitle => 'Kyradi teslim-atma ve saklama hizmeti';

  @override
  String get invoicePaymentMethodLabel => 'Ödeme Yöntemi';

  @override
  String get invoicePaymentStatusLabel => 'Ödeme Durumu';

  @override
  String get invoiceAmountLabel => 'Tutar';

  @override
  String get invoiceVatLabel => 'KDV';

  @override
  String get invoiceVatValue => 'Dahil';

  @override
  String get invoiceTotalLabel => 'Genel Toplam';

  @override
  String get invoiceFooterNote =>
      'Bu e-fatura Kyradi tarafından dijital olarak oluşturulmuştur.';

  @override
  String get luggageInfoSectionSubtitle =>
      'Bavul bilgileri ve planlanan zamanlar.';

  @override
  String get closeAction => 'Kapat';

  @override
  String get reservationInfoTitle => 'Rezervasyon Bilgileri';

  @override
  String get reservationInfoSubtitle =>
      'Rezervasyon süreci ve ödeme bilgileri.';

  @override
  String get luggageTimelinePayment => 'Ödeme';

  @override
  String get luggageTimelineTimeUnknown => 'Zaman bilgisi yok';

  @override
  String get invoiceDownloadAction => 'Faturayı İndir';

  @override
  String invoiceSavedMessage(Object file) {
    return 'Fatura kaydedildi: $file';
  }

  @override
  String get invoiceSaveFailedMessage => 'Fatura kaydedilemedi.';
}
