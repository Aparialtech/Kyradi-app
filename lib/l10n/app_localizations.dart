import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('ru'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'KYRADI'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @findLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konumumu Bul'**
  String get findLocation;

  /// No description provided for @exploreResultsCount.
  ///
  /// In tr, this message translates to:
  /// **'{count} lokasyon'**
  String exploreResultsCount(Object count);

  /// No description provided for @exploreSortNearby.
  ///
  /// In tr, this message translates to:
  /// **'Yakına Göre'**
  String get exploreSortNearby;

  /// No description provided for @exploreSortName.
  ///
  /// In tr, this message translates to:
  /// **'A-Z'**
  String get exploreSortName;

  /// No description provided for @exploreSortAvailability.
  ///
  /// In tr, this message translates to:
  /// **'Müsaitliğe Göre'**
  String get exploreSortAvailability;

  /// No description provided for @exploreShowMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla Göster'**
  String get exploreShowMore;

  /// No description provided for @destination.
  ///
  /// In tr, this message translates to:
  /// **'Varış Noktası'**
  String get destination;

  /// No description provided for @transitRoute.
  ///
  /// In tr, this message translates to:
  /// **'Toplu Taşıma Rotası'**
  String get transitRoute;

  /// No description provided for @myLuggages.
  ///
  /// In tr, this message translates to:
  /// **'Bavullarım'**
  String get myLuggages;

  /// No description provided for @total.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get total;

  /// No description provided for @addLuggageQr.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Ekle (QR)'**
  String get addLuggageQr;

  /// No description provided for @newLuggageAdded.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bavul eklendi ✅'**
  String get newLuggageAdded;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @saveProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil kaydedildi ✅'**
  String get saveProfile;

  /// No description provided for @saveProfileError.
  ///
  /// In tr, this message translates to:
  /// **'Kaydedilemedi'**
  String get saveProfileError;

  /// No description provided for @userInfo.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı Bilgileri'**
  String get userInfo;

  /// No description provided for @map.
  ///
  /// In tr, this message translates to:
  /// **'Harita'**
  String get map;

  /// No description provided for @mapIntro.
  ///
  /// In tr, this message translates to:
  /// **'KYRADI noktalarını haritada gör, en uygun rotayı oluştur.'**
  String get mapIntro;

  /// No description provided for @walkingRoute.
  ///
  /// In tr, this message translates to:
  /// **'Yürüme Rotası'**
  String get walkingRoute;

  /// No description provided for @drivingRoute.
  ///
  /// In tr, this message translates to:
  /// **'Araç Rotası'**
  String get drivingRoute;

  /// No description provided for @openInMaps.
  ///
  /// In tr, this message translates to:
  /// **'Google Haritalar\'da Aç'**
  String get openInMaps;

  /// No description provided for @routeOptions.
  ///
  /// In tr, this message translates to:
  /// **'Rota seçenekleri'**
  String get routeOptions;

  /// No description provided for @firstName.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get lastName;

  /// No description provided for @fullNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get fullNameLabel;

  /// No description provided for @phone.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get email;

  /// No description provided for @address.
  ///
  /// In tr, this message translates to:
  /// **'Adres'**
  String get address;

  /// No description provided for @birthDate.
  ///
  /// In tr, this message translates to:
  /// **'Doğum Tarihi'**
  String get birthDate;

  /// No description provided for @gender.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet'**
  String get gender;

  /// No description provided for @emergencyContact.
  ///
  /// In tr, this message translates to:
  /// **'Acil Durum Kişisi'**
  String get emergencyContact;

  /// No description provided for @note.
  ///
  /// In tr, this message translates to:
  /// **'Not / Açıklama'**
  String get note;

  /// No description provided for @cameraPermission.
  ///
  /// In tr, this message translates to:
  /// **'Kamera İzni'**
  String get cameraPermission;

  /// No description provided for @cameraPermissionDesc.
  ///
  /// In tr, this message translates to:
  /// **'QR okutmak için gereklidir'**
  String get cameraPermissionDesc;

  /// No description provided for @locationPermission.
  ///
  /// In tr, this message translates to:
  /// **'Konum İzni'**
  String get locationPermission;

  /// No description provided for @locationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon'**
  String get locationLabel;

  /// No description provided for @locationPermissionDesc.
  ///
  /// In tr, this message translates to:
  /// **'Toplu taşıma ve konum özellikleri için'**
  String get locationPermissionDesc;

  /// No description provided for @notificationPermission.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim İzni'**
  String get notificationPermission;

  /// No description provided for @notificationPermissionDesc.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatmalar ve güncellemeler için'**
  String get notificationPermissionDesc;

  /// No description provided for @inAppNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama içi bildirimler'**
  String get inAppNotifications;

  /// No description provided for @notificationSound.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim Sesi'**
  String get notificationSound;

  /// No description provided for @notificationVibrate.
  ///
  /// In tr, this message translates to:
  /// **'Titreşim'**
  String get notificationVibrate;

  /// No description provided for @account.
  ///
  /// In tr, this message translates to:
  /// **'Hesap'**
  String get account;

  /// No description provided for @changePassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Değiştir'**
  String get changePassword;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @aboutApp.
  ///
  /// In tr, this message translates to:
  /// **'Bu uygulama KYRADI tarafından geliştirilmiştir.'**
  String get aboutApp;

  /// No description provided for @qrCode.
  ///
  /// In tr, this message translates to:
  /// **'QR Kodu'**
  String get qrCode;

  /// No description provided for @weight.
  ///
  /// In tr, this message translates to:
  /// **'Ağırlık (kg)'**
  String get weight;

  /// No description provided for @size.
  ///
  /// In tr, this message translates to:
  /// **'Boyut'**
  String get size;

  /// No description provided for @sizeSmallDimensions.
  ///
  /// In tr, this message translates to:
  /// **'max 55x40x20 cm'**
  String get sizeSmallDimensions;

  /// No description provided for @sizeMediumDimensions.
  ///
  /// In tr, this message translates to:
  /// **'max 65x45x25 cm'**
  String get sizeMediumDimensions;

  /// No description provided for @sizeLargeDimensions.
  ///
  /// In tr, this message translates to:
  /// **'65x45x25 cm üstü'**
  String get sizeLargeDimensions;

  /// No description provided for @sizeSmallNote.
  ///
  /// In tr, this message translates to:
  /// **'Kabin boy ve sırt çantaları için uygundur'**
  String get sizeSmallNote;

  /// No description provided for @sizeSelectionNote.
  ///
  /// In tr, this message translates to:
  /// **'Bavul tesliminde boyut kontrol edilir, yanlış seçimde fiyat güncellenebilir.'**
  String get sizeSelectionNote;

  /// No description provided for @color.
  ///
  /// In tr, this message translates to:
  /// **'Renk'**
  String get color;

  /// No description provided for @small.
  ///
  /// In tr, this message translates to:
  /// **'Küçük'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In tr, this message translates to:
  /// **'Büyük'**
  String get large;

  /// No description provided for @black.
  ///
  /// In tr, this message translates to:
  /// **'Siyah'**
  String get black;

  /// No description provided for @red.
  ///
  /// In tr, this message translates to:
  /// **'Kırmızı'**
  String get red;

  /// No description provided for @blue.
  ///
  /// In tr, this message translates to:
  /// **'Mavi'**
  String get blue;

  /// No description provided for @grey.
  ///
  /// In tr, this message translates to:
  /// **'Gri'**
  String get grey;

  /// No description provided for @other.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get other;

  /// No description provided for @saveLuggage.
  ///
  /// In tr, this message translates to:
  /// **'Bavulu Kaydet'**
  String get saveLuggage;

  /// No description provided for @qrEmptyError.
  ///
  /// In tr, this message translates to:
  /// **'QR kod boş olamaz ❌'**
  String get qrEmptyError;

  /// No description provided for @oldPassword.
  ///
  /// In tr, this message translates to:
  /// **'Eski Şifre'**
  String get oldPassword;

  /// No description provided for @newPassword.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre'**
  String get newPassword;

  /// No description provided for @confirmNewPassword.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre (Tekrar)'**
  String get confirmNewPassword;

  /// No description provided for @passwordChanged.
  ///
  /// In tr, this message translates to:
  /// **'Şifre değiştirildi ✅'**
  String get passwordChanged;

  /// No description provided for @passwordMismatch.
  ///
  /// In tr, this message translates to:
  /// **'Yeni şifreler eşleşmiyor ❌'**
  String get passwordMismatch;

  /// No description provided for @languageChanged.
  ///
  /// In tr, this message translates to:
  /// **'Dil değiştirildi ✅'**
  String get languageChanged;

  /// No description provided for @permissionGranted.
  ///
  /// In tr, this message translates to:
  /// **'{permission} izni verildi ✅'**
  String permissionGranted(Object permission);

  /// No description provided for @permissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'{permission} izni reddedildi ❌'**
  String permissionDenied(Object permission);

  /// No description provided for @permissionDeniedForever.
  ///
  /// In tr, this message translates to:
  /// **'{permission} izni kalıcı olarak reddedildi, ayarlardan aç ⚙️'**
  String permissionDeniedForever(Object permission);

  /// No description provided for @locationReceived.
  ///
  /// In tr, this message translates to:
  /// **'Konum alındı 📍 {lat}, {lng}'**
  String locationReceived(Object lat, Object lng);

  /// No description provided for @locationFailed.
  ///
  /// In tr, this message translates to:
  /// **'Konum alınamadı ❌'**
  String get locationFailed;

  /// No description provided for @profileSaved.
  ///
  /// In tr, this message translates to:
  /// **'Profil kaydedildi ✅'**
  String get profileSaved;

  /// No description provided for @profileSaveError.
  ///
  /// In tr, this message translates to:
  /// **'Profil kaydedilemedi ❌'**
  String get profileSaveError;

  /// No description provided for @logoutSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapıldı 👋'**
  String get logoutSuccess;

  /// No description provided for @copyrightNotice.
  ///
  /// In tr, this message translates to:
  /// **'© 2025 KYRADI. Tüm hakları saklıdır.'**
  String get copyrightNotice;

  /// No description provided for @demoMapComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Harita modülü yakında açılacak.'**
  String get demoMapComingSoon;

  /// No description provided for @demoLuggageButton.
  ///
  /// In tr, this message translates to:
  /// **'Bavul {number}'**
  String demoLuggageButton(Object number);

  /// No description provided for @demoLuggageSelected.
  ///
  /// In tr, this message translates to:
  /// **'{label} seçildi.'**
  String demoLuggageSelected(Object label);

  /// No description provided for @demoFirstNameValue.
  ///
  /// In tr, this message translates to:
  /// **'Deniz'**
  String get demoFirstNameValue;

  /// No description provided for @demoLastNameValue.
  ///
  /// In tr, this message translates to:
  /// **'Gezensoy'**
  String get demoLastNameValue;

  /// No description provided for @demoNationalIdValue.
  ///
  /// In tr, this message translates to:
  /// **'12345678901'**
  String get demoNationalIdValue;

  /// No description provided for @demoAddressValue.
  ///
  /// In tr, this message translates to:
  /// **'İstanbul, Türkiye'**
  String get demoAddressValue;

  /// No description provided for @demoEmergencyNameValue.
  ///
  /// In tr, this message translates to:
  /// **'Merve Sönmez'**
  String get demoEmergencyNameValue;

  /// No description provided for @demoEmergencyAddressValue.
  ///
  /// In tr, this message translates to:
  /// **'Kadıköy, İstanbul'**
  String get demoEmergencyAddressValue;

  /// No description provided for @demoEmergencyEmailValue.
  ///
  /// In tr, this message translates to:
  /// **'merve@example.com'**
  String get demoEmergencyEmailValue;

  /// No description provided for @demoEmergencyRelationValue.
  ///
  /// In tr, this message translates to:
  /// **'Kardeş / Yakın Akraba'**
  String get demoEmergencyRelationValue;

  /// No description provided for @emergencyContactNote.
  ///
  /// In tr, this message translates to:
  /// **'Acil durumlarda bu kişi aranacaktır.'**
  String get emergencyContactNote;

  /// No description provided for @introTagline.
  ///
  /// In tr, this message translates to:
  /// **'Global Bavul Sistemi'**
  String get introTagline;

  /// No description provided for @splashSlogan.
  ///
  /// In tr, this message translates to:
  /// **'Bavulunu bırak, şehri keşfet'**
  String get splashSlogan;

  /// No description provided for @introTrackButton.
  ///
  /// In tr, this message translates to:
  /// **'Takip Et'**
  String get introTrackButton;

  /// No description provided for @serverButtonLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu'**
  String get serverButtonLabel;

  /// No description provided for @serverStatus.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu: {host}'**
  String serverStatus(Object host);

  /// No description provided for @loginHeroSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesabına giriş yaparak bavullarını yönet.'**
  String get loginHeroSubtitle;

  /// No description provided for @loginFormTitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş bilgileri'**
  String get loginFormTitle;

  /// No description provided for @loginFormSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapmak için en güncel sunucuya bağlan.'**
  String get loginFormSubtitle;

  /// No description provided for @emailHint.
  ///
  /// In tr, this message translates to:
  /// **'ornek@mail.com'**
  String get emailHint;

  /// No description provided for @passwordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In tr, this message translates to:
  /// **'••••••'**
  String get passwordHint;

  /// No description provided for @validationEmailRequired.
  ///
  /// In tr, this message translates to:
  /// **'E-posta gerekli'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir e-posta gir'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre gerekli'**
  String get validationPasswordRequired;

  /// No description provided for @validationMinChars.
  ///
  /// In tr, this message translates to:
  /// **'En az {count} karakter gir'**
  String validationMinChars(Object count);

  /// No description provided for @loginForgotPassword.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi unuttum'**
  String get loginForgotPassword;

  /// No description provided for @clearButton.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get clearButton;

  /// No description provided for @loginButtonLabel.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get loginButtonLabel;

  /// No description provided for @loginSocialDivider.
  ///
  /// In tr, this message translates to:
  /// **'veya'**
  String get loginSocialDivider;

  /// No description provided for @loginContinueWithGoogle.
  ///
  /// In tr, this message translates to:
  /// **'Google ile devam et'**
  String get loginContinueWithGoogle;

  /// No description provided for @loginContinueWithApple.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile devam et'**
  String get loginContinueWithApple;

  /// No description provided for @loginSocialComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'{provider} yakında aktif olacak.'**
  String loginSocialComingSoon(Object provider);

  /// No description provided for @loginNoAccount.
  ///
  /// In tr, this message translates to:
  /// **'Hesabın yok mu?'**
  String get loginNoAccount;

  /// No description provided for @registerButtonLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerButtonLabel;

  /// No description provided for @loginSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarılı ✅'**
  String get loginSuccess;

  /// No description provided for @loginInvalidCredentials.
  ///
  /// In tr, this message translates to:
  /// **'E-posta veya şifre hatalı ❌'**
  String get loginInvalidCredentials;

  /// No description provided for @loginTooManyAttempts.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yaptınız, lütfen birkaç dakika sonra tekrar deneyin ⚠️'**
  String get loginTooManyAttempts;

  /// No description provided for @loginFailed.
  ///
  /// In tr, this message translates to:
  /// **'Giriş başarısız, tekrar deneyin ❌'**
  String get loginFailed;

  /// No description provided for @genericErrorWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu: {details}'**
  String genericErrorWithDetails(Object details);

  /// No description provided for @genericErrorMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bir hata oluştu.'**
  String get genericErrorMessage;

  /// No description provided for @loginVerificationRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen hesabını doğrula 📨'**
  String get loginVerificationRequired;

  /// No description provided for @verificationSendFailedWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama kodu gönderilemedi: {details}'**
  String verificationSendFailedWithDetails(Object details);

  /// No description provided for @registerTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get registerTitle;

  /// No description provided for @registerPersonalSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Bilgiler'**
  String get registerPersonalSectionTitle;

  /// No description provided for @registerPersonalSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik ve doğum tarihini paylaş.'**
  String get registerPersonalSectionSubtitle;

  /// No description provided for @genderMale.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get genderFemale;

  /// No description provided for @genderUndisclosed.
  ///
  /// In tr, this message translates to:
  /// **'Belirtmek istemiyorum'**
  String get genderUndisclosed;

  /// No description provided for @registerContactSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'İletişim Bilgileri'**
  String get registerContactSectionTitle;

  /// No description provided for @registerContactSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'E-posta ve doğrulama bilgileriniz'**
  String get registerContactSectionSubtitle;

  /// No description provided for @nationalIdLabel.
  ///
  /// In tr, this message translates to:
  /// **'TC Kimlik No'**
  String get nationalIdLabel;

  /// No description provided for @phoneHint.
  ///
  /// In tr, this message translates to:
  /// **'+90 5xx xxx xx xx'**
  String get phoneHint;

  /// No description provided for @registerSecuritySectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get registerSecuritySectionTitle;

  /// No description provided for @registerSecuritySectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifreni belirle ve doğrula'**
  String get registerSecuritySectionSubtitle;

  /// No description provided for @registerPasswordRepeatLabel.
  ///
  /// In tr, this message translates to:
  /// **'Şifre Tekrar'**
  String get registerPasswordRepeatLabel;

  /// No description provided for @registerCaptchaLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ben robot değilim'**
  String get registerCaptchaLabel;

  /// No description provided for @registerCaptchaWarning.
  ///
  /// In tr, this message translates to:
  /// **'\"Ben robot değilim\" kutusunu işaretleyin'**
  String get registerCaptchaWarning;

  /// No description provided for @registerKvkkAgreementLabel.
  ///
  /// In tr, this message translates to:
  /// **'KYRADI – KVKK Aydınlatma Metni\'ni okudum ve onaylıyorum.'**
  String get registerKvkkAgreementLabel;

  /// No description provided for @registerKvkkAgreementWarning.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen KVKK Aydınlatma Metni\'ni kabul edin.'**
  String get registerKvkkAgreementWarning;

  /// No description provided for @registerRestrictedAgreementLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aparial\'in ve genel taşıma şirketlerinin reddettiği maddeleri okudum ve kabul ediyorum.'**
  String get registerRestrictedAgreementLabel;

  /// No description provided for @registerRestrictedAgreementWarning.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen reddedilen maddeler belgesini onaylayın.'**
  String get registerRestrictedAgreementWarning;

  /// No description provided for @registerAgreementView.
  ///
  /// In tr, this message translates to:
  /// **'Metni Görüntüle'**
  String get registerAgreementView;

  /// No description provided for @registerKvkkDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'KYRADI – KVKK Aydınlatma Metni'**
  String get registerKvkkDialogTitle;

  /// No description provided for @registerRestrictedDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aparial\'in ve Genel Taşıma Şirketlerinin Reddettiği Maddeler'**
  String get registerRestrictedDialogTitle;

  /// No description provided for @registerKvkkDocumentBody.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel Verilerin Korunması ve İşlenmesine İlişkin Aydınlatma Metni\nBu metin, KYRADI platformu kapsamında işlenen kişisel verilerin, 6698 sayılı Kişisel Verilerin Korunması Kanunu (\"KVKK\") uyarınca hangi kapsamda ve hangi amaçlarla işlendiğini açıklamak amacıyla hazırlanmıştır.\n\nİşlenen Kişisel Veri Türleri\nKYRADI platformu kapsamında aşağıdaki kişisel veri grupları işlenmektedir:\nMüşteri verileri:\nAd Soyad, Telefon, QR kod tokenı, Rezervasyon ve dolap bilgisi, Ödeme tutarı ve işlem numarası\nPersonel verileri:\nAd Soyad, E-posta, Kullanıcı rolü, IP, işlem logları, oturum bilgisi\nTeknik veriler:\nAudit log kayıtları, Tarayıcı/cihaz bilgisi, Hata raporları\n\nVeri İşleme Amaçları\nKişisel veriler; rezervasyon akışının sağlanması, QR kod üretimi ve doğrulaması, ödeme intent yönetimi, bagaj teslim ve iade sürecinin yürütülmesi, sistem güvenliğinin sağlanması ve kötüye kullanımın tespiti, yasal saklama yükümlülüklerinin yerine getirilmesi ile raporlama ve platform iyileştirmeleri amaçlarıyla işlenmektedir.\n\nHukuki Dayanaklar\nKişisel veriler, KVKK’nın 5/2-c maddesi kapsamında sözleşmenin kurulması ve ifası, 5/2-f maddesi kapsamında meşru menfaat, 5/2-ç maddesi kapsamında hukuki yükümlülükler ile açık rıza gerektiren durumlarda ilgili kişinin açık rızasına dayanılarak işlenmektedir.\n\nVerilerin Aktarıldığı Taraflar\nKişisel veriler; ödeme hizmetlerinin sağlanması amacıyla Stripe ve Iyzico gibi ödeme servislerine, altyapı ve barındırma hizmetleri kapsamında AWS, Google Cloud, Render ve Vercel gibi bulut sağlayıcılara, zorunlu hallerde kamu kurumlarına ve hukuki veya mali danışmanlara aktarılabilmektedir.\n\nSaklama Süreleri\nKişisel veriler; rezervasyon ve ödeme kayıtları için 10 yıl, audit log kayıtları için 2 yıl, kullanıcı hesapları için hesap kapanışından itibaren 1 yıl süreyle saklanmakta olup, QR kod tokenları 1–24 saat aralığında muhafaza edilmektedir.\n\nGüvenlik Tedbirleri\nKYRADI platformunda; tenant bazlı veri izolasyonu, parola hashleme, JWT tabanlı güvenlik, rol bazlı erişim kontrolü, rate limiting ve saldırı önleme mekanizmaları ile kritik işlemler için audit log tutulması gibi teknik ve idari güvenlik tedbirleri uygulanmaktadır.\n\nAydınlatma ve Açık Rıza\nKullanıcı, gerekli hallerde açık rızasının alınacağını ve rızasını dilediği zaman geri çekebileceğini kabul eder. Açık rızanın geri çekilmesi, ilgili işlemlerin yürütülmesini kısmen veya tamamen etkileyebilir.\n\nVeri Güncelliği ve Doğruluk\nKullanıcı, KYRADI platformuna sunduğu verilerin doğru ve güncel olduğunu kabul eder. Yanlış veya güncel olmayan verilerden doğabilecek aksaklıklardan kullanıcı sorumludur.\n\nİletişim ve Bilgilendirme\nKullanıcı, hesap ve işlem bildirimlerinin e-posta, SMS veya uygulama içi bildirimlerle gönderilebileceğini kabul eder. Bu bildirimler güvenlik, ödeme ve rezervasyon süreçlerinin yürütülmesi amacıyla yapılır.\n\nİlgili Kişinin Hakları\nKVKK’nın 11. maddesi kapsamında ilgili kişiler; kişisel verilerinin işlenip işlenmediğini öğrenme, silme ve düzeltme talebinde bulunma, veri işlemeye itiraz etme ve zarar halinde tazminat talep etme haklarına sahiptir.\n\nBaşvurular kvkk@kyradi.com adresi üzerinden iletilebilir.'**
  String get registerKvkkDocumentBody;

  /// No description provided for @registerRestrictedDocumentBody.
  ///
  /// In tr, this message translates to:
  /// **'Bu belge, Aparial ve genel taşıma şirketleri tarafından taşınması reddedilen maddeleri özetlemektedir.\nGüvenlik, yasal düzenlemeler ve operasyonel riskler nedeniyle aşağıda belirtilen maddeler taşımaya kabul edilmez:\n\nTehlikeli ve Riskli Maddeler\n- Patlayıcı maddeler (dinamit, havai fişek, el bombası vb.)\n- Yanıcı ve parlayıcı maddeler (benzin, tiner, boya, çözücü vb.)\n- Basınçlı gazlar (propan, butan, oksijen tüpleri vb.)\n- Toksik, zehirli veya aşındırıcı kimyasallar (asit, baz, ağartıcı vb.)\n- Radyoaktif maddeler\n- Yanıcı kimyasallar içeren sıvılar veya çözücüler\n- Patlama veya yangın riski oluşturan herhangi bir madde veya cihaz\n\nSilah ve Tehlikeli Ekipmanlar\n- Silahlar, mühimmat ve benzeri ateşli cihazlar\n- Kesici veya delici aletler (hançer, uzun bıçak, sivri metal aletler vb.)\n\nCihazlar ve Basınçlı Ürünler\n- Gaz veya yakıt içeren cihazlar (yakıt dolu kamp ocakları vb.)\n- Basınçlı aerosol kutuları (tehlikeli gaz içeren spreyler)\n- Yüksek kapasiteli veya yedek lityum piller ve bataryalar\n\nRahatsızlık ve Güvenlik Riski Oluşturan Maddeler\n- Ağır kokulu, duman çıkaran veya çevreyi rahatsız eden maddeler\n\nDeğerli Eşyalar\n- Ziynet eşyalar (altın, mücevher vb. değerli eşyalar) taşımaya kabul edilmez.\n- Para (miktarına bakılmaksızın) taşımaya kabul edilmez.\n\nNot:\nBazı maddeler belirli izin, miktar veya güvenlik önlemleri ile taşınabilir. Ancak genel olarak bu tür maddeler hem Aparial hem de diğer taşıma şirketleri tarafından reddedilmektedir.'**
  String get registerRestrictedDocumentBody;

  /// No description provided for @registerSuccessMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarılı ✅ Doğrulama e-postası gönderildi.'**
  String get registerSuccessMessage;

  /// No description provided for @registerEmailExistsMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresi zaten kayıtlı ❌'**
  String get registerEmailExistsMessage;

  /// No description provided for @registerGenericErrorMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt başarısız ❌'**
  String get registerGenericErrorMessage;

  /// No description provided for @validationRequired.
  ///
  /// In tr, this message translates to:
  /// **'Zorunlu'**
  String get validationRequired;

  /// No description provided for @validationPasswordNeedsLetter.
  ///
  /// In tr, this message translates to:
  /// **'En az 1 harf içermeli'**
  String get validationPasswordNeedsLetter;

  /// No description provided for @validationPasswordNeedsNumber.
  ///
  /// In tr, this message translates to:
  /// **'En az 1 rakam içermeli'**
  String get validationPasswordNeedsNumber;

  /// No description provided for @validationPasswordRepeatRequired.
  ///
  /// In tr, this message translates to:
  /// **'Şifre tekrar gerekli'**
  String get validationPasswordRepeatRequired;

  /// No description provided for @validationNationalIdRequired.
  ///
  /// In tr, this message translates to:
  /// **'TC gerekli'**
  String get validationNationalIdRequired;

  /// No description provided for @validationNationalIdLength.
  ///
  /// In tr, this message translates to:
  /// **'TC 11 hane olmalı'**
  String get validationNationalIdLength;

  /// No description provided for @validationNationalIdChecksumTen.
  ///
  /// In tr, this message translates to:
  /// **'TC geçersiz (10. hane)'**
  String get validationNationalIdChecksumTen;

  /// No description provided for @validationNationalIdChecksumEleven.
  ///
  /// In tr, this message translates to:
  /// **'TC geçersiz (11. hane)'**
  String get validationNationalIdChecksumEleven;

  /// No description provided for @validationNationalIdInvalid.
  ///
  /// In tr, this message translates to:
  /// **'TC geçersiz'**
  String get validationNationalIdInvalid;

  /// No description provided for @validationPhoneRequired.
  ///
  /// In tr, this message translates to:
  /// **'Telefon gerekli'**
  String get validationPhoneRequired;

  /// No description provided for @validationPhoneFormat.
  ///
  /// In tr, this message translates to:
  /// **'Format: +90 5xx xxx xx xx'**
  String get validationPhoneFormat;

  /// No description provided for @validationBirthDateRequired.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi seçin'**
  String get validationBirthDateRequired;

  /// No description provided for @validationAgeRequirement.
  ///
  /// In tr, this message translates to:
  /// **'18 yaşından büyük olmalısınız'**
  String get validationAgeRequirement;

  /// No description provided for @formNotSelected.
  ///
  /// In tr, this message translates to:
  /// **'Seçilmedi'**
  String get formNotSelected;

  /// No description provided for @forgotTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifremi Unuttum'**
  String get forgotTitle;

  /// No description provided for @forgotIntro.
  ///
  /// In tr, this message translates to:
  /// **'Şifreni sıfırlamak için kayıtlı e-postana kod gönderelim.'**
  String get forgotIntro;

  /// No description provided for @forgotEmailSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'E-posta doğrulama'**
  String get forgotEmailSectionTitle;

  /// No description provided for @forgotEmailSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı adresine tek kullanımlık kod gönderilecektir.'**
  String get forgotEmailSectionSubtitle;

  /// No description provided for @emailAddressLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta adresi'**
  String get emailAddressLabel;

  /// No description provided for @forgotSendButton.
  ///
  /// In tr, this message translates to:
  /// **'Kod Gönder'**
  String get forgotSendButton;

  /// No description provided for @forgotResendCountdown.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Gönder ({seconds}s)'**
  String forgotResendCountdown(int seconds);

  /// No description provided for @forgotAlreadyHaveCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodum zaten var'**
  String get forgotAlreadyHaveCode;

  /// No description provided for @forgotNeedValidEmail.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen önce geçerli bir e-posta gir 💌'**
  String get forgotNeedValidEmail;

  /// No description provided for @forgotCodeSent.
  ///
  /// In tr, this message translates to:
  /// **'Kod gönderildi 📩'**
  String get forgotCodeSent;

  /// No description provided for @forgotEmailNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta sistemde kayıtlı değil ❌'**
  String get forgotEmailNotFound;

  /// No description provided for @forgotTooManyAttempts.
  ///
  /// In tr, this message translates to:
  /// **'Çok fazla deneme yaptınız, lütfen 1 dakika sonra tekrar deneyin ⚠️'**
  String get forgotTooManyAttempts;

  /// No description provided for @forgotCodeFailed.
  ///
  /// In tr, this message translates to:
  /// **'Kod gönderilemedi ❌'**
  String get forgotCodeFailed;

  /// No description provided for @resetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Sıfırla'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-posta adresine gönderilen kodu girerek yeni şifreni oluştur.'**
  String get resetSubtitle;

  /// No description provided for @verificationCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama Kodu'**
  String get verificationCodeLabel;

  /// No description provided for @resetNewPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre'**
  String get resetNewPasswordLabel;

  /// No description provided for @resetConfirmPasswordLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Şifre (Tekrar)'**
  String get resetConfirmPasswordLabel;

  /// No description provided for @resetSubmitButton.
  ///
  /// In tr, this message translates to:
  /// **'Şifreyi Sıfırla'**
  String get resetSubmitButton;

  /// No description provided for @unknownError.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmeyen hata'**
  String get unknownError;

  /// No description provided for @verificationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama'**
  String get verificationTitle;

  /// No description provided for @verificationInstructions.
  ///
  /// In tr, this message translates to:
  /// **'{email} adresine gönderilen 6 haneli kodu gir.'**
  String verificationInstructions(Object email);

  /// No description provided for @verifyButtonLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kodu Doğrula'**
  String get verifyButtonLabel;

  /// No description provided for @verificationResendButton.
  ///
  /// In tr, this message translates to:
  /// **'Kodu Tekrar Gönder'**
  String get verificationResendButton;

  /// No description provided for @verificationCountdownLabel.
  ///
  /// In tr, this message translates to:
  /// **'{seconds} sn sonra tekrar gönder'**
  String verificationCountdownLabel(int seconds);

  /// No description provided for @verificationResentMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kod tekrar gönderildi'**
  String get verificationResentMessage;

  /// No description provided for @verificationSendErrorMessage.
  ///
  /// In tr, this message translates to:
  /// **'Gönderim hatası'**
  String get verificationSendErrorMessage;

  /// No description provided for @verificationMissingEmailMessage.
  ///
  /// In tr, this message translates to:
  /// **'E-posta alınamadı'**
  String get verificationMissingEmailMessage;

  /// No description provided for @verificationSuccessMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı doğrulandı ✅'**
  String get verificationSuccessMessage;

  /// No description provided for @verificationErrorMessage.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama hatası'**
  String get verificationErrorMessage;

  /// No description provided for @verificationCodeInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kod 6 haneli olmalı'**
  String get verificationCodeInvalidMessage;

  /// No description provided for @validationVerificationCodeRequired.
  ///
  /// In tr, this message translates to:
  /// **'Kod gerekli'**
  String get validationVerificationCodeRequired;

  /// No description provided for @validationVerificationCodeLength.
  ///
  /// In tr, this message translates to:
  /// **'6 haneli kod girin'**
  String get validationVerificationCodeLength;

  /// No description provided for @dashboardGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba, {name}'**
  String dashboardGreeting(Object name);

  /// No description provided for @dashboardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Konumunu paylaş, bavullarını yönet.'**
  String get dashboardSubtitle;

  /// No description provided for @dashboardTotalCount.
  ///
  /// In tr, this message translates to:
  /// **'Toplam {count}'**
  String dashboardTotalCount(Object count);

  /// No description provided for @travelerPlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Gezgin'**
  String get travelerPlaceholder;

  /// No description provided for @quickAddLuggage.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Ekle'**
  String get quickAddLuggage;

  /// No description provided for @quickTransit.
  ///
  /// In tr, this message translates to:
  /// **'Toplu Taşıma'**
  String get quickTransit;

  /// No description provided for @dashboardMetricAwaiting.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Bekleyen'**
  String get dashboardMetricAwaiting;

  /// No description provided for @dashboardMetricStored.
  ///
  /// In tr, this message translates to:
  /// **'Depoda'**
  String get dashboardMetricStored;

  /// No description provided for @dashboardMetricPicked.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Alınan'**
  String get dashboardMetricPicked;

  /// No description provided for @dashboardMetricCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İptal Edilen'**
  String get dashboardMetricCancelled;

  /// No description provided for @deliverySectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Teslimat & Rota'**
  String get deliverySectionTitle;

  /// No description provided for @deliverySectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Teslim noktasını seç ve varış rotasını aç.'**
  String get deliverySectionSubtitle;

  /// No description provided for @deliveryPointLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Noktası'**
  String get deliveryPointLabel;

  /// No description provided for @deliveryPointOption.
  ///
  /// In tr, this message translates to:
  /// **'{name} • Boş {available}/{total}'**
  String deliveryPointOption(Object name, int available, int total);

  /// No description provided for @deliveryPointSelected.
  ///
  /// In tr, this message translates to:
  /// **'Teslim noktası seçildi: {name} ✅'**
  String deliveryPointSelected(Object name);

  /// No description provided for @routeNeedLocation.
  ///
  /// In tr, this message translates to:
  /// **'Önce \"Konumumu Bul\" seçeneğini kullan.'**
  String get routeNeedLocation;

  /// No description provided for @routeNeedDestination.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir varış noktası gir.'**
  String get routeNeedDestination;

  /// No description provided for @mapsOpenFailed.
  ///
  /// In tr, this message translates to:
  /// **'Google Maps açılamadı.'**
  String get mapsOpenFailed;

  /// No description provided for @reservationSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon Durumları'**
  String get reservationSectionTitle;

  /// No description provided for @reservationSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Açık noktaların doluluk ve rezervasyon bilgilerini incele.'**
  String get reservationSectionSubtitle;

  /// No description provided for @reservationEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyonu Düzenle'**
  String get reservationEditTitle;

  /// No description provided for @luggagesSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'QR kodlarını göster, bırakma/teslim işlemlerini tamamla.'**
  String get luggagesSectionSubtitle;

  /// No description provided for @newLuggageButton.
  ///
  /// In tr, this message translates to:
  /// **'Yeni Bavul'**
  String get newLuggageButton;

  /// No description provided for @luggageFilterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get luggageFilterAll;

  /// No description provided for @luggageFilterAwaiting.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Bekleyen'**
  String get luggageFilterAwaiting;

  /// No description provided for @luggageFilterStored.
  ///
  /// In tr, this message translates to:
  /// **'Depoda'**
  String get luggageFilterStored;

  /// No description provided for @luggageFilterPicked.
  ///
  /// In tr, this message translates to:
  /// **'Teslim'**
  String get luggageFilterPicked;

  /// No description provided for @luggageFilterCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İptal Edilen'**
  String get luggageFilterCancelled;

  /// No description provided for @luggageEmptyStateNoItems.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıtlı bavul yok. Hemen yeni bir bavul ekleyin.'**
  String get luggageEmptyStateNoItems;

  /// No description provided for @luggageSearchHint.
  ///
  /// In tr, this message translates to:
  /// **'Bavul adı, QR veya lokasyon ara'**
  String get luggageSearchHint;

  /// No description provided for @luggageSortLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sırala'**
  String get luggageSortLabel;

  /// No description provided for @luggageSortDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarihe Göre'**
  String get luggageSortDate;

  /// No description provided for @luggageSortStatus.
  ///
  /// In tr, this message translates to:
  /// **'Duruma Göre'**
  String get luggageSortStatus;

  /// No description provided for @luggageSortLocation.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyona Göre'**
  String get luggageSortLocation;

  /// No description provided for @luggageSortPayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Durumu'**
  String get luggageSortPayment;

  /// No description provided for @luggageViewList.
  ///
  /// In tr, this message translates to:
  /// **'Liste'**
  String get luggageViewList;

  /// No description provided for @luggageViewCards.
  ///
  /// In tr, this message translates to:
  /// **'Kart'**
  String get luggageViewCards;

  /// No description provided for @luggageViewCalendar.
  ///
  /// In tr, this message translates to:
  /// **'Takvim'**
  String get luggageViewCalendar;

  /// No description provided for @luggageShowMore.
  ///
  /// In tr, this message translates to:
  /// **'Daha Fazla Yükle'**
  String get luggageShowMore;

  /// No description provided for @luggageNoResultsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sonuç bulunamadı'**
  String get luggageNoResultsTitle;

  /// No description provided for @luggageNoResultsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Aramanı veya filtrelerini değiştir.'**
  String get luggageNoResultsSubtitle;

  /// No description provided for @luggageFilterTitle.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get luggageFilterTitle;

  /// No description provided for @luggageFilterStatus.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get luggageFilterStatus;

  /// No description provided for @luggageFilterPayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme'**
  String get luggageFilterPayment;

  /// No description provided for @luggageFilterLocation.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon'**
  String get luggageFilterLocation;

  /// No description provided for @luggageFilterSize.
  ///
  /// In tr, this message translates to:
  /// **'Boyut'**
  String get luggageFilterSize;

  /// No description provided for @luggageFilterReset.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get luggageFilterReset;

  /// No description provided for @luggageFilterApply.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get luggageFilterApply;

  /// No description provided for @comingSoonMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu özellik yakında.'**
  String get comingSoonMessage;

  /// No description provided for @luggageEmptyStateFiltered.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen filtrede bavul bulunamadı.'**
  String get luggageEmptyStateFiltered;

  /// No description provided for @profileInfoSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İletişim bilgilerini güncel tut.'**
  String get profileInfoSubtitle;

  /// No description provided for @emergencySectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yakınını ekleyerek güvenliği artır.'**
  String get emergencySectionSubtitle;

  /// No description provided for @relationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yakınlık'**
  String get relationLabel;

  /// No description provided for @emergencyRegisteredPerson.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı kişi'**
  String get emergencyRegisteredPerson;

  /// No description provided for @identitySectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik / Pasaport'**
  String get identitySectionTitle;

  /// No description provided for @identitySectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Teslim süreçlerinde gösterilecek belgeyi güvenle yükleyin.'**
  String get identitySectionSubtitle;

  /// No description provided for @identityPreviewHint.
  ///
  /// In tr, this message translates to:
  /// **'Belge ön izlemesi burada görünecek'**
  String get identityPreviewHint;

  /// No description provided for @identityDocIdCard.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik'**
  String get identityDocIdCard;

  /// No description provided for @identityDocPassport.
  ///
  /// In tr, this message translates to:
  /// **'Pasaport'**
  String get identityDocPassport;

  /// No description provided for @identityUploaded.
  ///
  /// In tr, this message translates to:
  /// **'Yüklenen belge: {file}'**
  String identityUploaded(Object file);

  /// No description provided for @identityMissing.
  ///
  /// In tr, this message translates to:
  /// **'Henüz belge yüklenmedi. Teslimat için kimlik veya pasaport fotoğrafı zorunlu.'**
  String get identityMissing;

  /// No description provided for @identityTakePhoto.
  ///
  /// In tr, this message translates to:
  /// **'Kameradan çek'**
  String get identityTakePhoto;

  /// No description provided for @identityPickFromGallery.
  ///
  /// In tr, this message translates to:
  /// **'Galeriden seç'**
  String get identityPickFromGallery;

  /// No description provided for @identityDelete.
  ///
  /// In tr, this message translates to:
  /// **'Belgeyi sil'**
  String get identityDelete;

  /// No description provided for @identityPhotoSaved.
  ///
  /// In tr, this message translates to:
  /// **'{docType} fotoğrafı kaydedildi ✅'**
  String identityPhotoSaved(Object docType);

  /// No description provided for @identityUploadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Belge yüklenemedi: {details}'**
  String identityUploadFailed(Object details);

  /// No description provided for @identityRemoved.
  ///
  /// In tr, this message translates to:
  /// **'Belge kaldırıldı.'**
  String get identityRemoved;

  /// No description provided for @identityProofRequired.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmeden önce kimlik veya pasaport fotoğrafı yükleyin.'**
  String get identityProofRequired;

  /// No description provided for @profileDataMissing.
  ///
  /// In tr, this message translates to:
  /// **'Profil verisi alınamadı.'**
  String get profileDataMissing;

  /// No description provided for @profileLoadFailed.
  ///
  /// In tr, this message translates to:
  /// **'Profil yüklenemedi: {details}'**
  String profileLoadFailed(Object details);

  /// No description provided for @profileUserMissing.
  ///
  /// In tr, this message translates to:
  /// **'Kullanıcı bulunamadı. Lütfen tekrar giriş yapın.'**
  String get profileUserMissing;

  /// No description provided for @luggageLocationMissing.
  ///
  /// In tr, this message translates to:
  /// **'Bu bavul için lokasyon bilgisi bulunamadı.'**
  String get luggageLocationMissing;

  /// No description provided for @luggageInfoSize.
  ///
  /// In tr, this message translates to:
  /// **'Boyut: {value}'**
  String luggageInfoSize(Object value);

  /// No description provided for @luggageInfoWeight.
  ///
  /// In tr, this message translates to:
  /// **'Ağırlık: {value} kg'**
  String luggageInfoWeight(Object value);

  /// No description provided for @luggageInfoSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Bilgileri'**
  String get luggageInfoSectionTitle;

  /// No description provided for @luggageInfoLabelSize.
  ///
  /// In tr, this message translates to:
  /// **'Boyut'**
  String get luggageInfoLabelSize;

  /// No description provided for @luggageInfoLabelWeight.
  ///
  /// In tr, this message translates to:
  /// **'Ağırlık'**
  String get luggageInfoLabelWeight;

  /// No description provided for @luggageInfoLabelColor.
  ///
  /// In tr, this message translates to:
  /// **'Renk'**
  String get luggageInfoLabelColor;

  /// No description provided for @luggageInfoLabelPayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme'**
  String get luggageInfoLabelPayment;

  /// No description provided for @luggageInfoLabelTotal.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get luggageInfoLabelTotal;

  /// No description provided for @luggageInfoColor.
  ///
  /// In tr, this message translates to:
  /// **'Renk: {value}'**
  String luggageInfoColor(Object value);

  /// No description provided for @noteLabel.
  ///
  /// In tr, this message translates to:
  /// **'Not: {note}'**
  String noteLabel(Object note);

  /// No description provided for @scheduledDropLabel.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan bırakma: {date}'**
  String scheduledDropLabel(Object date);

  /// No description provided for @scheduledPickupLabel.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan teslim alma: {date}'**
  String scheduledPickupLabel(Object date);

  /// No description provided for @reservationCancelledLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bu rezervasyon iptal edildi.'**
  String get reservationCancelledLabel;

  /// No description provided for @luggageShowQr.
  ///
  /// In tr, this message translates to:
  /// **'QR Kodunu Göster'**
  String get luggageShowQr;

  /// No description provided for @luggageDropAction.
  ///
  /// In tr, this message translates to:
  /// **'Bavulu bıraktım'**
  String get luggageDropAction;

  /// No description provided for @luggagePickupAction.
  ///
  /// In tr, this message translates to:
  /// **'Bavulumu Teslim Al'**
  String get luggagePickupAction;

  /// No description provided for @luggageCancelAction.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyonu İptal Et'**
  String get luggageCancelAction;

  /// No description provided for @luggageOpenLocation.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyonu Aç'**
  String get luggageOpenLocation;

  /// No description provided for @createdAtLabel.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturuldu: {date}'**
  String createdAtLabel(Object date);

  /// No description provided for @dropConfirmedAtLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma onayı: {date}'**
  String dropConfirmedAtLabel(Object date);

  /// No description provided for @pickupConfirmedAtLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alındı: {date}'**
  String pickupConfirmedAtLabel(Object date);

  /// No description provided for @loginRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen önce giriş yapın.'**
  String get loginRequired;

  /// No description provided for @luggageCreated.
  ///
  /// In tr, this message translates to:
  /// **'Yeni bavul oluşturuldu ✅'**
  String get luggageCreated;

  /// No description provided for @dropConfirmedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bavul bırakma doğrulandı ✅'**
  String get dropConfirmedMessage;

  /// No description provided for @pickupConfirmedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alma tamamlandı ✅'**
  String get pickupConfirmedMessage;

  /// No description provided for @operationFailed.
  ///
  /// In tr, this message translates to:
  /// **'İşlem tamamlanamadı.'**
  String get operationFailed;

  /// No description provided for @operationFailedWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'İşlem tamamlanamadı: {details}'**
  String operationFailedWithDetails(Object details);

  /// No description provided for @reservationCancelledMessage.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon iptal edildi.'**
  String get reservationCancelledMessage;

  /// No description provided for @cancelFailed.
  ///
  /// In tr, this message translates to:
  /// **'İptal edilemedi.'**
  String get cancelFailed;

  /// No description provided for @cancelFailedWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'İptal tamamlanamadı: {details}'**
  String cancelFailedWithDetails(Object details);

  /// No description provided for @cancelReservationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyonu iptal et'**
  String get cancelReservationTitle;

  /// No description provided for @cancelReservationMessage.
  ///
  /// In tr, this message translates to:
  /// **'\"{label}\" için oluşturulan rezervasyonu iptal etmek istediğinizden emin misiniz?'**
  String cancelReservationMessage(Object label);

  /// No description provided for @dialogDismiss.
  ///
  /// In tr, this message translates to:
  /// **'Vazgeç'**
  String get dialogDismiss;

  /// No description provided for @dialogConfirmCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal Et'**
  String get dialogConfirmCancel;

  /// No description provided for @dialogConfirm.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get dialogConfirm;

  /// No description provided for @reservationTileTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon {code}'**
  String reservationTileTitle(Object code);

  /// No description provided for @reservationTileSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'{code} • {time}'**
  String reservationTileSubtitle(Object code, Object time);

  /// No description provided for @reservationSlotSummary.
  ///
  /// In tr, this message translates to:
  /// **'{count} bavul • {time}'**
  String reservationSlotSummary(int count, Object time);

  /// No description provided for @notificationsTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notificationsTooltip;

  /// No description provided for @notificationsClearTooltip.
  ///
  /// In tr, this message translates to:
  /// **'Temizle'**
  String get notificationsClearTooltip;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz bildirim yok'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler burada görünecek. Giriş yapınca veya işlemler yaptıkça güncellenecek.'**
  String get notificationsEmptySubtitle;

  /// No description provided for @notificationTypeSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get notificationTypeSuccess;

  /// No description provided for @notificationTypeWarning.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı'**
  String get notificationTypeWarning;

  /// No description provided for @notificationTypeError.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get notificationTypeError;

  /// No description provided for @notificationTypeInfo.
  ///
  /// In tr, this message translates to:
  /// **'Bilgi'**
  String get notificationTypeInfo;

  /// No description provided for @notificationsRelativeNow.
  ///
  /// In tr, this message translates to:
  /// **'Şimdi'**
  String get notificationsRelativeNow;

  /// No description provided for @notificationsRelativeSeconds.
  ///
  /// In tr, this message translates to:
  /// **'{count} sn önce'**
  String notificationsRelativeSeconds(int count);

  /// No description provided for @notificationsRelativeMinutes.
  ///
  /// In tr, this message translates to:
  /// **'{count} dk önce'**
  String notificationsRelativeMinutes(int count);

  /// No description provided for @notificationsRelativeHours.
  ///
  /// In tr, this message translates to:
  /// **'{count} sa önce'**
  String notificationsRelativeHours(int count);

  /// No description provided for @notificationsRelativeDays.
  ///
  /// In tr, this message translates to:
  /// **'{count} gün önce'**
  String notificationsRelativeDays(int count);

  /// No description provided for @mapNoLocations.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon bulunamadı.'**
  String get mapNoLocations;

  /// No description provided for @locationServiceDisabled.
  ///
  /// In tr, this message translates to:
  /// **'Konum servisi kapalı.'**
  String get locationServiceDisabled;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni kalıcı reddedildi. Ayarlardan açmalısın.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @locationFailedWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'Konum alınamadı: {details}'**
  String locationFailedWithDetails(Object details);

  /// No description provided for @locationNotFoundTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon bulunamadı'**
  String get locationNotFoundTitle;

  /// No description provided for @locationNotFoundMessage.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen lokasyon artık mevcut değil.'**
  String get locationNotFoundMessage;

  /// No description provided for @permissionManageButton.
  ///
  /// In tr, this message translates to:
  /// **'Yönet'**
  String get permissionManageButton;

  /// No description provided for @settingsPermissionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İzinler'**
  String get settingsPermissionsTitle;

  /// No description provided for @settingsPermissionsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kamera, konum ve bildirim izinlerini yönet.'**
  String get settingsPermissionsSubtitle;

  /// No description provided for @privacySectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik'**
  String get privacySectionTitle;

  /// No description provided for @privacySectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama içi bildirim tercihlerini düzenle.'**
  String get privacySectionSubtitle;

  /// No description provided for @remindersSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hatırlatıcılar'**
  String get remindersSectionTitle;

  /// No description provided for @remindersSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Teslim ve bırakma uyarıları için tercihlerini seç.'**
  String get remindersSectionSubtitle;

  /// No description provided for @pushRemindersLabel.
  ///
  /// In tr, this message translates to:
  /// **'Push Bildirimleri'**
  String get pushRemindersLabel;

  /// No description provided for @emailRemindersLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta Hatırlatıcısı'**
  String get emailRemindersLabel;

  /// No description provided for @languageSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçimi'**
  String get languageSectionTitle;

  /// No description provided for @languageSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamanın dilini değiştirmek için seçim yap.'**
  String get languageSectionSubtitle;

  /// No description provided for @languageNameTr.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageNameTr;

  /// No description provided for @languageNameEn.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get languageNameEn;

  /// No description provided for @languageNameDe.
  ///
  /// In tr, this message translates to:
  /// **'Almanca'**
  String get languageNameDe;

  /// No description provided for @languageNameEs.
  ///
  /// In tr, this message translates to:
  /// **'İspanyolca'**
  String get languageNameEs;

  /// No description provided for @languageNameRu.
  ///
  /// In tr, this message translates to:
  /// **'Rusça'**
  String get languageNameRu;

  /// No description provided for @languageChangedTo.
  ///
  /// In tr, this message translates to:
  /// **'Dil {language} olarak değiştirildi ✅'**
  String languageChangedTo(Object language);

  /// No description provided for @upcomingReservationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan Rezervasyonlar'**
  String get upcomingReservationsTitle;

  /// No description provided for @upcomingReservationsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İsimler gizlidir; yalnızca kod ve doluluk bilgisi gösterilir.'**
  String get upcomingReservationsSubtitle;

  /// No description provided for @upcomingReservationsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Bu lokasyonda planlanmış rezervasyon yok.'**
  String get upcomingReservationsEmpty;

  /// No description provided for @continueSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueSectionTitle;

  /// No description provided for @continueSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Üyeysen giriş yap, değilsen hızlıca kayıt ol.'**
  String get continueSectionSubtitle;

  /// No description provided for @locationAuthReadyMessage.
  ///
  /// In tr, this message translates to:
  /// **'Devam etmek için hesabın hazır. Hemen rezervasyona geçebilirsin.'**
  String get locationAuthReadyMessage;

  /// No description provided for @exploreEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Konum bulunamadı.'**
  String get exploreEmptyTitle;

  /// No description provided for @exploreEmptySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Filtreleri değiştirmeyi deneyin.'**
  String get exploreEmptySubtitle;

  /// No description provided for @accountSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifreni değiştir veya oturumu kapat.'**
  String get accountSectionSubtitle;

  /// No description provided for @logoutDialogTitle.
  ///
  /// In tr, this message translates to:
  /// **'Oturumu kapat'**
  String get logoutDialogTitle;

  /// No description provided for @logoutDialogMessage.
  ///
  /// In tr, this message translates to:
  /// **'Hesaptan çıkış yapmak istiyor musun?'**
  String get logoutDialogMessage;

  /// No description provided for @changePasswordIntro.
  ///
  /// In tr, this message translates to:
  /// **'Güvenliğin için yeni şifreni belirle.'**
  String get changePasswordIntro;

  /// No description provided for @changePasswordRequirementHint.
  ///
  /// In tr, this message translates to:
  /// **'En az 8 karakter, harf ve rakam içermeli.'**
  String get changePasswordRequirementHint;

  /// No description provided for @userIdMissing.
  ///
  /// In tr, this message translates to:
  /// **'Giriş yapılmamış: userId bulunamadı.'**
  String get userIdMissing;

  /// No description provided for @userIdReadFailed.
  ///
  /// In tr, this message translates to:
  /// **'userId okunamadı: {details}'**
  String userIdReadFailed(Object details);

  /// No description provided for @mapsMissingApiKey.
  ///
  /// In tr, this message translates to:
  /// **'Google Maps API anahtarı tanımlı değil.'**
  String get mapsMissingApiKey;

  /// No description provided for @routeFetchFailedWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'Rota alınamadı: {details}'**
  String routeFetchFailedWithDetails(Object details);

  /// No description provided for @routeNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Rota bulunamadı.'**
  String get routeNotFound;

  /// No description provided for @routeDataMissing.
  ///
  /// In tr, this message translates to:
  /// **'Rota verisi alınamadı.'**
  String get routeDataMissing;

  /// No description provided for @directionsApiError.
  ///
  /// In tr, this message translates to:
  /// **'Google Directions API başarısız: {status}. Anahtarın Directions API yetkisini kontrol edin.'**
  String directionsApiError(Object status);

  /// No description provided for @reservationEmptyState.
  ///
  /// In tr, this message translates to:
  /// **'Planlanmış rezervasyon yok.'**
  String get reservationEmptyState;

  /// No description provided for @availableSlotsLabel.
  ///
  /// In tr, this message translates to:
  /// **'Boş {available}/{total}'**
  String availableSlotsLabel(int available, int total);

  /// No description provided for @qrDropTitle.
  ///
  /// In tr, this message translates to:
  /// **'QR ile bırakma doğrulaması'**
  String get qrDropTitle;

  /// No description provided for @qrPickupTitle.
  ///
  /// In tr, this message translates to:
  /// **'QR ile teslim alma'**
  String get qrPickupTitle;

  /// No description provided for @qrManualEntryHint.
  ///
  /// In tr, this message translates to:
  /// **'QR kodunu okutamıyorsan manuel gir.'**
  String get qrManualEntryHint;

  /// No description provided for @qrVerifyButton.
  ///
  /// In tr, this message translates to:
  /// **'Doğrula'**
  String get qrVerifyButton;

  /// No description provided for @qrMismatchMessage.
  ///
  /// In tr, this message translates to:
  /// **'QR kodu eşleşmedi. Tekrar dene.'**
  String get qrMismatchMessage;

  /// No description provided for @qrCopied.
  ///
  /// In tr, this message translates to:
  /// **'QR kodu kopyalandı.'**
  String get qrCopied;

  /// No description provided for @qrTextCopied.
  ///
  /// In tr, this message translates to:
  /// **'Metin kopyalandı.'**
  String get qrTextCopied;

  /// No description provided for @qrCopyCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu kopyala'**
  String get qrCopyCode;

  /// No description provided for @qrCopyPrintable.
  ///
  /// In tr, this message translates to:
  /// **'Yazdırılabilir metni kopyala'**
  String get qrCopyPrintable;

  /// No description provided for @qrShareInstructions.
  ///
  /// In tr, this message translates to:
  /// **'Bu kodu personelle paylaşarak sticker çıktısı alabilirsiniz. Müşteri bırakma ve teslim sırasında aynı kodu okutmalıdır.'**
  String get qrShareInstructions;

  /// No description provided for @qrDuplicateWarning.
  ///
  /// In tr, this message translates to:
  /// **'Bu QR kodu zaten kullanılıyor. Yeni bir kod ürettik, lütfen tekrar dene.'**
  String get qrDuplicateWarning;

  /// No description provided for @qrScanTip.
  ///
  /// In tr, this message translates to:
  /// **'Kodun çerçeve içinde net görünmesine dikkat et.'**
  String get qrScanTip;

  /// No description provided for @qrScanTitle.
  ///
  /// In tr, this message translates to:
  /// **'QR Tara'**
  String get qrScanTitle;

  /// No description provided for @qrScanGuide.
  ///
  /// In tr, this message translates to:
  /// **'QR okut veya manuel kod girerek rezervasyon detaylarına ulaş.'**
  String get qrScanGuide;

  /// No description provided for @qrManualEntry.
  ///
  /// In tr, this message translates to:
  /// **'Manuel Giriş'**
  String get qrManualEntry;

  /// No description provided for @qrManualHint.
  ///
  /// In tr, this message translates to:
  /// **'QR kodunu veya rezervasyon kodunu gir'**
  String get qrManualHint;

  /// No description provided for @qrManualSearchAction.
  ///
  /// In tr, this message translates to:
  /// **'Kodu Sorgula'**
  String get qrManualSearchAction;

  /// No description provided for @qrAwaitingScan.
  ///
  /// In tr, this message translates to:
  /// **'QR okutulduğunda rezervasyon bilgileri burada görünecek.'**
  String get qrAwaitingScan;

  /// No description provided for @qrNotFound.
  ///
  /// In tr, this message translates to:
  /// **'Bu QR kodu için kayıt bulunamadı.'**
  String get qrNotFound;

  /// No description provided for @qrLookupFailed.
  ///
  /// In tr, this message translates to:
  /// **'QR doğrulama başarısız. Lütfen tekrar deneyin.'**
  String get qrLookupFailed;

  /// No description provided for @qrReservationInfoTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon Bilgileri'**
  String get qrReservationInfoTitle;

  /// No description provided for @qrScanAgain.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Tara'**
  String get qrScanAgain;

  /// No description provided for @qrDropConfirmAction.
  ///
  /// In tr, this message translates to:
  /// **'Bavulu Bırak'**
  String get qrDropConfirmAction;

  /// No description provided for @qrConfirmDropTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Bırakma'**
  String get qrConfirmDropTitle;

  /// No description provided for @qrConfirmDropMessage.
  ///
  /// In tr, this message translates to:
  /// **'Bu bavulu teslim aldığınızı onaylıyor musunuz?'**
  String get qrConfirmDropMessage;

  /// No description provided for @qrDropSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Bavul başarıyla teslim alındı.'**
  String get qrDropSuccess;

  /// No description provided for @qrDropFailed.
  ///
  /// In tr, this message translates to:
  /// **'Bavul teslim işlemi başarısız.'**
  String get qrDropFailed;

  /// No description provided for @locationFetching.
  ///
  /// In tr, this message translates to:
  /// **'Konum alınıyor...'**
  String get locationFetching;

  /// No description provided for @refreshNearbyButton.
  ///
  /// In tr, this message translates to:
  /// **'Yakındaki noktaları güncelle'**
  String get refreshNearbyButton;

  /// No description provided for @nearbyLocationsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yakındaki lokasyonlar'**
  String get nearbyLocationsTitle;

  /// No description provided for @commonSelect.
  ///
  /// In tr, this message translates to:
  /// **'Seç'**
  String get commonSelect;

  /// No description provided for @landingTitle.
  ///
  /// In tr, this message translates to:
  /// **'KYRADI Track'**
  String get landingTitle;

  /// No description provided for @landingIntro.
  ///
  /// In tr, this message translates to:
  /// **'Bavullarını bırakmak istediğin noktayı seç. Haritadan dilediğin noktaya dokun, doluluk oranını gör ve rezervasyon detayını aç.'**
  String get landingIntro;

  /// No description provided for @occupancyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doluluk: {current}/{max}'**
  String occupancyLabel(Object current, Object max);

  /// No description provided for @locationOpenLabel.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get locationOpenLabel;

  /// No description provided for @locationClosedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get locationClosedLabel;

  /// No description provided for @openingHoursTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çalışma Saatleri'**
  String get openingHoursTitle;

  /// No description provided for @openingHoursSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Haftalık program'**
  String get openingHoursSubtitle;

  /// No description provided for @openingHoursAlwaysOpen.
  ///
  /// In tr, this message translates to:
  /// **'7/24 açık'**
  String get openingHoursAlwaysOpen;

  /// No description provided for @openingHoursClosed.
  ///
  /// In tr, this message translates to:
  /// **'Kapalı'**
  String get openingHoursClosed;

  /// No description provided for @locationFullWarning.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen lokasyon dolu.'**
  String get locationFullWarning;

  /// No description provided for @locationClosedWarning.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen lokasyon şu anda kapalı.'**
  String get locationClosedWarning;

  /// No description provided for @locationInactiveWarning.
  ///
  /// In tr, this message translates to:
  /// **'Seçilen lokasyon aktif değil.'**
  String get locationInactiveWarning;

  /// No description provided for @protectionLevelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Koruma Seviyesi'**
  String get protectionLevelTitle;

  /// No description provided for @protectionStandard.
  ///
  /// In tr, this message translates to:
  /// **'Standart'**
  String get protectionStandard;

  /// No description provided for @protectionPremium.
  ///
  /// In tr, this message translates to:
  /// **'Ek sigorta (premium)'**
  String get protectionPremium;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Yöntemi'**
  String get paymentMethodTitle;

  /// No description provided for @paymentMethodWallet.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi Cüzdan ile Öde (Bakiye: {balance} ₺)'**
  String paymentMethodWallet(Object balance);

  /// No description provided for @paymentWalletInsufficientTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bakiye Yetersiz'**
  String get paymentWalletInsufficientTitle;

  /// No description provided for @paymentWalletInsufficientMessage.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdan bakiyen {balance} ₺. Toplam tutar {amount} ₺. Para yükleyin veya kart ile ödeyin.'**
  String paymentWalletInsufficientMessage(Object balance, Object amount);

  /// No description provided for @paymentWalletTopUpAction.
  ///
  /// In tr, this message translates to:
  /// **'Para Yükle'**
  String get paymentWalletTopUpAction;

  /// No description provided for @paymentWalletUseCardAction.
  ///
  /// In tr, this message translates to:
  /// **'Kart ile Öde'**
  String get paymentWalletUseCardAction;

  /// No description provided for @paymentMethodCard.
  ///
  /// In tr, this message translates to:
  /// **'Kart'**
  String get paymentMethodCard;

  /// No description provided for @paymentMethodInstallment.
  ///
  /// In tr, this message translates to:
  /// **'Taksit'**
  String get paymentMethodInstallment;

  /// No description provided for @paymentMethodPayAtHotel.
  ///
  /// In tr, this message translates to:
  /// **'Otelde öde'**
  String get paymentMethodPayAtHotel;

  /// No description provided for @paymentMethodUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get paymentMethodUnknown;

  /// No description provided for @paymentStatusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Durumu'**
  String get paymentStatusLabel;

  /// No description provided for @paymentStatusUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get paymentStatusUnknown;

  /// No description provided for @luggageDetailsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Detayları'**
  String get luggageDetailsTitle;

  /// No description provided for @luggageDetailsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon ve ödeme bilgilerini görüntüleyin.'**
  String get luggageDetailsSubtitle;

  /// No description provided for @luggageIdLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bavul ID'**
  String get luggageIdLabel;

  /// No description provided for @createdAtTitle.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturulma'**
  String get createdAtTitle;

  /// No description provided for @statusUpdateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Durum güncellenemedi. Lütfen tekrar deneyin.'**
  String get statusUpdateFailed;

  /// No description provided for @inviteFriendsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş Davet Et'**
  String get inviteFriendsTitle;

  /// No description provided for @inviteFriendsHeadline.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodunu paylaş'**
  String get inviteFriendsHeadline;

  /// No description provided for @inviteFriendsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşlarını davet et, rezervasyon yaptıkça cashback kazan.'**
  String get inviteFriendsSubtitle;

  /// No description provided for @inviteCodeCopied.
  ///
  /// In tr, this message translates to:
  /// **'Davet kodu kopyalandı'**
  String get inviteCodeCopied;

  /// No description provided for @shareComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım yakında.'**
  String get shareComingSoon;

  /// No description provided for @shareAction.
  ///
  /// In tr, this message translates to:
  /// **'Paylaş'**
  String get shareAction;

  /// No description provided for @cashbackRulesTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback Kuralları'**
  String get cashbackRulesTitle;

  /// No description provided for @cashbackRuleEarnTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback kazan'**
  String get cashbackRuleEarnTitle;

  /// No description provided for @cashbackRuleEarnSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygun rezervasyon ve kampanyalardan cashback kazan.'**
  String get cashbackRuleEarnSubtitle;

  /// No description provided for @cashbackRuleUseTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback kullan'**
  String get cashbackRuleUseTitle;

  /// No description provided for @cashbackRuleUseSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Desteklenen lokasyonlarda ödeme sırasında cashback uygula.'**
  String get cashbackRuleUseSubtitle;

  /// No description provided for @cashbackRuleExpireTitle.
  ///
  /// In tr, this message translates to:
  /// **'Süre dolumu'**
  String get cashbackRuleExpireTitle;

  /// No description provided for @cashbackRuleExpireSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback kullanılmazsa 12 ay sonra sona erer.'**
  String get cashbackRuleExpireSubtitle;

  /// No description provided for @couponsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kuponlar'**
  String get couponsTitle;

  /// No description provided for @couponWelcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bir sonraki rezervasyonunda %10 indirim.'**
  String get couponWelcomeSubtitle;

  /// No description provided for @couponCitySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Şehir merkezi noktalarında 5 ₺ cashback.'**
  String get couponCitySubtitle;

  /// No description provided for @couponWeekendSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu teslimde %15 indirim.'**
  String get couponWeekendSubtitle;

  /// No description provided for @crashLogsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çökme Kayıtları'**
  String get crashLogsTitle;

  /// No description provided for @crashLogsCopied.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlar kopyalandı'**
  String get crashLogsCopied;

  /// No description provided for @crashLogsEmpty.
  ///
  /// In tr, this message translates to:
  /// **'Henüz kayıt yok.'**
  String get crashLogsEmpty;

  /// No description provided for @allLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get allLabel;

  /// No description provided for @bookingUpcomingLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan'**
  String get bookingUpcomingLabel;

  /// No description provided for @bookingActiveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get bookingActiveLabel;

  /// No description provided for @bookingPastLabel.
  ///
  /// In tr, this message translates to:
  /// **'Geçmiş'**
  String get bookingPastLabel;

  /// No description provided for @supportSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get supportSectionTitle;

  /// No description provided for @faqTitle.
  ///
  /// In tr, this message translates to:
  /// **'SSS'**
  String get faqTitle;

  /// No description provided for @aboutKyradiTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi Hakkında'**
  String get aboutKyradiTitle;

  /// No description provided for @whatsappLabel.
  ///
  /// In tr, this message translates to:
  /// **'WhatsApp'**
  String get whatsappLabel;

  /// No description provided for @callLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get callLabel;

  /// No description provided for @emailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get emailLabel;

  /// No description provided for @securitySectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get securitySectionTitle;

  /// No description provided for @changePasswordTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şifre değiştir'**
  String get changePasswordTitle;

  /// No description provided for @languageTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get languageTurkish;

  /// No description provided for @languageEnglish.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageGerman.
  ///
  /// In tr, this message translates to:
  /// **'Deutsch'**
  String get languageGerman;

  /// No description provided for @languageSpanish.
  ///
  /// In tr, this message translates to:
  /// **'Español'**
  String get languageSpanish;

  /// No description provided for @languageRussian.
  ///
  /// In tr, this message translates to:
  /// **'Русский'**
  String get languageRussian;

  /// No description provided for @filtersTitle.
  ///
  /// In tr, this message translates to:
  /// **'Filtreler'**
  String get filtersTitle;

  /// No description provided for @resetAction.
  ///
  /// In tr, this message translates to:
  /// **'Sıfırla'**
  String get resetAction;

  /// No description provided for @filterOpenNow.
  ///
  /// In tr, this message translates to:
  /// **'Şu an açık'**
  String get filterOpenNow;

  /// No description provided for @filterAvailableSlots.
  ///
  /// In tr, this message translates to:
  /// **'Uygun slotlar'**
  String get filterAvailableSlots;

  /// No description provided for @filterActiveLocations.
  ///
  /// In tr, this message translates to:
  /// **'Aktif lokasyonlar'**
  String get filterActiveLocations;

  /// No description provided for @applyAction.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get applyAction;

  /// No description provided for @refreshAction.
  ///
  /// In tr, this message translates to:
  /// **'Yenile'**
  String get refreshAction;

  /// No description provided for @faqQ1.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi nasıl çalışır?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In tr, this message translates to:
  /// **'Bavulunu anlaşmalı noktaya bırak, QR/PIN ile teslim al.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In tr, this message translates to:
  /// **'Yerinde ödeme yapabilir miyim?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In tr, this message translates to:
  /// **'Evet, lokasyonda veya kart ile ödeme yapabilirsin.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon doluysa ne olur?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In tr, this message translates to:
  /// **'Farklı bir lokasyon veya saat seçebilirsin.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik nasıl yüklenir?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In tr, this message translates to:
  /// **'Profil → Doğrulama → Kimlik adımlarını takip et.'**
  String get faqA4;

  /// No description provided for @aboutKyradiDescription.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi, gezginleri güvenilir partner noktalarla buluşturan bir bavul depolama superapp’idir.'**
  String get aboutKyradiDescription;

  /// No description provided for @versionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Sürüm'**
  String get versionLabel;

  /// No description provided for @accountVerificationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesap Doğrulama'**
  String get accountVerificationTitle;

  /// No description provided for @requiredFieldLabel.
  ///
  /// In tr, this message translates to:
  /// **'Zorunlu'**
  String get requiredFieldLabel;

  /// No description provided for @birthDateSelectLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi seç'**
  String get birthDateSelectLabel;

  /// No description provided for @birthDateRequiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Doğum tarihi gerekli'**
  String get birthDateRequiredMessage;

  /// No description provided for @firebaseConfigMissing.
  ///
  /// In tr, this message translates to:
  /// **'Firebase yapılandırması eksik.'**
  String get firebaseConfigMissing;

  /// No description provided for @googleTokenInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Google token doğrulanamadı. Lütfen tekrar deneyin.'**
  String get googleTokenInvalid;

  /// No description provided for @tokenInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Geçersiz token.'**
  String get tokenInvalidMessage;

  /// No description provided for @socialTokenFormatInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Google token formatı geçersiz.'**
  String get socialTokenFormatInvalid;

  /// No description provided for @socialTokenInvalid.
  ///
  /// In tr, this message translates to:
  /// **'Google oturumu doğrulanamadı, tekrar deneyin.'**
  String get socialTokenInvalid;

  /// No description provided for @authFlowWrong.
  ///
  /// In tr, this message translates to:
  /// **'Yanlış giriş akışı.'**
  String get authFlowWrong;

  /// No description provided for @socialLoginCancelled.
  ///
  /// In tr, this message translates to:
  /// **'Giriş iptal edildi.'**
  String get socialLoginCancelled;

  /// No description provided for @authBusyMessage.
  ///
  /// In tr, this message translates to:
  /// **'İşlem devam ediyor, lütfen bekleyin.'**
  String get authBusyMessage;

  /// No description provided for @googleConfigMissing.
  ///
  /// In tr, this message translates to:
  /// **'Google giriş yapılandırması eksik.'**
  String get googleConfigMissing;

  /// No description provided for @googleConfigMissingIosScheme.
  ///
  /// In tr, this message translates to:
  /// **'Google giriş yapılandırması eksik (iOS URL scheme).'**
  String get googleConfigMissingIosScheme;

  /// No description provided for @appleSignInUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Apple ile giriş kullanılamıyor.'**
  String get appleSignInUnavailable;

  /// No description provided for @appleConfigMissing.
  ///
  /// In tr, this message translates to:
  /// **'Apple giriş yapılandırması eksik.'**
  String get appleConfigMissing;

  /// No description provided for @retryAction.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get retryAction;

  /// No description provided for @verificationStatusVerified.
  ///
  /// In tr, this message translates to:
  /// **'Hesap onaylı'**
  String get verificationStatusVerified;

  /// No description provided for @verificationStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama bekliyor'**
  String get verificationStatusPending;

  /// No description provided for @verificationStatusRequired.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama gerekli'**
  String get verificationStatusRequired;

  /// No description provided for @verificationBadgeVerified.
  ///
  /// In tr, this message translates to:
  /// **'Onaylı'**
  String get verificationBadgeVerified;

  /// No description provided for @verificationBadgePending.
  ///
  /// In tr, this message translates to:
  /// **'Bekliyor'**
  String get verificationBadgePending;

  /// No description provided for @verificationBadgeNew.
  ///
  /// In tr, this message translates to:
  /// **'Yeni'**
  String get verificationBadgeNew;

  /// No description provided for @viewAction.
  ///
  /// In tr, this message translates to:
  /// **'Görüntüle'**
  String get viewAction;

  /// No description provided for @manageAction.
  ///
  /// In tr, this message translates to:
  /// **'Yönet'**
  String get manageAction;

  /// No description provided for @locationSlotsLabel.
  ///
  /// In tr, this message translates to:
  /// **'{available}/{total} slot'**
  String locationSlotsLabel(Object available, Object total);

  /// No description provided for @quickActionScanQr.
  ///
  /// In tr, this message translates to:
  /// **'Scan QR'**
  String get quickActionScanQr;

  /// No description provided for @quickActionCashback.
  ///
  /// In tr, this message translates to:
  /// **'Cashback'**
  String get quickActionCashback;

  /// No description provided for @quickActionReservation.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon'**
  String get quickActionReservation;

  /// No description provided for @quickActionSupport.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get quickActionSupport;

  /// No description provided for @quickActionCampaigns.
  ///
  /// In tr, this message translates to:
  /// **'Kampanyalar'**
  String get quickActionCampaigns;

  /// No description provided for @paymentHotelCommissionNote.
  ///
  /// In tr, this message translates to:
  /// **'Otelde yüzde 5 komisyon eklenecektir.'**
  String get paymentHotelCommissionNote;

  /// No description provided for @paymentStartAction.
  ///
  /// In tr, this message translates to:
  /// **'Ödemeyi Başlat'**
  String get paymentStartAction;

  /// No description provided for @paymentRequiredBeforeDropMessage.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme tamamlanmadan bırakma yapılamaz.'**
  String get paymentRequiredBeforeDropMessage;

  /// No description provided for @paymentNotCompletedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme tamamlanmadan bırakma yapılamaz.'**
  String get paymentNotCompletedMessage;

  /// No description provided for @paymentCompletedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme tamamlandı. Bavulu bırakabilirsiniz.'**
  String get paymentCompletedMessage;

  /// No description provided for @paymentPageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme'**
  String get paymentPageTitle;

  /// No description provided for @paymentPageSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart bilgilerinizi girerek ödemenizi tamamlayın.'**
  String get paymentPageSubtitle;

  /// No description provided for @paymentCardNumberLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kart Numarası'**
  String get paymentCardNumberLabel;

  /// No description provided for @paymentCardNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kart Üzerindeki İsim'**
  String get paymentCardNameLabel;

  /// No description provided for @paymentExpiryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma'**
  String get paymentExpiryLabel;

  /// No description provided for @paymentCvcLabel.
  ///
  /// In tr, this message translates to:
  /// **'CVC'**
  String get paymentCvcLabel;

  /// No description provided for @paymentCompleteAction.
  ///
  /// In tr, this message translates to:
  /// **'Ödemeyi Tamamla'**
  String get paymentCompleteAction;

  /// No description provided for @paymentDemoBadge.
  ///
  /// In tr, this message translates to:
  /// **'Demo Ödeme (Altyapı bağlanacak)'**
  String get paymentDemoBadge;

  /// No description provided for @paymentFormIncompleteMessage.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen kart bilgilerini eksiksiz girin.'**
  String get paymentFormIncompleteMessage;

  /// No description provided for @paymentFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme tamamlanamadı.'**
  String get paymentFailedMessage;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme başarıyla alındı'**
  String get paymentSuccessMessage;

  /// No description provided for @paymentCardNumberInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kart numarası 16 hane olmalı.'**
  String get paymentCardNumberInvalidMessage;

  /// No description provided for @paymentExpiryInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Son kullanma tarihi MM/YY formatında olmalı.'**
  String get paymentExpiryInvalidMessage;

  /// No description provided for @paymentCvvInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'CVV 3 veya 4 haneli olmalı.'**
  String get paymentCvvInvalidMessage;

  /// No description provided for @paymentPayAtHotelTitle.
  ///
  /// In tr, this message translates to:
  /// **'Otelde Ödeme'**
  String get paymentPayAtHotelTitle;

  /// No description provided for @paymentPayAtHotelBody.
  ///
  /// In tr, this message translates to:
  /// **'Ödemenizi seçtiğiniz lokasyonda tamamlayabilirsiniz.'**
  String get paymentPayAtHotelBody;

  /// No description provided for @paymentTotalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam: {amount} ₺'**
  String paymentTotalLabel(Object amount);

  /// No description provided for @installmentCountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Taksit sayısı'**
  String get installmentCountLabel;

  /// No description provided for @pricingEstimateTitle.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini Fiyat'**
  String get pricingEstimateTitle;

  /// No description provided for @pricingEstimateLoading.
  ///
  /// In tr, this message translates to:
  /// **'Tahmin hesaplanıyor...'**
  String get pricingEstimateLoading;

  /// No description provided for @pricingBasePriceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Baz fiyat'**
  String get pricingBasePriceLabel;

  /// No description provided for @pricingPremiumFeeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ek sigorta'**
  String get pricingPremiumFeeLabel;

  /// No description provided for @pricingHotelCommissionLabel.
  ///
  /// In tr, this message translates to:
  /// **'Otel komisyonu'**
  String get pricingHotelCommissionLabel;

  /// No description provided for @pricingInstallmentFeeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Taksit farkı'**
  String get pricingInstallmentFeeLabel;

  /// No description provided for @pricingTotalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam'**
  String get pricingTotalLabel;

  /// No description provided for @pricingTierLabel.
  ///
  /// In tr, this message translates to:
  /// **'Süre bandı'**
  String get pricingTierLabel;

  /// No description provided for @pricingPriceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini fiyat'**
  String get pricingPriceLabel;

  /// No description provided for @pricingTier0To6.
  ///
  /// In tr, this message translates to:
  /// **'0–6 saat'**
  String get pricingTier0To6;

  /// No description provided for @pricingTier6To24.
  ///
  /// In tr, this message translates to:
  /// **'6–24 saat'**
  String get pricingTier6To24;

  /// No description provided for @pricingTierDaily.
  ///
  /// In tr, this message translates to:
  /// **'{days} gün'**
  String pricingTierDaily(Object days);

  /// No description provided for @pricingInvalidRangeMessage.
  ///
  /// In tr, this message translates to:
  /// **'Teslim saati bırakma saatinden sonra olmalı.'**
  String get pricingInvalidRangeMessage;

  /// No description provided for @pricingQuoteFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Fiyat hesaplanamadı'**
  String get pricingQuoteFailedMessage;

  /// No description provided for @pricingSummaryTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ücret Özeti'**
  String get pricingSummaryTitle;

  /// No description provided for @pricingSummaryEdit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get pricingSummaryEdit;

  /// No description provided for @pricingSummarySizeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Boyut'**
  String get pricingSummarySizeLabel;

  /// No description provided for @pricingSummaryDurationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get pricingSummaryDurationLabel;

  /// No description provided for @pricingSummaryAmountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get pricingSummaryAmountLabel;

  /// No description provided for @pricingEstimateDisclaimer.
  ///
  /// In tr, this message translates to:
  /// **'Bu ücret tahminidir, gerçek teslim saatine göre güncellenebilir.'**
  String get pricingEstimateDisclaimer;

  /// No description provided for @pricingEstimateUnavailable.
  ///
  /// In tr, this message translates to:
  /// **'Tahmin için bırakma ve teslim saatini seçin.'**
  String get pricingEstimateUnavailable;

  /// No description provided for @pickupPinSentMessage.
  ///
  /// In tr, this message translates to:
  /// **'PIN mailinize gönderildi.'**
  String get pickupPinSentMessage;

  /// No description provided for @pickupPinFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'PIN gönderilemedi, lütfen daha sonra tekrar deneyin.'**
  String get pickupPinFailedMessage;

  /// No description provided for @landingLocateSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sana en yakın noktaları bul'**
  String get landingLocateSectionTitle;

  /// No description provided for @landingLocateSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Konumunu paylaşırsan öneriler liste halinde çıkar.'**
  String get landingLocateSectionSubtitle;

  /// No description provided for @landingLocateButton.
  ///
  /// In tr, this message translates to:
  /// **'Konumumu Bul'**
  String get landingLocateButton;

  /// No description provided for @landingLocatingButton.
  ///
  /// In tr, this message translates to:
  /// **'Konum alınıyor...'**
  String get landingLocatingButton;

  /// No description provided for @landingNearestTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sana en yakın noktalar'**
  String get landingNearestTitle;

  /// No description provided for @landingNearestSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Konumuna göre önerilen 3 nokta'**
  String get landingNearestSubtitle;

  /// No description provided for @landingGoButton.
  ///
  /// In tr, this message translates to:
  /// **'Git'**
  String get landingGoButton;

  /// No description provided for @landingDetailsButton.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get landingDetailsButton;

  /// No description provided for @dropTimePending.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma zamanı seçilmedi'**
  String get dropTimePending;

  /// No description provided for @dropTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma zamanı: {time}'**
  String dropTimeLabel(Object time);

  /// No description provided for @pickupTimePending.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alma zamanı seçilmedi'**
  String get pickupTimePending;

  /// No description provided for @pickupTimeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alma zamanı: {time}'**
  String pickupTimeLabel(Object time);

  /// No description provided for @scheduleTimesRequired.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma ve teslim alma zamanları zorunludur.'**
  String get scheduleTimesRequired;

  /// No description provided for @notesHint.
  ///
  /// In tr, this message translates to:
  /// **'Kilidi, kırılganlık, özel talimatlar...'**
  String get notesHint;

  /// No description provided for @luggageNameHint.
  ///
  /// In tr, this message translates to:
  /// **'Bavula bir ad ver (isteğe bağlı)'**
  String get luggageNameHint;

  /// No description provided for @luggageRegistrationNote.
  ///
  /// In tr, this message translates to:
  /// **'Kaydın ardından personeliniz QR sticker çıktısını alabilir. Müşteri bırakma ve teslimde kodu okutmalıdır.'**
  String get luggageRegistrationNote;

  /// No description provided for @luggageDelegateAction.
  ///
  /// In tr, this message translates to:
  /// **'Acil durum kişisine teslim et'**
  String get luggageDelegateAction;

  /// No description provided for @delegateInfoRequiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Acil durum kişisinin bilgilerini doldurun.'**
  String get delegateInfoRequiredMessage;

  /// No description provided for @howItWorksTitle.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl çalışır?'**
  String get howItWorksTitle;

  /// No description provided for @howItWorksIntro.
  ///
  /// In tr, this message translates to:
  /// **'KYRADI, “kurye yok” modelinde çalışan bir bavul bırakma ve teslim alma uygulamasıdır. Bavulunu seçtiğin otele/partner noktaya kendin götürür, güvenli şekilde bırakır ve geri alırken PIN ile doğrularsın. Süreç boyunca adım adım yönlendirilir ve net bilgilendirmeler alırsın.'**
  String get howItWorksIntro;

  /// No description provided for @howItWorksStep1Title.
  ///
  /// In tr, this message translates to:
  /// **'1) Lokasyon seçimi ve uygunluk kontrolü'**
  String get howItWorksStep1Title;

  /// No description provided for @howItWorksStep1Body.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama, harita ve liste üzerinden partner noktaları gösterir. Her lokasyonun çalışma saatleri, maksimum kapasitesi ve anlık doluluğu vardır. Lokasyon kapalı, dolu veya pasifse bavul ekleme ve/veya bırakma adımı engellenir. Bu sayede kapıda sürpriz yaşamazsın ve gerçekten hizmet alabileceğin noktayı seçersin.'**
  String get howItWorksStep1Body;

  /// No description provided for @howItWorksStep2Title.
  ///
  /// In tr, this message translates to:
  /// **'2) Bavul bilgileri, süre ve koruma seçimi'**
  String get howItWorksStep2Title;

  /// No description provided for @howItWorksStep2Body.
  ///
  /// In tr, this message translates to:
  /// **'Bavulunu eklerken boyutu (small/medium/large), bırakma ve teslim alma saatlerini belirlersin. Bu bilgiler fiyatı etkiler. Koruma seviyesi olarak “Standart koruma” (varsayılan) veya “Ek sigorta (premium)” seçebilirsin. Seçimini değiştirdikçe tahmini ücret güncellenir.'**
  String get howItWorksStep2Body;

  /// No description provided for @howItWorksStep3Title.
  ///
  /// In tr, this message translates to:
  /// **'3) Tahmini Ücret kartı nasıl çalışır?'**
  String get howItWorksStep3Title;

  /// No description provided for @howItWorksStep3Body.
  ///
  /// In tr, this message translates to:
  /// **'Uygulamadaki “Tahmini Ücret” kartı; boyut, süre, koruma ve ödeme yöntemine göre hesaplanır. Süre için 0–6 saat, 6–24 saat ve günlük tier kullanılır. Bu ücret bir ön bilgilendirmedir; gerçek teslim saatine göre değişebilir.'**
  String get howItWorksStep3Body;

  /// No description provided for @howItWorksStep4Title.
  ///
  /// In tr, this message translates to:
  /// **'4) Rezervasyon oluşturma'**
  String get howItWorksStep4Title;

  /// No description provided for @howItWorksStep4Body.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon oluşturabilir ve planını netleştirebilirsin. Ancak rezervasyon, “Bavulu Bırak” adımı tamamlanmadan hizmeti aktive etmez.'**
  String get howItWorksStep4Body;

  /// No description provided for @howItWorksStep5Title.
  ///
  /// In tr, this message translates to:
  /// **'5) Lokasyona gidip “Bavulu Bırak”'**
  String get howItWorksStep5Title;

  /// No description provided for @howItWorksStep5Body.
  ///
  /// In tr, this message translates to:
  /// **'“Bavulu Bırak” butonu, bırakma sürecini başlatan ana adımdır. Kurye yoktur; bavulu lokasyona sen götürürsün. QR doğrulaması ve ödeme tamamlanmadan bırakma işlemi tamamlanamaz. Önemli: Bavulu Bırak butonu ödemesiz asla tamamlanamaz.'**
  String get howItWorksStep5Body;

  /// No description provided for @howItWorksStep6Title.
  ///
  /// In tr, this message translates to:
  /// **'6) Ödeme ekranı ve 3 yöntem'**
  String get howItWorksStep6Title;

  /// No description provided for @howItWorksStep6Body.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme adımında üç seçenek vardır: (1) Otelde ödeme: ödeme otelde alınır, ek komisyon ücrete yansıyabilir. (2) Kredi/Banka kartı: MagicPay altyapısı ile güvenli ödeme yapılır. (3) Taksitli ödeme: vade farkı ücrete yansıyabilir.'**
  String get howItWorksStep6Body;

  /// No description provided for @howItWorksStep7Title.
  ///
  /// In tr, this message translates to:
  /// **'7) Ödeme başarılı/başarısız olursa ne olur?'**
  String get howItWorksStep7Title;

  /// No description provided for @howItWorksStep7Body.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme başarılı olursa bırakma tamamlanır ve PIN üretilir. Ödeme başarısız olursa uygulama net bir hata mesajı verir ve tekrar denemen için yönlendirir; bırakma tamamlanmaz.'**
  String get howItWorksStep7Body;

  /// No description provided for @howItWorksStep8Title.
  ///
  /// In tr, this message translates to:
  /// **'8) PIN ile teslim alma'**
  String get howItWorksStep8Title;

  /// No description provided for @howItWorksStep8Body.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma tamamlandığında teslim alma PIN’i oluşturulur. PIN ekranda gösterilir ve ayrıca e‑posta ile gönderilebilir. Mail gitmese bile süreç bozulmaz; PIN ile lokasyonda teslim alma doğrulanır.'**
  String get howItWorksStep8Body;

  /// No description provided for @howItWorksFaqTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sık Sorulan Sorular'**
  String get howItWorksFaqTitle;

  /// No description provided for @howItWorksFaq1Q.
  ///
  /// In tr, this message translates to:
  /// **'Neden ödeme bırakma anında?'**
  String get howItWorksFaq1Q;

  /// No description provided for @howItWorksFaq1A.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme, hizmetin aktifleştiği anı temsil eder ve kapasite/rezervasyon dengesini korur. Bu nedenle bırakma ödemesiz tamamlanamaz.'**
  String get howItWorksFaq1A;

  /// No description provided for @howItWorksFaq2Q.
  ///
  /// In tr, this message translates to:
  /// **'Tahmini ücret neden değişebilir?'**
  String get howItWorksFaq2Q;

  /// No description provided for @howItWorksFaq2A.
  ///
  /// In tr, this message translates to:
  /// **'Tahmin; boyut, süre ve teslim saatine göre hesaplanır. Gerçek bırakma/teslim saatleri değişirse ücret de değişebilir.'**
  String get howItWorksFaq2A;

  /// No description provided for @howItWorksFaq3Q.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon kapalıysa/doluysa ne yapmalıyım?'**
  String get howItWorksFaq3Q;

  /// No description provided for @howItWorksFaq3A.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama bunu açıkça gösterir. Farklı bir lokasyon seçebilir veya daha uygun bir saat için planlama yapabilirsin.'**
  String get howItWorksFaq3A;

  /// No description provided for @howItWorksFaq4Q.
  ///
  /// In tr, this message translates to:
  /// **'Otelde ödeme seçersem kart ekranı açılır mı?'**
  String get howItWorksFaq4Q;

  /// No description provided for @howItWorksFaq4A.
  ///
  /// In tr, this message translates to:
  /// **'Hayır. Otelde ödeme seçildiğinde kart ekranı açılmaz; ödeme otelde alınır. Ek komisyon ücrete yansıyabilir.'**
  String get howItWorksFaq4A;

  /// No description provided for @howItWorksFaq5Q.
  ///
  /// In tr, this message translates to:
  /// **'Taksit nasıl işler?'**
  String get howItWorksFaq5Q;

  /// No description provided for @howItWorksFaq5A.
  ///
  /// In tr, this message translates to:
  /// **'Kredi kartı ile ödeme sırasında taksit seçilir. Seçilen vade farkı ücrete yansıyabilir ve toplam tutar buna göre hesaplanır.'**
  String get howItWorksFaq5A;

  /// No description provided for @howItWorksFaq6Q.
  ///
  /// In tr, this message translates to:
  /// **'Premium koruma ne sağlar?'**
  String get howItWorksFaq6Q;

  /// No description provided for @howItWorksFaq6A.
  ///
  /// In tr, this message translates to:
  /// **'Standart korumaya ek güvence sunar. Ek sigorta seçildiğinde ücret biraz artabilir; detaylar “Tahmini Ücret” kartında görünür.'**
  String get howItWorksFaq6A;

  /// No description provided for @howItWorksFaq7Q.
  ///
  /// In tr, this message translates to:
  /// **'PIN’i kaybedersem ne olur?'**
  String get howItWorksFaq7Q;

  /// No description provided for @howItWorksFaq7A.
  ///
  /// In tr, this message translates to:
  /// **'PIN, e‑posta ile yeniden gönderilebilir. Gerekirse profil/rezervasyon detaylarından tekrar görebilirsin. Destek ekibi de yardımcı olur.'**
  String get howItWorksFaq7A;

  /// No description provided for @howItWorksFaq8Q.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme oldu ama uygulama güncellenmedi, ne yapmalıyım?'**
  String get howItWorksFaq8Q;

  /// No description provided for @howItWorksFaq8A.
  ///
  /// In tr, this message translates to:
  /// **'Bağlantını kontrol edip sayfayı yenile. Ödeme durumunu kontrol etmek için tekrar dene. Sorun sürerse destek ekibiyle iletişime geç.'**
  String get howItWorksFaq8A;

  /// No description provided for @pickupPinTitle.
  ///
  /// In tr, this message translates to:
  /// **'Teslim PIN'**
  String get pickupPinTitle;

  /// No description provided for @pickupPinLabel.
  ///
  /// In tr, this message translates to:
  /// **'Teslim PIN'**
  String get pickupPinLabel;

  /// No description provided for @pickupPinHint.
  ///
  /// In tr, this message translates to:
  /// **'4 haneli PIN'**
  String get pickupPinHint;

  /// No description provided for @pickupPinGenerated.
  ///
  /// In tr, this message translates to:
  /// **'Teslim PIN: {pin}'**
  String pickupPinGenerated(Object pin);

  /// No description provided for @pickupPinRequiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Teslim için PIN gerekli.'**
  String get pickupPinRequiredMessage;

  /// No description provided for @pickupPinInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'PIN hatalı. Tekrar dene.'**
  String get pickupPinInvalidMessage;

  /// No description provided for @delegateSetupTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili Kişi'**
  String get delegateSetupTitle;

  /// No description provided for @delegateNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get delegateNameLabel;

  /// No description provided for @delegatePhoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get delegatePhoneLabel;

  /// No description provided for @delegateEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get delegateEmailLabel;

  /// No description provided for @delegateCodeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili Kişi Kodu'**
  String get delegateCodeTitle;

  /// No description provided for @delegateCodeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili Kodu'**
  String get delegateCodeLabel;

  /// No description provided for @delegateCodeHint.
  ///
  /// In tr, this message translates to:
  /// **'6 haneli kod'**
  String get delegateCodeHint;

  /// No description provided for @delegateCodeGenerated.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili kodu: {code}'**
  String delegateCodeGenerated(Object code);

  /// No description provided for @delegateCodeRequiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili kodu gerekli.'**
  String get delegateCodeRequiredMessage;

  /// No description provided for @delegateCodeInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili kodu hatalı.'**
  String get delegateCodeInvalidMessage;

  /// No description provided for @delegateCodeExpiredMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili kodunun süresi dolmuş.'**
  String get delegateCodeExpiredMessage;

  /// No description provided for @delegateCodeUsedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili kodu daha önce kullanılmış.'**
  String get delegateCodeUsedMessage;

  /// No description provided for @delegateSavedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yetkili kişi kaydedildi.'**
  String get delegateSavedMessage;

  /// No description provided for @delegateEmergencyCodeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Acil Durum Kodu'**
  String get delegateEmergencyCodeTitle;

  /// No description provided for @ownerInfoTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sahip Bilgileri'**
  String get ownerInfoTitle;

  /// No description provided for @ownerNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad Soyad'**
  String get ownerNameLabel;

  /// No description provided for @ownerPhoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get ownerPhoneLabel;

  /// No description provided for @ownerEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get ownerEmailLabel;

  /// No description provided for @pickupPinSafetyWarning.
  ///
  /// In tr, this message translates to:
  /// **'PIN’inizi kaydedin ve kimseyle paylaşmayın. Teslim alma sırasında bu PIN istenecektir.'**
  String get pickupPinSafetyWarning;

  /// No description provided for @pickupPinCopiedMessage.
  ///
  /// In tr, this message translates to:
  /// **'PIN kopyalandı — PIN’inizi güvenli bir yerde saklayın.'**
  String get pickupPinCopiedMessage;

  /// No description provided for @copy.
  ///
  /// In tr, this message translates to:
  /// **'Kopyala'**
  String get copy;

  /// No description provided for @luggageCreateFailed.
  ///
  /// In tr, this message translates to:
  /// **'Bavul oluşturulamadı.'**
  String get luggageCreateFailed;

  /// No description provided for @savingInProgress.
  ///
  /// In tr, this message translates to:
  /// **'Kaydediliyor...'**
  String get savingInProgress;

  /// No description provided for @statusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Durum'**
  String get statusLabel;

  /// No description provided for @permissionNameCamera.
  ///
  /// In tr, this message translates to:
  /// **'Kamera'**
  String get permissionNameCamera;

  /// No description provided for @permissionNameLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get permissionNameLocation;

  /// No description provided for @permissionNameNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirim'**
  String get permissionNameNotifications;

  /// No description provided for @footerCopyright.
  ///
  /// In tr, this message translates to:
  /// **'@2025 aparial.com'**
  String get footerCopyright;

  /// No description provided for @green.
  ///
  /// In tr, this message translates to:
  /// **'Yeşil'**
  String get green;

  /// No description provided for @qrRegenerate.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Oluştur'**
  String get qrRegenerate;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In tr, this message translates to:
  /// **'Konum izni verilmedi.'**
  String get locationPermissionDenied;

  /// No description provided for @dropDatePickerHelp.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma tarihi'**
  String get dropDatePickerHelp;

  /// No description provided for @pickupDatePickerHelp.
  ///
  /// In tr, this message translates to:
  /// **'Teslim tarihi'**
  String get pickupDatePickerHelp;

  /// No description provided for @addLuggageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Oluştur'**
  String get addLuggageTitle;

  /// No description provided for @apiSettingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu Ayarları'**
  String get apiSettingsTitle;

  /// No description provided for @apiSettingsBaseUrlLabel.
  ///
  /// In tr, this message translates to:
  /// **'Taban URL'**
  String get apiSettingsBaseUrlLabel;

  /// No description provided for @apiSettingsActiveLabel.
  ///
  /// In tr, this message translates to:
  /// **'Aktif: {url}'**
  String apiSettingsActiveLabel(Object url);

  /// No description provided for @apiSettingsEnvLockedNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu değer uygulama derlenirken sabitlenmiş. Değişiklik yapmak için dart-define parametrelerini güncellemelisiniz.'**
  String get apiSettingsEnvLockedNote;

  /// No description provided for @apiSettingsDeviceNote.
  ///
  /// In tr, this message translates to:
  /// **'Not: Telefon veya fiziksel cihazdan test ederken bilgisayarınızın yerel IP adresini girin.'**
  String get apiSettingsDeviceNote;

  /// No description provided for @apiSettingsResetButton.
  ///
  /// In tr, this message translates to:
  /// **'Varsayılan'**
  String get apiSettingsResetButton;

  /// No description provided for @apiSettingsInvalidUrl.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen geçerli bir URL girin'**
  String get apiSettingsInvalidUrl;

  /// No description provided for @apiSettingsResetSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu adresi varsayılan ayara döndü.'**
  String get apiSettingsResetSuccess;

  /// No description provided for @apiSettingsUpdatedSuccess.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu adresi güncellendi.'**
  String get apiSettingsUpdatedSuccess;

  /// No description provided for @rememberMeLabel.
  ///
  /// In tr, this message translates to:
  /// **'Beni Hatırla'**
  String get rememberMeLabel;

  /// No description provided for @qrShowAction.
  ///
  /// In tr, this message translates to:
  /// **'QR Göster'**
  String get qrShowAction;

  /// No description provided for @qrScanAction.
  ///
  /// In tr, this message translates to:
  /// **'QR Okut'**
  String get qrScanAction;

  /// No description provided for @detailsAction.
  ///
  /// In tr, this message translates to:
  /// **'Detay'**
  String get detailsAction;

  /// No description provided for @supportAction.
  ///
  /// In tr, this message translates to:
  /// **'Destek'**
  String get supportAction;

  /// No description provided for @luggageStatusAwaitingDrop.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Bekliyor'**
  String get luggageStatusAwaitingDrop;

  /// No description provided for @luggageStatusDropped.
  ///
  /// In tr, this message translates to:
  /// **'Depoda'**
  String get luggageStatusDropped;

  /// No description provided for @luggageStatusPickedUp.
  ///
  /// In tr, this message translates to:
  /// **'Teslim Alındı'**
  String get luggageStatusPickedUp;

  /// No description provided for @luggageStatusCancelled.
  ///
  /// In tr, this message translates to:
  /// **'İptal Edildi'**
  String get luggageStatusCancelled;

  /// No description provided for @paymentStatusPaid.
  ///
  /// In tr, this message translates to:
  /// **'Ödendi'**
  String get paymentStatusPaid;

  /// No description provided for @paymentStatusPending.
  ///
  /// In tr, this message translates to:
  /// **'Beklemede'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusFailed.
  ///
  /// In tr, this message translates to:
  /// **'Başarısız'**
  String get paymentStatusFailed;

  /// No description provided for @paymentStatusUnpaid.
  ///
  /// In tr, this message translates to:
  /// **'Ödenmedi'**
  String get paymentStatusUnpaid;

  /// No description provided for @luggageTimelineCreated.
  ///
  /// In tr, this message translates to:
  /// **'Oluşturuldu'**
  String get luggageTimelineCreated;

  /// No description provided for @luggageTimelineScheduledDrop.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan bırakma'**
  String get luggageTimelineScheduledDrop;

  /// No description provided for @luggageTimelineDropped.
  ///
  /// In tr, this message translates to:
  /// **'Bırakıldı'**
  String get luggageTimelineDropped;

  /// No description provided for @luggageTimelineScheduledPickup.
  ///
  /// In tr, this message translates to:
  /// **'Planlanan teslim alma'**
  String get luggageTimelineScheduledPickup;

  /// No description provided for @luggageTimelinePickedUp.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alındı'**
  String get luggageTimelinePickedUp;

  /// No description provided for @luggageTimelineLastUpdate.
  ///
  /// In tr, this message translates to:
  /// **'Son güncelleme'**
  String get luggageTimelineLastUpdate;

  /// No description provided for @luggageTimelineScheduled.
  ///
  /// In tr, this message translates to:
  /// **'Planlandı'**
  String get luggageTimelineScheduled;

  /// No description provided for @activeTripTitle.
  ///
  /// In tr, this message translates to:
  /// **'Aktif yolculuk'**
  String get activeTripTitle;

  /// No description provided for @seeAllAction.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü gör'**
  String get seeAllAction;

  /// No description provided for @campaignsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kampanyalar'**
  String get campaignsTitle;

  /// No description provided for @campaignsEmptyState.
  ///
  /// In tr, this message translates to:
  /// **'Şu an kampanya yok.'**
  String get campaignsEmptyState;

  /// No description provided for @campaignsComingSoon.
  ///
  /// In tr, this message translates to:
  /// **'Kampanyalar yakında.'**
  String get campaignsComingSoon;

  /// No description provided for @campaignCityWelcomeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Şehre Hoş Geldin'**
  String get campaignCityWelcomeTitle;

  /// No description provided for @campaignCityWelcomeSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'İlk rezervasyonda %10 geri kazan.'**
  String get campaignCityWelcomeSubtitle;

  /// No description provided for @campaignWeekendTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hafta Sonu Depolama'**
  String get campaignWeekendTitle;

  /// No description provided for @campaignWeekendSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu bırakmalarında tasarruf et.'**
  String get campaignWeekendSubtitle;

  /// No description provided for @campaignAirportTitle.
  ///
  /// In tr, this message translates to:
  /// **'Havalimanı Bırakma'**
  String get campaignAirportTitle;

  /// No description provided for @campaignAirportSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Havalimanı noktalarında ekstra puan.'**
  String get campaignAirportSubtitle;

  /// No description provided for @campaignNewTag.
  ///
  /// In tr, this message translates to:
  /// **'YENİ'**
  String get campaignNewTag;

  /// No description provided for @campaignHotTag.
  ///
  /// In tr, this message translates to:
  /// **'POPÜLER'**
  String get campaignHotTag;

  /// No description provided for @campaignBonusTag.
  ///
  /// In tr, this message translates to:
  /// **'BONUS'**
  String get campaignBonusTag;

  /// No description provided for @profileVerifiedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulandı'**
  String get profileVerifiedLabel;

  /// No description provided for @profileEditTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil Düzenle'**
  String get profileEditTitle;

  /// No description provided for @profileSaveAction.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get profileSaveAction;

  /// No description provided for @profilePhotoSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil fotoğrafı'**
  String get profilePhotoSectionTitle;

  /// No description provided for @profilePhotoSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Profilini kişiselleştir ve güven ver.'**
  String get profilePhotoSectionSubtitle;

  /// No description provided for @profilePhotoUploadTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf yükle'**
  String get profilePhotoUploadTitle;

  /// No description provided for @profilePhotoUploadHint.
  ///
  /// In tr, this message translates to:
  /// **'PNG veya JPG, net bir yüz fotoğrafı önerilir.'**
  String get profilePhotoUploadHint;

  /// No description provided for @profilePhotoSelectAction.
  ///
  /// In tr, this message translates to:
  /// **'Fotoğraf Seç'**
  String get profilePhotoSelectAction;

  /// No description provided for @profilePersonalSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kişisel bilgiler'**
  String get profilePersonalSectionTitle;

  /// No description provided for @profilePersonalSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ad-soyad ve kimlik bilgilerini güncelle.'**
  String get profilePersonalSectionSubtitle;

  /// No description provided for @profileFirstNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ad'**
  String get profileFirstNameLabel;

  /// No description provided for @profileLastNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Soyad'**
  String get profileLastNameLabel;

  /// No description provided for @profileBirthDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Doğum Tarihi'**
  String get profileBirthDateLabel;

  /// No description provided for @profileNationalIdLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kimlik No'**
  String get profileNationalIdLabel;

  /// No description provided for @profileContactSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'İletişim'**
  String get profileContactSectionTitle;

  /// No description provided for @profileContactSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Telefon ve adres bilgilerini güncelle.'**
  String get profileContactSectionSubtitle;

  /// No description provided for @profilePhoneLabel.
  ///
  /// In tr, this message translates to:
  /// **'Telefon'**
  String get profilePhoneLabel;

  /// No description provided for @profileAddressLabel.
  ///
  /// In tr, this message translates to:
  /// **'Adres'**
  String get profileAddressLabel;

  /// No description provided for @profileSavedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Profil güncellendi.'**
  String get profileSavedMessage;

  /// No description provided for @profileSaveFailed.
  ///
  /// In tr, this message translates to:
  /// **'Profil güncellenemedi.'**
  String get profileSaveFailed;

  /// No description provided for @profileSaveFailedWithDetails.
  ///
  /// In tr, this message translates to:
  /// **'Profil güncellenemedi: {details}'**
  String profileSaveFailedWithDetails(Object details);

  /// No description provided for @settingsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settingsTitle;

  /// No description provided for @settingsInAppNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama içi bildirimler'**
  String get settingsInAppNotifications;

  /// No description provided for @settingsEmailReminders.
  ///
  /// In tr, this message translates to:
  /// **'E-posta hatırlatmaları'**
  String get settingsEmailReminders;

  /// No description provided for @settingsLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingsLanguage;

  /// No description provided for @settingsTheme.
  ///
  /// In tr, this message translates to:
  /// **'Tema'**
  String get settingsTheme;

  /// No description provided for @settingsThemeLight.
  ///
  /// In tr, this message translates to:
  /// **'Açık'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In tr, this message translates to:
  /// **'Koyu'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In tr, this message translates to:
  /// **'Sistem'**
  String get settingsThemeSystem;

  /// No description provided for @profileDetailsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Profil Bilgileri'**
  String get profileDetailsTitle;

  /// No description provided for @profileDetailsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hesap ve iletişim bilgilerin'**
  String get profileDetailsSubtitle;

  /// No description provided for @profileEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get profileEmailLabel;

  /// No description provided for @profileGenderLabel.
  ///
  /// In tr, this message translates to:
  /// **'Cinsiyet'**
  String get profileGenderLabel;

  /// No description provided for @profileGenderFemale.
  ///
  /// In tr, this message translates to:
  /// **'Kadın'**
  String get profileGenderFemale;

  /// No description provided for @profileGenderMale.
  ///
  /// In tr, this message translates to:
  /// **'Erkek'**
  String get profileGenderMale;

  /// No description provided for @profileGenderUnspecified.
  ///
  /// In tr, this message translates to:
  /// **'Belirtilmedi'**
  String get profileGenderUnspecified;

  /// No description provided for @profileVerificationStatus.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama Durumu'**
  String get profileVerificationStatus;

  /// No description provided for @profileVerificationPending.
  ///
  /// In tr, this message translates to:
  /// **'İnceleme Bekliyor'**
  String get profileVerificationPending;

  /// No description provided for @profileVerificationMissing.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulanmadı'**
  String get profileVerificationMissing;

  /// No description provided for @walletTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdan'**
  String get walletTitle;

  /// No description provided for @walletHeaderTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback'**
  String get walletHeaderTitle;

  /// No description provided for @walletHeaderSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Seyahat ettikçe ödül kazan.'**
  String get walletHeaderSubtitle;

  /// No description provided for @walletCashbackTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback'**
  String get walletCashbackTitle;

  /// No description provided for @walletCashbackTotalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Cashback'**
  String get walletCashbackTotalLabel;

  /// No description provided for @walletCardsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kartlarım'**
  String get walletCardsTitle;

  /// No description provided for @walletAddCardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart Ekle'**
  String get walletAddCardTitle;

  /// No description provided for @walletAddCardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı ödeme için kart bilgilerini kaydet.'**
  String get walletAddCardSubtitle;

  /// No description provided for @walletCardNumberLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kart Numarası'**
  String get walletCardNumberLabel;

  /// No description provided for @walletCardNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kart Üzerindeki İsim'**
  String get walletCardNameLabel;

  /// No description provided for @walletCardExpiryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Son Kullanma'**
  String get walletCardExpiryLabel;

  /// No description provided for @walletCardCvvLabel.
  ///
  /// In tr, this message translates to:
  /// **'CVV'**
  String get walletCardCvvLabel;

  /// No description provided for @walletAddCardAction.
  ///
  /// In tr, this message translates to:
  /// **'Kartı Kaydet'**
  String get walletAddCardAction;

  /// No description provided for @walletCardsEmptyTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart bulunamadı'**
  String get walletCardsEmptyTitle;

  /// No description provided for @walletCardsEmptySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli kartlarını buraya ekleyebilirsin.'**
  String get walletCardsEmptySubtitle;

  /// No description provided for @walletTabTopUps.
  ///
  /// In tr, this message translates to:
  /// **'Yüklemeler'**
  String get walletTabTopUps;

  /// No description provided for @walletTabSpends.
  ///
  /// In tr, this message translates to:
  /// **'Harcamalar'**
  String get walletTabSpends;

  /// No description provided for @walletTabCashback.
  ///
  /// In tr, this message translates to:
  /// **'Cashback'**
  String get walletTabCashback;

  /// No description provided for @walletFilterDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tarih Aralığı'**
  String get walletFilterDateLabel;

  /// No description provided for @walletFilterLast7.
  ///
  /// In tr, this message translates to:
  /// **'Son 7 gün'**
  String get walletFilterLast7;

  /// No description provided for @walletFilterLast30.
  ///
  /// In tr, this message translates to:
  /// **'Son 30 gün'**
  String get walletFilterLast30;

  /// No description provided for @walletFilterLast90.
  ///
  /// In tr, this message translates to:
  /// **'Son 90 gün'**
  String get walletFilterLast90;

  /// No description provided for @walletRulesAction.
  ///
  /// In tr, this message translates to:
  /// **'Kurallar'**
  String get walletRulesAction;

  /// No description provided for @walletBalanceLabel.
  ///
  /// In tr, this message translates to:
  /// **'Cashback bakiyesi'**
  String get walletBalanceLabel;

  /// No description provided for @walletMonthlyEarnedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Bu ay +{amount} ₺'**
  String walletMonthlyEarnedLabel(Object amount);

  /// No description provided for @walletUseCashbackAction.
  ///
  /// In tr, this message translates to:
  /// **'Cashback kullan'**
  String get walletUseCashbackAction;

  /// No description provided for @walletCouponsAction.
  ///
  /// In tr, this message translates to:
  /// **'Kuponlar'**
  String get walletCouponsAction;

  /// No description provided for @walletInviteAction.
  ///
  /// In tr, this message translates to:
  /// **'Davet et'**
  String get walletInviteAction;

  /// No description provided for @couponSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kupon kodu'**
  String get couponSectionTitle;

  /// No description provided for @couponSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Avantaj veya indirim için kod uygula.'**
  String get couponSectionSubtitle;

  /// No description provided for @couponInputLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kupon kodu'**
  String get couponInputLabel;

  /// No description provided for @couponApplyAction.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get couponApplyAction;

  /// No description provided for @couponAppliedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kupon uygulandı.'**
  String get couponAppliedMessage;

  /// No description provided for @couponInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kupon geçersiz.'**
  String get couponInvalidMessage;

  /// No description provided for @couponFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kupon uygulanamadı.'**
  String get couponFailedMessage;

  /// No description provided for @topUpSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Para yükle'**
  String get topUpSectionTitle;

  /// No description provided for @topUpSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdanına güvenle para ekle.'**
  String get topUpSectionSubtitle;

  /// No description provided for @topUpMethodTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme yöntemi seç'**
  String get topUpMethodTitle;

  /// No description provided for @topUpMethodSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı kartla devam et veya yeni kart ekle.'**
  String get topUpMethodSubtitle;

  /// No description provided for @topUpUseSavedCardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı kart kullan'**
  String get topUpUseSavedCardTitle;

  /// No description provided for @topUpUseSavedCardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı kredi/banka kartlarından seç.'**
  String get topUpUseSavedCardSubtitle;

  /// No description provided for @topUpUseNewCardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kart kullan'**
  String get topUpUseNewCardTitle;

  /// No description provided for @topUpUseNewCardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kredi ya da banka kartıyla öde.'**
  String get topUpUseNewCardSubtitle;

  /// No description provided for @topUpAmountTitle.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme tutarı'**
  String get topUpAmountTitle;

  /// No description provided for @topUpAmountSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Tutarı seç veya manuel gir.'**
  String get topUpAmountSubtitle;

  /// No description provided for @topUpAmountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme tutarı (₺)'**
  String get topUpAmountLabel;

  /// No description provided for @topUpSelectCardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart seç'**
  String get topUpSelectCardTitle;

  /// No description provided for @topUpSelectCardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ücretlendirmek istediğin kartı seç.'**
  String get topUpSelectCardSubtitle;

  /// No description provided for @topUpSelectCardMessage.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen kayıtlı bir kart seçin.'**
  String get topUpSelectCardMessage;

  /// No description provided for @topUpCardDetailsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart bilgileri'**
  String get topUpCardDetailsTitle;

  /// No description provided for @topUpCardDetailsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart bilgilerini güvenle gir.'**
  String get topUpCardDetailsSubtitle;

  /// No description provided for @cardNumberLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kart numarası'**
  String get cardNumberLabel;

  /// No description provided for @cardHolderNameLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kart sahibi'**
  String get cardHolderNameLabel;

  /// No description provided for @cardExpiryLabel.
  ///
  /// In tr, this message translates to:
  /// **'Son kullanma (AA/YY)'**
  String get cardExpiryLabel;

  /// No description provided for @cardCvvLabel.
  ///
  /// In tr, this message translates to:
  /// **'CVV'**
  String get cardCvvLabel;

  /// No description provided for @topUpPayAction.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Yap'**
  String get topUpPayAction;

  /// No description provided for @topUpConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Onayı'**
  String get topUpConfirmTitle;

  /// No description provided for @topUpConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'{amount} ₺ yüklemek istediğine emin misin? Kart: {card}'**
  String topUpConfirmMessage(Object amount, Object card);

  /// No description provided for @topUpProcessingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme İşleniyor'**
  String get topUpProcessingTitle;

  /// No description provided for @topUpProcessingSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Güvenli ödeme için doğrulama yapılıyor.'**
  String get topUpProcessingSubtitle;

  /// No description provided for @topUpInvalidAmountMessage.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli bir tutar gir.'**
  String get topUpInvalidAmountMessage;

  /// No description provided for @topUpInvalidCardMessage.
  ///
  /// In tr, this message translates to:
  /// **'Geçerli kart bilgisi gir.'**
  String get topUpInvalidCardMessage;

  /// No description provided for @topUpSuccessMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme başarılı.'**
  String get topUpSuccessMessage;

  /// No description provided for @topUpFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme başarısız. Tekrar dene.'**
  String get topUpFailedMessage;

  /// No description provided for @topUpTransactionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdan yükleme'**
  String get topUpTransactionTitle;

  /// No description provided for @topUpTransactionTitleWithMethod.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdan yükleme ({method})'**
  String topUpTransactionTitleWithMethod(Object method);

  /// No description provided for @topUpTransactionCategory.
  ///
  /// In tr, this message translates to:
  /// **'Yükleme'**
  String get topUpTransactionCategory;

  /// No description provided for @walletSelectCardTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kart seç'**
  String get walletSelectCardTitle;

  /// No description provided for @selectedLabel.
  ///
  /// In tr, this message translates to:
  /// **'Seçildi'**
  String get selectedLabel;

  /// No description provided for @transferSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Transfer'**
  String get transferSectionTitle;

  /// No description provided for @walletActionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hızlı işlemler'**
  String get walletActionsTitle;

  /// No description provided for @walletActionsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kupon, para yükleme ve transfer adımlarını aç.'**
  String get walletActionsSubtitle;

  /// No description provided for @transferSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Başka kullanıcıya para gönder.'**
  String get transferSectionSubtitle;

  /// No description provided for @transferTargetLabel.
  ///
  /// In tr, this message translates to:
  /// **'Alıcı (telefon/e-posta/ID)'**
  String get transferTargetLabel;

  /// No description provided for @transferAmountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get transferAmountLabel;

  /// No description provided for @transferNoteLabel.
  ///
  /// In tr, this message translates to:
  /// **'Not (opsiyonel)'**
  String get transferNoteLabel;

  /// No description provided for @transferAction.
  ///
  /// In tr, this message translates to:
  /// **'Transfer Et'**
  String get transferAction;

  /// No description provided for @transferInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Alıcı ve tutar girin.'**
  String get transferInvalidMessage;

  /// No description provided for @transferInsufficientBalanceMessage.
  ///
  /// In tr, this message translates to:
  /// **'Yetersiz bakiye.'**
  String get transferInsufficientBalanceMessage;

  /// No description provided for @transferConfirmTitle.
  ///
  /// In tr, this message translates to:
  /// **'Transferi onayla'**
  String get transferConfirmTitle;

  /// No description provided for @transferConfirmMessage.
  ///
  /// In tr, this message translates to:
  /// **'{target} kişisine {amount} ₺ gönderilsin mi?'**
  String transferConfirmMessage(Object target, Object amount);

  /// No description provided for @transferSuccessMessage.
  ///
  /// In tr, this message translates to:
  /// **'Transfer başarılı.'**
  String get transferSuccessMessage;

  /// No description provided for @transferFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Transfer başarısız.'**
  String get transferFailedMessage;

  /// No description provided for @transferTransactionTitle.
  ///
  /// In tr, this message translates to:
  /// **'{target} kişisine transfer'**
  String transferTransactionTitle(Object target);

  /// No description provided for @transferTransactionCategory.
  ///
  /// In tr, this message translates to:
  /// **'Transfer'**
  String get transferTransactionCategory;

  /// No description provided for @walletMissionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Görevler'**
  String get walletMissionsTitle;

  /// No description provided for @walletTransactionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'İşlemler'**
  String get walletTransactionsTitle;

  /// No description provided for @walletEmptyTransactionsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Henüz işlem yok'**
  String get walletEmptyTransactionsTitle;

  /// No description provided for @walletEmptyTransactionsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Cashback hareketlerin burada görünecek.'**
  String get walletEmptyTransactionsSubtitle;

  /// No description provided for @walletMockLocationTitle.
  ///
  /// In tr, this message translates to:
  /// **'Taksim KYRADI'**
  String get walletMockLocationTitle;

  /// No description provided for @walletMockPaymentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon ödemesi'**
  String get walletMockPaymentTitle;

  /// No description provided for @walletMockCampaignTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu kampanyası'**
  String get walletMockCampaignTitle;

  /// No description provided for @walletMockAdjustmentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Manuel düzeltme'**
  String get walletMockAdjustmentTitle;

  /// No description provided for @walletTransactionCategoryCashback.
  ///
  /// In tr, this message translates to:
  /// **'Cashback'**
  String get walletTransactionCategoryCashback;

  /// No description provided for @walletTransactionCategoryUsage.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım'**
  String get walletTransactionCategoryUsage;

  /// No description provided for @walletTransactionCategoryCampaign.
  ///
  /// In tr, this message translates to:
  /// **'Kampanya'**
  String get walletTransactionCategoryCampaign;

  /// No description provided for @walletTransactionCategoryAdjustment.
  ///
  /// In tr, this message translates to:
  /// **'Düzeltme'**
  String get walletTransactionCategoryAdjustment;

  /// No description provided for @walletMissionExploreTitle.
  ///
  /// In tr, this message translates to:
  /// **'3 lokasyon keşfet'**
  String get walletMissionExploreTitle;

  /// No description provided for @walletMissionExploreSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'3 partner lokasyonu ziyaret et veya rezervasyon yap.'**
  String get walletMissionExploreSubtitle;

  /// No description provided for @walletMissionWeekendTitle.
  ///
  /// In tr, this message translates to:
  /// **'Hafta sonu gezgini'**
  String get walletMissionWeekendTitle;

  /// No description provided for @walletMissionWeekendSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'2 hafta sonu rezervasyonu tamamla.'**
  String get walletMissionWeekendSubtitle;

  /// No description provided for @walletMissionInviteTitle.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaş daveti'**
  String get walletMissionInviteTitle;

  /// No description provided for @walletMissionInviteSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'3 arkadaş davet ederek ödül kazan.'**
  String get walletMissionInviteSubtitle;

  /// No description provided for @supportSoonMessage.
  ///
  /// In tr, this message translates to:
  /// **'Destek yakında.'**
  String get supportSoonMessage;

  /// No description provided for @supportChatTitle.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi Destek'**
  String get supportChatTitle;

  /// No description provided for @supportChatGreeting.
  ///
  /// In tr, this message translates to:
  /// **'Merhaba! Kyradi Sanal Destek\'e hoş geldin. Nasıl yardımcı olabilirim?'**
  String get supportChatGreeting;

  /// No description provided for @supportChatHint.
  ///
  /// In tr, this message translates to:
  /// **'Mesajınızı yazın...'**
  String get supportChatHint;

  /// No description provided for @supportChatTyping.
  ///
  /// In tr, this message translates to:
  /// **'Yazıyor...'**
  String get supportChatTyping;

  /// No description provided for @supportChatFallback.
  ///
  /// In tr, this message translates to:
  /// **'Şu anda tam anlayamadım. Lütfen biraz daha detay verebilir misiniz?'**
  String get supportChatFallback;

  /// No description provided for @supportChatHelpCancel.
  ///
  /// In tr, this message translates to:
  /// **'Bavul iptali için: Bavullarım > Detay > İptal Et adımını kullanabilirsiniz.'**
  String get supportChatHelpCancel;

  /// No description provided for @supportChatHelpPayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme konusunda hata alırsanız kart hareketleri ve hata mesajını paylaşın, yardımcı olalım.'**
  String get supportChatHelpPayment;

  /// No description provided for @supportChatHelpReservation.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon için uygun lokasyon ve tarih seçerek devam edebilirsiniz.'**
  String get supportChatHelpReservation;

  /// No description provided for @supportChatHelpPickup.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alma saati yaklaşınca hatırlatma alırsın. Gecikme varsa destekten bildir.'**
  String get supportChatHelpPickup;

  /// No description provided for @supportChatHelpLocation.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyonların doluluk bilgisini Keşfet ekranında görebilirsiniz.'**
  String get supportChatHelpLocation;

  /// No description provided for @supportChatHelpWallet.
  ///
  /// In tr, this message translates to:
  /// **'Cüzdana para yüklemek için Cüzdan > Para Yükle adımını kullanabilirsiniz.'**
  String get supportChatHelpWallet;

  /// No description provided for @qrScanSoonMessage.
  ///
  /// In tr, this message translates to:
  /// **'QR tarama yakında.'**
  String get qrScanSoonMessage;

  /// No description provided for @stepBagInfoTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Bilgileri'**
  String get stepBagInfoTitle;

  /// No description provided for @stepScheduleTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon & Zaman'**
  String get stepScheduleTitle;

  /// No description provided for @stepPricingTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ücret & Opsiyonlar'**
  String get stepPricingTitle;

  /// No description provided for @stepPaymentTitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme'**
  String get stepPaymentTitle;

  /// No description provided for @stepSuccessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get stepSuccessTitle;

  /// No description provided for @continueAction.
  ///
  /// In tr, this message translates to:
  /// **'Devam Et'**
  String get continueAction;

  /// No description provided for @pricingDurationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Süre'**
  String get pricingDurationLabel;

  /// No description provided for @pricingDurationValue.
  ///
  /// In tr, this message translates to:
  /// **'{hours} saat ({days} gün)'**
  String pricingDurationValue(Object hours, Object days);

  /// No description provided for @pricingHourlyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Saatlik hesap'**
  String get pricingHourlyLabel;

  /// No description provided for @pricingHourlyValue.
  ///
  /// In tr, this message translates to:
  /// **'{amount} ₺'**
  String pricingHourlyValue(Object amount);

  /// No description provided for @pricingDailyLabel.
  ///
  /// In tr, this message translates to:
  /// **'Günlük hesap'**
  String get pricingDailyLabel;

  /// No description provided for @pricingDailyValue.
  ///
  /// In tr, this message translates to:
  /// **'{amount} ₺'**
  String pricingDailyValue(Object amount);

  /// No description provided for @pricingBestPriceLabel.
  ///
  /// In tr, this message translates to:
  /// **'En iyi fiyat'**
  String get pricingBestPriceLabel;

  /// No description provided for @pricingBestValue.
  ///
  /// In tr, this message translates to:
  /// **'{amount} ₺'**
  String pricingBestValue(Object amount);

  /// No description provided for @insuranceOptionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Sigorta paketi'**
  String get insuranceOptionTitle;

  /// No description provided for @insuranceOptionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Opsiyonel koruma (+99 ₺)'**
  String get insuranceOptionSubtitle;

  /// No description provided for @paymentMethodTransfer.
  ///
  /// In tr, this message translates to:
  /// **'Havale / EFT'**
  String get paymentMethodTransfer;

  /// No description provided for @paymentTransferNote.
  ///
  /// In tr, this message translates to:
  /// **'Dekont yükleyerek ödeme tamamlanır.'**
  String get paymentTransferNote;

  /// No description provided for @paymentHotelFeeNote.
  ///
  /// In tr, this message translates to:
  /// **'Otelde ödeme seçilirse +%10 hizmet bedeli eklenir.'**
  String get paymentHotelFeeNote;

  /// No description provided for @reservationSuccessTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon oluşturuldu'**
  String get reservationSuccessTitle;

  /// No description provided for @reservationSuccessSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavulunuz için rezervasyon oluşturduk. Detayları Bavullarım’da görebilirsiniz.'**
  String get reservationSuccessSubtitle;

  /// No description provided for @reservationSuccessGoLuggages.
  ///
  /// In tr, this message translates to:
  /// **'Bavullarım’a git'**
  String get reservationSuccessGoLuggages;

  /// No description provided for @reservationSuccessViewDetails.
  ///
  /// In tr, this message translates to:
  /// **'Detayları gör'**
  String get reservationSuccessViewDetails;

  /// No description provided for @reservationSuccessClose.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get reservationSuccessClose;

  /// No description provided for @dropTimeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bırakma zamanı'**
  String get dropTimeTitle;

  /// No description provided for @pickupTimeTitle.
  ///
  /// In tr, this message translates to:
  /// **'Teslim alma zamanı'**
  String get pickupTimeTitle;

  /// No description provided for @dropTimePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Tarih ve saat seçin'**
  String get dropTimePlaceholder;

  /// No description provided for @pickupTimePlaceholder.
  ///
  /// In tr, this message translates to:
  /// **'Tarih ve saat seçin'**
  String get pickupTimePlaceholder;

  /// No description provided for @paymentMethodWalletShort.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi Cüzdan'**
  String get paymentMethodWalletShort;

  /// No description provided for @invoiceSectionTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fatura'**
  String get invoiceSectionTitle;

  /// No description provided for @invoiceSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme özeti ve e-fatura görüntüle.'**
  String get invoiceSectionSubtitle;

  /// No description provided for @invoiceShowAction.
  ///
  /// In tr, this message translates to:
  /// **'Faturayı Göster'**
  String get invoiceShowAction;

  /// No description provided for @invoiceTitle.
  ///
  /// In tr, this message translates to:
  /// **'E-Fatura'**
  String get invoiceTitle;

  /// No description provided for @invoiceNumberLabel.
  ///
  /// In tr, this message translates to:
  /// **'Fatura No'**
  String get invoiceNumberLabel;

  /// No description provided for @invoiceDateLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tarih'**
  String get invoiceDateLabel;

  /// No description provided for @invoiceCustomerLabel.
  ///
  /// In tr, this message translates to:
  /// **'Müşteri'**
  String get invoiceCustomerLabel;

  /// No description provided for @invoiceCustomerFallback.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi Misafiri'**
  String get invoiceCustomerFallback;

  /// No description provided for @invoiceEmailLabel.
  ///
  /// In tr, this message translates to:
  /// **'E-posta'**
  String get invoiceEmailLabel;

  /// No description provided for @invoiceLocationLabel.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon'**
  String get invoiceLocationLabel;

  /// No description provided for @invoiceItemLabel.
  ///
  /// In tr, this message translates to:
  /// **'Hizmet'**
  String get invoiceItemLabel;

  /// No description provided for @invoiceItemTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul Rezervasyonu'**
  String get invoiceItemTitle;

  /// No description provided for @invoiceItemDesc.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get invoiceItemDesc;

  /// No description provided for @invoiceItemSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kyradi teslim-atma ve saklama hizmeti'**
  String get invoiceItemSubtitle;

  /// No description provided for @invoicePaymentMethodLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Yöntemi'**
  String get invoicePaymentMethodLabel;

  /// No description provided for @invoicePaymentStatusLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme Durumu'**
  String get invoicePaymentStatusLabel;

  /// No description provided for @invoiceAmountLabel.
  ///
  /// In tr, this message translates to:
  /// **'Tutar'**
  String get invoiceAmountLabel;

  /// No description provided for @invoiceVatLabel.
  ///
  /// In tr, this message translates to:
  /// **'KDV'**
  String get invoiceVatLabel;

  /// No description provided for @invoiceVatValue.
  ///
  /// In tr, this message translates to:
  /// **'Dahil'**
  String get invoiceVatValue;

  /// No description provided for @invoiceTotalLabel.
  ///
  /// In tr, this message translates to:
  /// **'Genel Toplam'**
  String get invoiceTotalLabel;

  /// No description provided for @invoiceFooterNote.
  ///
  /// In tr, this message translates to:
  /// **'Bu e-fatura Kyradi tarafından dijital olarak oluşturulmuştur.'**
  String get invoiceFooterNote;

  /// No description provided for @luggageInfoSectionSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Bavul bilgileri ve planlanan zamanlar.'**
  String get luggageInfoSectionSubtitle;

  /// No description provided for @closeAction.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get closeAction;

  /// No description provided for @reservationInfoTitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon Bilgileri'**
  String get reservationInfoTitle;

  /// No description provided for @reservationInfoSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Rezervasyon süreci ve ödeme bilgileri.'**
  String get reservationInfoSubtitle;

  /// No description provided for @luggageTimelinePayment.
  ///
  /// In tr, this message translates to:
  /// **'Ödeme'**
  String get luggageTimelinePayment;

  /// No description provided for @luggageTimelineTimeUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Zaman bilgisi yok'**
  String get luggageTimelineTimeUnknown;

  /// No description provided for @invoiceDownloadAction.
  ///
  /// In tr, this message translates to:
  /// **'Faturayı İndir'**
  String get invoiceDownloadAction;

  /// No description provided for @invoiceSavedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Fatura kaydedildi: {file}'**
  String invoiceSavedMessage(Object file);

  /// No description provided for @invoiceSaveFailedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Fatura kaydedilemedi.'**
  String get invoiceSaveFailedMessage;

  /// No description provided for @pricingRecalculateAction.
  ///
  /// In tr, this message translates to:
  /// **'Yeniden Hesapla'**
  String get pricingRecalculateAction;

  /// No description provided for @locationDetailsTitle.
  ///
  /// In tr, this message translates to:
  /// **'Lokasyon Bilgileri'**
  String get locationDetailsTitle;

  /// No description provided for @locationDetailsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Doluluk, açık/kapalı ve kapasite bilgileri.'**
  String get locationDetailsSubtitle;

  /// No description provided for @directionsAction.
  ///
  /// In tr, this message translates to:
  /// **'Yol Tarifi Al'**
  String get directionsAction;

  /// No description provided for @directionsSheetTitle.
  ///
  /// In tr, this message translates to:
  /// **'Harita uygulaması seçin'**
  String get directionsSheetTitle;

  /// No description provided for @directionsSheetSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Konum için yönlendirme açılacak.'**
  String get directionsSheetSubtitle;

  /// No description provided for @directionsGoogleMaps.
  ///
  /// In tr, this message translates to:
  /// **'Google Maps ile aç'**
  String get directionsGoogleMaps;

  /// No description provided for @directionsAppleMaps.
  ///
  /// In tr, this message translates to:
  /// **'Apple Haritalar ile aç'**
  String get directionsAppleMaps;

  /// No description provided for @directionsPreviewTitle.
  ///
  /// In tr, this message translates to:
  /// **'Konumu haritada görüntüle'**
  String get directionsPreviewTitle;

  /// No description provided for @walletCreditCardLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kredi Kartı'**
  String get walletCreditCardLabel;

  /// No description provided for @walletDebitCardLabel.
  ///
  /// In tr, this message translates to:
  /// **'Banka Kartı'**
  String get walletDebitCardLabel;

  /// No description provided for @walletCreditCardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Kredi kartlarını görüntüle ve yönet.'**
  String get walletCreditCardSubtitle;

  /// No description provided for @walletDebitCardSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Banka kartlarını görüntüle ve yönet.'**
  String get walletDebitCardSubtitle;

  /// No description provided for @walletCardSavedMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kart kaydedildi.'**
  String get walletCardSavedMessage;

  /// No description provided for @walletCardInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Kart bilgilerini eksiksiz girin.'**
  String get walletCardInvalidMessage;

  /// No description provided for @walletCardExpiryInvalidMessage.
  ///
  /// In tr, this message translates to:
  /// **'Son kullanma tarihi geçersiz.'**
  String get walletCardExpiryInvalidMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'ru', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'ru':
      return AppLocalizationsRu();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
