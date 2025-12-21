// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'KYRADI';

  @override
  String get dashboard => 'Inicio';

  @override
  String get profile => 'Perfil';

  @override
  String get settings => 'Configuración';

  @override
  String get findLocation => 'Encontrar mi ubicación';

  @override
  String get destination => 'Destino';

  @override
  String get transitRoute => 'Ruta de transporte público';

  @override
  String get myLuggages => 'Mis maletas';

  @override
  String get total => 'Total';

  @override
  String get addLuggageQr => 'Agregar equipaje (QR)';

  @override
  String get newLuggageAdded => 'Nuevo equipaje agregado ✅';

  @override
  String get save => 'Guardar';

  @override
  String get saveProfile => 'Perfil guardado ✅';

  @override
  String get saveProfileError => 'Error al guardar';

  @override
  String get userInfo => 'Información del usuario';

  @override
  String get map => 'Mapa';

  @override
  String get mapIntro =>
      'Consulta los puntos BavulGO en el mapa y planifica la mejor ruta.';

  @override
  String get walkingRoute => 'Ruta a pie';

  @override
  String get drivingRoute => 'Ruta en coche';

  @override
  String get openInMaps => 'Abrir en Google Maps';

  @override
  String get routeOptions => 'Opciones de ruta';

  @override
  String get firstName => 'Nombre';

  @override
  String get lastName => 'Apellido';

  @override
  String get fullNameLabel => 'Nombre completo';

  @override
  String get phone => 'Teléfono';

  @override
  String get email => 'Correo electrónico';

  @override
  String get address => 'Dirección';

  @override
  String get birthDate => 'Fecha de nacimiento';

  @override
  String get gender => 'Género';

  @override
  String get emergencyContact => 'Contacto de emergencia';

  @override
  String get note => 'Nota / Descripción';

  @override
  String get cameraPermission => 'Permiso de cámara';

  @override
  String get cameraPermissionDesc => 'Requerido para escanear QR';

  @override
  String get locationPermission => 'Permiso de ubicación';

  @override
  String get locationPermissionDesc =>
      'Requerido para transporte público y funciones de ubicación';

  @override
  String get notificationPermission => 'Permiso de notificación';

  @override
  String get notificationPermissionDesc =>
      'Para recordatorios y actualizaciones';

  @override
  String get inAppNotifications => 'Notificaciones en la aplicación';

  @override
  String get notificationSound => 'Sonido de notificación';

  @override
  String get notificationVibrate => 'Vibración';

  @override
  String get account => 'Cuenta';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get logout => 'Cerrar sesión';

  @override
  String get about => 'Acerca de';

  @override
  String get aboutApp => 'Esta aplicación fue desarrollada por KYRADI.';

  @override
  String get qrCode => 'Código QR';

  @override
  String get weight => 'Peso (kg)';

  @override
  String get size => 'Tamaño';

  @override
  String get color => 'Color';

  @override
  String get small => 'Pequeño';

  @override
  String get medium => 'Mediano';

  @override
  String get large => 'Grande';

  @override
  String get black => 'Negro';

  @override
  String get red => 'Rojo';

  @override
  String get blue => 'Azul';

  @override
  String get grey => 'Gris';

  @override
  String get other => 'Otro';

  @override
  String get saveLuggage => 'Guardar equipaje';

  @override
  String get qrEmptyError => 'El código QR no puede estar vacío ❌';

  @override
  String get oldPassword => 'Contraseña anterior';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmNewPassword => 'Confirmar nueva contraseña';

  @override
  String get passwordChanged => 'Contraseña cambiada ✅';

  @override
  String get passwordMismatch => 'Las nuevas contraseñas no coinciden ❌';

  @override
  String get languageChanged => 'Idioma cambiado ✅';

  @override
  String permissionGranted(Object permission) {
    return 'Permiso de $permission concedido ✅';
  }

  @override
  String permissionDenied(Object permission) {
    return 'Permiso de $permission denegado ❌';
  }

  @override
  String permissionDeniedForever(Object permission) {
    return 'Permiso de $permission denegado permanentemente, actívalo en la configuración ⚙️';
  }

  @override
  String locationReceived(Object lat, Object lng) {
    return 'Ubicación recibida 📍 $lat, $lng';
  }

  @override
  String get locationFailed => 'No se pudo obtener la ubicación ❌';

  @override
  String get profileSaved => 'Perfil guardado ✅';

  @override
  String get profileSaveError => 'No se pudo guardar el perfil ❌';

  @override
  String get logoutSuccess => 'Cierre de sesión exitoso 👋';

  @override
  String get copyrightNotice => '© 2025 KYRADI. Todos los derechos reservados.';

  @override
  String get demoMapComingSoon => 'El módulo de mapas se abrirá pronto.';

  @override
  String demoLuggageButton(Object number) {
    return 'Equipaje $number';
  }

  @override
  String demoLuggageSelected(Object label) {
    return 'Se seleccionó $label.';
  }

  @override
  String get demoFirstNameValue => 'Deniz';

  @override
  String get demoLastNameValue => 'Gezensoy';

  @override
  String get demoNationalIdValue => '12345678901';

  @override
  String get demoAddressValue => 'Estambul, Turquía';

  @override
  String get demoEmergencyNameValue => 'Merve Sönmez';

  @override
  String get demoEmergencyAddressValue => 'Kadıköy, Estambul';

  @override
  String get demoEmergencyEmailValue => 'merve@example.com';

  @override
  String get demoEmergencyRelationValue => 'Hermano/a o familiar cercano';

  @override
  String get emergencyContactNote =>
      'Esta persona será contactada en emergencias.';

  @override
  String get introTagline => 'Sistema global de equipaje';

  @override
  String get introTrackButton => 'Rastrear';

  @override
  String get serverButtonLabel => 'Servidor';

  @override
  String serverStatus(Object host) {
    return 'Servidor: $host';
  }

  @override
  String get loginHeroSubtitle =>
      'Administra tu equipaje después de iniciar sesión.';

  @override
  String get loginFormTitle => 'Datos de inicio de sesión';

  @override
  String get loginFormSubtitle =>
      'Conéctate al servidor más actualizado para iniciar sesión.';

  @override
  String get emailHint => 'ejemplo@mail.com';

  @override
  String get passwordLabel => 'Contraseña';

  @override
  String get passwordHint => '••••••';

  @override
  String get validationEmailRequired => 'El correo es obligatorio';

  @override
  String get validationEmailInvalid => 'Introduce un correo válido';

  @override
  String get validationPasswordRequired => 'La contraseña es obligatoria';

  @override
  String validationMinChars(Object count) {
    return 'Escribe al menos $count caracteres';
  }

  @override
  String get loginForgotPassword => 'Olvidé mi contraseña';

  @override
  String get clearButton => 'Limpiar';

  @override
  String get loginButtonLabel => 'Iniciar sesión';

  @override
  String get loginNoAccount => '¿No tienes cuenta?';

  @override
  String get registerButtonLabel => 'Registrarse';

  @override
  String get loginSuccess => 'Inicio de sesión exitoso ✅';

  @override
  String get loginInvalidCredentials => 'Correo o contraseña incorrectos ❌';

  @override
  String get loginTooManyAttempts =>
      'Demasiados intentos, inténtalo de nuevo en unos minutos ⚠️';

  @override
  String get loginFailed => 'El inicio de sesión falló, inténtalo de nuevo ❌';

  @override
  String genericErrorWithDetails(Object details) {
    return 'Ocurrió un error: $details';
  }

  @override
  String get loginVerificationRequired => 'Verifica tu cuenta 📨';

  @override
  String verificationSendFailedWithDetails(Object details) {
    return 'No se pudo enviar el código de verificación: $details';
  }

  @override
  String get registerTitle => 'Crear cuenta';

  @override
  String get registerPersonalSectionTitle => 'Información personal';

  @override
  String get registerPersonalSectionSubtitle =>
      'Comparte tu identidad y fecha de nacimiento.';

  @override
  String get genderMale => 'Hombre';

  @override
  String get genderFemale => 'Mujer';

  @override
  String get genderUndisclosed => 'Prefiero no decir';

  @override
  String get registerContactSectionTitle => 'Información de contacto';

  @override
  String get registerContactSectionSubtitle =>
      'Tu correo y datos de verificación';

  @override
  String get nationalIdLabel => 'Número de identificación';

  @override
  String get phoneHint => '+90 5xx xxx xx xx';

  @override
  String get registerSecuritySectionTitle => 'Seguridad';

  @override
  String get registerSecuritySectionSubtitle =>
      'Define y confirma tu contraseña';

  @override
  String get registerPasswordRepeatLabel => 'Repite la contraseña';

  @override
  String get registerCaptchaLabel => 'No soy un robot';

  @override
  String get registerCaptchaWarning => 'Marca \"No soy un robot\"';

  @override
  String get registerKvkkAgreementLabel =>
      'He leído y acepto el aviso de privacidad KVKK de KYRADI.';

  @override
  String get registerKvkkAgreementWarning =>
      'Acepta el aviso de privacidad KVKK.';

  @override
  String get registerRestrictedAgreementLabel =>
      'He leído y acepto la lista de artículos rechazados por Aparial y las empresas de transporte.';

  @override
  String get registerRestrictedAgreementWarning =>
      'Confirma el documento de artículos restringidos.';

  @override
  String get registerAgreementView => 'Ver documento';

  @override
  String get registerKvkkDialogTitle => 'KYRADI – Aviso de Privacidad KVKK';

  @override
  String get registerRestrictedDialogTitle =>
      'Artículos rechazados por Aparial y las empresas de transporte';

  @override
  String get registerSuccessMessage =>
      'Registro exitoso ✅ Se envió el correo de verificación.';

  @override
  String get registerEmailExistsMessage => 'Este correo ya está registrado ❌';

  @override
  String get registerGenericErrorMessage => 'El registro falló ❌';

  @override
  String get validationRequired => 'Obligatorio';

  @override
  String get validationPasswordNeedsLetter => 'Incluye al menos una letra';

  @override
  String get validationPasswordNeedsNumber => 'Incluye al menos un número';

  @override
  String get validationPasswordRepeatRequired => 'Repite tu contraseña';

  @override
  String get validationNationalIdRequired =>
      'El número de identificación es obligatorio';

  @override
  String get validationNationalIdLength => 'El ID debe tener 11 dígitos';

  @override
  String get validationNationalIdChecksumTen => 'ID no válido (10.º dígito)';

  @override
  String get validationNationalIdChecksumEleven => 'ID no válido (11.º dígito)';

  @override
  String get validationNationalIdInvalid => 'ID no válido';

  @override
  String get validationPhoneRequired => 'El teléfono es obligatorio';

  @override
  String get validationPhoneFormat => 'Formato: +90 5xx xxx xx xx';

  @override
  String get validationBirthDateRequired =>
      'Selecciona una fecha de nacimiento';

  @override
  String get validationAgeRequirement => 'Debes tener más de 18 años';

  @override
  String get formNotSelected => 'Sin seleccionar';

  @override
  String get forgotTitle => 'Olvidé mi contraseña';

  @override
  String get forgotIntro =>
      'Enviemos un código a tu correo registrado para restablecer tu contraseña.';

  @override
  String get forgotEmailSectionTitle => 'Verificación de correo';

  @override
  String get forgotEmailSectionSubtitle =>
      'Se enviará un código de un solo uso a tu dirección registrada.';

  @override
  String get emailAddressLabel => 'Dirección de correo';

  @override
  String get forgotSendButton => 'Enviar código';

  @override
  String forgotResendCountdown(int seconds) {
    return 'Enviar de nuevo (${seconds}s)';
  }

  @override
  String get forgotAlreadyHaveCode => 'Ya tengo un código';

  @override
  String get forgotNeedValidEmail => 'Ingresa primero un correo válido 💌';

  @override
  String get forgotCodeSent => 'Código enviado 📩';

  @override
  String get forgotEmailNotFound => 'Este correo no está registrado ❌';

  @override
  String get forgotTooManyAttempts =>
      'Demasiados intentos, inténtalo de nuevo en 1 minuto ⚠️';

  @override
  String get forgotCodeFailed => 'No se pudo enviar el código ❌';

  @override
  String get resetTitle => 'Restablecer contraseña';

  @override
  String get resetSubtitle =>
      'Introduce el código enviado a este correo y crea una nueva contraseña.';

  @override
  String get verificationCodeLabel => 'Código de verificación';

  @override
  String get resetNewPasswordLabel => 'Nueva contraseña';

  @override
  String get resetConfirmPasswordLabel => 'Nueva contraseña (repite)';

  @override
  String get resetSubmitButton => 'Restablecer contraseña';

  @override
  String get unknownError => 'Error desconocido';

  @override
  String get verificationTitle => 'Verificación de correo';

  @override
  String verificationInstructions(Object email) {
    return 'Ingresa el código de 6 dígitos enviado a $email.';
  }

  @override
  String get verifyButtonLabel => 'Verificar código';

  @override
  String get verificationResendButton => 'Enviar código otra vez';

  @override
  String verificationCountdownLabel(int seconds) {
    return 'Enviar de nuevo en ${seconds}s';
  }

  @override
  String get verificationResentMessage => 'Código enviado de nuevo';

  @override
  String get verificationSendErrorMessage => 'Error al enviar';

  @override
  String get verificationMissingEmailMessage => 'No se pudo obtener el correo';

  @override
  String get verificationSuccessMessage => 'Cuenta verificada ✅';

  @override
  String get verificationErrorMessage => 'Error de verificación';

  @override
  String get verificationCodeInvalidMessage => 'El código debe tener 6 dígitos';

  @override
  String get validationVerificationCodeRequired => 'El código es obligatorio';

  @override
  String get validationVerificationCodeLength =>
      'Introduce un código de 6 dígitos';

  @override
  String dashboardGreeting(Object name) {
    return 'Hola, $name';
  }

  @override
  String get dashboardSubtitle =>
      'Comparte tu ubicación y administra tu equipaje.';

  @override
  String dashboardTotalCount(Object count) {
    return 'Total $count';
  }

  @override
  String get travelerPlaceholder => 'Viajero';

  @override
  String get quickAddLuggage => 'Agregar equipaje';

  @override
  String get quickTransit => 'Transporte público';

  @override
  String get dashboardMetricAwaiting => 'Pendiente de entrega';

  @override
  String get dashboardMetricStored => 'Almacenado';

  @override
  String get dashboardMetricPicked => 'Retirado';

  @override
  String get dashboardMetricCancelled => 'Cancelado';

  @override
  String get deliverySectionTitle => 'Entrega y ruta';

  @override
  String get deliverySectionSubtitle =>
      'Elige un punto de entrega y abre la ruta.';

  @override
  String get deliveryPointLabel => 'Punto de entrega';

  @override
  String deliveryPointOption(Object name, int available, int total) {
    return '$name • Libre $available/$total';
  }

  @override
  String deliveryPointSelected(Object name) {
    return 'Punto de entrega seleccionado: $name ✅';
  }

  @override
  String get routeNeedLocation => 'Primero usa «Encontrar mi ubicación».';

  @override
  String get routeNeedDestination => 'Ingresa un destino.';

  @override
  String get mapsOpenFailed => 'No se pudo abrir Google Maps.';

  @override
  String get reservationSectionTitle => 'Estados de reserva';

  @override
  String get reservationSectionSubtitle =>
      'Consulta la disponibilidad y los detalles de ocupación.';

  @override
  String get luggagesSectionSubtitle =>
      'Muestra códigos QR y completa los pasos de entrega/recogida.';

  @override
  String get newLuggageButton => 'Nuevo equipaje';

  @override
  String get luggageFilterAll => 'Todos';

  @override
  String get luggageFilterAwaiting => 'Pendiente de entrega';

  @override
  String get luggageFilterStored => 'Almacenado';

  @override
  String get luggageFilterPicked => 'Retirado';

  @override
  String get luggageEmptyStateNoItems =>
      'Aún no hay equipaje. ¡Agrega tu primera maleta!';

  @override
  String get luggageEmptyStateFiltered =>
      'No se encontró equipaje para este filtro.';

  @override
  String get profileInfoSubtitle =>
      'Mantén actualizada tu información de contacto.';

  @override
  String get emergencySectionSubtitle =>
      'Agrega un contacto de confianza para mayor seguridad.';

  @override
  String get relationLabel => 'Relación';

  @override
  String get emergencyRegisteredPerson => 'Contacto registrado';

  @override
  String get identitySectionTitle => 'ID / Pasaporte';

  @override
  String get identitySectionSubtitle =>
      'Carga el documento que mostrarás durante las entregas.';

  @override
  String get identityPreviewHint =>
      'La vista previa del documento aparecerá aquí';

  @override
  String get identityDocIdCard => 'Documento de identidad';

  @override
  String get identityDocPassport => 'Pasaporte';

  @override
  String identityUploaded(Object file) {
    return 'Documento cargado: $file';
  }

  @override
  String get identityMissing =>
      'Aún no se ha cargado un documento. Se requiere foto de ID o pasaporte para las entregas.';

  @override
  String get identityTakePhoto => 'Tomar con la cámara';

  @override
  String get identityPickFromGallery => 'Elegir de la galería';

  @override
  String get identityDelete => 'Eliminar documento';

  @override
  String identityPhotoSaved(Object docType) {
    return 'Foto de $docType guardada ✅';
  }

  @override
  String identityUploadFailed(Object details) {
    return 'No se pudo subir el documento: $details';
  }

  @override
  String get identityRemoved => 'Documento eliminado.';

  @override
  String get identityProofRequired =>
      'Sube una foto de tu ID o pasaporte antes de continuar.';

  @override
  String get profileDataMissing =>
      'No se pudieron cargar los datos del perfil.';

  @override
  String profileLoadFailed(Object details) {
    return 'No se pudo cargar el perfil: $details';
  }

  @override
  String get profileUserMissing =>
      'Usuario no encontrado. Inicia sesión nuevamente.';

  @override
  String get luggageLocationMissing =>
      'No hay información de ubicación para este equipaje.';

  @override
  String luggageInfoSize(Object value) {
    return 'Tamaño: $value';
  }

  @override
  String luggageInfoWeight(Object value) {
    return 'Peso: $value kg';
  }

  @override
  String luggageInfoColor(Object value) {
    return 'Color: $value';
  }

  @override
  String noteLabel(Object note) {
    return 'Nota: $note';
  }

  @override
  String scheduledDropLabel(Object date) {
    return 'Entrega planificada: $date';
  }

  @override
  String scheduledPickupLabel(Object date) {
    return 'Recogida planificada: $date';
  }

  @override
  String get reservationCancelledLabel => 'Esta reserva ha sido cancelada.';

  @override
  String get luggageShowQr => 'Mostrar código QR';

  @override
  String get luggageDropAction => 'Dejé el equipaje';

  @override
  String get luggagePickupAction => 'Recoger equipaje';

  @override
  String get luggageCancelAction => 'Cancelar reserva';

  @override
  String get luggageOpenLocation => 'Abrir ubicación';

  @override
  String createdAtLabel(Object date) {
    return 'Creado: $date';
  }

  @override
  String dropConfirmedAtLabel(Object date) {
    return 'Entrega confirmada: $date';
  }

  @override
  String pickupConfirmedAtLabel(Object date) {
    return 'Recogida confirmada: $date';
  }

  @override
  String get loginRequired => 'Inicia sesión primero.';

  @override
  String get luggageCreated => 'Nuevo equipaje creado ✅';

  @override
  String get dropConfirmedMessage => 'Entrega confirmada ✅';

  @override
  String get pickupConfirmedMessage => 'Recogida completada ✅';

  @override
  String get operationFailed => 'No se pudo completar la operación.';

  @override
  String operationFailedWithDetails(Object details) {
    return 'La operación no se completó: $details';
  }

  @override
  String get reservationCancelledMessage => 'Reserva cancelada.';

  @override
  String get cancelFailed => 'No se pudo cancelar.';

  @override
  String cancelFailedWithDetails(Object details) {
    return 'La cancelación falló: $details';
  }

  @override
  String get cancelReservationTitle => 'Cancelar reserva';

  @override
  String cancelReservationMessage(Object label) {
    return '¿Seguro que deseas cancelar la reserva de “$label”?';
  }

  @override
  String get dialogDismiss => 'Cancelar';

  @override
  String get dialogConfirmCancel => 'Cancelar';

  @override
  String get dialogConfirm => 'Sí';

  @override
  String reservationTileTitle(Object code) {
    return 'Reserva $code';
  }

  @override
  String reservationTileSubtitle(Object code, Object time) {
    return '$code • $time';
  }

  @override
  String reservationSlotSummary(int count, Object time) {
    return '$count equipajes • $time';
  }

  @override
  String get notificationsTooltip => 'Notificaciones';

  @override
  String get notificationsClearTooltip => 'Limpiar';

  @override
  String get notificationsEmptyTitle => 'No hay notificaciones aún';

  @override
  String get notificationsEmptySubtitle =>
      'Tus notificaciones aparecerán aquí cuando inicies sesión o empieces a usar la app.';

  @override
  String get notificationTypeSuccess => 'Éxito';

  @override
  String get notificationTypeWarning => 'Advertencia';

  @override
  String get notificationTypeError => 'Error';

  @override
  String get notificationTypeInfo => 'Información';

  @override
  String get notificationsRelativeNow => 'Justo ahora';

  @override
  String notificationsRelativeSeconds(int count) {
    return 'Hace $count s';
  }

  @override
  String notificationsRelativeMinutes(int count) {
    return 'Hace $count min';
  }

  @override
  String notificationsRelativeHours(int count) {
    return 'Hace $count h';
  }

  @override
  String notificationsRelativeDays(int count) {
    return 'Hace $count d';
  }

  @override
  String get mapNoLocations => 'No se encontraron ubicaciones.';

  @override
  String get locationServiceDisabled =>
      'El servicio de ubicación está desactivado.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'El permiso de ubicación se denegó permanentemente. Actívalo desde la configuración.';

  @override
  String locationFailedWithDetails(Object details) {
    return 'No se pudo obtener la ubicación: $details';
  }

  @override
  String get locationNotFoundTitle => 'Ubicación no encontrada';

  @override
  String get locationNotFoundMessage =>
      'La ubicación seleccionada ya no está disponible.';

  @override
  String get permissionManageButton => 'Gestionar';

  @override
  String get settingsPermissionsTitle => 'Permisos';

  @override
  String get settingsPermissionsSubtitle =>
      'Administra los permisos de cámara, ubicación y notificaciones.';

  @override
  String get privacySectionTitle => 'Privacidad';

  @override
  String get privacySectionSubtitle =>
      'Ajusta las preferencias de notificaciones en la app.';

  @override
  String get remindersSectionTitle => 'Recordatorios';

  @override
  String get remindersSectionSubtitle =>
      'Elige alertas para entrega y recogida.';

  @override
  String get pushRemindersLabel => 'Notificaciones push';

  @override
  String get emailRemindersLabel => 'Recordatorios por correo';

  @override
  String get languageSectionTitle => 'Idioma';

  @override
  String get languageSectionSubtitle => 'Elige el idioma de la app.';

  @override
  String get languageNameTr => 'Turco';

  @override
  String get languageNameEn => 'Inglés';

  @override
  String get languageNameDe => 'Alemán';

  @override
  String get languageNameEs => 'Español';

  @override
  String get languageNameRu => 'Ruso';

  @override
  String languageChangedTo(Object language) {
    return 'Idioma cambiado a $language ✅';
  }

  @override
  String get upcomingReservationsTitle => 'Reservas próximas';

  @override
  String get upcomingReservationsSubtitle =>
      'Los nombres se mantienen ocultos; solo se muestran los códigos y la capacidad.';

  @override
  String get upcomingReservationsEmpty =>
      'No hay reservas planificadas para esta ubicación.';

  @override
  String get continueSectionTitle => 'Continuar';

  @override
  String get continueSectionSubtitle =>
      'Si ya eres miembro inicia sesión; de lo contrario regístrate rápido.';

  @override
  String get accountSectionSubtitle => 'Cambia tu contraseña o cierra sesión.';

  @override
  String get logoutDialogTitle => 'Cerrar sesión';

  @override
  String get logoutDialogMessage => '¿Quieres cerrar sesión?';

  @override
  String get changePasswordIntro => 'Güvenliğin için yeni şifreni belirle.';

  @override
  String get changePasswordRequirementHint =>
      'En az 8 karakter, harf ve rakam içermeli.';

  @override
  String get userIdMissing => 'No has iniciado sesión: no se encontró userId.';

  @override
  String userIdReadFailed(Object details) {
    return 'No se pudo leer el userId: $details';
  }

  @override
  String get mapsMissingApiKey =>
      'La clave de Google Maps no está configurada.';

  @override
  String routeFetchFailedWithDetails(Object details) {
    return 'No se pudo obtener la ruta: $details';
  }

  @override
  String get routeNotFound => 'No se encontró ruta.';

  @override
  String get routeDataMissing => 'No se pudieron obtener los datos de la ruta.';

  @override
  String directionsApiError(Object status) {
    return 'La API de Google Directions falló: $status. Verifica que la clave tenga acceso a Directions.';
  }

  @override
  String get reservationEmptyState => 'No hay reservas programadas.';

  @override
  String availableSlotsLabel(int available, int total) {
    return 'Libre $available/$total';
  }

  @override
  String get qrDropTitle => 'Confirmar entrega con QR';

  @override
  String get qrPickupTitle => 'Confirmar recogida con QR';

  @override
  String get qrManualEntryHint =>
      'Si no puedes escanear el QR, introdúcelo manualmente.';

  @override
  String get qrVerifyButton => 'Verificar';

  @override
  String get qrMismatchMessage =>
      'El código QR no coincide. Inténtalo de nuevo.';

  @override
  String get qrCopied => 'Código QR copiado.';

  @override
  String get qrTextCopied => 'Texto copiado.';

  @override
  String get qrCopyCode => 'Copiar código';

  @override
  String get qrCopyPrintable => 'Copiar texto para imprimir';

  @override
  String get qrShareInstructions =>
      'Comparte este código con el personal para imprimir la pegatina. El cliente debe escanearlo al dejar y recoger.';

  @override
  String get qrDuplicateWarning =>
      'Este código QR ya está en uso. Generamos uno nuevo, inténtalo otra vez.';

  @override
  String get qrScanTip =>
      'Asegúrate de que el código esté nítido dentro del marco.';

  @override
  String get locationFetching => 'Obteniendo ubicación...';

  @override
  String get refreshNearbyButton => 'Actualizar ubicaciones cercanas';

  @override
  String get nearbyLocationsTitle => 'Ubicaciones cercanas';

  @override
  String get commonSelect => 'Seleccionar';

  @override
  String get landingTitle => 'BavulGO Track';

  @override
  String get landingIntro =>
      'Elige dónde dejar tu equipaje. Toca un punto en el mapa para ver su ocupación y abrir los detalles de la reserva.';

  @override
  String get landingLocateSectionTitle => 'Encuentra los puntos más cercanos';

  @override
  String get landingLocateSectionSubtitle =>
      'Comparte tu ubicación para mostrar recomendaciones.';

  @override
  String get landingLocateButton => 'Encontrar mi ubicación';

  @override
  String get landingLocatingButton => 'Obteniendo ubicación...';

  @override
  String get landingNearestTitle => 'Puntos más cercanos';

  @override
  String get landingNearestSubtitle =>
      '3 lugares recomendados según tu ubicación';

  @override
  String get landingGoButton => 'Ir';

  @override
  String get landingDetailsButton => 'Detalles';

  @override
  String get dropTimePending => 'Hora de entrega no seleccionada';

  @override
  String dropTimeLabel(Object time) {
    return 'Hora de entrega: $time';
  }

  @override
  String get pickupTimePending => 'Hora de recogida no seleccionada';

  @override
  String pickupTimeLabel(Object time) {
    return 'Hora de recogida: $time';
  }

  @override
  String get scheduleTimesRequired =>
      'Debes elegir la hora de entrega y recogida.';

  @override
  String get notesHint => 'Candado, frágil, instrucciones especiales...';

  @override
  String get luggageNameHint => 'Ponle un nombre al equipaje (opcional)';

  @override
  String get luggageRegistrationNote =>
      'Después de guardar, tu personal puede imprimir la pegatina QR. El cliente debe escanear el código al dejar y recoger.';

  @override
  String get luggageCreateFailed => 'No se pudo crear el equipaje.';

  @override
  String get savingInProgress => 'Guardando...';

  @override
  String get statusLabel => 'Estado';

  @override
  String get permissionNameCamera => 'Cámara';

  @override
  String get permissionNameLocation => 'Ubicación';

  @override
  String get permissionNameNotifications => 'Notificaciones';

  @override
  String get footerCopyright => '@2025 aparial.com';

  @override
  String get green => 'Verde';

  @override
  String get qrRegenerate => 'Regenerar';

  @override
  String get locationPermissionDenied => 'Permiso de ubicación no concedido.';

  @override
  String get dropDatePickerHelp => 'Fecha de entrega';

  @override
  String get pickupDatePickerHelp => 'Fecha de recogida';

  @override
  String get addLuggageTitle => 'Crear equipaje';

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
