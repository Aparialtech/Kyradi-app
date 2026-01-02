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
      'Смотрите точки KYRADI на карте и строите лучший маршрут.';

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
  String get sizeSmallDimensions => 'до 55x40x20 см';

  @override
  String get sizeMediumDimensions => 'до 65x45x25 см';

  @override
  String get sizeLargeDimensions => 'более 65x45x25 см';

  @override
  String get sizeSmallNote => 'Подходит для ручной клади и рюкзаков';

  @override
  String get sizeSelectionNote =>
      'Размер проверяется при сдаче; при неверном выборе цена может измениться.';

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
  String get loginSocialDivider => 'или';

  @override
  String get loginContinueWithGoogle => 'Продолжить с Google';

  @override
  String get loginContinueWithApple => 'Продолжить с Apple';

  @override
  String loginSocialComingSoon(Object provider) {
    return '$provider скоро будет доступен.';
  }

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
  String get registerKvkkDocumentBody =>
      'Уведомление о защите и обработке персональных данных\nЭтот текст подготовлен, чтобы объяснить, в каком объеме и для каких целей обрабатываются персональные данные в рамках платформы KYRADI в соответствии с Законом Турции о защите персональных данных № 6698 (\"KVKK\").\n\nВиды обрабатываемых персональных данных\nВ рамках KYRADI обрабатываются следующие категории данных:\nДанные клиента:\nИмя и фамилия, телефон, QR-токен, информация о бронировании и ячейке, сумма платежа и номер транзакции\nДанные персонала:\nИмя и фамилия, e-mail, роль пользователя, IP, журналы операций, информация о сессии\nТехнические данные:\nЗаписи audit log, информация о браузере/устройстве, отчеты об ошибках\n\nЦели обработки\nПерсональные данные обрабатываются для обеспечения процесса бронирования, генерации и проверки QR-кодов, управления платежными намерениями, выполнения процессов сдачи и получения багажа, обеспечения безопасности системы и выявления злоупотреблений, выполнения обязательных сроков хранения, а также для отчетности и улучшения платформы.\n\nПравовые основания\nПерсональные данные обрабатываются на основании ст. 5/2-c KVKK (заключение и исполнение договора), ст. 5/2-f (законный интерес), ст. 5/2-ç (законные обязанности), а также на основании явного согласия в требуемых случаях.\n\nПолучатели передачи данных\nПерсональные данные могут передаваться платежным сервисам, таким как Stripe и Iyzico, облачным провайдерам, таким как AWS, Google Cloud, Render и Vercel, государственным органам в обязательных случаях, а также юридическим или финансовым консультантам.\n\nСроки хранения\nПерсональные данные хранятся 10 лет для записей бронирований и платежей, 2 года для audit log, и 1 год после закрытия аккаунта для учетных записей пользователей; QR-токены хранятся 1–24 часа.\n\nМеры безопасности\nKYRADI применяет технические и организационные меры безопасности, такие как изоляция данных по арендаторам, хэширование паролей, безопасность на базе JWT, контроль доступа по ролям, ограничение скорости и предотвращение атак, а также audit log для критических операций.\n\nПрава субъекта данных\nСогласно ст. 11 KVKK, субъекты данных имеют право узнать, обрабатываются ли их персональные данные, запросить удаление или исправление, возразить против обработки и требовать компенсацию в случае ущерба.\n\nОбращения можно направлять на kvkk@kyradi.com.';

  @override
  String get registerRestrictedDocumentBody =>
      'Этот документ обобщает предметы, которые Aparial и общие транспортные компании не принимают к перевозке.\nПо причинам безопасности, правового регулирования и операционных рисков перечисленные ниже предметы не принимаются:\n\nОпасные и рискованные предметы\n- Взрывчатые вещества (динамит, фейерверки, гранаты и т.д.)\n- Легковоспламеняющиеся вещества (бензин, растворитель, краска и т.д.)\n- Сжатые газы (пропан, бутан, кислородные баллоны и т.д.)\n- Токсичные, ядовитые или едкие химикаты (кислота, щелочь, отбеливатель и т.д.)\n- Радиоактивные материалы\n- Горючие жидкости или растворители с опасными химикатами\n- Любое вещество или устройство, представляющее риск взрыва или пожара\n\nОружие и опасное оборудование\n- Оружие, боеприпасы и аналогичное огнестрельное\n- Колюще-режущие предметы (кинжалы, длинные ножи, острые металлические инструменты и т.д.)\n\nУстройства и продукция под давлением\n- Устройства с газом или топливом (туристические горелки с топливом и т.д.)\n- Аэрозольные баллоны под давлением (спреи с опасным газом)\n- Литиевые аккумуляторы большой емкости или запасные\n\nПредметы, вызывающие дискомфорт или риск\n- Сильно пахнущие, дымящие или раздражающие вещества\n\nЦенности\n- Ювелирные изделия (золото, драгоценные камни и т.д.) не принимаются.\n- Наличные деньги (независимо от суммы) не принимаются.\n\nПримечание:\nНекоторые предметы могут перевозиться при наличии разрешений, в определенных количествах или при соблюдении мер безопасности. Однако в целом такие предметы отклоняются как Aparial, так и другими перевозчиками.';

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
  String get reservationEditTitle => 'Изменить бронирование';

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
  String get luggageFilterCancelled => 'Отменено';

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
  String get landingTitle => 'KYRADI Track';

  @override
  String get landingIntro =>
      'Выбери, где оставить багаж. Нажми точку на карте, чтобы увидеть заполненность и открыть детали бронирования.';

  @override
  String occupancyLabel(Object current, Object max) {
    return 'Заполненность: $current/$max';
  }

  @override
  String get locationOpenLabel => 'Открыто';

  @override
  String get locationClosedLabel => 'Закрыто';

  @override
  String get openingHoursTitle => 'Часы работы';

  @override
  String get openingHoursSubtitle => 'Еженедельный график';

  @override
  String get openingHoursAlwaysOpen => 'Открыто 24/7';

  @override
  String get openingHoursClosed => 'Закрыто';

  @override
  String get locationFullWarning => 'Выбранная локация заполнена.';

  @override
  String get locationClosedWarning => 'Выбранная локация сейчас закрыта.';

  @override
  String get locationInactiveWarning => 'Выбранная локация неактивна.';

  @override
  String get protectionLevelTitle => 'Уровень защиты';

  @override
  String get protectionStandard => 'Стандарт';

  @override
  String get protectionPremium => 'Премиум-защита';

  @override
  String get paymentMethodTitle => 'Способ оплаты';

  @override
  String get paymentMethodCard => 'Карта';

  @override
  String get paymentMethodInstallment => 'Рассрочка';

  @override
  String get paymentMethodPayAtHotel => 'Оплата в отеле';

  @override
  String get paymentHotelCommissionNote =>
      'Будет добавлена комиссия отеля 5 %.';

  @override
  String get paymentStartAction => 'Начать оплату';

  @override
  String get paymentRequiredBeforeDropMessage =>
      'Сдача невозможна до завершения оплаты.';

  @override
  String get paymentNotCompletedMessage =>
      'Оплату нужно завершить перед сдачей.';

  @override
  String get paymentCompletedMessage => 'Оплата завершена. Можно сдать багаж.';

  @override
  String get paymentPageTitle => 'Оплата';

  @override
  String get paymentPageSubtitle =>
      'Введите данные карты, чтобы завершить оплату.';

  @override
  String get paymentCardNumberLabel => 'Номер карты';

  @override
  String get paymentCardNameLabel => 'Имя на карте';

  @override
  String get paymentExpiryLabel => 'Срок действия';

  @override
  String get paymentCvcLabel => 'CVC';

  @override
  String get paymentCompleteAction => 'Завершить оплату';

  @override
  String get paymentFormIncompleteMessage => 'Заполните все данные карты.';

  @override
  String get paymentFailedMessage => 'Не удалось завершить оплату.';

  @override
  String get paymentSuccessMessage => 'Платёж успешно получен';

  @override
  String get paymentCardNumberInvalidMessage =>
      'Номер карты должен содержать 16 цифр.';

  @override
  String get paymentExpiryInvalidMessage =>
      'Срок действия должен быть в формате ММ/ГГ.';

  @override
  String get paymentCvvInvalidMessage => 'CVV должен быть 3 или 4 цифры.';

  @override
  String get paymentPayAtHotelTitle => 'Оплата в отеле';

  @override
  String get paymentPayAtHotelBody =>
      'Вы можете завершить оплату в выбранной локации.';

  @override
  String paymentTotalLabel(Object amount) {
    return 'Итого: $amount TRY';
  }

  @override
  String get installmentCountLabel => 'Количество платежей';

  @override
  String get pricingEstimateTitle => 'Предварительная стоимость';

  @override
  String get pricingEstimateLoading => 'Расчёт стоимости...';

  @override
  String get pricingBasePriceLabel => 'Базовая цена';

  @override
  String get pricingPremiumFeeLabel => 'Премиум-защита';

  @override
  String get pricingHotelCommissionLabel => 'Комиссия отеля';

  @override
  String get pricingInstallmentFeeLabel => 'Наценка за рассрочку';

  @override
  String get pricingTotalLabel => 'Итого';

  @override
  String get pricingTierLabel => 'Временной диапазон';

  @override
  String get pricingPriceLabel => 'Предварительная цена';

  @override
  String get pricingTier0To6 => '0–6 часов';

  @override
  String get pricingTier6To24 => '6–24 часа';

  @override
  String pricingTierDaily(Object days) {
    return '$days дней';
  }

  @override
  String get pricingInvalidRangeMessage =>
      'Время получения должно быть позже времени сдачи.';

  @override
  String get pricingQuoteFailedMessage => 'Не удалось рассчитать цену';

  @override
  String get pricingSummaryTitle => 'Сводка цены';

  @override
  String get pricingSummaryEdit => 'Изменить';

  @override
  String get pricingSummarySizeLabel => 'Размер';

  @override
  String get pricingSummaryDurationLabel => 'Длительность';

  @override
  String get pricingSummaryAmountLabel => 'Сумма';

  @override
  String get pricingEstimateDisclaimer =>
      'Это оценка, итоговая сумма может измениться по фактическому времени сдачи.';

  @override
  String get pricingEstimateUnavailable =>
      'Выберите время сдачи и получения, чтобы увидеть оценку.';

  @override
  String get pickupPinSentMessage =>
      'PIN для получения отправлен на вашу почту.';

  @override
  String get pickupPinFailedMessage =>
      'Не удалось отправить PIN. Попробуйте позже.';

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
  String get luggageDelegateAction => 'Передать аварийному контакту';

  @override
  String get delegateInfoRequiredMessage =>
      'Заполните данные аварийного контакта.';

  @override
  String get howItWorksTitle => 'Как это работает';

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
  String get pickupPinTitle => 'PIN выдачи';

  @override
  String get pickupPinLabel => 'PIN выдачи';

  @override
  String get pickupPinHint => '4-значный PIN';

  @override
  String pickupPinGenerated(Object pin) {
    return 'PIN выдачи: $pin';
  }

  @override
  String get pickupPinRequiredMessage => 'Нужен PIN выдачи.';

  @override
  String get pickupPinInvalidMessage => 'PIN неверный. Попробуйте снова.';

  @override
  String get delegateSetupTitle => 'Доверенное лицо';

  @override
  String get delegateNameLabel => 'Полное имя';

  @override
  String get delegatePhoneLabel => 'Телефон';

  @override
  String get delegateEmailLabel => 'E-mail';

  @override
  String get delegateCodeTitle => 'Код доверенного лица';

  @override
  String get delegateCodeLabel => 'Код доверенного лица';

  @override
  String get delegateCodeHint => '6-значный код';

  @override
  String delegateCodeGenerated(Object code) {
    return 'Код доверенного лица: $code';
  }

  @override
  String get delegateCodeRequiredMessage => 'Нужен код доверенного лица.';

  @override
  String get delegateCodeInvalidMessage => 'Код доверенного лица неверный.';

  @override
  String get delegateCodeExpiredMessage =>
      'Срок действия кода доверенного лица истек.';

  @override
  String get delegateCodeUsedMessage => 'Код доверенного лица уже использован.';

  @override
  String get delegateSavedMessage => 'Доверенное лицо сохранено.';

  @override
  String get delegateEmergencyCodeTitle => 'Экстренный код';

  @override
  String get ownerInfoTitle => 'Данные владельца';

  @override
  String get ownerNameLabel => 'Полное имя';

  @override
  String get ownerPhoneLabel => 'Телефон';

  @override
  String get ownerEmailLabel => 'E-mail';

  @override
  String get pickupPinSafetyWarning =>
      'Сохраните PIN и никому не сообщайте. Он понадобится при выдаче.';

  @override
  String get pickupPinCopiedMessage =>
      'PIN скопирован — храните его в безопасном месте.';

  @override
  String get copy => 'Копировать';

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
