import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/api_settings_dialog.dart';
import '../widgets/section_card.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/app_notification.dart';
import '../l10n/app_localizations.dart';
import '../core/ios/ios_config_service.dart';
import '../core/firebase/firebase_bootstrap.dart';
import '../core/auth/google_oauth_config.dart';
import '../utils/crash_log.dart';
import '../ui/components/rainbow_bar.dart';
import '../widgets/app_logo_overlay.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static const LinearGradient _warmGradient = LinearGradient(
    colors: [Color(0xFFFF8C42), Color(0xFFFF5F6D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _surCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tcCtrl = TextEditingController();
  final _telCtrl = TextEditingController(text: '+90 ');
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  DateTime? _birthDate;

  String _gender = 'none';
  int _step = 0;
  bool _loading = false;
  bool _googleConfigOk = true;
  bool _appleConfigOk = true;
  bool _firebaseReady = true;
  bool _googleBusy = false;
  bool _kvkkAccepted = false;
  bool _restrictedItemsAccepted = false;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  String _mapSocialAuthError(AppLocalizations l10n, String err) {
    switch (err) {
      case 'BUSY':
        return l10n.authBusyMessage;
      case 'TOKEN_INVALID':
        return l10n.tokenInvalidMessage;
      case 'SOCIAL_TOKEN_FORMAT_INVALID':
        return l10n.socialTokenFormatInvalid;
      case 'SOCIAL_TOKEN_INVALID':
        return l10n.socialTokenInvalid;
      case 'WRONG_AUTH_FLOW':
        return l10n.authFlowWrong;
      case 'invalid-credential':
        return l10n.googleTokenInvalid;
      default:
        if (err.contains('popup_closed') || err.contains('login cancelled')) {
          return l10n.socialLoginCancelled;
        }
        if (err == l10n.googleConfigMissing ||
            err == l10n.appleSignInUnavailable ||
            err == l10n.firebaseConfigMissing) {
          return err;
        }
        return err.isNotEmpty ? err : l10n.loginFailed;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surCtrl.dispose();
    _emailCtrl.dispose();
    _tcCtrl.dispose();
    _telCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkAuthConfig();
  }

  Future<void> _checkAuthConfig() async {
    if (!Platform.isIOS) {
      setState(() => _firebaseReady = FirebaseBootstrap.isReady);
      return;
    }
    final clientIdOk = isValidIosGoogleClientId(kIosGoogleClientId);
    final hasScheme = clientIdOk
        ? await IosConfigService.hasUrlScheme(kIosReversedScheme)
        : false;
    final appleAvailable = await AuthService.isAppleAvailable();
    if (!mounted) return;
    setState(() {
      _firebaseReady = FirebaseBootstrap.isReady;
      _googleConfigOk = clientIdOk && hasScheme;
      _appleConfigOk = appleAvailable;
    });
    appLog(
      'auth',
      'IOS_CONFIG_REGISTER firebase_ok=$_firebaseReady google_ok=$_googleConfigOk apple_ok=$_appleConfigOk clientIdPresent=$clientIdOk schemePresent=$hasScheme',
      level: AppLogLevel.info,
    );
  }

  bool _validateStep(AppLocalizations l10n) {
    switch (_step) {
      case 0:
        if ((_nameCtrl.text.trim().isEmpty) ||
            (_surCtrl.text.trim().isEmpty)) {
          _notify(l10n.validationRequired, type: AppNotificationType.error);
          return false;
        }
        final ageError = AppValidators.age18(_birthDate, l10n);
        if (ageError != null) {
          _notify(ageError, type: AppNotificationType.error);
          return false;
        }
        return true;
      case 1:
        final emailErr = AppValidators.email(_emailCtrl.text, l10n);
        if (emailErr != null) {
          _notify(emailErr, type: AppNotificationType.error);
          return false;
        }
        final phoneErr = AppValidators.phone(_telCtrl.text, l10n);
        if (phoneErr != null) {
          _notify(phoneErr, type: AppNotificationType.error);
          return false;
        }
        return true;
      case 2:
        final tcErr = AppValidators.tcKimlik(_tcCtrl.text, l10n);
        if (tcErr != null) {
          _notify(tcErr, type: AppNotificationType.error);
          return false;
        }
        final passErr = AppValidators.password(_passCtrl.text, l10n);
        if (passErr != null) {
          _notify(passErr, type: AppNotificationType.error);
          return false;
        }
        final pass2Err = AppValidators.passwordRepeat(
          _pass2Ctrl.text.trim(),
          _passCtrl.text.trim(),
          l10n,
        );
        if (pass2Err != null) {
          _notify(pass2Err, type: AppNotificationType.error);
          return false;
        }
        if (!_kvkkAccepted) {
          _notify(l10n.registerKvkkAgreementWarning, type: AppNotificationType.error);
          return false;
        }
        if (!_restrictedItemsAccepted) {
          _notify(
            l10n.registerRestrictedAgreementWarning,
            type: AppNotificationType.error,
          );
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _nextStep(AppLocalizations l10n) {
    if (_validateStep(l10n)) {
      setState(() => _step = (_step + 1).clamp(0, 2));
    }
  }

  void _prevStep() {
    setState(() => _step = (_step - 1).clamp(0, 2));
  }

  Future<AuthResult> _signInWithGoogle() async {
    appLog('auth', 'AUTH_GOOGLE_TAP', level: AppLogLevel.info);
    if (_googleBusy) {
      return AuthResult(ok: false, error: 'BUSY', statusCode: 429);
    }
    if (Platform.isIOS) {
      final clientIdOk = isValidIosGoogleClientId(kIosGoogleClientId);
      final hasScheme = clientIdOk
          ? await IosConfigService.hasUrlScheme(kIosReversedScheme)
          : false;
      if (!clientIdOk || !hasScheme) {
        appLog(
          'auth',
          'AUTH_GOOGLE_PREFLIGHT_FAIL clientIdPresent=$clientIdOk schemePresent=$hasScheme',
          level: AppLogLevel.error,
        );
        return AuthResult(
          ok: false,
          error: AppLocalizations.of(context)!.googleConfigMissing,
          statusCode: 500,
        );
      }
    }
    appLog('auth', 'AUTH_GOOGLE_PREFLIGHT_OK', level: AppLogLevel.info);
    appLog('auth', 'AUTH_GOOGLE_START', level: AppLogLevel.info);
    _googleBusy = true;
    try {
      final result = await AuthService.signInWithGoogle();
      return result;
    } catch (e) {
      appLog('auth', 'AUTH_GOOGLE_ERROR $e', level: AppLogLevel.error);
      return AuthResult(ok: false, error: e.toString(), statusCode: 500);
    } finally {
      _googleBusy = false;
    }
  }

  Future<AuthResult> _signInWithApple() async {
    appLog('auth', 'AUTH_APPLE_TAP', level: AppLogLevel.info);
    if (!await AuthService.isAppleAvailable()) {
      appLog('auth', 'AUTH_APPLE_ERROR not_available', level: AppLogLevel.warn);
      return AuthResult(
        ok: false,
        error: AppLocalizations.of(context)!.appleSignInUnavailable,
        statusCode: 400,
      );
    }
    appLog('auth', 'AUTH_APPLE_START', level: AppLogLevel.info);
    final result = await AuthService.signInWithApple();
    if (result.ok) {
      appLog('auth', 'AUTH_APPLE_RESULT ok', level: AppLogLevel.info);
    }
    return result;
  }

  Future<void> _handleSocialAuth(
    Future<AuthResult> Function() handler, {
    required String provider,
  }) async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_firebaseReady) {
      _notify(
        l10n.firebaseConfigMissing,
        type: AppNotificationType.warning,
      );
      return;
    }
    appLog('auth', 'AUTH_${provider.toUpperCase()}_START', level: AppLogLevel.info);
    setState(() => _loading = true);
    try {
      final authResult = await handler();
      if (!authResult.ok) {
        if (!mounted) return;
        setState(() => _loading = false);
        final err = authResult.error ?? 'Login failed';
        final message = _mapSocialAuthError(l10n, err);
        _notify(message, type: AppNotificationType.error);
        return;
      }
      final firebaseIdToken = authResult.firebaseIdToken;
      final idToken = authResult.providerIdToken;
      final accessToken = authResult.accessToken;
      final authorizationCode = authResult.authorizationCode;
      final effectiveToken = provider == 'google'
          ? (firebaseIdToken?.isNotEmpty == true ? firebaseIdToken : idToken)
          : idToken;
      final tokenTrimmed = effectiveToken?.trim() ?? '';
      final tokenSegments = tokenTrimmed.isEmpty ? 0 : tokenTrimmed.split('.').length;
      final startsWithEyJ = tokenTrimmed.startsWith('eyJ');
      if (tokenTrimmed.isEmpty) {
        if (!mounted) return;
        setState(() => _loading = false);
        _notify(l10n.tokenInvalidMessage, type: AppNotificationType.error);
        return;
      }
      appLog(
        'auth',
        'AUTH_${provider.toUpperCase()}_TOKEN_FORMAT tokenLen=${tokenTrimmed.length} segments=$tokenSegments startsWithEyJ=$startsWithEyJ',
        level: AppLogLevel.info,
      );
      if (tokenSegments != 3 || !startsWithEyJ) {
        if (!mounted) return;
        setState(() => _loading = false);
        _notify(
          provider == 'google' ? l10n.googleTokenInvalid : l10n.tokenInvalidMessage,
          type: AppNotificationType.error,
        );
        return;
      }
      final res = await ApiService.socialLogin(
        provider: provider,
        idToken: effectiveToken,
        accessToken: idToken == null || idToken.isEmpty ? accessToken : null,
        authorizationCode: authorizationCode,
        platform: Platform.isIOS ? 'ios' : 'android',
        flow: 'register',
      );
      if (!mounted) return;
      setState(() => _loading = false);
      final ok = res['ok'] == true;
      final status = res['statusCode'] ?? 0;
      final msg = (res['message'] ?? res['error'] ?? '').toString();
      if (ok) {
        final profile = res["profile"];
        final userId = profile?["id"] ?? profile?["_id"];
        if (userId != null) {
          final prefs = await SharedPreferences.getInstance();
          if (!mounted) return;
          await prefs.setString('userId', userId.toString());
          if (!mounted) return;
        }
        _notify(
          AppLocalizations.of(context)!.loginSuccess,
          type: AppNotificationType.success,
        );
        if (!mounted) return;
        AppLogoOverlayController.show();
        context.go('/home');
      } else if (status == 400 || status == 401) {
        final mapped = _mapSocialAuthError(l10n, msg.isNotEmpty ? msg : 'TOKEN_INVALID');
        _notify(mapped, type: AppNotificationType.error);
      } else {
        _notify(
          msg.isNotEmpty ? msg : AppLocalizations.of(context)!.loginFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      appLog('auth', 'AUTH_${provider.toUpperCase()}_ERROR $e', level: AppLogLevel.error);
      if (!mounted) return;
      setState(() => _loading = false);
      _notify(
        AppLocalizations.of(context)!.genericErrorWithDetails('$e'),
        type: AppNotificationType.error,
      );
    }
  }

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 10),
      helpText: l10n.birthDate,
    );
    if (!mounted) return;
    if (picked != null) setState(() => _birthDate = picked);
  }

  // ignore: unused_element
  Future<void> _openServerSettings() async {
    final outcome = await showApiSettingsDialog(context);
    if (outcome == null) return;
    if (!mounted) return;
    _notify(outcome.message, type: AppNotificationType.info);
  }

  // ignore: unused_element
  Future<void> _showAgreementDialog({
    required String title,
    required String body,
  }) async {
    final loc = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(body),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.dialogDismiss),
          ),
        ],
      ),
    );
  }

  Future<void> _openAgreementPage({
    required String title,
    required String body,
    required ValueChanged<bool> onAccepted,
  }) async {
    final accepted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AgreementReadPage(
          title: title,
          body: body,
        ),
      ),
    );
    if (accepted == true) {
      if (!mounted) return;
      onAccepted(true);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_birthDate == null) {
      _notify(l10n.validationBirthDateRequired, type: AppNotificationType.warning);
      return;
    }
    if (!_kvkkAccepted) {
      _notify(
        l10n.registerKvkkAgreementWarning,
        type: AppNotificationType.warning,
      );
      return;
    }
    if (!_restrictedItemsAccepted) {
      _notify(
        l10n.registerRestrictedAgreementWarning,
        type: AppNotificationType.warning,
      );
      return;
    }

    final sanitizedTc = _tcCtrl.text.replaceAll(RegExp(r'\s+'), '');
    String sanitizedPhone =
        _telCtrl.text.replaceAll(RegExp(r'\s+'), '').replaceAll('-', '');
    sanitizedPhone = sanitizedPhone.replaceAll('+', '');
    if (sanitizedPhone.isNotEmpty) {
      sanitizedPhone = '+$sanitizedPhone';
    }

    setState(() => _loading = true);
    try {
      final res = await ApiService.register({
        "name": _nameCtrl.text.trim(),
        "surname": _surCtrl.text.trim(),
        "email": _emailCtrl.text.trim().toLowerCase(),
        "tc": sanitizedTc,
        "phone": sanitizedPhone,
        "password": _passCtrl.text.trim(),
        "birthDate": _birthDate!.toIso8601String(),
        "gender": _gender,
      });

      if (!mounted) return;
      setState(() => _loading = false);

      final ok = res["ok"] == true;
      final status = res["statusCode"] ?? res["_httpStatus"] ?? 0;
      final msg = (res["message"] ?? res["error"] ?? "").toString();

      if (ok) {
        _notify(
          l10n.registerSuccessMessage,
          type: AppNotificationType.success,
        );
        if (!mounted) return;
        context.push('/verify', extra: _emailCtrl.text.trim());
      }
      // 🔹 409 veya “email already” gibi durumlar
      else if (status == 409 ||
          msg.toLowerCase().contains("email") ||
          msg.toLowerCase().contains("already")) {
        _notify(l10n.registerEmailExistsMessage, type: AppNotificationType.error);
      }
      // 🔹 diğer backend hataları
      else {
        _notify(
          msg.isNotEmpty ? msg : l10n.registerGenericErrorMessage,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notify(l10n.genericErrorWithDetails('$e'), type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final stepTitles = [
      l10n.registerPersonalSectionTitle,
      l10n.registerContactSectionTitle,
      l10n.registerSecuritySectionTitle,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF2F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                const RainbowBar(height: 4),
                const SizedBox(height: 12),
                _StepProgress(
                  current: _step,
                  titles: stepTitles,
                ),
                const SizedBox(height: 16),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: _step == 0
                      ? _RegisterStepCard(
                          key: const ValueKey('step-personal'),
                          title: l10n.registerPersonalSectionTitle,
                          subtitle: l10n.registerPersonalSectionSubtitle,
                          icon: Icons.badge_outlined,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _nameCtrl,
                                      decoration: InputDecoration(
                                        labelText: l10n.firstName,
                                        prefixIcon: const _FieldIcon(
                                          icon: Icons.person_outline,
                                        ),
                                      ),
                                      validator: (v) => (v == null || v.trim().isEmpty)
                                          ? l10n.validationRequired
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _surCtrl,
                                      decoration: InputDecoration(
                                        labelText: l10n.lastName,
                                        prefixIcon: const _FieldIcon(
                                          icon: Icons.person_rounded,
                                        ),
                                      ),
                                      validator: (v) => (v == null || v.trim().isEmpty)
                                          ? l10n.validationRequired
                                          : null,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              InkWell(
                                onTap: _pickBirth,
                                borderRadius: BorderRadius.circular(18),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: l10n.birthDate,
                                    prefixIcon: const _FieldIcon(
                                      icon: Icons.event,
                                    ),
                                  ),
                                  child: Text(
                                    _birthDate == null
                                        ? l10n.formNotSelected
                                        : '${_birthDate!.day.toString().padLeft(2, '0')}.'
                                          '${_birthDate!.month.toString().padLeft(2, '0')}.'
                                          '${_birthDate!.year}',
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              DropdownButtonFormField<String>(
                                key: ValueKey(_gender),
                                initialValue: _gender,
                                items: [
                                  DropdownMenuItem(
                                    value: 'male',
                                    child: Text(l10n.genderMale),
                                  ),
                                  DropdownMenuItem(
                                    value: 'female',
                                    child: Text(l10n.genderFemale),
                                  ),
                                  DropdownMenuItem(
                                    value: 'none',
                                    child: Text(l10n.genderUndisclosed),
                                  ),
                                ],
                                onChanged: (v) => setState(() => _gender = v ?? 'none'),
                                decoration: InputDecoration(
                                  labelText: l10n.gender,
                                  prefixIcon: const _FieldIcon(
                                    icon: Icons.wc,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : _step == 1
                          ? _RegisterStepCard(
                              key: const ValueKey('step-contact'),
                              title: l10n.registerContactSectionTitle,
                              subtitle: l10n.registerContactSectionSubtitle,
                              icon: Icons.contact_mail_outlined,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailCtrl,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: l10n.emailAddressLabel,
                                      hintText: l10n.emailHint,
                                      prefixIcon: const _FieldIcon(
                                        icon: Icons.email_outlined,
                                      ),
                                    ),
                                    validator: (v) => AppValidators.email(v, l10n),
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: _telCtrl,
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      labelText: l10n.phone,
                                      hintText: l10n.phoneHint,
                                      prefixIcon: const _FieldIcon(
                                        icon: Icons.phone_outlined,
                                      ),
                                    ),
                                    validator: (v) => AppValidators.phone(v, l10n),
                                  ),
                                ],
                              ),
                            )
                          : _RegisterStepCard(
                              key: const ValueKey('step-security'),
                              title: l10n.registerSecuritySectionTitle,
                              subtitle: l10n.registerSecuritySectionSubtitle,
                              icon: Icons.lock_outline_rounded,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _tcCtrl,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(11),
                                      AppValidators.digitsOnlyFormatter,
                                    ],
                                    decoration: InputDecoration(
                                      labelText: l10n.nationalIdLabel,
                                      prefixIcon: const _FieldIcon(
                                        icon: Icons.credit_card,
                                      ),
                                    ),
                                    validator: (v) => AppValidators.tcKimlik(v, l10n),
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: _passCtrl,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: l10n.passwordLabel,
                                      prefixIcon: const _FieldIcon(
                                        icon: Icons.lock_outline,
                                      ),
                                    ),
                                    onChanged: (_) => _formKey.currentState?.validate(),
                                    validator: (v) => AppValidators.password(v, l10n),
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    controller: _pass2Ctrl,
                                    obscureText: true,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                    ],
                                    decoration: InputDecoration(
                                      labelText: l10n.registerPasswordRepeatLabel,
                                      prefixIcon: const _FieldIcon(
                                        icon: Icons.verified_user_outlined,
                                      ),
                                    ),
                                    onChanged: (_) => _formKey.currentState?.validate(),
                                    validator: (v) => AppValidators.passwordRepeat(
                                      v?.trim(),
                                      _passCtrl.text.trim(),
                                      l10n,
                                    ),
                                  ),
                                  const SizedBox(height: 14),
                                  _AgreementTile(
                                    accepted: _kvkkAccepted,
                                    label: l10n.registerKvkkAgreementLabel,
                                    onOpen: () => _openAgreementPage(
                                      title: l10n.registerKvkkDialogTitle,
                                      body: l10n.registerKvkkDocumentBody,
                                      onAccepted: (v) =>
                                          setState(() => _kvkkAccepted = v),
                                    ),
                                    actionLabel: l10n.registerAgreementView,
                                  ),
                                  _AgreementTile(
                                    accepted: _restrictedItemsAccepted,
                                    label: l10n.registerRestrictedAgreementLabel,
                                    onOpen: () => _openAgreementPage(
                                      title: l10n.registerRestrictedDialogTitle,
                                      body: l10n.registerRestrictedDocumentBody,
                                      onAccepted: (v) => setState(
                                        () => _restrictedItemsAccepted = v,
                                      ),
                                    ),
                                    actionLabel: l10n.registerAgreementView,
                                  ),
                                  const SizedBox(height: 8),
                                  GradientButton(
                                    text: l10n.registerButtonLabel,
                                    onPressed: _loading
                                        ? null
                                        : () {
                                            if (_validateStep(l10n)) {
                                              _submit();
                                            }
                                          },
                                    loading: _loading,
                                    gradient: _warmGradient,
                                    glass: true,
                                  ),
                                ],
                              ),
                            ),
                ),
                const SizedBox(height: 16),
                _StepActions(
                  step: _step,
                  onBack: _prevStep,
                  onNext: () => _nextStep(l10n),
                ),
                const SizedBox(height: 18),
                SectionCard(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              l10n.loginSocialDivider,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 360),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _loading || !_googleConfigOk || !_firebaseReady
                                      ? null
                                      : () => _handleSocialAuth(
                                            _signInWithGoogle,
                                            provider: 'google',
                                          ),
                                  icon: const CircleAvatar(
                                    radius: 10,
                                    backgroundColor: Color(0xFFEA4335),
                                    child: Text(
                                      'G',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  label: Text(l10n.loginContinueWithGoogle),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: OutlinedButton.icon(
                                  onPressed: _loading || !_appleConfigOk || !_firebaseReady
                                      ? null
                                      : () => _handleSocialAuth(
                                            _signInWithApple,
                                            provider: 'apple',
                                          ),
                                  icon: const Icon(Icons.apple),
                                  label: Text(l10n.loginContinueWithApple),
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (!_firebaseReady || !_googleConfigOk || !_appleConfigOk) ...[
                        const SizedBox(height: 10),
                        Text(
                          !_firebaseReady
                              ? l10n.firebaseConfigMissing
                              : (!_googleConfigOk
                                  ? l10n.googleConfigMissingIosScheme
                                  : l10n.appleConfigMissing),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.error,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.copyrightNotice,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.current,
    required this.titles,
  });

  final int current;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Row(
          children: List.generate(titles.length, (index) {
            final isActive = index <= current;
            return Expanded(
              child: Container(
                height: 4,
                margin: EdgeInsets.only(right: index == titles.length - 1 ? 0 : 8),
                decoration: BoxDecoration(
                  color: isActive
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 10),
        Text(
          titles[current],
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _RegisterStepCard extends StatelessWidget {
  const _RegisterStepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      child: Column(
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            icon: icon,
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

class _StepActions extends StatelessWidget {
  const _StepActions({
    required this.step,
    required this.onBack,
    required this.onNext,
  });

  final int step;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    if (step == 2) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        if (step > 0)
          OutlinedButton.icon(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 16),
            label: const Text('Geri'),
          ),
        if (step > 0) const SizedBox(width: 12),
        Expanded(
          child: FilledButton(
            onPressed: onNext,
            child: const Text('Devam Et'),
          ),
        ),
      ],
    );
  }
}

class _FieldIcon extends StatelessWidget {
  const _FieldIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = theme.colorScheme.primary;
    final base = theme.colorScheme.surface;
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 28,
            width: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  accent.withValues(alpha: 0.25),
                  accent.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
          Container(
            height: 22,
            width: 22,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: base,
              border: Border.all(color: accent.withValues(alpha: 0.35)),
            ),
          ),
          Icon(icon, size: 14, color: accent),
        ],
      ),
    );
  }
}

class _AgreementTile extends StatelessWidget {
  const _AgreementTile({
    required this.accepted,
    required this.label,
    required this.onOpen,
    required this.actionLabel,
  });

  final bool accepted;
  final String label;
  final VoidCallback onOpen;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: accepted ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                TextButton(
                  onPressed: onOpen,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgreementReadPage extends StatefulWidget {
  const AgreementReadPage({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  State<AgreementReadPage> createState() => _AgreementReadPageState();
}

class _AgreementReadPageState extends State<AgreementReadPage> {
  final ScrollController _controller = ScrollController();
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final current = max <= 0 ? 0.0 : (_controller.offset / max);
    setState(() => _progress = current.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atEnd = _progress >= 1.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(atEnd),
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: SelectableText(widget.body),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 14,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween<double>(begin: 0, end: _progress),
                        builder: (context, value, _) {
                          return FractionallySizedBox(
                            widthFactor: value.clamp(0.0, 1.0),
                            child: Container(
                              color: const Color(0xFF2E7D32),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedOpacity(
                opacity: atEnd ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
