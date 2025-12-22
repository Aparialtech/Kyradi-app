// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'KYRADI';

  @override
  String get dashboard => 'Ana Sayfa';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get findLocation => 'Konumumu Bul';

  @override
  String get destination => 'Varış Noktası';

  @override
  String get transitRoute => 'Toplu Taşıma Rotası';

  @override
  String get myLuggages => 'Bavullarım';

  @override
  String get total => 'Toplam';

  @override
  String get addLuggageQr => 'Bavul Ekle (QR)';

  @override
  String get newLuggageAdded => 'Yeni bavul eklendi ✅';

  @override
  String get save => 'Kaydet';

  @override
  String get saveProfile => 'Profil kaydedildi ✅';

  @override
  String get saveProfileError => 'Kaydedilemedi';

  @override
  String get userInfo => 'Kullanıcı Bilgileri';

  @override
  String get map => 'Harita';

  @override
  String get mapIntro =>
      'KYRADI noktalarını haritada gör, en uygun rotayı oluştur.';

  @override
  String get walkingRoute => 'Yürüme Rotası';

  @override
  String get drivingRoute => 'Araç Rotası';

  @override
  String get openInMaps => 'Google Haritalar\'da Aç';

  @override
  String get routeOptions => 'Rota seçenekleri';

  @override
  String get firstName => 'Ad';

  @override
  String get lastName => 'Soyad';

  @override
  String get fullNameLabel => 'Ad Soyad';

  @override
  String get phone => 'Telefon';

  @override
  String get email => 'E-posta';

  @override
  String get address => 'Adres';

  @override
  String get birthDate => 'Doğum Tarihi';

  @override
  String get gender => 'Cinsiyet';

  @override
  String get emergencyContact => 'Acil Durum Kişisi';

  @override
  String get note => 'Not / Açıklama';

  @override
  String get cameraPermission => 'Kamera İzni';

  @override
  String get cameraPermissionDesc => 'QR okutmak için gereklidir';

  @override
  String get locationPermission => 'Konum İzni';

  @override
  String get locationPermissionDesc => 'Toplu taşıma ve konum özellikleri için';

  @override
  String get notificationPermission => 'Bildirim İzni';

  @override
  String get notificationPermissionDesc =>
      'Hatırlatmalar ve güncellemeler için';

  @override
  String get inAppNotifications => 'Uygulama içi bildirimler';

  @override
  String get notificationSound => 'Bildirim Sesi';

  @override
  String get notificationVibrate => 'Titreşim';

  @override
  String get account => 'Hesap';

  @override
  String get changePassword => 'Şifreyi Değiştir';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get about => 'Hakkında';

  @override
  String get aboutApp => 'Bu uygulama KYRADI tarafından geliştirilmiştir.';

  @override
  String get qrCode => 'QR Kodu';

  @override
  String get weight => 'Ağırlık (kg)';

  @override
  String get size => 'Boyut';

  @override
  String get color => 'Renk';

  @override
  String get small => 'Küçük';

  @override
  String get medium => 'Orta';

  @override
  String get large => 'Büyük';

  @override
  String get black => 'Siyah';

  @override
  String get red => 'Kırmızı';

  @override
  String get blue => 'Mavi';

  @override
  String get grey => 'Gri';

  @override
  String get other => 'Diğer';

  @override
  String get saveLuggage => 'Bavulu Kaydet';

  @override
  String get qrEmptyError => 'QR kod boş olamaz ❌';

  @override
  String get oldPassword => 'Eski Şifre';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get confirmNewPassword => 'Yeni Şifre (Tekrar)';

  @override
  String get passwordChanged => 'Şifre değiştirildi ✅';

  @override
  String get passwordMismatch => 'Yeni şifreler eşleşmiyor ❌';

  @override
  String get languageChanged => 'Dil değiştirildi ✅';

  @override
  String permissionGranted(Object permission) {
    return '$permission izni verildi ✅';
  }

  @override
  String permissionDenied(Object permission) {
    return '$permission izni reddedildi ❌';
  }

  @override
  String permissionDeniedForever(Object permission) {
    return '$permission izni kalıcı olarak reddedildi, ayarlardan aç ⚙️';
  }

  @override
  String locationReceived(Object lat, Object lng) {
    return 'Konum alındı 📍 $lat, $lng';
  }

  @override
  String get locationFailed => 'Konum alınamadı ❌';

  @override
  String get profileSaved => 'Profil kaydedildi ✅';

  @override
  String get profileSaveError => 'Profil kaydedilemedi ❌';

  @override
  String get logoutSuccess => 'Çıkış yapıldı 👋';

  @override
  String get copyrightNotice => '© 2025 KYRADI. Tüm hakları saklıdır.';

  @override
  String get demoMapComingSoon => 'Harita modülü yakında açılacak.';

  @override
  String demoLuggageButton(Object number) {
    return 'Bavul $number';
  }

  @override
  String demoLuggageSelected(Object label) {
    return '$label seçildi.';
  }

  @override
  String get demoFirstNameValue => 'Deniz';

  @override
  String get demoLastNameValue => 'Gezensoy';

  @override
  String get demoNationalIdValue => '12345678901';

  @override
  String get demoAddressValue => 'İstanbul, Türkiye';

  @override
  String get demoEmergencyNameValue => 'Merve Sönmez';

  @override
  String get demoEmergencyAddressValue => 'Kadıköy, İstanbul';

  @override
  String get demoEmergencyEmailValue => 'merve@example.com';

  @override
  String get demoEmergencyRelationValue => 'Kardeş / Yakın Akraba';

  @override
  String get emergencyContactNote => 'Acil durumlarda bu kişi aranacaktır.';

  @override
  String get introTagline => 'Global bavul sistemi';

  @override
  String get introTrackButton => 'Takip Et';

  @override
  String get serverButtonLabel => 'Sunucu';

  @override
  String serverStatus(Object host) {
    return 'Sunucu: $host';
  }

  @override
  String get loginHeroSubtitle => 'Hesabına giriş yaparak bavullarını yönet.';

  @override
  String get loginFormTitle => 'Giriş bilgileri';

  @override
  String get loginFormSubtitle =>
      'Giriş yapmak için en güncel sunucuya bağlan.';

  @override
  String get emailHint => 'ornek@mail.com';

  @override
  String get passwordLabel => 'Şifre';

  @override
  String get passwordHint => '••••••';

  @override
  String get validationEmailRequired => 'E-posta gerekli';

  @override
  String get validationEmailInvalid => 'Geçerli bir e-posta gir';

  @override
  String get validationPasswordRequired => 'Şifre gerekli';

  @override
  String validationMinChars(Object count) {
    return 'En az $count karakter gir';
  }

  @override
  String get loginForgotPassword => 'Şifremi unuttum';

  @override
  String get clearButton => 'Temizle';

  @override
  String get loginButtonLabel => 'Giriş Yap';

  @override
  String get loginNoAccount => 'Hesabın yok mu?';

  @override
  String get registerButtonLabel => 'Kayıt Ol';

  @override
  String get loginSuccess => 'Giriş başarılı ✅';

  @override
  String get loginInvalidCredentials => 'E-posta veya şifre hatalı ❌';

  @override
  String get loginTooManyAttempts =>
      'Çok fazla deneme yaptınız, lütfen birkaç dakika sonra tekrar deneyin ⚠️';

  @override
  String get loginFailed => 'Giriş başarısız, tekrar deneyin ❌';

  @override
  String genericErrorWithDetails(Object details) {
    return 'Bir hata oluştu: $details';
  }

  @override
  String get loginVerificationRequired => 'Lütfen hesabını doğrula 📨';

  @override
  String verificationSendFailedWithDetails(Object details) {
    return 'Doğrulama kodu gönderilemedi: $details';
  }

  @override
  String get registerTitle => 'Kayıt Ol';

  @override
  String get registerPersonalSectionTitle => 'Kişisel Bilgiler';

  @override
  String get registerPersonalSectionSubtitle =>
      'Kimlik ve doğum tarihini paylaş.';

  @override
  String get genderMale => 'Erkek';

  @override
  String get genderFemale => 'Kadın';

  @override
  String get genderUndisclosed => 'Belirtmek istemiyorum';

  @override
  String get registerContactSectionTitle => 'İletişim Bilgileri';

  @override
  String get registerContactSectionSubtitle =>
      'E-posta ve doğrulama bilgileriniz';

  @override
  String get nationalIdLabel => 'TC Kimlik No';

  @override
  String get phoneHint => '+90 5xx xxx xx xx';

  @override
  String get registerSecuritySectionTitle => 'Güvenlik';

  @override
  String get registerSecuritySectionSubtitle => 'Şifreni belirle ve doğrula';

  @override
  String get registerPasswordRepeatLabel => 'Şifre Tekrar';

  @override
  String get registerCaptchaLabel => 'Ben robot değilim';

  @override
  String get registerCaptchaWarning =>
      '\"Ben robot değilim\" kutusunu işaretleyin';

  @override
  String get registerKvkkAgreementLabel =>
      'KYRADI – KVKK Aydınlatma Metni\'ni okudum ve onaylıyorum.';

  @override
  String get registerKvkkAgreementWarning =>
      'Lütfen KVKK Aydınlatma Metni\'ni kabul edin.';

  @override
  String get registerRestrictedAgreementLabel =>
      'Aparial\'in ve genel taşıma şirketlerinin reddettiği maddeleri okudum ve kabul ediyorum.';

  @override
  String get registerRestrictedAgreementWarning =>
      'Lütfen reddedilen maddeler belgesini onaylayın.';

  @override
  String get registerAgreementView => 'Metni Görüntüle';

  @override
  String get registerKvkkDialogTitle => 'KYRADI – KVKK Aydınlatma Metni';

  @override
  String get registerRestrictedDialogTitle =>
      'Aparial\'in ve Genel Taşıma Şirketlerinin Reddettiği Maddeler';

  @override
  String get registerSuccessMessage =>
      'Kayıt başarılı ✅ Doğrulama e-postası gönderildi.';

  @override
  String get registerEmailExistsMessage => 'Bu e-posta adresi zaten kayıtlı ❌';

  @override
  String get registerGenericErrorMessage => 'Kayıt başarısız ❌';

  @override
  String get validationRequired => 'Zorunlu';

  @override
  String get validationPasswordNeedsLetter => 'En az 1 harf içermeli';

  @override
  String get validationPasswordNeedsNumber => 'En az 1 rakam içermeli';

  @override
  String get validationPasswordRepeatRequired => 'Şifre tekrar gerekli';

  @override
  String get validationNationalIdRequired => 'TC gerekli';

  @override
  String get validationNationalIdLength => 'TC 11 hane olmalı';

  @override
  String get validationNationalIdChecksumTen => 'TC geçersiz (10. hane)';

  @override
  String get validationNationalIdChecksumEleven => 'TC geçersiz (11. hane)';

  @override
  String get validationNationalIdInvalid => 'TC geçersiz';

  @override
  String get validationPhoneRequired => 'Telefon gerekli';

  @override
  String get validationPhoneFormat => 'Format: +90 5xx xxx xx xx';

  @override
  String get validationBirthDateRequired => 'Doğum tarihi seçin';

  @override
  String get validationAgeRequirement => '18 yaşından büyük olmalısınız';

  @override
  String get formNotSelected => 'Seçilmedi';

  @override
  String get forgotTitle => 'Şifremi Unuttum';

  @override
  String get forgotIntro =>
      'Şifreni sıfırlamak için kayıtlı e-postana kod gönderelim.';

  @override
  String get forgotEmailSectionTitle => 'E-posta doğrulama';

  @override
  String get forgotEmailSectionSubtitle =>
      'Kayıtlı adresine tek kullanımlık kod gönderilecektir.';

  @override
  String get emailAddressLabel => 'E-posta adresi';

  @override
  String get forgotSendButton => 'Kod Gönder';

  @override
  String forgotResendCountdown(int seconds) {
    return 'Tekrar Gönder (${seconds}s)';
  }

  @override
  String get forgotAlreadyHaveCode => 'Kodum zaten var';

  @override
  String get forgotNeedValidEmail => 'Lütfen önce geçerli bir e-posta gir 💌';

  @override
  String get forgotCodeSent => 'Kod gönderildi 📩';

  @override
  String get forgotEmailNotFound => 'Bu e-posta sistemde kayıtlı değil ❌';

  @override
  String get forgotTooManyAttempts =>
      'Çok fazla deneme yaptınız, lütfen 1 dakika sonra tekrar deneyin ⚠️';

  @override
  String get forgotCodeFailed => 'Kod gönderilemedi ❌';

  @override
  String get resetTitle => 'Şifreyi Sıfırla';

  @override
  String get resetSubtitle =>
      'Bu e-posta adresine gönderilen kodu girerek yeni şifreni oluştur.';

  @override
  String get verificationCodeLabel => 'Doğrulama Kodu';

  @override
  String get resetNewPasswordLabel => 'Yeni Şifre';

  @override
  String get resetConfirmPasswordLabel => 'Yeni Şifre (Tekrar)';

  @override
  String get resetSubmitButton => 'Şifreyi Sıfırla';

  @override
  String get unknownError => 'Bilinmeyen hata';

  @override
  String get verificationTitle => 'E-posta Doğrulama';

  @override
  String verificationInstructions(Object email) {
    return '$email adresine gönderilen 6 haneli kodu gir.';
  }

  @override
  String get verifyButtonLabel => 'Kodu Doğrula';

  @override
  String get verificationResendButton => 'Kodu Tekrar Gönder';

  @override
  String verificationCountdownLabel(int seconds) {
    return '$seconds sn sonra tekrar gönder';
  }

  @override
  String get verificationResentMessage => 'Kod tekrar gönderildi';

  @override
  String get verificationSendErrorMessage => 'Gönderim hatası';

  @override
  String get verificationMissingEmailMessage => 'E-posta alınamadı';

  @override
  String get verificationSuccessMessage => 'Kullanıcı doğrulandı ✅';

  @override
  String get verificationErrorMessage => 'Doğrulama hatası';

  @override
  String get verificationCodeInvalidMessage => 'Kod 6 haneli olmalı';

  @override
  String get validationVerificationCodeRequired => 'Kod gerekli';

  @override
  String get validationVerificationCodeLength => '6 haneli kod girin';

  @override
  String dashboardGreeting(Object name) {
    return 'Merhaba, $name';
  }

  @override
  String get dashboardSubtitle => 'Konumunu paylaş, bavullarını yönet.';

  @override
  String dashboardTotalCount(Object count) {
    return 'Toplam $count';
  }

  @override
  String get travelerPlaceholder => 'Gezgin';

  @override
  String get quickAddLuggage => 'Bavul Ekle';

  @override
  String get quickTransit => 'Toplu Taşıma';

  @override
  String get dashboardMetricAwaiting => 'Teslim Bekleyen';

  @override
  String get dashboardMetricStored => 'Depoda';

  @override
  String get dashboardMetricPicked => 'Teslim Alınan';

  @override
  String get dashboardMetricCancelled => 'İptal Edilen';

  @override
  String get deliverySectionTitle => 'Teslimat & Rota';

  @override
  String get deliverySectionSubtitle =>
      'Teslim noktasını seç ve varış rotasını aç.';

  @override
  String get deliveryPointLabel => 'Teslim Noktası';

  @override
  String deliveryPointOption(Object name, int available, int total) {
    return '$name • Boş $available/$total';
  }

  @override
  String deliveryPointSelected(Object name) {
    return 'Teslim noktası seçildi: $name ✅';
  }

  @override
  String get routeNeedLocation => 'Önce \"Konumumu Bul\" seçeneğini kullan.';

  @override
  String get routeNeedDestination => 'Lütfen bir varış noktası gir.';

  @override
  String get mapsOpenFailed => 'Google Maps açılamadı.';

  @override
  String get reservationSectionTitle => 'Rezervasyon Durumları';

  @override
  String get reservationSectionSubtitle =>
      'Açık noktaların doluluk ve rezervasyon bilgilerini incele.';

  @override
  String get luggagesSectionSubtitle =>
      'QR kodlarını göster, bırakma/teslim işlemlerini tamamla.';

  @override
  String get newLuggageButton => 'Yeni Bavul';

  @override
  String get luggageFilterAll => 'Tümü';

  @override
  String get luggageFilterAwaiting => 'Teslim Bekleyen';

  @override
  String get luggageFilterStored => 'Depoda';

  @override
  String get luggageFilterPicked => 'Teslim';

  @override
  String get luggageEmptyStateNoItems =>
      'Henüz kayıtlı bavul yok. Hemen yeni bir bavul ekleyin.';

  @override
  String get luggageEmptyStateFiltered => 'Seçilen filtrede bavul bulunamadı.';

  @override
  String get profileInfoSubtitle => 'İletişim bilgilerini güncel tut.';

  @override
  String get emergencySectionSubtitle => 'Yakınını ekleyerek güvenliği artır.';

  @override
  String get relationLabel => 'Yakınlık';

  @override
  String get emergencyRegisteredPerson => 'Kayıtlı kişi';

  @override
  String get identitySectionTitle => 'Kimlik / Pasaport';

  @override
  String get identitySectionSubtitle =>
      'Teslim süreçlerinde gösterilecek belgeyi güvenle yükleyin.';

  @override
  String get identityPreviewHint => 'Belge ön izlemesi burada görünecek';

  @override
  String get identityDocIdCard => 'Kimlik';

  @override
  String get identityDocPassport => 'Pasaport';

  @override
  String identityUploaded(Object file) {
    return 'Yüklenen belge: $file';
  }

  @override
  String get identityMissing =>
      'Henüz belge yüklenmedi. Teslimat için kimlik veya pasaport fotoğrafı zorunlu.';

  @override
  String get identityTakePhoto => 'Kameradan çek';

  @override
  String get identityPickFromGallery => 'Galeriden seç';

  @override
  String get identityDelete => 'Belgeyi sil';

  @override
  String identityPhotoSaved(Object docType) {
    return '$docType fotoğrafı kaydedildi ✅';
  }

  @override
  String identityUploadFailed(Object details) {
    return 'Belge yüklenemedi: $details';
  }

  @override
  String get identityRemoved => 'Belge kaldırıldı.';

  @override
  String get identityProofRequired =>
      'Devam etmeden önce kimlik veya pasaport fotoğrafı yükleyin.';

  @override
  String get profileDataMissing => 'Profil verisi alınamadı.';

  @override
  String profileLoadFailed(Object details) {
    return 'Profil yüklenemedi: $details';
  }

  @override
  String get profileUserMissing =>
      'Kullanıcı bulunamadı. Lütfen tekrar giriş yapın.';

  @override
  String get luggageLocationMissing =>
      'Bu bavul için lokasyon bilgisi bulunamadı.';

  @override
  String luggageInfoSize(Object value) {
    return 'Boyut: $value';
  }

  @override
  String luggageInfoWeight(Object value) {
    return 'Ağırlık: $value kg';
  }

  @override
  String luggageInfoColor(Object value) {
    return 'Renk: $value';
  }

  @override
  String noteLabel(Object note) {
    return 'Not: $note';
  }

  @override
  String scheduledDropLabel(Object date) {
    return 'Planlanan bırakma: $date';
  }

  @override
  String scheduledPickupLabel(Object date) {
    return 'Planlanan teslim alma: $date';
  }

  @override
  String get reservationCancelledLabel => 'Bu rezervasyon iptal edildi.';

  @override
  String get luggageShowQr => 'QR Kodunu Göster';

  @override
  String get luggageDropAction => 'Bavulu bıraktım';

  @override
  String get luggagePickupAction => 'Bavulumu Teslim Al';

  @override
  String get luggageCancelAction => 'Rezervasyonu İptal Et';

  @override
  String get luggageOpenLocation => 'Lokasyonu Aç';

  @override
  String createdAtLabel(Object date) {
    return 'Oluşturuldu: $date';
  }

  @override
  String dropConfirmedAtLabel(Object date) {
    return 'Bırakma onayı: $date';
  }

  @override
  String pickupConfirmedAtLabel(Object date) {
    return 'Teslim alındı: $date';
  }

  @override
  String get loginRequired => 'Lütfen önce giriş yapın.';

  @override
  String get luggageCreated => 'Yeni bavul oluşturuldu ✅';

  @override
  String get dropConfirmedMessage => 'Bavul bırakma doğrulandı ✅';

  @override
  String get pickupConfirmedMessage => 'Teslim alma tamamlandı ✅';

  @override
  String get operationFailed => 'İşlem tamamlanamadı.';

  @override
  String operationFailedWithDetails(Object details) {
    return 'İşlem tamamlanamadı: $details';
  }

  @override
  String get reservationCancelledMessage => 'Rezervasyon iptal edildi.';

  @override
  String get cancelFailed => 'İptal edilemedi.';

  @override
  String cancelFailedWithDetails(Object details) {
    return 'İptal tamamlanamadı: $details';
  }

  @override
  String get cancelReservationTitle => 'Rezervasyonu iptal et';

  @override
  String cancelReservationMessage(Object label) {
    return '\"$label\" için oluşturulan rezervasyonu iptal etmek istediğinizden emin misiniz?';
  }

  @override
  String get dialogDismiss => 'Vazgeç';

  @override
  String get dialogConfirmCancel => 'İptal Et';

  @override
  String get dialogConfirm => 'Evet';

  @override
  String reservationTileTitle(Object code) {
    return 'Rezervasyon $code';
  }

  @override
  String reservationTileSubtitle(Object code, Object time) {
    return '$code • $time';
  }

  @override
  String reservationSlotSummary(int count, Object time) {
    return '$count bavul • $time';
  }

  @override
  String get notificationsTooltip => 'Bildirimler';

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
  String get mapNoLocations => 'Lokasyon bulunamadı.';

  @override
  String get locationServiceDisabled => 'Konum servisi kapalı.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Konum izni kalıcı reddedildi. Ayarlardan açmalısın.';

  @override
  String locationFailedWithDetails(Object details) {
    return 'Konum alınamadı: $details';
  }

  @override
  String get locationNotFoundTitle => 'Lokasyon bulunamadı';

  @override
  String get locationNotFoundMessage => 'Seçilen lokasyon artık mevcut değil.';

  @override
  String get permissionManageButton => 'Yönet';

  @override
  String get settingsPermissionsTitle => 'İzinler';

  @override
  String get settingsPermissionsSubtitle =>
      'Kamera, konum ve bildirim izinlerini yönet.';

  @override
  String get privacySectionTitle => 'Gizlilik';

  @override
  String get privacySectionSubtitle =>
      'Uygulama içi bildirim tercihlerini düzenle.';

  @override
  String get remindersSectionTitle => 'Hatırlatıcılar';

  @override
  String get remindersSectionSubtitle =>
      'Teslim ve bırakma uyarıları için tercihlerini seç.';

  @override
  String get pushRemindersLabel => 'Push Bildirimleri';

  @override
  String get emailRemindersLabel => 'E-posta Hatırlatıcısı';

  @override
  String get languageSectionTitle => 'Dil Seçimi';

  @override
  String get languageSectionSubtitle =>
      'Uygulamanın dilini değiştirmek için seçim yap.';

  @override
  String get languageNameTr => 'Türkçe';

  @override
  String get languageNameEn => 'İngilizce';

  @override
  String get languageNameDe => 'Almanca';

  @override
  String get languageNameEs => 'İspanyolca';

  @override
  String get languageNameRu => 'Rusça';

  @override
  String languageChangedTo(Object language) {
    return 'Dil $language olarak değiştirildi ✅';
  }

  @override
  String get upcomingReservationsTitle => 'Yaklaşan Rezervasyonlar';

  @override
  String get upcomingReservationsSubtitle =>
      'İsimler gizlidir; yalnızca kod ve doluluk bilgisi gösterilir.';

  @override
  String get upcomingReservationsEmpty =>
      'Bu lokasyonda planlanmış rezervasyon yok.';

  @override
  String get continueSectionTitle => 'Devam Et';

  @override
  String get continueSectionSubtitle =>
      'Üyeysen giriş yap, değilsen hızlıca kayıt ol.';

  @override
  String get accountSectionSubtitle => 'Şifreni değiştir veya oturumu kapat.';

  @override
  String get logoutDialogTitle => 'Oturumu kapat';

  @override
  String get logoutDialogMessage => 'Hesaptan çıkış yapmak istiyor musun?';

  @override
  String get changePasswordIntro => 'Güvenliğin için yeni şifreni belirle.';

  @override
  String get changePasswordRequirementHint =>
      'En az 8 karakter, harf ve rakam içermeli.';

  @override
  String get userIdMissing => 'Giriş yapılmamış: userId bulunamadı.';

  @override
  String userIdReadFailed(Object details) {
    return 'userId okunamadı: $details';
  }

  @override
  String get mapsMissingApiKey => 'Google Maps API anahtarı tanımlı değil.';

  @override
  String routeFetchFailedWithDetails(Object details) {
    return 'Rota alınamadı: $details';
  }

  @override
  String get routeNotFound => 'Rota bulunamadı.';

  @override
  String get routeDataMissing => 'Rota verisi alınamadı.';

  @override
  String directionsApiError(Object status) {
    return 'Google Directions API başarısız: $status. Anahtarın Directions API yetkisini kontrol edin.';
  }

  @override
  String get reservationEmptyState => 'Planlanmış rezervasyon yok.';

  @override
  String availableSlotsLabel(int available, int total) {
    return 'Boş $available/$total';
  }

  @override
  String get qrDropTitle => 'QR ile bırakma doğrulaması';

  @override
  String get qrPickupTitle => 'QR ile teslim alma';

  @override
  String get qrManualEntryHint => 'QR kodunu okutamıyorsan manuel gir.';

  @override
  String get qrVerifyButton => 'Doğrula';

  @override
  String get qrMismatchMessage => 'QR kodu eşleşmedi. Tekrar dene.';

  @override
  String get qrCopied => 'QR kodu kopyalandı.';

  @override
  String get qrTextCopied => 'Metin kopyalandı.';

  @override
  String get qrCopyCode => 'Kodu kopyala';

  @override
  String get qrCopyPrintable => 'Yazdırılabilir metni kopyala';

  @override
  String get qrShareInstructions =>
      'Bu kodu personelle paylaşarak sticker çıktısı alabilirsiniz. Müşteri bırakma ve teslim sırasında aynı kodu okutmalıdır.';

  @override
  String get qrDuplicateWarning =>
      'Bu QR kodu zaten kullanılıyor. Yeni bir kod ürettik, lütfen tekrar dene.';

  @override
  String get qrScanTip => 'Kodun çerçeve içinde net görünmesine dikkat et.';

  @override
  String get locationFetching => 'Konum alınıyor...';

  @override
  String get refreshNearbyButton => 'Yakındaki noktaları güncelle';

  @override
  String get nearbyLocationsTitle => 'Yakındaki lokasyonlar';

  @override
  String get commonSelect => 'Seç';

  @override
  String get landingTitle => 'KYRADI Track';

  @override
  String get landingIntro =>
      'Bavullarını bırakmak istediğin noktayı seç. Haritadan dilediğin noktaya dokun, doluluk oranını gör ve rezervasyon detayını aç.';

  @override
  String get landingLocateSectionTitle => 'Sana en yakın noktaları bul';

  @override
  String get landingLocateSectionSubtitle =>
      'Konumunu paylaşırsan öneriler liste halinde çıkar.';

  @override
  String get landingLocateButton => 'Konumumu Bul';

  @override
  String get landingLocatingButton => 'Konum alınıyor...';

  @override
  String get landingNearestTitle => 'Sana en yakın noktalar';

  @override
  String get landingNearestSubtitle => 'Konumuna göre önerilen 3 nokta';

  @override
  String get landingGoButton => 'Git';

  @override
  String get landingDetailsButton => 'Detay';

  @override
  String get dropTimePending => 'Bırakma zamanı seçilmedi';

  @override
  String dropTimeLabel(Object time) {
    return 'Bırakma zamanı: $time';
  }

  @override
  String get pickupTimePending => 'Teslim alma zamanı seçilmedi';

  @override
  String pickupTimeLabel(Object time) {
    return 'Teslim alma zamanı: $time';
  }

  @override
  String get scheduleTimesRequired =>
      'Bırakma ve teslim alma zamanları zorunludur.';

  @override
  String get notesHint => 'Kilidi, kırılganlık, özel talimatlar...';

  @override
  String get luggageNameHint => 'Bavula bir ad ver (isteğe bağlı)';

  @override
  String get luggageRegistrationNote =>
      'Kaydın ardından personeliniz QR sticker çıktısını alabilir. Müşteri bırakma ve teslimde kodu okutmalıdır.';

  @override
  String get luggageDelegateAction => 'Yetkili Kişi';

  @override
  String get pickupPinTitle => 'Teslim PIN';

  @override
  String get pickupPinLabel => 'Teslim PIN';

  @override
  String get pickupPinHint => '4 haneli PIN';

  @override
  String pickupPinGenerated(Object pin) {
    return 'Teslim PIN: $pin';
  }

  @override
  String get pickupPinRequiredMessage => 'Teslim için PIN gerekli.';

  @override
  String get pickupPinInvalidMessage => 'PIN hatalı. Tekrar dene.';

  @override
  String get delegateSetupTitle => 'Yetkili Kişi';

  @override
  String get delegateNameLabel => 'Ad Soyad';

  @override
  String get delegatePhoneLabel => 'Telefon';

  @override
  String get delegateEmailLabel => 'E-posta';

  @override
  String get delegateCodeTitle => 'Yetkili Kişi Kodu';

  @override
  String get delegateCodeLabel => 'Yetkili Kodu';

  @override
  String get delegateCodeHint => '6 haneli kod';

  @override
  String delegateCodeGenerated(Object code) {
    return 'Yetkili kodu: $code';
  }

  @override
  String get delegateCodeRequiredMessage => 'Yetkili kodu gerekli.';

  @override
  String get delegateCodeInvalidMessage => 'Yetkili kodu hatalı.';

  @override
  String get delegateSavedMessage => 'Yetkili kişi kaydedildi.';

  @override
  String get pickupPinSafetyWarning =>
      'PIN’inizi kaydedin ve kimseyle paylaşmayın. Teslim alma sırasında bu PIN istenecektir.';

  @override
  String get pickupPinCopiedMessage =>
      'PIN kopyalandı — PIN’inizi güvenli bir yerde saklayın.';

  @override
  String get copy => 'Kopyala';

  @override
  String get luggageCreateFailed => 'Bavul oluşturulamadı.';

  @override
  String get savingInProgress => 'Kaydediliyor...';

  @override
  String get statusLabel => 'Durum';

  @override
  String get permissionNameCamera => 'Kamera';

  @override
  String get permissionNameLocation => 'Konum';

  @override
  String get permissionNameNotifications => 'Bildirim';

  @override
  String get footerCopyright => '@2025 aparial.com';

  @override
  String get green => 'Yeşil';

  @override
  String get qrRegenerate => 'Yeniden Oluştur';

  @override
  String get locationPermissionDenied => 'Konum izni verilmedi.';

  @override
  String get dropDatePickerHelp => 'Bırakma tarihi';

  @override
  String get pickupDatePickerHelp => 'Teslim tarihi';

  @override
  String get addLuggageTitle => 'Bavul Oluştur';

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
}
