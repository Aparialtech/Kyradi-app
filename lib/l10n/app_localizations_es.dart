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
      'Consulta los puntos KYRADI en el mapa y planifica la mejor ruta.';

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
  String get locationLabel => 'Location';

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
  String get sizeSmallDimensions => 'máx 55x40x20 cm';

  @override
  String get sizeMediumDimensions => 'máx 65x45x25 cm';

  @override
  String get sizeLargeDimensions => 'más de 65x45x25 cm';

  @override
  String get sizeSmallNote => 'Apto para equipaje de cabina y mochilas';

  @override
  String get sizeSelectionNote =>
      'El tamaño se verifica al entregar; el precio puede actualizarse si la selección es incorrecta.';

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
  String get splashSlogan => 'Leave your luggage, explore the city';

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
  String get loginSocialDivider => 'o';

  @override
  String get loginContinueWithGoogle => 'Continuar con Google';

  @override
  String get loginContinueWithApple => 'Continuar con Apple';

  @override
  String loginSocialComingSoon(Object provider) {
    return '$provider estará disponible pronto.';
  }

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
  String get genericErrorMessage => 'Ocurrió un error.';

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
  String get registerKvkkDocumentBody =>
      'Aviso de Protección y Tratamiento de Datos Personales\nEste texto explica el alcance y los fines del tratamiento de los datos personales procesados dentro de la plataforma KYRADI, de conformidad con la Ley turca de Protección de Datos Personales N.º 6698 (\"KVKK\").\n\nTipos de datos personales tratados\nEn KYRADI se tratan los siguientes grupos de datos:\nDatos del cliente:\nNombre y apellidos, teléfono, token de QR, información de reserva y taquilla, importe del pago y número de transacción\nDatos del personal:\nNombre y apellidos, correo electrónico, rol de usuario, IP, registros de transacciones, información de sesión\nDatos técnicos:\nRegistros de auditoría, información del navegador/dispositivo, informes de errores\n\nFinalidades del tratamiento\nLos datos personales se tratan para proporcionar el flujo de reservas, generar y verificar códigos QR, gestionar los intentos de pago, operar los procesos de entrega y recogida de equipaje, garantizar la seguridad del sistema y detectar abusos, cumplir obligaciones legales de conservación, y para informes y mejoras de la plataforma.\n\nBase legal\nLos datos personales se tratan conforme al Art. 5/2-c de la KVKK (celebración y ejecución del contrato), Art. 5/2-f (interés legítimo), Art. 5/2-ç (obligaciones legales) y consentimiento explícito cuando sea necesario.\n\nDestinatarios de las transferencias\nLos datos personales pueden transferirse a proveedores de servicios de pago como Stripe e Iyzico, proveedores de nube como AWS, Google Cloud, Render y Vercel para infraestructura y alojamiento, autoridades públicas en casos obligatorios y asesores legales o financieros.\n\nPlazos de conservación\nLos datos personales se conservan durante 10 años para registros de reservas y pagos, 2 años para registros de auditoría y 1 año después del cierre de la cuenta para cuentas de usuario; los tokens de QR se conservan de 1 a 24 horas.\n\nMedidas de seguridad\nKYRADI aplica medidas técnicas y administrativas como aislamiento de datos por inquilino, hash de contraseñas, seguridad basada en JWT, control de acceso por roles, limitación de tasa y prevención de ataques, y registros de auditoría para acciones críticas.\n\nDerechos del interesado\nSegún el Artículo 11 de la KVKK, los interesados tienen derecho a saber si sus datos personales se procesan, solicitar la eliminación o corrección, oponerse al tratamiento y reclamar compensación en caso de daño.\n\nLas solicitudes pueden enviarse a kvkk@kyradi.com.';

  @override
  String get registerRestrictedDocumentBody =>
      'Este documento resume los artículos que Aparial y las empresas de transporte generales no aceptan.\nPor razones de seguridad, normativas legales y riesgos operativos, los siguientes artículos no se aceptan para transporte:\n\nMateriales peligrosos y de riesgo\n- Explosivos (dinamita, fuegos artificiales, granadas, etc.)\n- Materiales inflamables y combustibles (gasolina, diluyente, pintura, disolventes, etc.)\n- Gases presurizados (propano, butano, cilindros de oxígeno, etc.)\n- Sustancias tóxicas, venenosas o corrosivas (ácido, base, lejía, etc.)\n- Materiales radiactivos\n- Líquidos inflamables o disolventes con químicos peligrosos\n- Cualquier material o dispositivo que suponga riesgo de explosión o incendio\n\nArmas y equipo peligroso\n- Armas, munición y armas de fuego similares\n- Herramientas cortantes o punzantes (dagas, cuchillos largos, herramientas metálicas puntiagudas, etc.)\n\nDispositivos y productos presurizados\n- Dispositivos con gas o combustible (hornillos de camping con combustible, etc.)\n- Aerosoles presurizados (sprays con gas peligroso)\n- Baterías de litio de alta capacidad o de repuesto\n\nSustancias que causan molestias o riesgo de seguridad\n- Sustancias de olor fuerte, que emiten humo o que molestan\n\nObjetos de valor\n- Joyas (oro, piedras preciosas, etc.) no se aceptan para transporte.\n- Dinero en efectivo (independientemente del importe) no se acepta para transporte.\n\nNota:\nAlgunos artículos pueden transportarse con permisos, cantidades o medidas de seguridad específicas. Sin embargo, en general, estos artículos son rechazados tanto por Aparial como por otros transportistas.';

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
  String get verificationTitle => 'Verificación';

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
  String get reservationEditTitle => 'Editar reserva';

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
  String get luggageFilterCancelled => 'Cancelado';

  @override
  String get luggageEmptyStateNoItems =>
      'Aún no hay equipaje. ¡Agrega tu primera maleta!';

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
  String get locationAuthReadyMessage =>
      'Has iniciado sesión y puedes continuar con la reserva.';

  @override
  String get exploreEmptyTitle => 'No se encontraron ubicaciones.';

  @override
  String get exploreEmptySubtitle => 'Intenta ajustar los filtros.';

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
  String get locationFetching => 'Obteniendo ubicación...';

  @override
  String get refreshNearbyButton => 'Actualizar ubicaciones cercanas';

  @override
  String get nearbyLocationsTitle => 'Ubicaciones cercanas';

  @override
  String get commonSelect => 'Seleccionar';

  @override
  String get landingTitle => 'KYRADI Track';

  @override
  String get landingIntro =>
      'Elige dónde dejar tu equipaje. Toca un punto en el mapa para ver su ocupación y abrir los detalles de la reserva.';

  @override
  String occupancyLabel(Object current, Object max) {
    return 'Ocupación: $current/$max';
  }

  @override
  String get locationOpenLabel => 'Abierto';

  @override
  String get locationClosedLabel => 'Cerrado';

  @override
  String get openingHoursTitle => 'Horario de apertura';

  @override
  String get openingHoursSubtitle => 'Horario semanal';

  @override
  String get openingHoursAlwaysOpen => 'Abierto 24/7';

  @override
  String get openingHoursClosed => 'Cerrado';

  @override
  String get locationFullWarning => 'La ubicación seleccionada está llena.';

  @override
  String get locationClosedWarning =>
      'La ubicación seleccionada está cerrada en este momento.';

  @override
  String get locationInactiveWarning =>
      'La ubicación seleccionada está inactiva.';

  @override
  String get protectionLevelTitle => 'Nivel de protección';

  @override
  String get protectionStandard => 'Estándar';

  @override
  String get protectionPremium => 'Protección premium';

  @override
  String get paymentMethodTitle => 'Método de pago';

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
  String get paymentMethodCard => 'Tarjeta';

  @override
  String get paymentMethodInstallment => 'Cuotas';

  @override
  String get paymentMethodPayAtHotel => 'Pagar en el hotel';

  @override
  String get paymentMethodUnknown => 'Desconocido';

  @override
  String get paymentStatusLabel => 'Estado del pago';

  @override
  String get paymentStatusUnknown => 'Desconocido';

  @override
  String get luggageDetailsTitle => 'Detalles del equipaje';

  @override
  String get luggageDetailsSubtitle =>
      'Revisa la información de la reserva y el pago.';

  @override
  String get luggageIdLabel => 'ID del equipaje';

  @override
  String get createdAtTitle => 'Creado el';

  @override
  String get statusUpdateFailed =>
      'No se pudo actualizar el estado. Inténtalo de nuevo.';

  @override
  String get inviteFriendsTitle => 'Invitar amigos';

  @override
  String get inviteFriendsHeadline => 'Comparte tu código de invitación';

  @override
  String get inviteFriendsSubtitle =>
      'Invita amigos y gana cashback cuando reserven.';

  @override
  String get inviteCodeCopied => 'Código de invitación copiado';

  @override
  String get shareComingSoon => 'El compartir llegará pronto.';

  @override
  String get shareAction => 'Compartir';

  @override
  String get cashbackRulesTitle => 'Reglas de cashback';

  @override
  String get cashbackRuleEarnTitle => 'Ganar cashback';

  @override
  String get cashbackRuleEarnSubtitle =>
      'Gana cashback en reservas y campañas elegibles.';

  @override
  String get cashbackRuleUseTitle => 'Usar cashback';

  @override
  String get cashbackRuleUseSubtitle =>
      'Aplica cashback en el checkout para ubicaciones compatibles.';

  @override
  String get cashbackRuleExpireTitle => 'Vencimiento';

  @override
  String get cashbackRuleExpireSubtitle =>
      'El cashback vence después de 12 meses si no se usa.';

  @override
  String get couponsTitle => 'Cupones';

  @override
  String get couponWelcomeSubtitle => '10% de descuento en tu próxima reserva.';

  @override
  String get couponCitySubtitle => '5 ₺ de cashback en ubicaciones del centro.';

  @override
  String get couponWeekendSubtitle =>
      '15% de descuento en entregas de fin de semana.';

  @override
  String get crashLogsTitle => 'Registros de fallos';

  @override
  String get crashLogsCopied => 'Registros copiados';

  @override
  String get crashLogsEmpty => 'Aún no hay registros.';

  @override
  String get allLabel => 'Todos';

  @override
  String get bookingUpcomingLabel => 'Próximos';

  @override
  String get bookingActiveLabel => 'Activos';

  @override
  String get bookingPastLabel => 'Pasados';

  @override
  String get supportSectionTitle => 'Soporte';

  @override
  String get faqTitle => 'Preguntas frecuentes';

  @override
  String get aboutKyradiTitle => 'Sobre Kyradi';

  @override
  String get whatsappLabel => 'WhatsApp';

  @override
  String get callLabel => 'Llamar';

  @override
  String get emailLabel => 'Correo';

  @override
  String get securitySectionTitle => 'Seguridad';

  @override
  String get changePasswordTitle => 'Cambiar contraseña';

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
  String get filtersTitle => 'Filtros';

  @override
  String get resetAction => 'Restablecer';

  @override
  String get filterOpenNow => 'Abierto ahora';

  @override
  String get filterAvailableSlots => 'Espacios disponibles';

  @override
  String get filterActiveLocations => 'Ubicaciones activas';

  @override
  String get applyAction => 'Aplicar';

  @override
  String get refreshAction => 'Actualizar';

  @override
  String get faqQ1 => '¿Cómo funciona Kyradi?';

  @override
  String get faqA1 =>
      'Deja tu equipaje en un punto aliado y retíralo luego con tu QR/PIN.';

  @override
  String get faqQ2 => '¿Puedo pagar en el sitio?';

  @override
  String get faqA2 => 'Sí, paga en el lugar o con tarjeta.';

  @override
  String get faqQ3 => '¿Qué pasa si una ubicación está llena?';

  @override
  String get faqA3 => 'Elige otra ubicación u otro horario.';

  @override
  String get faqQ4 => '¿Cómo subo mi identidad?';

  @override
  String get faqA4 => 'Abre Perfil → Verificación → Identidad.';

  @override
  String get aboutKyradiDescription =>
      'Kyradi es una superapp de almacenamiento de equipaje que conecta a viajeros con ubicaciones aliadas confiables.';

  @override
  String get versionLabel => 'Versión';

  @override
  String get accountVerificationTitle => 'Verificación de cuenta';

  @override
  String get requiredFieldLabel => 'Obligatorio';

  @override
  String get birthDateSelectLabel => 'Seleccionar fecha de nacimiento';

  @override
  String get birthDateRequiredMessage =>
      'La fecha de nacimiento es obligatoria';

  @override
  String get firebaseConfigMissing => 'Falta la configuración de Firebase.';

  @override
  String get googleTokenInvalid =>
      'No se pudo verificar el token de Google. Inténtalo de nuevo.';

  @override
  String get tokenInvalidMessage => 'Token inválido.';

  @override
  String get socialTokenFormatInvalid =>
      'El formato del token de Google es inválido.';

  @override
  String get socialTokenInvalid =>
      'No se pudo verificar la sesión de Google. Inténtalo de nuevo.';

  @override
  String get authFlowWrong => 'Flujo de autenticación incorrecto.';

  @override
  String get socialLoginCancelled => 'Inicio de sesión cancelado.';

  @override
  String get authBusyMessage => 'Acción en curso, espera por favor.';

  @override
  String get googleConfigMissing => 'Falta la configuración de Google Sign-In.';

  @override
  String get googleConfigMissingIosScheme =>
      'Falta la configuración de Google Sign-In (iOS URL scheme).';

  @override
  String get appleSignInUnavailable => 'Apple Sign-In no está disponible.';

  @override
  String get appleConfigMissing => 'Falta la configuración de Apple Sign-In.';

  @override
  String get retryAction => 'Reintentar';

  @override
  String get verificationStatusVerified => 'Cuenta verificada';

  @override
  String get verificationStatusPending => 'Verificación pendiente';

  @override
  String get verificationStatusRequired => 'Verificación requerida';

  @override
  String get verificationBadgeVerified => 'Verificado';

  @override
  String get verificationBadgePending => 'Pendiente';

  @override
  String get verificationBadgeNew => 'Nuevo';

  @override
  String get viewAction => 'Ver';

  @override
  String get manageAction => 'Gestionar';

  @override
  String locationSlotsLabel(Object available, Object total) {
    return '$available/$total espacios';
  }

  @override
  String get quickActionScanQr => 'Escanear QR';

  @override
  String get quickActionCashback => 'Cashback';

  @override
  String get quickActionReservation => 'Reserva';

  @override
  String get quickActionSupport => 'Soporte';

  @override
  String get quickActionCampaigns => 'Campañas';

  @override
  String get paymentHotelCommissionNote =>
      'Se añadirá una comisión del hotel del 5 %.';

  @override
  String get paymentStartAction => 'Iniciar pago';

  @override
  String get paymentRequiredBeforeDropMessage =>
      'No se puede completar la entrega sin el pago.';

  @override
  String get paymentNotCompletedMessage =>
      'El pago debe completarse antes de la entrega.';

  @override
  String get paymentCompletedMessage =>
      'Pago completado. Puedes entregar tu equipaje.';

  @override
  String get paymentPageTitle => 'Pago';

  @override
  String get paymentPageSubtitle =>
      'Introduce los datos de tu tarjeta para completar el pago.';

  @override
  String get paymentCardNumberLabel => 'Número de tarjeta';

  @override
  String get paymentCardNameLabel => 'Nombre en la tarjeta';

  @override
  String get paymentExpiryLabel => 'Caducidad';

  @override
  String get paymentCvcLabel => 'CVC';

  @override
  String get paymentCompleteAction => 'Completar pago';

  @override
  String get paymentDemoBadge => 'Demo payment (gateway not connected)';

  @override
  String get paymentFormIncompleteMessage =>
      'Completa todos los datos de la tarjeta.';

  @override
  String get paymentFailedMessage => 'No se pudo completar el pago.';

  @override
  String get paymentSuccessMessage => 'Pago recibido correctamente';

  @override
  String get paymentCardNumberInvalidMessage =>
      'El número de tarjeta debe tener 16 dígitos.';

  @override
  String get paymentExpiryInvalidMessage => 'La fecha debe ser MM/AA.';

  @override
  String get paymentCvvInvalidMessage => 'El CVV debe tener 3 o 4 dígitos.';

  @override
  String get paymentPayAtHotelTitle => 'Pagar en el hotel';

  @override
  String get paymentPayAtHotelBody =>
      'Puedes completar el pago en la ubicación seleccionada.';

  @override
  String paymentTotalLabel(Object amount) {
    return 'Total: $amount TRY';
  }

  @override
  String get installmentCountLabel => 'Número de cuotas';

  @override
  String get pricingEstimateTitle => 'Precio estimado';

  @override
  String get pricingEstimateLoading => 'Calculando estimación...';

  @override
  String get pricingBasePriceLabel => 'Precio base';

  @override
  String get pricingPremiumFeeLabel => 'Protección premium';

  @override
  String get pricingHotelCommissionLabel => 'Comisión del hotel';

  @override
  String get pricingInstallmentFeeLabel => 'Recargo por cuotas';

  @override
  String get pricingTotalLabel => 'Total';

  @override
  String get pricingTierLabel => 'Rango de tiempo';

  @override
  String get pricingPriceLabel => 'Precio estimado';

  @override
  String get pricingTier0To6 => '0–6 horas';

  @override
  String get pricingTier6To24 => '6–24 horas';

  @override
  String pricingTierDaily(Object days) {
    return '$days días';
  }

  @override
  String get pricingInvalidRangeMessage =>
      'La hora de recogida debe ser posterior a la de entrega.';

  @override
  String get pricingQuoteFailedMessage => 'No se pudo calcular el precio';

  @override
  String get pricingSummaryTitle => 'Resumen de precios';

  @override
  String get pricingSummaryEdit => 'Editar';

  @override
  String get pricingSummarySizeLabel => 'Tamaño';

  @override
  String get pricingSummaryDurationLabel => 'Duración';

  @override
  String get pricingSummaryAmountLabel => 'Importe';

  @override
  String get pricingEstimateDisclaimer =>
      'Este precio es una estimación y puede variar según la hora real de entrega.';

  @override
  String get pricingEstimateUnavailable =>
      'Selecciona las horas de entrega y recogida para ver una estimación.';

  @override
  String get pickupPinSentMessage => 'El PIN de recogida se envió a tu correo.';

  @override
  String get pickupPinFailedMessage =>
      'No se pudo enviar el PIN. Inténtalo más tarde.';

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
  String get luggageDelegateAction => 'Entregar a contacto de emergencia';

  @override
  String get delegateInfoRequiredMessage =>
      'Completa los datos del contacto de emergencia.';

  @override
  String get howItWorksTitle => 'Cómo funciona';

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
  String get pickupPinTitle => 'PIN de recogida';

  @override
  String get pickupPinLabel => 'PIN de recogida';

  @override
  String get pickupPinHint => 'PIN de 4 dígitos';

  @override
  String pickupPinGenerated(Object pin) {
    return 'PIN de recogida: $pin';
  }

  @override
  String get pickupPinRequiredMessage => 'El PIN de recogida es obligatorio.';

  @override
  String get pickupPinInvalidMessage =>
      'El PIN es incorrecto. Inténtalo de nuevo.';

  @override
  String get delegateSetupTitle => 'Delegado';

  @override
  String get delegateNameLabel => 'Nombre completo';

  @override
  String get delegatePhoneLabel => 'Teléfono';

  @override
  String get delegateEmailLabel => 'Correo';

  @override
  String get delegateCodeTitle => 'Código de delegado';

  @override
  String get delegateCodeLabel => 'Código de delegado';

  @override
  String get delegateCodeHint => 'Código de 6 dígitos';

  @override
  String delegateCodeGenerated(Object code) {
    return 'Código de delegado: $code';
  }

  @override
  String get delegateCodeRequiredMessage =>
      'El código de delegado es obligatorio.';

  @override
  String get delegateCodeInvalidMessage => 'El código de delegado es inválido.';

  @override
  String get delegateCodeExpiredMessage => 'El código de delegado ha expirado.';

  @override
  String get delegateCodeUsedMessage => 'El código de delegado ya fue usado.';

  @override
  String get delegateSavedMessage => 'Delegado guardado.';

  @override
  String get delegateEmergencyCodeTitle => 'Código de emergencia';

  @override
  String get ownerInfoTitle => 'Datos del propietario';

  @override
  String get ownerNameLabel => 'Nombre completo';

  @override
  String get ownerPhoneLabel => 'Teléfono';

  @override
  String get ownerEmailLabel => 'Correo';

  @override
  String get pickupPinSafetyWarning =>
      'Guarda tu PIN y no lo compartas. Se solicitará durante la recogida.';

  @override
  String get pickupPinCopiedMessage =>
      'PIN copiado — guárdalo en un lugar seguro.';

  @override
  String get copy => 'Copiar';

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
  String get topUpMethodTitle => 'Choose top-up method';

  @override
  String get topUpMethodSubtitle =>
      'Continue with a saved card or add a new card.';

  @override
  String get topUpUseSavedCardTitle => 'Use saved card';

  @override
  String get topUpUseSavedCardSubtitle =>
      'Pick from your saved credit/debit cards.';

  @override
  String get topUpUseNewCardTitle => 'Use new card';

  @override
  String get topUpUseNewCardSubtitle => 'Pay with a new credit or debit card.';

  @override
  String get topUpAmountTitle => 'Top-up amount';

  @override
  String get topUpAmountSubtitle => 'Select or enter the amount to add.';

  @override
  String get topUpAmountLabel => 'Top-up amount (₺)';

  @override
  String get topUpSelectCardTitle => 'Select a card';

  @override
  String get topUpSelectCardSubtitle => 'Choose the card you want to charge.';

  @override
  String get topUpSelectCardMessage => 'Please select a saved card.';

  @override
  String get topUpCardDetailsTitle => 'Card details';

  @override
  String get topUpCardDetailsSubtitle =>
      'Enter your card information securely.';

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
  String topUpTransactionTitleWithMethod(Object method) {
    return 'Wallet top-up ($method)';
  }

  @override
  String get topUpTransactionCategory => 'Top-up';

  @override
  String get walletSelectCardTitle => 'Select card';

  @override
  String get selectedLabel => 'Selected';

  @override
  String get transferSectionTitle => 'Transfer';

  @override
  String get walletActionsTitle => 'Wallet actions';

  @override
  String get walletActionsSubtitle => 'Choose what you want to do.';

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
  String get stepBagInfoTitle => 'Bag Details';

  @override
  String get stepScheduleTitle => 'Location & Time';

  @override
  String get stepPricingTitle => 'Pricing & Options';

  @override
  String get stepPaymentTitle => 'Payment';

  @override
  String get stepSuccessTitle => 'Success';

  @override
  String get continueAction => 'Continue';

  @override
  String get pricingDurationLabel => 'Duration';

  @override
  String pricingDurationValue(Object hours, Object days) {
    return '$hours hours ($days days)';
  }

  @override
  String get pricingHourlyLabel => 'Hourly';

  @override
  String pricingHourlyValue(Object amount) {
    return '₺$amount';
  }

  @override
  String get pricingDailyLabel => 'Daily';

  @override
  String pricingDailyValue(Object amount) {
    return '₺$amount';
  }

  @override
  String get pricingBestPriceLabel => 'Best price';

  @override
  String pricingBestValue(Object amount) {
    return '₺$amount';
  }

  @override
  String get insuranceOptionTitle => 'Insurance package';

  @override
  String get insuranceOptionSubtitle => 'Optional protection (+₺99)';

  @override
  String get paymentMethodTransfer => 'Bank transfer / EFT';

  @override
  String get paymentTransferNote =>
      'Complete payment by uploading a transfer receipt.';

  @override
  String get paymentHotelFeeNote => 'Pay at hotel adds a 10% service fee.';

  @override
  String get reservationSuccessTitle => 'Reservation created';

  @override
  String get reservationSuccessSubtitle =>
      'Your reservation is ready. You can view details under My Luggages.';

  @override
  String get reservationSuccessGoLuggages => 'Go to My Luggages';

  @override
  String get reservationSuccessViewDetails => 'View details';

  @override
  String get reservationSuccessClose => 'Close';

  @override
  String get dropTimeTitle => 'Drop-off time';

  @override
  String get pickupTimeTitle => 'Pick-up time';

  @override
  String get dropTimePlaceholder => 'Select date & time';

  @override
  String get pickupTimePlaceholder => 'Select date & time';

  @override
  String get paymentMethodWalletShort => 'Kyradi Wallet';

  @override
  String get invoiceSectionTitle => 'Invoice';

  @override
  String get invoiceSectionSubtitle => 'View payment summary and e-invoice.';

  @override
  String get invoiceShowAction => 'Show Invoice';

  @override
  String get invoiceTitle => 'E-Invoice';

  @override
  String get invoiceNumberLabel => 'Invoice No';

  @override
  String get invoiceDateLabel => 'Date';

  @override
  String get invoiceCustomerLabel => 'Customer';

  @override
  String get invoiceCustomerFallback => 'Kyradi Guest';

  @override
  String get invoiceEmailLabel => 'Email';

  @override
  String get invoiceLocationLabel => 'Location';

  @override
  String get invoiceItemLabel => 'Service';

  @override
  String get invoiceItemTitle => 'Luggage Reservation';

  @override
  String get invoiceItemDesc => 'Description';

  @override
  String get invoiceItemSubtitle => 'Kyradi drop-off & storage service';

  @override
  String get invoicePaymentMethodLabel => 'Payment Method';

  @override
  String get invoicePaymentStatusLabel => 'Payment Status';

  @override
  String get invoiceAmountLabel => 'Amount';

  @override
  String get invoiceVatLabel => 'VAT';

  @override
  String get invoiceVatValue => 'Included';

  @override
  String get invoiceTotalLabel => 'Grand Total';

  @override
  String get invoiceFooterNote =>
      'This e-invoice is generated digitally by Kyradi.';

  @override
  String get luggageInfoSectionSubtitle =>
      'Luggage details and scheduled times.';

  @override
  String get closeAction => 'Close';

  @override
  String get reservationInfoTitle => 'Reservation Details';

  @override
  String get reservationInfoSubtitle =>
      'Reservation status and payment details.';

  @override
  String get luggageTimelinePayment => 'Payment';

  @override
  String get luggageTimelineTimeUnknown => 'Time not available';

  @override
  String get invoiceDownloadAction => 'Download Invoice';

  @override
  String invoiceSavedMessage(Object file) {
    return 'Invoice saved: $file';
  }

  @override
  String get invoiceSaveFailedMessage => 'Invoice could not be saved.';

  @override
  String get pricingRecalculateAction => 'Recalculate';

  @override
  String get locationDetailsTitle => 'Location Details';

  @override
  String get locationDetailsSubtitle => 'Occupancy, open hours and capacity.';

  @override
  String get directionsAction => 'Get Directions';

  @override
  String get directionsSheetTitle => 'Choose a maps app';

  @override
  String get directionsSheetSubtitle =>
      'We will open navigation to the location.';

  @override
  String get directionsGoogleMaps => 'Open in Google Maps';

  @override
  String get directionsAppleMaps => 'Open in Apple Maps';

  @override
  String get directionsPreviewTitle => 'Live map preview';

  @override
  String get walletCreditCardLabel => 'Credit Card';

  @override
  String get walletDebitCardLabel => 'Debit Card';

  @override
  String get walletCreditCardSubtitle => 'View and manage credit cards.';

  @override
  String get walletDebitCardSubtitle => 'View and manage debit cards.';

  @override
  String get walletCardSavedMessage => 'Card saved.';

  @override
  String get walletCardInvalidMessage => 'Please fill card details.';

  @override
  String get walletCardExpiryInvalidMessage => 'Invalid expiry date.';

  @override
  String get identityVerificationTitle => 'Kimlik Doğrulama';

  @override
  String get identityVerificationSubtitle =>
      'Kimlik bilgilerini ve belgelerini yükle.';

  @override
  String get emailVerificationTitle => 'E-posta Doğrulama';

  @override
  String get emailVerificationSubtitle =>
      'E-postana gönderilen kod ile doğrula.';

  @override
  String get emailVerifiedLabel => 'E-posta doğrulandı';

  @override
  String get emailPendingLabel => 'E-posta doğrulama bekleniyor';

  @override
  String get emailVerificationNeededLabel => 'E-posta doğrulaması gerekli';

  @override
  String get identityVerifiedLabel => 'Kimlik doğrulandı';

  @override
  String get identityVerificationNeededLabel => 'Kimlik doğrulaması gerekli';

  @override
  String get personalInfoTitle => 'Kişisel Bilgiler';

  @override
  String get identityPhotosTitle => 'Kimlik Fotoğrafları';

  @override
  String get identityFrontLabel => 'Kimlik Ön Yüz';

  @override
  String get identityBackLabel => 'Kimlik Arka Yüz';

  @override
  String get selfieStepTitle => 'Selfie';

  @override
  String get selfieLabel => 'Selfie';

  @override
  String get selfieNotRequiredMessage =>
      'Selfie bu doğrulama için gerekli değil.';

  @override
  String get reviewAndSubmitTitle => 'Onay ve Gönder';

  @override
  String get reviewHint => 'Bilgileri kontrol edin ve doğrulama için gönderin.';

  @override
  String get uploadedLabel => 'Yüklendi';

  @override
  String get missingLabel => 'Eksik';

  @override
  String get nextAction => 'Devam Et';

  @override
  String get back => 'Geri';

  @override
  String get cancel => 'Vazgeç';

  @override
  String get submit => 'Gönder';

  @override
  String get identityPhotoLabel => 'Kimlik Fotoğrafı';

  @override
  String get identityVerifiedTitle => 'Hesabın kimlikle onaylandı';

  @override
  String get identityPendingReviewTitle => 'Kimlik doğrulama incelemede';

  @override
  String get submittedForReviewMessage =>
      'Kimlik doğrulama inceleme için gönderildi.';

  @override
  String get uploadSuccessMessage => 'Yükleme tamamlandı.';

  @override
  String get saveSuccessMessage => 'Kaydedildi.';

  @override
  String get nationalIdInvalidMessage => 'T.C. kimlik numarası geçersiz.';
}
