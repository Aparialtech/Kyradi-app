// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'KYRADI';

  @override
  String get dashboard => 'Главная';

  @override
  String get profile => 'Профиль';

  @override
  String get settings => 'Настройки';

  @override
  String get findLocation => 'Найти мое местоположение';

  @override
  String get destination => 'Пункт назначения';

  @override
  String get transitRoute => 'Маршрут общественного транспорта';

  @override
  String get myLuggages => 'Мои чемоданы';

  @override
  String get total => 'Итого';

  @override
  String get addLuggageQr => 'Добавить багаж (QR)';

  @override
  String get newLuggageAdded => 'Новый багаж добавлен ✅';

  @override
  String get save => 'Сохранить';

  @override
  String get saveProfile => 'Профиль сохранен ✅';

  @override
  String get saveProfileError => 'Не удалось сохранить';

  @override
  String get userInfo => 'Информация о пользователе';

  @override
  String get map => 'Карта';

  @override
  String get mapIntro =>
      'Смотрите точки BavulGO на карте и строите лучший маршрут.';

  @override
  String get walkingRoute => 'Пеший маршрут';

  @override
  String get drivingRoute => 'Маршрут на авто';

  @override
  String get openInMaps => 'Открыть в Google Картах';

  @override
  String get routeOptions => 'Варианты маршрута';

  @override
  String get firstName => 'Имя';

  @override
  String get lastName => 'Фамилия';

  @override
  String get fullNameLabel => 'Полное имя';

  @override
  String get phone => 'Телефон';

  @override
  String get email => 'Эл. почта';

  @override
  String get address => 'Адрес';

  @override
  String get birthDate => 'Дата рождения';

  @override
  String get gender => 'Пол';

  @override
  String get emergencyContact => 'Экстренный контакт';

  @override
  String get note => 'Заметка / Описание';

  @override
  String get cameraPermission => 'Разрешение на камеру';

  @override
  String get cameraPermissionDesc => 'Требуется для сканирования QR';

  @override
  String get locationPermission => 'Разрешение на геолокацию';

  @override
  String get locationPermissionDesc =>
      'Для транспорта и функций местоположения';

  @override
  String get notificationPermission => 'Разрешение на уведомления';

  @override
  String get notificationPermissionDesc => 'Для напоминаний и обновлений';

  @override
  String get inAppNotifications => 'Уведомления в приложении';

  @override
  String get notificationSound => 'Звук уведомления';

  @override
  String get notificationVibrate => 'Вибрация';

  @override
  String get account => 'Аккаунт';

  @override
  String get changePassword => 'Сменить пароль';

  @override
  String get logout => 'Выйти';

  @override
  String get about => 'О приложении';

  @override
  String get aboutApp => 'Это приложение разработано KYRADI.';

  @override
  String get qrCode => 'QR-код';

  @override
  String get weight => 'Вес (кг)';

  @override
  String get size => 'Размер';

  @override
  String get color => 'Цвет';

  @override
  String get small => 'Маленький';

  @override
  String get medium => 'Средний';

  @override
  String get large => 'Большой';

  @override
  String get black => 'Чёрный';

  @override
  String get red => 'Красный';

  @override
  String get blue => 'Синий';

  @override
  String get grey => 'Серый';

  @override
  String get other => 'Другой';

  @override
  String get saveLuggage => 'Сохранить багаж';

  @override
  String get qrEmptyError => 'QR-код не может быть пустым ❌';

  @override
  String get oldPassword => 'Старый пароль';

  @override
  String get newPassword => 'Новый пароль';

  @override
  String get confirmNewPassword => 'Подтвердите новый пароль';

  @override
  String get passwordChanged => 'Пароль изменён ✅';

  @override
  String get passwordMismatch => 'Новые пароли не совпадают ❌';

  @override
  String get languageChanged => 'Язык изменён ✅';

  @override
  String permissionGranted(Object permission) {
    return 'Разрешение $permission предоставлено ✅';
  }

  @override
  String permissionDenied(Object permission) {
    return 'Разрешение $permission отклонено ❌';
  }

  @override
  String permissionDeniedForever(Object permission) {
    return 'Разрешение $permission отклонено навсегда, включите в настройках ⚙️';
  }

  @override
  String locationReceived(Object lat, Object lng) {
    return 'Местоположение получено 📍 $lat, $lng';
  }

  @override
  String get locationFailed => 'Не удалось получить местоположение ❌';

  @override
  String get profileSaved => 'Профиль сохранён ✅';

  @override
  String get profileSaveError => 'Не удалось сохранить профиль ❌';

  @override
  String get logoutSuccess => 'Вы успешно вышли 👋';

  @override
  String get copyrightNotice => '© 2025 KYRADI. Все права защищены.';

  @override
  String get demoMapComingSoon => 'Модуль карты скоро откроется.';

  @override
  String demoLuggageButton(Object number) {
    return 'Багаж $number';
  }

  @override
  String demoLuggageSelected(Object label) {
    return 'Выбран $label.';
  }

  @override
  String get demoFirstNameValue => 'Deniz';

  @override
  String get demoLastNameValue => 'Gezensoy';

  @override
  String get demoNationalIdValue => '12345678901';

  @override
  String get demoAddressValue => 'Стамбул, Турция';

  @override
  String get demoEmergencyNameValue => 'Merve Sönmez';

  @override
  String get demoEmergencyAddressValue => 'Кадыкёй, Стамбул';

  @override
  String get demoEmergencyEmailValue => 'merve@example.com';

  @override
  String get demoEmergencyRelationValue =>
      'Брат / сестра или близкий родственник';

  @override
  String get emergencyContactNote =>
      'С этим человеком свяжутся в экстренных ситуациях.';

  @override
  String get introTagline => 'Глобальная система чемоданов';

  @override
  String get introTrackButton => 'Отслеживать';

  @override
  String get serverButtonLabel => 'Сервер';

  @override
  String serverStatus(Object host) {
    return 'Сервер: $host';
  }

  @override
  String get loginHeroSubtitle => 'Управляйте багажом после входа.';

  @override
  String get loginFormTitle => 'Данные для входа';

  @override
  String get loginFormSubtitle =>
      'Подключитесь к актуальному серверу, чтобы войти.';

  @override
  String get emailHint => 'example@mail.com';

  @override
  String get passwordLabel => 'Пароль';

  @override
  String get passwordHint => '••••••';

  @override
  String get validationEmailRequired => 'E-mail обязателен';

  @override
  String get validationEmailInvalid => 'Введите корректный e-mail';

  @override
  String get validationPasswordRequired => 'Пароль обязателен';

  @override
  String validationMinChars(Object count) {
    return 'Введите минимум $count символов';
  }

  @override
  String get loginForgotPassword => 'Забыл пароль';

  @override
  String get clearButton => 'Очистить';

  @override
  String get loginButtonLabel => 'Войти';

  @override
  String get loginNoAccount => 'Нет аккаунта?';

  @override
  String get registerButtonLabel => 'Зарегистрироваться';

  @override
  String get loginSuccess => 'Вход выполнен ✅';

  @override
  String get loginInvalidCredentials => 'Неверный e-mail или пароль ❌';

  @override
  String get loginTooManyAttempts =>
      'Слишком много попыток, повторите через несколько минут ⚠️';

  @override
  String get loginFailed => 'Не удалось войти, попробуйте снова ❌';

  @override
  String genericErrorWithDetails(Object details) {
    return 'Произошла ошибка: $details';
  }

  @override
  String get loginVerificationRequired => 'Пожалуйста, подтвердите аккаунт 📨';

  @override
  String verificationSendFailedWithDetails(Object details) {
    return 'Не удалось отправить код подтверждения: $details';
  }

  @override
  String get registerTitle => 'Создать аккаунт';

  @override
  String get registerPersonalSectionTitle => 'Личные данные';

  @override
  String get registerPersonalSectionSubtitle =>
      'Укажите удостоверение личности и дату рождения.';

  @override
  String get genderMale => 'Мужской';

  @override
  String get genderFemale => 'Женский';

  @override
  String get genderUndisclosed => 'Не указывать';

  @override
  String get registerContactSectionTitle => 'Контактная информация';

  @override
  String get registerContactSectionSubtitle =>
      'E-mail и данные для подтверждения';

  @override
  String get nationalIdLabel => 'Номер удостоверения личности';

  @override
  String get phoneHint => '+90 5xx xxx xx xx';

  @override
  String get registerSecuritySectionTitle => 'Безопасность';

  @override
  String get registerSecuritySectionSubtitle => 'Задайте и подтвердите пароль';

  @override
  String get registerPasswordRepeatLabel => 'Повторите пароль';

  @override
  String get registerCaptchaLabel => 'Я не робот';

  @override
  String get registerCaptchaWarning => 'Отметьте «Я не робот»';

  @override
  String get registerKvkkAgreementLabel =>
      'Я прочитал и принимаю уведомление KVKK компании KYRADI.';

  @override
  String get registerKvkkAgreementWarning =>
      'Пожалуйста, примите уведомление KVKK.';

  @override
  String get registerRestrictedAgreementLabel =>
      'Я прочитал и принимаю список предметов, которые Aparial и перевозчики не принимают.';

  @override
  String get registerRestrictedAgreementWarning =>
      'Пожалуйста, подтвердите документ с запрещёнными предметами.';

  @override
  String get registerAgreementView => 'Показать документ';

  @override
  String get registerKvkkDialogTitle => 'KYRADI – уведомление KVKK';

  @override
  String get registerRestrictedDialogTitle =>
      'Предметы, которые отклоняют Aparial и транспортные компании';

  @override
  String get registerSuccessMessage =>
      'Регистрация успешна ✅ Письмо подтверждения отправлено.';

  @override
  String get registerEmailExistsMessage => 'Этот e-mail уже зарегистрирован ❌';

  @override
  String get registerGenericErrorMessage => 'Регистрация не удалась ❌';

  @override
  String get validationRequired => 'Обязательно';

  @override
  String get validationPasswordNeedsLetter => 'Нужна минимум одна буква';

  @override
  String get validationPasswordNeedsNumber => 'Нужна минимум одна цифра';

  @override
  String get validationPasswordRepeatRequired => 'Повторите пароль';

  @override
  String get validationNationalIdRequired => 'Требуется номер удостоверения';

  @override
  String get validationNationalIdLength => 'Номер должен содержать 11 цифр';

  @override
  String get validationNationalIdChecksumTen => 'Неверный номер (10-я цифра)';

  @override
  String get validationNationalIdChecksumEleven =>
      'Неверный номер (11-я цифра)';

  @override
  String get validationNationalIdInvalid => 'Неверный номер';

  @override
  String get validationPhoneRequired => 'Нужен номер телефона';

  @override
  String get validationPhoneFormat => 'Формат: +90 5xx xxx xx xx';

  @override
  String get validationBirthDateRequired => 'Выберите дату рождения';

  @override
  String get validationAgeRequirement => 'Вам должно быть больше 18 лет';

  @override
  String get formNotSelected => 'Не выбрано';

  @override
  String get forgotTitle => 'Забыли пароль';

  @override
  String get forgotIntro => 'Отправим код на вашу почту для сброса пароля.';

  @override
  String get forgotEmailSectionTitle => 'Подтверждение e-mail';

  @override
  String get forgotEmailSectionSubtitle =>
      'На зарегистрированный адрес придёт одноразовый код.';

  @override
  String get emailAddressLabel => 'Адрес e-mail';

  @override
  String get forgotSendButton => 'Отправить код';

  @override
  String forgotResendCountdown(int seconds) {
    return 'Отправить снова ($seconds с)';
  }

  @override
  String get forgotAlreadyHaveCode => 'У меня уже есть код';

  @override
  String get forgotNeedValidEmail => 'Сначала введите корректный e-mail 💌';

  @override
  String get forgotCodeSent => 'Код отправлен 📩';

  @override
  String get forgotEmailNotFound => 'Этот e-mail не зарегистрирован ❌';

  @override
  String get forgotTooManyAttempts =>
      'Слишком много попыток, повторите через минуту ⚠️';

  @override
  String get forgotCodeFailed => 'Не удалось отправить код ❌';

  @override
  String get resetTitle => 'Сброс пароля';

  @override
  String get resetSubtitle =>
      'Введите код, отправленный на этот e-mail, и создайте новый пароль.';

  @override
  String get verificationCodeLabel => 'Код подтверждения';

  @override
  String get resetNewPasswordLabel => 'Новый пароль';

  @override
  String get resetConfirmPasswordLabel => 'Новый пароль (повтор)';

  @override
  String get resetSubmitButton => 'Сбросить пароль';

  @override
  String get unknownError => 'Неизвестная ошибка';

  @override
  String get verificationTitle => 'Подтверждение e-mail';

  @override
  String verificationInstructions(Object email) {
    return 'Введите 6-значный код, отправленный на $email.';
  }

  @override
  String get verifyButtonLabel => 'Подтвердить код';

  @override
  String get verificationResendButton => 'Отправить код снова';

  @override
  String verificationCountdownLabel(int seconds) {
    return 'Отправить снова через $seconds с';
  }

  @override
  String get verificationResentMessage => 'Код отправлен повторно';

  @override
  String get verificationSendErrorMessage => 'Ошибка отправки';

  @override
  String get verificationMissingEmailMessage => 'Не удалось получить e-mail';

  @override
  String get verificationSuccessMessage => 'Аккаунт подтверждён ✅';

  @override
  String get verificationErrorMessage => 'Ошибка подтверждения';

  @override
  String get verificationCodeInvalidMessage => 'Код должен состоять из 6 цифр';

  @override
  String get validationVerificationCodeRequired => 'Код обязателен';

  @override
  String get validationVerificationCodeLength => 'Введите 6-значный код';

  @override
  String dashboardGreeting(Object name) {
    return 'Привет, $name';
  }

  @override
  String get dashboardSubtitle =>
      'Поделись местоположением и управляй багажом.';

  @override
  String dashboardTotalCount(Object count) {
    return 'Всего $count';
  }

  @override
  String get travelerPlaceholder => 'Путешественник';

  @override
  String get quickAddLuggage => 'Добавить багаж';

  @override
  String get quickTransit => 'Транспорт';

  @override
  String get dashboardMetricAwaiting => 'Ожидает сдачи';

  @override
  String get dashboardMetricStored => 'На хранении';

  @override
  String get dashboardMetricPicked => 'Выдано';

  @override
  String get dashboardMetricCancelled => 'Отменено';

  @override
  String get deliverySectionTitle => 'Доставка и маршрут';

  @override
  String get deliverySectionSubtitle => 'Выбери пункт сдачи и открой маршрут.';

  @override
  String get deliveryPointLabel => 'Пункт сдачи';

  @override
  String deliveryPointOption(Object name, int available, int total) {
    return '$name • Свободно $available/$total';
  }

  @override
  String deliveryPointSelected(Object name) {
    return 'Пункт сдачи выбран: $name ✅';
  }

  @override
  String get routeNeedLocation => 'Сначала нажмите «Найти моё местоположение».';

  @override
  String get routeNeedDestination => 'Укажите пункт назначения.';

  @override
  String get mapsOpenFailed => 'Не удалось открыть Google Maps.';

  @override
  String get reservationSectionTitle => 'Статусы бронирований';

  @override
  String get reservationSectionSubtitle =>
      'Смотри доступность и занятость точек.';

  @override
  String get luggagesSectionSubtitle =>
      'Показывай QR-коды и завершай шаги сдачи/получения.';

  @override
  String get newLuggageButton => 'Новый багаж';

  @override
  String get luggageFilterAll => 'Все';

  @override
  String get luggageFilterAwaiting => 'Ожидает сдачи';

  @override
  String get luggageFilterStored => 'На хранении';

  @override
  String get luggageFilterPicked => 'Выдано';

  @override
  String get luggageEmptyStateNoItems =>
      'Багаж ещё не добавлен. Создайте первый!';

  @override
  String get luggageEmptyStateFiltered => 'Для этого фильтра багаж не найден.';

  @override
  String get profileInfoSubtitle =>
      'Держите контактные данные в актуальном состоянии.';

  @override
  String get emergencySectionSubtitle =>
      'Добавьте доверенное лицо для безопасности.';

  @override
  String get relationLabel => 'Степень родства';

  @override
  String get emergencyRegisteredPerson => 'Сохранённый контакт';

  @override
  String get identitySectionTitle => 'ID / Паспорт';

  @override
  String get identitySectionSubtitle =>
      'Загрузите документ, который покажете при доставке.';

  @override
  String get identityPreviewHint =>
      'Здесь появится предварительный просмотр документа';

  @override
  String get identityDocIdCard => 'Удостоверение личности';

  @override
  String get identityDocPassport => 'Паспорт';

  @override
  String identityUploaded(Object file) {
    return 'Загруженный документ: $file';
  }

  @override
  String get identityMissing =>
      'Документ ещё не загружен. Для доставки требуется фото удостоверения или паспорта.';

  @override
  String get identityTakePhoto => 'Снять на камеру';

  @override
  String get identityPickFromGallery => 'Выбрать из галереи';

  @override
  String get identityDelete => 'Удалить документ';

  @override
  String identityPhotoSaved(Object docType) {
    return 'Фото $docType сохранено ✅';
  }

  @override
  String identityUploadFailed(Object details) {
    return 'Не удалось загрузить документ: $details';
  }

  @override
  String get identityRemoved => 'Документ удалён.';

  @override
  String get identityProofRequired =>
      'Загрузите фото удостоверения или паспорта перед продолжением.';

  @override
  String get profileDataMissing => 'Не удалось загрузить данные профиля.';

  @override
  String profileLoadFailed(Object details) {
    return 'Не удалось загрузить профиль: $details';
  }

  @override
  String get profileUserMissing =>
      'Пользователь не найден. Пожалуйста, войдите снова.';

  @override
  String get luggageLocationMissing => 'Для этого багажа нет данных о локации.';

  @override
  String luggageInfoSize(Object value) {
    return 'Размер: $value';
  }

  @override
  String luggageInfoWeight(Object value) {
    return 'Вес: $value кг';
  }

  @override
  String luggageInfoColor(Object value) {
    return 'Цвет: $value';
  }

  @override
  String noteLabel(Object note) {
    return 'Заметка: $note';
  }

  @override
  String scheduledDropLabel(Object date) {
    return 'Планируемая сдача: $date';
  }

  @override
  String scheduledPickupLabel(Object date) {
    return 'Планируемое получение: $date';
  }

  @override
  String get reservationCancelledLabel => 'Это бронирование отменено.';

  @override
  String get luggageShowQr => 'Показать QR-код';

  @override
  String get luggageDropAction => 'Я оставил багаж';

  @override
  String get luggagePickupAction => 'Забрать багаж';

  @override
  String get luggageCancelAction => 'Отменить бронирование';

  @override
  String get luggageOpenLocation => 'Открыть локацию';

  @override
  String createdAtLabel(Object date) {
    return 'Создано: $date';
  }

  @override
  String dropConfirmedAtLabel(Object date) {
    return 'Сдача подтверждена: $date';
  }

  @override
  String pickupConfirmedAtLabel(Object date) {
    return 'Получение подтверждено: $date';
  }

  @override
  String get loginRequired => 'Сначала войдите в систему.';

  @override
  String get luggageCreated => 'Создан новый багаж ✅';

  @override
  String get dropConfirmedMessage => 'Сдача подтверждена ✅';

  @override
  String get pickupConfirmedMessage => 'Получение завершено ✅';

  @override
  String get operationFailed => 'Операция не завершена.';

  @override
  String operationFailedWithDetails(Object details) {
    return 'Операция не завершена: $details';
  }

  @override
  String get reservationCancelledMessage => 'Бронирование отменено.';

  @override
  String get cancelFailed => 'Отмена не выполнена.';

  @override
  String cancelFailedWithDetails(Object details) {
    return 'Не удалось отменить: $details';
  }

  @override
  String get cancelReservationTitle => 'Отменить бронирование';

  @override
  String cancelReservationMessage(Object label) {
    return 'Вы уверены, что хотите отменить бронирование «$label»?';
  }

  @override
  String get dialogDismiss => 'Отмена';

  @override
  String get dialogConfirmCancel => 'Отменить';

  @override
  String get dialogConfirm => 'Да';

  @override
  String reservationTileTitle(Object code) {
    return 'Бронирование $code';
  }

  @override
  String reservationTileSubtitle(Object code, Object time) {
    return '$code • $time';
  }

  @override
  String reservationSlotSummary(int count, Object time) {
    return '$count багаж • $time';
  }

  @override
  String get notificationsTooltip => 'Уведомления';

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
  String get mapNoLocations => 'Локации не найдены.';

  @override
  String get locationServiceDisabled => 'Служба геолокации отключена.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Доступ к геолокации навсегда отклонён. Включите в настройках.';

  @override
  String locationFailedWithDetails(Object details) {
    return 'Не удалось получить геолокацию: $details';
  }

  @override
  String get locationNotFoundTitle => 'Локация не найдена';

  @override
  String get locationNotFoundMessage => 'Выбранная локация больше недоступна.';

  @override
  String get permissionManageButton => 'Настроить';

  @override
  String get settingsPermissionsTitle => 'Разрешения';

  @override
  String get settingsPermissionsSubtitle =>
      'Управляйте доступом к камере, геолокации и уведомлениям.';

  @override
  String get privacySectionTitle => 'Конфиденциальность';

  @override
  String get privacySectionSubtitle =>
      'Настройте параметры уведомлений в приложении.';

  @override
  String get remindersSectionTitle => 'Напоминания';

  @override
  String get remindersSectionSubtitle =>
      'Выберите оповещения о сдаче и получении.';

  @override
  String get pushRemindersLabel => 'Push-уведомления';

  @override
  String get emailRemindersLabel => 'Email-напоминания';

  @override
  String get languageSectionTitle => 'Язык';

  @override
  String get languageSectionSubtitle => 'Выберите язык приложения.';

  @override
  String get languageNameTr => 'Турецкий';

  @override
  String get languageNameEn => 'Английский';

  @override
  String get languageNameDe => 'Немецкий';

  @override
  String get languageNameEs => 'Испанский';

  @override
  String get languageNameRu => 'Русский';

  @override
  String languageChangedTo(Object language) {
    return 'Язык изменён на $language ✅';
  }

  @override
  String get upcomingReservationsTitle => 'Ближайшие бронирования';

  @override
  String get upcomingReservationsSubtitle =>
      'Имена скрыты; показаны только коды и заполняемость.';

  @override
  String get upcomingReservationsEmpty =>
      'Для этой локации бронирования не запланированы.';

  @override
  String get continueSectionTitle => 'Продолжить';

  @override
  String get continueSectionSubtitle =>
      'Если вы уже зарегистрированы — войдите, иначе быстро создайте аккаунт.';

  @override
  String get accountSectionSubtitle => 'Смените пароль или выйдите.';

  @override
  String get logoutDialogTitle => 'Выход из аккаунта';

  @override
  String get logoutDialogMessage => 'Выйти из аккаунта?';

  @override
  String get changePasswordIntro => 'Güvenliğin için yeni şifreni belirle.';

  @override
  String get changePasswordRequirementHint =>
      'En az 8 karakter, harf ve rakam içermeli.';

  @override
  String get userIdMissing => 'Вход не выполнен: userId не найден.';

  @override
  String userIdReadFailed(Object details) {
    return 'Не удалось прочитать userId: $details';
  }

  @override
  String get mapsMissingApiKey => 'Ключ Google Maps не настроен.';

  @override
  String routeFetchFailedWithDetails(Object details) {
    return 'Не удалось получить маршрут: $details';
  }

  @override
  String get routeNotFound => 'Маршрут не найден.';

  @override
  String get routeDataMissing => 'Не удалось получить данные маршрута.';

  @override
  String directionsApiError(Object status) {
    return 'Google Directions вернул ошибку: $status. Проверьте доступ ключа к Directions.';
  }

  @override
  String get reservationEmptyState => 'Нет запланированных бронирований.';

  @override
  String availableSlotsLabel(int available, int total) {
    return 'Свободно $available/$total';
  }

  @override
  String get qrDropTitle => 'Подтвердить сдачу по QR';

  @override
  String get qrPickupTitle => 'Подтвердить выдачу по QR';

  @override
  String get qrManualEntryHint =>
      'Если не удаётся сканировать, введите код вручную.';

  @override
  String get qrVerifyButton => 'Проверить';

  @override
  String get qrMismatchMessage => 'QR-код не совпал. Попробуйте снова.';

  @override
  String get qrCopied => 'QR-код скопирован.';

  @override
  String get qrTextCopied => 'Текст скопирован.';

  @override
  String get qrCopyCode => 'Скопировать код';

  @override
  String get qrCopyPrintable => 'Скопировать текст для печати';

  @override
  String get qrShareInstructions =>
      'Поделитесь этим кодом с персоналом, чтобы распечатать стикер. Клиент должен сканировать его при сдаче и выдаче.';

  @override
  String get qrDuplicateWarning =>
      'Этот QR-код уже используется. Мы создали новый — попробуйте ещё раз.';

  @override
  String get qrScanTip => 'Убедитесь, что код хорошо виден в рамке.';

  @override
  String get locationFetching => 'Получаем местоположение...';

  @override
  String get refreshNearbyButton => 'Обновить ближайшие точки';

  @override
  String get nearbyLocationsTitle => 'Ближайшие точки';

  @override
  String get commonSelect => 'Выбрать';

  @override
  String get landingTitle => 'BavulGO Track';

  @override
  String get landingIntro =>
      'Выбери, где оставить багаж. Нажми точку на карте, чтобы увидеть заполненность и открыть детали бронирования.';

  @override
  String get landingLocateSectionTitle => 'Найди ближайшие точки';

  @override
  String get landingLocateSectionSubtitle =>
      'Поделись геолокацией, чтобы получить рекомендации.';

  @override
  String get landingLocateButton => 'Найти мое местоположение';

  @override
  String get landingLocatingButton => 'Получаем местоположение...';

  @override
  String get landingNearestTitle => 'Ближайшие точки';

  @override
  String get landingNearestSubtitle => '3 рекомендуемые места рядом с вами';

  @override
  String get landingGoButton => 'Маршрут';

  @override
  String get landingDetailsButton => 'Подробнее';

  @override
  String get dropTimePending => 'Время сдачи не выбрано';

  @override
  String dropTimeLabel(Object time) {
    return 'Время сдачи: $time';
  }

  @override
  String get pickupTimePending => 'Время выдачи не выбрано';

  @override
  String pickupTimeLabel(Object time) {
    return 'Время выдачи: $time';
  }

  @override
  String get scheduleTimesRequired => 'Нужно выбрать время сдачи и выдачи.';

  @override
  String get notesHint => 'Замок, хрупкое, особые указания...';

  @override
  String get luggageNameHint => 'Дайте имя багажу (необязательно)';

  @override
  String get luggageRegistrationNote =>
      'После сохранения персонал сможет распечатать QR-стикер. Клиент должен сканировать код при сдаче и выдаче.';

  @override
  String get luggageCreateFailed => 'Не удалось создать багаж.';

  @override
  String get savingInProgress => 'Сохранение...';

  @override
  String get statusLabel => 'Статус';

  @override
  String get permissionNameCamera => 'Камера';

  @override
  String get permissionNameLocation => 'Геолокация';

  @override
  String get permissionNameNotifications => 'Уведомления';

  @override
  String get footerCopyright => '@2025 aparial.com';

  @override
  String get green => 'Зелёный';

  @override
  String get qrRegenerate => 'Создать заново';

  @override
  String get locationPermissionDenied => 'Доступ к геолокации не предоставлен.';

  @override
  String get dropDatePickerHelp => 'Дата сдачи';

  @override
  String get pickupDatePickerHelp => 'Дата выдачи';

  @override
  String get addLuggageTitle => 'Создать багаж';

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
