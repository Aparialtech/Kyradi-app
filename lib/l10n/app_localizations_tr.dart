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
  String exploreResultsCount(Object count) {
    return '$count lokasyon';
  }

  @override
  String get exploreSortNearby => 'Yakına Göre';

  @override
  String get exploreSortName => 'A-Z';

  @override
  String get exploreSortAvailability => 'Müsaitliğe Göre';

  @override
  String get exploreShowMore => 'Daha Fazla Göster';

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
  String get locationLabel => 'Lokasyon';

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
  String get sizeSmallDimensions => 'max 55x40x20 cm';

  @override
  String get sizeMediumDimensions => 'max 65x45x25 cm';

  @override
  String get sizeLargeDimensions => '65x45x25 cm üstü';

  @override
  String get sizeSmallNote => 'Kabin boy ve sırt çantaları için uygundur';

  @override
  String get sizeSelectionNote =>
      'Bavul tesliminde boyut kontrol edilir, yanlış seçimde fiyat güncellenebilir.';

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
  String get introTagline => 'Global Bavul Sistemi';

  @override
  String get splashSlogan => 'Bavulunu bırak, şehri keşfet';

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
  String get loginSocialDivider => 'veya';

  @override
  String get loginContinueWithGoogle => 'Google ile devam et';

  @override
  String get loginContinueWithApple => 'Apple ile devam et';

  @override
  String loginSocialComingSoon(Object provider) {
    return '$provider yakında aktif olacak.';
  }

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
  String get genericErrorMessage => 'Bir hata oluştu.';

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
  String get registerKvkkDocumentBody =>
      'Kişisel Verilerin Korunması ve İşlenmesine İlişkin Aydınlatma Metni\nBu metin, KYRADI platformu kapsamında işlenen kişisel verilerin, 6698 sayılı Kişisel Verilerin Korunması Kanunu (\"KVKK\") uyarınca hangi kapsamda ve hangi amaçlarla işlendiğini açıklamak amacıyla hazırlanmıştır.\n\nİşlenen Kişisel Veri Türleri\nKYRADI platformu kapsamında aşağıdaki kişisel veri grupları işlenmektedir:\nMüşteri verileri:\nAd Soyad, Telefon, QR kod tokenı, Rezervasyon ve dolap bilgisi, Ödeme tutarı ve işlem numarası\nPersonel verileri:\nAd Soyad, E-posta, Kullanıcı rolü, IP, işlem logları, oturum bilgisi\nTeknik veriler:\nAudit log kayıtları, Tarayıcı/cihaz bilgisi, Hata raporları\n\nVeri İşleme Amaçları\nKişisel veriler; rezervasyon akışının sağlanması, QR kod üretimi ve doğrulaması, ödeme intent yönetimi, bagaj teslim ve iade sürecinin yürütülmesi, sistem güvenliğinin sağlanması ve kötüye kullanımın tespiti, yasal saklama yükümlülüklerinin yerine getirilmesi ile raporlama ve platform iyileştirmeleri amaçlarıyla işlenmektedir.\n\nHukuki Dayanaklar\nKişisel veriler, KVKK’nın 5/2-c maddesi kapsamında sözleşmenin kurulması ve ifası, 5/2-f maddesi kapsamında meşru menfaat, 5/2-ç maddesi kapsamında hukuki yükümlülükler ile açık rıza gerektiren durumlarda ilgili kişinin açık rızasına dayanılarak işlenmektedir.\n\nVerilerin Aktarıldığı Taraflar\nKişisel veriler; ödeme hizmetlerinin sağlanması amacıyla Stripe ve Iyzico gibi ödeme servislerine, altyapı ve barındırma hizmetleri kapsamında AWS, Google Cloud, Render ve Vercel gibi bulut sağlayıcılara, zorunlu hallerde kamu kurumlarına ve hukuki veya mali danışmanlara aktarılabilmektedir.\n\nSaklama Süreleri\nKişisel veriler; rezervasyon ve ödeme kayıtları için 10 yıl, audit log kayıtları için 2 yıl, kullanıcı hesapları için hesap kapanışından itibaren 1 yıl süreyle saklanmakta olup, QR kod tokenları 1–24 saat aralığında muhafaza edilmektedir.\n\nGüvenlik Tedbirleri\nKYRADI platformunda; tenant bazlı veri izolasyonu, parola hashleme, JWT tabanlı güvenlik, rol bazlı erişim kontrolü, rate limiting ve saldırı önleme mekanizmaları ile kritik işlemler için audit log tutulması gibi teknik ve idari güvenlik tedbirleri uygulanmaktadır.\n\nİlgili Kişinin Hakları\nKVKK’nın 11. maddesi kapsamında ilgili kişiler; kişisel verilerinin işlenip işlenmediğini öğrenme, silme ve düzeltme talebinde bulunma, veri işlemeye itiraz etme ve zarar halinde tazminat talep etme haklarına sahiptir.\n\nBaşvurular kvkk@kyradi.com adresi üzerinden iletilebilir.';

  @override
  String get registerRestrictedDocumentBody =>
      'Bu belge, Aparial ve genel taşıma şirketleri tarafından taşınması reddedilen maddeleri özetlemektedir.\nGüvenlik, yasal düzenlemeler ve operasyonel riskler nedeniyle aşağıda belirtilen maddeler taşımaya kabul edilmez:\n\nTehlikeli ve Riskli Maddeler\n- Patlayıcı maddeler (dinamit, havai fişek, el bombası vb.)\n- Yanıcı ve parlayıcı maddeler (benzin, tiner, boya, çözücü vb.)\n- Basınçlı gazlar (propan, butan, oksijen tüpleri vb.)\n- Toksik, zehirli veya aşındırıcı kimyasallar (asit, baz, ağartıcı vb.)\n- Radyoaktif maddeler\n- Yanıcı kimyasallar içeren sıvılar veya çözücüler\n- Patlama veya yangın riski oluşturan herhangi bir madde veya cihaz\n\nSilah ve Tehlikeli Ekipmanlar\n- Silahlar, mühimmat ve benzeri ateşli cihazlar\n- Kesici veya delici aletler (hançer, uzun bıçak, sivri metal aletler vb.)\n\nCihazlar ve Basınçlı Ürünler\n- Gaz veya yakıt içeren cihazlar (yakıt dolu kamp ocakları vb.)\n- Basınçlı aerosol kutuları (tehlikeli gaz içeren spreyler)\n- Yüksek kapasiteli veya yedek lityum piller ve bataryalar\n\nRahatsızlık ve Güvenlik Riski Oluşturan Maddeler\n- Ağır kokulu, duman çıkaran veya çevreyi rahatsız eden maddeler\n\nDeğerli Eşyalar\n- Ziynet eşyalar (altın, mücevher vb. değerli eşyalar) taşımaya kabul edilmez.\n- Para (miktarına bakılmaksızın) taşımaya kabul edilmez.\n\nNot:\nBazı maddeler belirli izin, miktar veya güvenlik önlemleri ile taşınabilir. Ancak genel olarak bu tür maddeler hem Aparial hem de diğer taşıma şirketleri tarafından reddedilmektedir.';

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
  String get verificationTitle => 'Doğrulama';

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
  String get reservationEditTitle => 'Rezervasyonu Düzenle';

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
  String get luggageFilterCancelled => 'İptal Edilen';

  @override
  String get luggageEmptyStateNoItems =>
      'Henüz kayıtlı bavul yok. Hemen yeni bir bavul ekleyin.';

  @override
  String get luggageSearchHint => 'Bavul adı, QR veya lokasyon ara';

  @override
  String get luggageSortLabel => 'Sırala';

  @override
  String get luggageSortDate => 'Tarihe Göre';

  @override
  String get luggageSortStatus => 'Duruma Göre';

  @override
  String get luggageSortLocation => 'Lokasyona Göre';

  @override
  String get luggageSortPayment => 'Ödeme Durumu';

  @override
  String get luggageViewList => 'Liste';

  @override
  String get luggageViewCards => 'Kart';

  @override
  String get luggageViewCalendar => 'Takvim';

  @override
  String get luggageShowMore => 'Daha Fazla Yükle';

  @override
  String get luggageNoResultsTitle => 'Sonuç bulunamadı';

  @override
  String get luggageNoResultsSubtitle => 'Aramanı veya filtrelerini değiştir.';

  @override
  String get luggageFilterTitle => 'Filtreler';

  @override
  String get luggageFilterStatus => 'Durum';

  @override
  String get luggageFilterPayment => 'Ödeme';

  @override
  String get luggageFilterLocation => 'Lokasyon';

  @override
  String get luggageFilterSize => 'Boyut';

  @override
  String get luggageFilterReset => 'Sıfırla';

  @override
  String get luggageFilterApply => 'Uygula';

  @override
  String get comingSoonMessage => 'Bu özellik yakında.';

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
  String get luggageInfoSectionTitle => 'Bavul Bilgileri';

  @override
  String get luggageInfoLabelSize => 'Boyut';

  @override
  String get luggageInfoLabelWeight => 'Ağırlık';

  @override
  String get luggageInfoLabelColor => 'Renk';

  @override
  String get luggageInfoLabelPayment => 'Ödeme';

  @override
  String get luggageInfoLabelTotal => 'Toplam';

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
  String get locationAuthReadyMessage =>
      'Devam etmek için hesabın hazır. Hemen rezervasyona geçebilirsin.';

  @override
  String get exploreEmptyTitle => 'Konum bulunamadı.';

  @override
  String get exploreEmptySubtitle => 'Filtreleri değiştirmeyi deneyin.';

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
  String get qrScanTitle => 'QR Tara';

  @override
  String get qrScanGuide =>
      'QR okut veya manuel kod girerek rezervasyon detaylarına ulaş.';

  @override
  String get qrManualEntry => 'Manuel Giriş';

  @override
  String get qrManualHint => 'QR kodunu veya rezervasyon kodunu gir';

  @override
  String get qrManualSearchAction => 'Kodu Sorgula';

  @override
  String get qrAwaitingScan =>
      'QR okutulduğunda rezervasyon bilgileri burada görünecek.';

  @override
  String get qrNotFound => 'Bu QR kodu için kayıt bulunamadı.';

  @override
  String get qrLookupFailed => 'QR doğrulama başarısız. Lütfen tekrar deneyin.';

  @override
  String get qrReservationInfoTitle => 'Rezervasyon Bilgileri';

  @override
  String get qrScanAgain => 'Tekrar Tara';

  @override
  String get qrDropConfirmAction => 'Bavulu Bırak';

  @override
  String get qrConfirmDropTitle => 'Bavul Bırakma';

  @override
  String get qrConfirmDropMessage =>
      'Bu bavulu teslim aldığınızı onaylıyor musunuz?';

  @override
  String get qrDropSuccess => 'Bavul başarıyla teslim alındı.';

  @override
  String get qrDropFailed => 'Bavul teslim işlemi başarısız.';

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
  String occupancyLabel(Object current, Object max) {
    return 'Doluluk: $current/$max';
  }

  @override
  String get locationOpenLabel => 'Açık';

  @override
  String get locationClosedLabel => 'Kapalı';

  @override
  String get openingHoursTitle => 'Çalışma Saatleri';

  @override
  String get openingHoursSubtitle => 'Haftalık program';

  @override
  String get openingHoursAlwaysOpen => '7/24 açık';

  @override
  String get openingHoursClosed => 'Kapalı';

  @override
  String get locationFullWarning => 'Seçilen lokasyon dolu.';

  @override
  String get locationClosedWarning => 'Seçilen lokasyon şu anda kapalı.';

  @override
  String get locationInactiveWarning => 'Seçilen lokasyon aktif değil.';

  @override
  String get protectionLevelTitle => 'Koruma Seviyesi';

  @override
  String get protectionStandard => 'Standart';

  @override
  String get protectionPremium => 'Ek sigorta (premium)';

  @override
  String get paymentMethodTitle => 'Ödeme Yöntemi';

  @override
  String paymentMethodWallet(Object balance) {
    return 'Kyradi Cüzdan ile Öde (Bakiye: $balance ₺)';
  }

  @override
  String get paymentWalletInsufficientTitle => 'Bakiye Yetersiz';

  @override
  String paymentWalletInsufficientMessage(Object balance, Object amount) {
    return 'Cüzdan bakiyen $balance ₺. Toplam tutar $amount ₺. Para yükleyin veya kart ile ödeyin.';
  }

  @override
  String get paymentWalletTopUpAction => 'Para Yükle';

  @override
  String get paymentWalletUseCardAction => 'Kart ile Öde';

  @override
  String get paymentMethodCard => 'Kart';

  @override
  String get paymentMethodInstallment => 'Taksit';

  @override
  String get paymentMethodPayAtHotel => 'Otelde öde';

  @override
  String get paymentMethodUnknown => 'Bilinmiyor';

  @override
  String get paymentStatusLabel => 'Ödeme Durumu';

  @override
  String get paymentStatusUnknown => 'Bilinmiyor';

  @override
  String get luggageDetailsTitle => 'Bavul Detayları';

  @override
  String get luggageDetailsSubtitle =>
      'Rezervasyon ve ödeme bilgilerini görüntüleyin.';

  @override
  String get luggageIdLabel => 'Bavul ID';

  @override
  String get createdAtTitle => 'Oluşturulma';

  @override
  String get statusUpdateFailed =>
      'Durum güncellenemedi. Lütfen tekrar deneyin.';

  @override
  String get inviteFriendsTitle => 'Arkadaş Davet Et';

  @override
  String get inviteFriendsHeadline => 'Davet kodunu paylaş';

  @override
  String get inviteFriendsSubtitle =>
      'Arkadaşlarını davet et, rezervasyon yaptıkça cashback kazan.';

  @override
  String get inviteCodeCopied => 'Davet kodu kopyalandı';

  @override
  String get shareComingSoon => 'Paylaşım yakında.';

  @override
  String get shareAction => 'Paylaş';

  @override
  String get cashbackRulesTitle => 'Cashback Kuralları';

  @override
  String get cashbackRuleEarnTitle => 'Cashback kazan';

  @override
  String get cashbackRuleEarnSubtitle =>
      'Uygun rezervasyon ve kampanyalardan cashback kazan.';

  @override
  String get cashbackRuleUseTitle => 'Cashback kullan';

  @override
  String get cashbackRuleUseSubtitle =>
      'Desteklenen lokasyonlarda ödeme sırasında cashback uygula.';

  @override
  String get cashbackRuleExpireTitle => 'Süre dolumu';

  @override
  String get cashbackRuleExpireSubtitle =>
      'Cashback kullanılmazsa 12 ay sonra sona erer.';

  @override
  String get couponsTitle => 'Kuponlar';

  @override
  String get couponWelcomeSubtitle =>
      'Bir sonraki rezervasyonunda %10 indirim.';

  @override
  String get couponCitySubtitle => 'Şehir merkezi noktalarında 5 ₺ cashback.';

  @override
  String get couponWeekendSubtitle => 'Hafta sonu teslimde %15 indirim.';

  @override
  String get crashLogsTitle => 'Çökme Kayıtları';

  @override
  String get crashLogsCopied => 'Kayıtlar kopyalandı';

  @override
  String get crashLogsEmpty => 'Henüz kayıt yok.';

  @override
  String get allLabel => 'Tümü';

  @override
  String get bookingUpcomingLabel => 'Yaklaşan';

  @override
  String get bookingActiveLabel => 'Aktif';

  @override
  String get bookingPastLabel => 'Geçmiş';

  @override
  String get supportSectionTitle => 'Destek';

  @override
  String get faqTitle => 'SSS';

  @override
  String get aboutKyradiTitle => 'Kyradi Hakkında';

  @override
  String get whatsappLabel => 'WhatsApp';

  @override
  String get callLabel => 'Ara';

  @override
  String get emailLabel => 'E-posta';

  @override
  String get securitySectionTitle => 'Güvenlik';

  @override
  String get changePasswordTitle => 'Şifre değiştir';

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
  String get filtersTitle => 'Filtreler';

  @override
  String get resetAction => 'Sıfırla';

  @override
  String get filterOpenNow => 'Şu an açık';

  @override
  String get filterAvailableSlots => 'Uygun slotlar';

  @override
  String get filterActiveLocations => 'Aktif lokasyonlar';

  @override
  String get applyAction => 'Uygula';

  @override
  String get refreshAction => 'Yenile';

  @override
  String get faqQ1 => 'Kyradi nasıl çalışır?';

  @override
  String get faqA1 => 'Bavulunu anlaşmalı noktaya bırak, QR/PIN ile teslim al.';

  @override
  String get faqQ2 => 'Yerinde ödeme yapabilir miyim?';

  @override
  String get faqA2 => 'Evet, lokasyonda veya kart ile ödeme yapabilirsin.';

  @override
  String get faqQ3 => 'Lokasyon doluysa ne olur?';

  @override
  String get faqA3 => 'Farklı bir lokasyon veya saat seçebilirsin.';

  @override
  String get faqQ4 => 'Kimlik nasıl yüklenir?';

  @override
  String get faqA4 => 'Profil → Doğrulama → Kimlik adımlarını takip et.';

  @override
  String get aboutKyradiDescription =>
      'Kyradi, gezginleri güvenilir partner noktalarla buluşturan bir bavul depolama superapp’idir.';

  @override
  String get versionLabel => 'Sürüm';

  @override
  String get accountVerificationTitle => 'Hesap Doğrulama';

  @override
  String get requiredFieldLabel => 'Zorunlu';

  @override
  String get birthDateSelectLabel => 'Doğum tarihi seç';

  @override
  String get birthDateRequiredMessage => 'Doğum tarihi gerekli';

  @override
  String get firebaseConfigMissing => 'Firebase yapılandırması eksik.';

  @override
  String get googleTokenInvalid =>
      'Google token doğrulanamadı. Lütfen tekrar deneyin.';

  @override
  String get tokenInvalidMessage => 'Geçersiz token.';

  @override
  String get socialTokenFormatInvalid => 'Google token formatı geçersiz.';

  @override
  String get socialTokenInvalid =>
      'Google oturumu doğrulanamadı, tekrar deneyin.';

  @override
  String get authFlowWrong => 'Yanlış giriş akışı.';

  @override
  String get socialLoginCancelled => 'Giriş iptal edildi.';

  @override
  String get authBusyMessage => 'İşlem devam ediyor, lütfen bekleyin.';

  @override
  String get googleConfigMissing => 'Google giriş yapılandırması eksik.';

  @override
  String get googleConfigMissingIosScheme =>
      'Google giriş yapılandırması eksik (iOS URL scheme).';

  @override
  String get appleSignInUnavailable => 'Apple ile giriş kullanılamıyor.';

  @override
  String get appleConfigMissing => 'Apple giriş yapılandırması eksik.';

  @override
  String get retryAction => 'Tekrar Dene';

  @override
  String get verificationStatusVerified => 'Hesap onaylı';

  @override
  String get verificationStatusPending => 'Doğrulama bekliyor';

  @override
  String get verificationStatusRequired => 'Doğrulama gerekli';

  @override
  String get verificationBadgeVerified => 'Onaylı';

  @override
  String get verificationBadgePending => 'Bekliyor';

  @override
  String get verificationBadgeNew => 'Yeni';

  @override
  String get viewAction => 'Görüntüle';

  @override
  String get manageAction => 'Yönet';

  @override
  String locationSlotsLabel(Object available, Object total) {
    return '$available/$total slot';
  }

  @override
  String get quickActionScanQr => 'Scan QR';

  @override
  String get quickActionCashback => 'Cashback';

  @override
  String get quickActionReservation => 'Rezervasyon';

  @override
  String get quickActionSupport => 'Destek';

  @override
  String get quickActionCampaigns => 'Kampanyalar';

  @override
  String get paymentHotelCommissionNote =>
      'Otelde yüzde 5 komisyon eklenecektir.';

  @override
  String get paymentStartAction => 'Ödemeyi Başlat';

  @override
  String get paymentRequiredBeforeDropMessage =>
      'Ödeme tamamlanmadan bırakma yapılamaz.';

  @override
  String get paymentNotCompletedMessage =>
      'Ödeme tamamlanmadan bırakma yapılamaz.';

  @override
  String get paymentCompletedMessage =>
      'Ödeme tamamlandı. Bavulu bırakabilirsiniz.';

  @override
  String get paymentPageTitle => 'Ödeme';

  @override
  String get paymentPageSubtitle =>
      'Kart bilgilerinizi girerek ödemenizi tamamlayın.';

  @override
  String get paymentCardNumberLabel => 'Kart Numarası';

  @override
  String get paymentCardNameLabel => 'Kart Üzerindeki İsim';

  @override
  String get paymentExpiryLabel => 'Son Kullanma';

  @override
  String get paymentCvcLabel => 'CVC';

  @override
  String get paymentCompleteAction => 'Ödemeyi Tamamla';

  @override
  String get paymentDemoBadge => 'Demo Ödeme (Altyapı bağlanacak)';

  @override
  String get paymentFormIncompleteMessage =>
      'Lütfen kart bilgilerini eksiksiz girin.';

  @override
  String get paymentFailedMessage => 'Ödeme tamamlanamadı.';

  @override
  String get paymentSuccessMessage => 'Ödeme başarıyla alındı';

  @override
  String get paymentCardNumberInvalidMessage => 'Kart numarası 16 hane olmalı.';

  @override
  String get paymentExpiryInvalidMessage =>
      'Son kullanma tarihi MM/YY formatında olmalı.';

  @override
  String get paymentCvvInvalidMessage => 'CVV 3 veya 4 haneli olmalı.';

  @override
  String get paymentPayAtHotelTitle => 'Otelde Ödeme';

  @override
  String get paymentPayAtHotelBody =>
      'Ödemenizi seçtiğiniz lokasyonda tamamlayabilirsiniz.';

  @override
  String paymentTotalLabel(Object amount) {
    return 'Toplam: $amount ₺';
  }

  @override
  String get installmentCountLabel => 'Taksit sayısı';

  @override
  String get pricingEstimateTitle => 'Tahmini Fiyat';

  @override
  String get pricingEstimateLoading => 'Tahmin hesaplanıyor...';

  @override
  String get pricingBasePriceLabel => 'Baz fiyat';

  @override
  String get pricingPremiumFeeLabel => 'Ek sigorta';

  @override
  String get pricingHotelCommissionLabel => 'Otel komisyonu';

  @override
  String get pricingInstallmentFeeLabel => 'Taksit farkı';

  @override
  String get pricingTotalLabel => 'Toplam';

  @override
  String get pricingTierLabel => 'Süre bandı';

  @override
  String get pricingPriceLabel => 'Tahmini fiyat';

  @override
  String get pricingTier0To6 => '0–6 saat';

  @override
  String get pricingTier6To24 => '6–24 saat';

  @override
  String pricingTierDaily(Object days) {
    return '$days gün';
  }

  @override
  String get pricingInvalidRangeMessage =>
      'Teslim saati bırakma saatinden sonra olmalı.';

  @override
  String get pricingQuoteFailedMessage => 'Fiyat hesaplanamadı';

  @override
  String get pricingSummaryTitle => 'Ücret Özeti';

  @override
  String get pricingSummaryEdit => 'Düzenle';

  @override
  String get pricingSummarySizeLabel => 'Boyut';

  @override
  String get pricingSummaryDurationLabel => 'Süre';

  @override
  String get pricingSummaryAmountLabel => 'Tutar';

  @override
  String get pricingEstimateDisclaimer =>
      'Bu ücret tahminidir, gerçek teslim saatine göre güncellenebilir.';

  @override
  String get pricingEstimateUnavailable =>
      'Tahmin için bırakma ve teslim saatini seçin.';

  @override
  String get pickupPinSentMessage => 'PIN mailinize gönderildi.';

  @override
  String get pickupPinFailedMessage =>
      'PIN gönderilemedi, lütfen daha sonra tekrar deneyin.';

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
  String get luggageDelegateAction => 'Acil durum kişisine teslim et';

  @override
  String get delegateInfoRequiredMessage =>
      'Acil durum kişisinin bilgilerini doldurun.';

  @override
  String get howItWorksTitle => 'Nasıl çalışır?';

  @override
  String get howItWorksIntro =>
      'KYRADI, “kurye yok” modelinde çalışan bir bavul bırakma ve teslim alma uygulamasıdır. Bavulunu seçtiğin otele/partner noktaya kendin götürür, güvenli şekilde bırakır ve geri alırken PIN ile doğrularsın. Süreç boyunca adım adım yönlendirilir ve net bilgilendirmeler alırsın.';

  @override
  String get howItWorksStep1Title => '1) Lokasyon seçimi ve uygunluk kontrolü';

  @override
  String get howItWorksStep1Body =>
      'Uygulama, harita ve liste üzerinden partner noktaları gösterir. Her lokasyonun çalışma saatleri, maksimum kapasitesi ve anlık doluluğu vardır. Lokasyon kapalı, dolu veya pasifse bavul ekleme ve/veya bırakma adımı engellenir. Bu sayede kapıda sürpriz yaşamazsın ve gerçekten hizmet alabileceğin noktayı seçersin.';

  @override
  String get howItWorksStep2Title =>
      '2) Bavul bilgileri, süre ve koruma seçimi';

  @override
  String get howItWorksStep2Body =>
      'Bavulunu eklerken boyutu (small/medium/large), bırakma ve teslim alma saatlerini belirlersin. Bu bilgiler fiyatı etkiler. Koruma seviyesi olarak “Standart koruma” (varsayılan) veya “Ek sigorta (premium)” seçebilirsin. Seçimini değiştirdikçe tahmini ücret güncellenir.';

  @override
  String get howItWorksStep3Title => '3) Tahmini Ücret kartı nasıl çalışır?';

  @override
  String get howItWorksStep3Body =>
      'Uygulamadaki “Tahmini Ücret” kartı; boyut, süre, koruma ve ödeme yöntemine göre hesaplanır. Süre için 0–6 saat, 6–24 saat ve günlük tier kullanılır. Bu ücret bir ön bilgilendirmedir; gerçek teslim saatine göre değişebilir.';

  @override
  String get howItWorksStep4Title => '4) Rezervasyon oluşturma';

  @override
  String get howItWorksStep4Body =>
      'Rezervasyon oluşturabilir ve planını netleştirebilirsin. Ancak rezervasyon, “Bavulu Bırak” adımı tamamlanmadan hizmeti aktive etmez.';

  @override
  String get howItWorksStep5Title => '5) Lokasyona gidip “Bavulu Bırak”';

  @override
  String get howItWorksStep5Body =>
      '“Bavulu Bırak” butonu, bırakma sürecini başlatan ana adımdır. Kurye yoktur; bavulu lokasyona sen götürürsün. QR doğrulaması ve ödeme tamamlanmadan bırakma işlemi tamamlanamaz. Önemli: Bavulu Bırak butonu ödemesiz asla tamamlanamaz.';

  @override
  String get howItWorksStep6Title => '6) Ödeme ekranı ve 3 yöntem';

  @override
  String get howItWorksStep6Body =>
      'Ödeme adımında üç seçenek vardır: (1) Otelde ödeme: ödeme otelde alınır, ek komisyon ücrete yansıyabilir. (2) Kredi/Banka kartı: MagicPay altyapısı ile güvenli ödeme yapılır. (3) Taksitli ödeme: vade farkı ücrete yansıyabilir.';

  @override
  String get howItWorksStep7Title =>
      '7) Ödeme başarılı/başarısız olursa ne olur?';

  @override
  String get howItWorksStep7Body =>
      'Ödeme başarılı olursa bırakma tamamlanır ve PIN üretilir. Ödeme başarısız olursa uygulama net bir hata mesajı verir ve tekrar denemen için yönlendirir; bırakma tamamlanmaz.';

  @override
  String get howItWorksStep8Title => '8) PIN ile teslim alma';

  @override
  String get howItWorksStep8Body =>
      'Bırakma tamamlandığında teslim alma PIN’i oluşturulur. PIN ekranda gösterilir ve ayrıca e‑posta ile gönderilebilir. Mail gitmese bile süreç bozulmaz; PIN ile lokasyonda teslim alma doğrulanır.';

  @override
  String get howItWorksFaqTitle => 'Sık Sorulan Sorular';

  @override
  String get howItWorksFaq1Q => 'Neden ödeme bırakma anında?';

  @override
  String get howItWorksFaq1A =>
      'Ödeme, hizmetin aktifleştiği anı temsil eder ve kapasite/rezervasyon dengesini korur. Bu nedenle bırakma ödemesiz tamamlanamaz.';

  @override
  String get howItWorksFaq2Q => 'Tahmini ücret neden değişebilir?';

  @override
  String get howItWorksFaq2A =>
      'Tahmin; boyut, süre ve teslim saatine göre hesaplanır. Gerçek bırakma/teslim saatleri değişirse ücret de değişebilir.';

  @override
  String get howItWorksFaq3Q => 'Lokasyon kapalıysa/doluysa ne yapmalıyım?';

  @override
  String get howItWorksFaq3A =>
      'Uygulama bunu açıkça gösterir. Farklı bir lokasyon seçebilir veya daha uygun bir saat için planlama yapabilirsin.';

  @override
  String get howItWorksFaq4Q => 'Otelde ödeme seçersem kart ekranı açılır mı?';

  @override
  String get howItWorksFaq4A =>
      'Hayır. Otelde ödeme seçildiğinde kart ekranı açılmaz; ödeme otelde alınır. Ek komisyon ücrete yansıyabilir.';

  @override
  String get howItWorksFaq5Q => 'Taksit nasıl işler?';

  @override
  String get howItWorksFaq5A =>
      'Kredi kartı ile ödeme sırasında taksit seçilir. Seçilen vade farkı ücrete yansıyabilir ve toplam tutar buna göre hesaplanır.';

  @override
  String get howItWorksFaq6Q => 'Premium koruma ne sağlar?';

  @override
  String get howItWorksFaq6A =>
      'Standart korumaya ek güvence sunar. Ek sigorta seçildiğinde ücret biraz artabilir; detaylar “Tahmini Ücret” kartında görünür.';

  @override
  String get howItWorksFaq7Q => 'PIN’i kaybedersem ne olur?';

  @override
  String get howItWorksFaq7A =>
      'PIN, e‑posta ile yeniden gönderilebilir. Gerekirse profil/rezervasyon detaylarından tekrar görebilirsin. Destek ekibi de yardımcı olur.';

  @override
  String get howItWorksFaq8Q =>
      'Ödeme oldu ama uygulama güncellenmedi, ne yapmalıyım?';

  @override
  String get howItWorksFaq8A =>
      'Bağlantını kontrol edip sayfayı yenile. Ödeme durumunu kontrol etmek için tekrar dene. Sorun sürerse destek ekibiyle iletişime geç.';

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
  String get delegateCodeExpiredMessage => 'Yetkili kodunun süresi dolmuş.';

  @override
  String get delegateCodeUsedMessage => 'Yetkili kodu daha önce kullanılmış.';

  @override
  String get delegateSavedMessage => 'Yetkili kişi kaydedildi.';

  @override
  String get delegateEmergencyCodeTitle => 'Acil Durum Kodu';

  @override
  String get ownerInfoTitle => 'Sahip Bilgileri';

  @override
  String get ownerNameLabel => 'Ad Soyad';

  @override
  String get ownerPhoneLabel => 'Telefon';

  @override
  String get ownerEmailLabel => 'E-posta';

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

  @override
  String get rememberMeLabel => 'Beni Hatırla';

  @override
  String get qrShowAction => 'QR Göster';

  @override
  String get qrScanAction => 'QR Okut';

  @override
  String get detailsAction => 'Detay';

  @override
  String get supportAction => 'Destek';

  @override
  String get luggageStatusAwaitingDrop => 'Teslim Bekliyor';

  @override
  String get luggageStatusDropped => 'Depoda';

  @override
  String get luggageStatusPickedUp => 'Teslim Alındı';

  @override
  String get luggageStatusCancelled => 'İptal Edildi';

  @override
  String get paymentStatusPaid => 'Ödendi';

  @override
  String get paymentStatusPending => 'Beklemede';

  @override
  String get paymentStatusFailed => 'Başarısız';

  @override
  String get paymentStatusUnpaid => 'Ödenmedi';

  @override
  String get luggageTimelineCreated => 'Oluşturuldu';

  @override
  String get luggageTimelineScheduledDrop => 'Planlanan bırakma';

  @override
  String get luggageTimelineDropped => 'Bırakıldı';

  @override
  String get luggageTimelineScheduledPickup => 'Planlanan teslim alma';

  @override
  String get luggageTimelinePickedUp => 'Teslim alındı';

  @override
  String get luggageTimelineLastUpdate => 'Son güncelleme';

  @override
  String get luggageTimelineScheduled => 'Planlandı';

  @override
  String get activeTripTitle => 'Aktif yolculuk';

  @override
  String get seeAllAction => 'Tümünü gör';

  @override
  String get campaignsTitle => 'Kampanyalar';

  @override
  String get campaignsEmptyState => 'Şu an kampanya yok.';

  @override
  String get campaignsComingSoon => 'Kampanyalar yakında.';

  @override
  String get campaignCityWelcomeTitle => 'Şehre Hoş Geldin';

  @override
  String get campaignCityWelcomeSubtitle => 'İlk rezervasyonda %10 geri kazan.';

  @override
  String get campaignWeekendTitle => 'Hafta Sonu Depolama';

  @override
  String get campaignWeekendSubtitle =>
      'Hafta sonu bırakmalarında tasarruf et.';

  @override
  String get campaignAirportTitle => 'Havalimanı Bırakma';

  @override
  String get campaignAirportSubtitle => 'Havalimanı noktalarında ekstra puan.';

  @override
  String get campaignNewTag => 'YENİ';

  @override
  String get campaignHotTag => 'POPÜLER';

  @override
  String get campaignBonusTag => 'BONUS';

  @override
  String get profileVerifiedLabel => 'Doğrulandı';

  @override
  String get profileEditTitle => 'Profil Düzenle';

  @override
  String get profileSaveAction => 'Kaydet';

  @override
  String get profilePhotoSectionTitle => 'Profil fotoğrafı';

  @override
  String get profilePhotoSectionSubtitle =>
      'Profilini kişiselleştir ve güven ver.';

  @override
  String get profilePhotoUploadTitle => 'Fotoğraf yükle';

  @override
  String get profilePhotoUploadHint =>
      'PNG veya JPG, net bir yüz fotoğrafı önerilir.';

  @override
  String get profilePhotoSelectAction => 'Fotoğraf Seç';

  @override
  String get profilePersonalSectionTitle => 'Kişisel bilgiler';

  @override
  String get profilePersonalSectionSubtitle =>
      'Ad-soyad ve kimlik bilgilerini güncelle.';

  @override
  String get profileFirstNameLabel => 'Ad';

  @override
  String get profileLastNameLabel => 'Soyad';

  @override
  String get profileBirthDateLabel => 'Doğum Tarihi';

  @override
  String get profileNationalIdLabel => 'Kimlik No';

  @override
  String get profileContactSectionTitle => 'İletişim';

  @override
  String get profileContactSectionSubtitle =>
      'Telefon ve adres bilgilerini güncelle.';

  @override
  String get profilePhoneLabel => 'Telefon';

  @override
  String get profileAddressLabel => 'Adres';

  @override
  String get profileSavedMessage => 'Profil güncellendi.';

  @override
  String get profileSaveFailed => 'Profil güncellenemedi.';

  @override
  String profileSaveFailedWithDetails(Object details) {
    return 'Profil güncellenemedi: $details';
  }

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsInAppNotifications => 'Uygulama içi bildirimler';

  @override
  String get settingsEmailReminders => 'E-posta hatırlatmaları';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsThemeLight => 'Açık';

  @override
  String get settingsThemeDark => 'Koyu';

  @override
  String get settingsThemeSystem => 'Sistem';

  @override
  String get profileDetailsTitle => 'Profil Bilgileri';

  @override
  String get profileDetailsSubtitle => 'Hesap ve iletişim bilgilerin';

  @override
  String get profileEmailLabel => 'E-posta';

  @override
  String get profileGenderLabel => 'Cinsiyet';

  @override
  String get profileGenderFemale => 'Kadın';

  @override
  String get profileGenderMale => 'Erkek';

  @override
  String get profileGenderUnspecified => 'Belirtilmedi';

  @override
  String get profileVerificationStatus => 'Doğrulama Durumu';

  @override
  String get profileVerificationPending => 'İnceleme Bekliyor';

  @override
  String get profileVerificationMissing => 'Doğrulanmadı';

  @override
  String get walletTitle => 'Cüzdan';

  @override
  String get walletHeaderTitle => 'Cashback';

  @override
  String get walletHeaderSubtitle => 'Seyahat ettikçe ödül kazan.';

  @override
  String get walletCashbackTitle => 'Cashback';

  @override
  String get walletCashbackTotalLabel => 'Toplam Cashback';

  @override
  String get walletCardsTitle => 'Kartlarım';

  @override
  String get walletAddCardTitle => 'Kart Ekle';

  @override
  String get walletAddCardSubtitle =>
      'Hızlı ödeme için kart bilgilerini kaydet.';

  @override
  String get walletCardNumberLabel => 'Kart Numarası';

  @override
  String get walletCardNameLabel => 'Kart Üzerindeki İsim';

  @override
  String get walletCardExpiryLabel => 'Son Kullanma';

  @override
  String get walletCardCvvLabel => 'CVV';

  @override
  String get walletAddCardAction => 'Kartı Kaydet';

  @override
  String get walletCardsEmptyTitle => 'Kart bulunamadı';

  @override
  String get walletCardsEmptySubtitle =>
      'Güvenli kartlarını buraya ekleyebilirsin.';

  @override
  String get walletTabTopUps => 'Yüklemeler';

  @override
  String get walletTabSpends => 'Harcamalar';

  @override
  String get walletTabCashback => 'Cashback';

  @override
  String get walletFilterDateLabel => 'Tarih Aralığı';

  @override
  String get walletFilterLast7 => 'Son 7 gün';

  @override
  String get walletFilterLast30 => 'Son 30 gün';

  @override
  String get walletFilterLast90 => 'Son 90 gün';

  @override
  String get walletRulesAction => 'Kurallar';

  @override
  String get walletBalanceLabel => 'Cashback bakiyesi';

  @override
  String walletMonthlyEarnedLabel(Object amount) {
    return 'Bu ay +$amount ₺';
  }

  @override
  String get walletUseCashbackAction => 'Cashback kullan';

  @override
  String get walletCouponsAction => 'Kuponlar';

  @override
  String get walletInviteAction => 'Davet et';

  @override
  String get couponSectionTitle => 'Kupon kodu';

  @override
  String get couponSectionSubtitle => 'Avantaj veya indirim için kod uygula.';

  @override
  String get couponInputLabel => 'Kupon kodu';

  @override
  String get couponApplyAction => 'Uygula';

  @override
  String get couponAppliedMessage => 'Kupon uygulandı.';

  @override
  String get couponInvalidMessage => 'Kupon geçersiz.';

  @override
  String get couponFailedMessage => 'Kupon uygulanamadı.';

  @override
  String get topUpSectionTitle => 'Para yükle';

  @override
  String get topUpSectionSubtitle => 'Cüzdanına güvenle para ekle.';

  @override
  String get topUpAmountLabel => 'Yükleme tutarı (₺)';

  @override
  String get cardNumberLabel => 'Kart numarası';

  @override
  String get cardHolderNameLabel => 'Kart sahibi';

  @override
  String get cardExpiryLabel => 'Son kullanma (AA/YY)';

  @override
  String get cardCvvLabel => 'CVV';

  @override
  String get topUpPayAction => 'Ödeme Yap';

  @override
  String get topUpConfirmTitle => 'Ödeme Onayı';

  @override
  String topUpConfirmMessage(Object amount, Object card) {
    return '$amount ₺ yüklemek istediğine emin misin? Kart: $card';
  }

  @override
  String get topUpProcessingTitle => 'Ödeme İşleniyor';

  @override
  String get topUpProcessingSubtitle =>
      'Güvenli ödeme için doğrulama yapılıyor.';

  @override
  String get topUpInvalidAmountMessage => 'Geçerli bir tutar gir.';

  @override
  String get topUpInvalidCardMessage => 'Geçerli kart bilgisi gir.';

  @override
  String get topUpSuccessMessage => 'Yükleme başarılı.';

  @override
  String get topUpFailedMessage => 'Yükleme başarısız. Tekrar dene.';

  @override
  String get topUpTransactionTitle => 'Cüzdan yükleme';

  @override
  String get topUpTransactionCategory => 'Yükleme';

  @override
  String get transferSectionTitle => 'Transfer';

  @override
  String get walletActionsTitle => 'Hızlı işlemler';

  @override
  String get walletActionsSubtitle =>
      'Kupon, para yükleme ve transfer adımlarını aç.';

  @override
  String get transferSectionSubtitle => 'Başka kullanıcıya para gönder.';

  @override
  String get transferTargetLabel => 'Alıcı (telefon/e-posta/ID)';

  @override
  String get transferAmountLabel => 'Tutar';

  @override
  String get transferNoteLabel => 'Not (opsiyonel)';

  @override
  String get transferAction => 'Transfer Et';

  @override
  String get transferInvalidMessage => 'Alıcı ve tutar girin.';

  @override
  String get transferInsufficientBalanceMessage => 'Yetersiz bakiye.';

  @override
  String get transferConfirmTitle => 'Transferi onayla';

  @override
  String transferConfirmMessage(Object target, Object amount) {
    return '$target kişisine $amount ₺ gönderilsin mi?';
  }

  @override
  String get transferSuccessMessage => 'Transfer başarılı.';

  @override
  String get transferFailedMessage => 'Transfer başarısız.';

  @override
  String transferTransactionTitle(Object target) {
    return '$target kişisine transfer';
  }

  @override
  String get transferTransactionCategory => 'Transfer';

  @override
  String get walletMissionsTitle => 'Görevler';

  @override
  String get walletTransactionsTitle => 'İşlemler';

  @override
  String get walletEmptyTransactionsTitle => 'Henüz işlem yok';

  @override
  String get walletEmptyTransactionsSubtitle =>
      'Cashback hareketlerin burada görünecek.';

  @override
  String get walletMockLocationTitle => 'Taksim KYRADI';

  @override
  String get walletMockPaymentTitle => 'Rezervasyon ödemesi';

  @override
  String get walletMockCampaignTitle => 'Hafta sonu kampanyası';

  @override
  String get walletMockAdjustmentTitle => 'Manuel düzeltme';

  @override
  String get walletTransactionCategoryCashback => 'Cashback';

  @override
  String get walletTransactionCategoryUsage => 'Kullanım';

  @override
  String get walletTransactionCategoryCampaign => 'Kampanya';

  @override
  String get walletTransactionCategoryAdjustment => 'Düzeltme';

  @override
  String get walletMissionExploreTitle => '3 lokasyon keşfet';

  @override
  String get walletMissionExploreSubtitle =>
      '3 partner lokasyonu ziyaret et veya rezervasyon yap.';

  @override
  String get walletMissionWeekendTitle => 'Hafta sonu gezgini';

  @override
  String get walletMissionWeekendSubtitle =>
      '2 hafta sonu rezervasyonu tamamla.';

  @override
  String get walletMissionInviteTitle => 'Arkadaş daveti';

  @override
  String get walletMissionInviteSubtitle =>
      '3 arkadaş davet ederek ödül kazan.';

  @override
  String get supportSoonMessage => 'Destek yakında.';

  @override
  String get supportChatTitle => 'Kyradi Destek';

  @override
  String get supportChatGreeting =>
      'Merhaba! Kyradi Sanal Destek\'e hoş geldin. Nasıl yardımcı olabilirim?';

  @override
  String get supportChatHint => 'Mesajınızı yazın...';

  @override
  String get supportChatTyping => 'Yazıyor...';

  @override
  String get supportChatFallback =>
      'Şu anda tam anlayamadım. Lütfen biraz daha detay verebilir misiniz?';

  @override
  String get supportChatHelpCancel =>
      'Bavul iptali için: Bavullarım > Detay > İptal Et adımını kullanabilirsiniz.';

  @override
  String get supportChatHelpPayment =>
      'Ödeme konusunda hata alırsanız kart hareketleri ve hata mesajını paylaşın, yardımcı olalım.';

  @override
  String get supportChatHelpReservation =>
      'Rezervasyon için uygun lokasyon ve tarih seçerek devam edebilirsiniz.';

  @override
  String get supportChatHelpPickup =>
      'Teslim alma saati yaklaşınca hatırlatma alırsın. Gecikme varsa destekten bildir.';

  @override
  String get supportChatHelpLocation =>
      'Lokasyonların doluluk bilgisini Keşfet ekranında görebilirsiniz.';

  @override
  String get supportChatHelpWallet =>
      'Cüzdana para yüklemek için Cüzdan > Para Yükle adımını kullanabilirsiniz.';

  @override
  String get qrScanSoonMessage => 'QR tarama yakında.';

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
