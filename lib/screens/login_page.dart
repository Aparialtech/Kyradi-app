// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../widgets/gradient_button.dart';
import '../services/api_service.dart';
import '../widgets/app_notification.dart';
import '../l10n/app_localizations.dart';
import '../utils/crash_log.dart';
import '../core/ios/ios_config_service.dart';
import '../core/firebase/firebase_bootstrap.dart';
import '../core/auth/google_oauth_config.dart';
import '../ui/components/app_back_app_bar.dart';
import '../widgets/auth_mesh_background.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  static const String _rememberEmailKey = 'remember_email';
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  bool _googleBusy = false;
  bool _googleConfigOk = true;
  bool _appleConfigOk = true;
  bool _firebaseReady = true;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _checkAuthConfig();
    _loadRememberedEmail();
  }

  Future<void> _checkAuthConfig() async {
    if (!Platform.isIOS) {
      setState(() => _firebaseReady = FirebaseBootstrap.isReady);
      return;
    }
    final hasFirebasePlist = await IosConfigService.hasFirebasePlist();
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
      'IOS_CONFIG firebase_plist=$hasFirebasePlist google_ok=$_googleConfigOk apple_ok=$_appleConfigOk clientIdPresent=$clientIdOk schemePresent=$hasScheme',
      level: AppLogLevel.info,
    );
  }

  Future<void> _loadRememberedEmail() async {
    try {
      final stored = await _secureStorage.read(key: _rememberEmailKey);
      if (!mounted) return;
      if (stored != null && stored.trim().isNotEmpty) {
        _emailCtrl.text = stored.trim();
        setState(() => _rememberMe = true);
      }
    } catch (_) {}
  }

  Future<void> _persistRememberedEmail(String email) async {
    try {
      if (_rememberMe && email.trim().isNotEmpty) {
        await _secureStorage.write(key: _rememberEmailKey, value: email.trim());
      } else {
        await _secureStorage.delete(key: _rememberEmailKey);
      }
    } catch (_) {}
  }

  void _notify(
    String message, {
    AppNotificationType type = AppNotificationType.info,
  }) {
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

  Future<void> _handleSocialAuth(
    Future<AuthResult> Function() handler, {
    required String provider,
  }) async {
    if (_loading) return;
    final l10n = AppLocalizations.of(context)!;
    if (!_firebaseReady) {
      _notify(l10n.firebaseConfigMissing, type: AppNotificationType.warning);
      return;
    }
    appLog(
      'auth',
      'AUTH_${provider.toUpperCase()}_START',
      level: AppLogLevel.info,
    );
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
      final idToken = authResult.providerIdToken;
      final firebaseIdToken = authResult.firebaseIdToken;
      final accessToken = authResult.accessToken;
      final authorizationCode = authResult.authorizationCode;
      final effectiveToken = provider == 'google'
          ? (firebaseIdToken?.isNotEmpty == true ? firebaseIdToken : idToken)
          : idToken;
      final tokenTrimmed = effectiveToken?.trim() ?? '';
      final tokenSegments = tokenTrimmed.isEmpty
          ? 0
          : tokenTrimmed.split('.').length;
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
          provider == 'google'
              ? l10n.googleTokenInvalid
              : l10n.tokenInvalidMessage,
          type: AppNotificationType.error,
        );
        return;
      }
      appLog(
        'auth',
        'AUTH_${provider.toUpperCase()}_TOKEN firebaseLen=${firebaseIdToken?.length ?? 0} idTokenLen=${idToken?.length ?? 0}',
        level: AppLogLevel.debug,
      );
      final res = await ApiService.socialLogin(
        provider: provider,
        idToken: effectiveToken,
        accessToken: idToken == null || idToken.isEmpty ? accessToken : null,
        authorizationCode: authorizationCode,
        platform: Platform.isIOS ? 'ios' : 'android',
      );
      if (!mounted) return;
      setState(() => _loading = false);
      final ok = res['ok'] == true;
      final status = res['statusCode'] ?? 0;
      final msg = (res['message'] ?? res['error'] ?? '').toString();
      if (!mounted) return;
      if (ok) {
        appLog(
          'auth',
          'AUTH_${provider.toUpperCase()}_RESULT ok',
          level: AppLogLevel.info,
        );
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
        context.go('/home');
      } else if (msg.toLowerCase().contains('popup_closed') ||
          msg.toLowerCase().contains('login cancelled')) {
        appLog(
          'auth',
          'AUTH_${provider.toUpperCase()}_RESULT cancelled',
          level: AppLogLevel.info,
        );
        return;
      } else if (status == 400 || status == 401) {
        appLog(
          'auth',
          'AUTH_${provider.toUpperCase()}_ERROR invalid',
          level: AppLogLevel.warn,
        );
        final mapped = _mapSocialAuthError(
          l10n,
          msg.isNotEmpty ? msg : 'TOKEN_INVALID',
        );
        _notify(mapped, type: AppNotificationType.error);
      } else {
        appLog(
          'auth',
          'AUTH_${provider.toUpperCase()}_ERROR',
          level: AppLogLevel.warn,
        );
        _notify(
          msg.isNotEmpty ? msg : AppLocalizations.of(context)!.loginFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      appLog(
        'auth',
        'AUTH_${provider.toUpperCase()}_ERROR $e',
        level: AppLogLevel.error,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      _notify(
        AppLocalizations.of(context)!.genericErrorWithDetails('$e'),
        type: AppNotificationType.error,
      );
    }
  }

  Future<AuthResult> _signInWithGoogle() async {
    final l10n = AppLocalizations.of(context)!;
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
          error: l10n.googleConfigMissing,
          statusCode: 500,
        );
      }
    }
    appLog('auth', 'AUTH_GOOGLE_PREFLIGHT_OK', level: AppLogLevel.info);
    appLog('auth', 'AUTH_GOOGLE_START', level: AppLogLevel.info);
    _googleBusy = true;
    try {
      final result = await AuthService.signInWithGoogle();
      if (result.ok && kDebugMode) {
        appLog(
          'auth',
          "firebaseToken len: ${result.firebaseIdToken?.length ?? 0}",
          level: AppLogLevel.debug,
        );
      }
      return result;
    } catch (e) {
      appLog('auth', 'AUTH_GOOGLE_ERROR $e', level: AppLogLevel.error);
      return AuthResult(ok: false, error: e.toString(), statusCode: 500);
    } finally {
      _googleBusy = false;
    }
  }

  Future<AuthResult> _signInWithApple() async {
    final l10n = AppLocalizations.of(context)!;
    appLog('auth', 'AUTH_APPLE_TAP', level: AppLogLevel.info);
    if (!await AuthService.isAppleAvailable()) {
      appLog('auth', 'AUTH_APPLE_ERROR not_available', level: AppLogLevel.warn);
      return AuthResult(
        ok: false,
        error: l10n.appleSignInUnavailable,
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

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      final email = _emailCtrl.text.trim().toLowerCase();
      final password = _passCtrl.text.trim();
      final res = await ApiService.login(email, password);

      if (!mounted) return;
      setState(() => _loading = false);

      final ok = res['ok'] == true;
      final status = res['statusCode'] ?? 0;
      final msg = (res['message'] ?? res['error'] ?? '').toString();

      // 🎯 Duruma göre kullanıcıya anlamlı mesaj göster
      if (ok) {
        //  Başarılı giriş
        final profile = res["profile"];
        final userId = profile?["id"] ?? profile?["_id"];
        if (userId != null) {
          final prefs = await SharedPreferences.getInstance();
          if (!mounted) return;
          await prefs.setString('userId', userId.toString());
          if (!mounted) return;
        }

        await _persistRememberedEmail(email);
        _notify(l10n.loginSuccess, type: AppNotificationType.success);
        if (!mounted) return;
        context.go('/home');
      } else if (status == 401) {
        _notify(l10n.loginInvalidCredentials, type: AppNotificationType.error);
      } else if (status == 403) {
        await _handleVerificationRequired(email, msg);
      } else if (status == 429) {
        _notify(l10n.loginTooManyAttempts, type: AppNotificationType.warning);
      } else {
        _notify(
          msg.isNotEmpty ? msg : l10n.loginFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notify(
        AppLocalizations.of(context)!.genericErrorWithDetails('$e'),
        type: AppNotificationType.error,
      );
    }
  }

  Future<void> _handleVerificationRequired(
    String email,
    String serverMessage,
  ) async {
    final normalized = email.trim().toLowerCase();
    final l10n = AppLocalizations.of(context)!;
    _notify(
      serverMessage.isNotEmpty ? serverMessage : l10n.loginVerificationRequired,
      type: AppNotificationType.warning,
    );
    if (normalized.isEmpty || !mounted) return;

    setState(() => _loading = true);
    try {
      final res = await ApiService.resendVerify(normalized);
      if (!mounted) return;
      final ok = res['ok'] == true;
      final info = (res['message'] ?? res['error'] ?? '').toString();
      if (info.isNotEmpty) {
        _notify(
          info,
          type: ok ? AppNotificationType.success : AppNotificationType.warning,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _notify(
        l10n.verificationSendFailedWithDetails('$e'),
        type: AppNotificationType.error,
      );
    }
    if (!mounted) return;
    setState(() => _loading = false);
    context.push('/verify', extra: normalized);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final rememberLabel = l10n.rememberMeLabel;
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: buildBackAppBar(context),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthMeshBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 20,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 430),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(34),
                              color: Colors.white.withValues(alpha: 0.92),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.95),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.16),
                                  blurRadius: 30,
                                  offset: const Offset(0, 16),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(28),
                                color: const Color(0xFFF0F2F9),
                              ),
                              padding: const EdgeInsets.fromLTRB(
                                18,
                                20,
                                18,
                                18,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      l10n.loginFormTitle,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      l10n.loginFormSubtitle,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF4D5361),
                                            height: 1.4,
                                          ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      l10n.email,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF626878),
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    _SoftTextField(
                                      child: TextFormField(
                                        controller: _emailCtrl,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: InputDecoration(
                                          hintText: l10n.emailHint,
                                          prefixIcon: const _FieldIcon(
                                            icon: Icons.alternate_email,
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.trim().isEmpty) {
                                            return l10n.validationEmailRequired;
                                          }
                                          final ok = RegExp(
                                            r'^\S+@\S+\.\S+$',
                                          ).hasMatch(v.trim());
                                          if (!ok) {
                                            return l10n.validationEmailInvalid;
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      l10n.passwordLabel,
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF626878),
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    _SoftTextField(
                                      child: TextFormField(
                                        controller: _passCtrl,
                                        obscureText: _obscure,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.deny(
                                            RegExp(r'\s'),
                                          ),
                                        ],
                                        decoration: InputDecoration(
                                          hintText: l10n.passwordHint,
                                          prefixIcon: const _FieldIcon(
                                            icon: Icons.lock_outline,
                                          ),
                                          suffixIcon: IconButton(
                                            onPressed: () => setState(
                                              () => _obscure = !_obscure,
                                            ),
                                            icon: Icon(
                                              _obscure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                            ),
                                          ),
                                        ),
                                        validator: (v) {
                                          if (v == null || v.isEmpty) {
                                            return l10n
                                                .validationPasswordRequired;
                                          }
                                          if (v.length < 6) {
                                            return l10n.validationMinChars('6');
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(
                                              () =>
                                                  _rememberMe = value ?? false,
                                            );
                                            if (!(value ?? false)) {
                                              _secureStorage.delete(
                                                key: _rememberEmailKey,
                                              );
                                            }
                                          },
                                        ),
                                        Text(rememberLabel),
                                        const Spacer(),
                                        TextButton(
                                          onPressed: () =>
                                              context.push('/forgot'),
                                          child: Text(l10n.loginForgotPassword),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    GradientButton(
                                      text: l10n.loginButtonLabel,
                                      onPressed: _loading ? null : _submit,
                                      loading: _loading,
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFF48FA9),
                                          Color(0xFFE66783),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      leading: const Icon(Icons.arrow_forward),
                                      radius: 18,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      glass: false,
                                    ),
                                    const SizedBox(height: 14),
                                    Row(
                                      children: [
                                        const Expanded(child: Divider()),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                          ),
                                          child: Text(
                                            l10n.loginSocialDivider,
                                            style: theme.textTheme.bodySmall
                                                ?.copyWith(
                                                  color: theme
                                                      .colorScheme
                                                      .onSurface
                                                      .withValues(alpha: 0.6),
                                                ),
                                          ),
                                        ),
                                        const Expanded(child: Divider()),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _SocialCircleButton(
                                          icon: Icons.mail_outline_rounded,
                                          borderColor: const Color(0xFF22242E),
                                          onTap: () =>
                                              context.push('/register'),
                                        ),
                                        const SizedBox(width: 14),
                                        _SocialCircleButton(
                                          icon: Icons.apple_rounded,
                                          filled: true,
                                          onTap:
                                              _loading ||
                                                  !_appleConfigOk ||
                                                  !_firebaseReady
                                              ? null
                                              : () => _handleSocialAuth(
                                                  _signInWithApple,
                                                  provider: 'apple',
                                                ),
                                        ),
                                        const SizedBox(width: 14),
                                        _SocialCircleButton(
                                          icon: Icons.g_mobiledata_rounded,
                                          borderColor: const Color(0xFFE96A84),
                                          foregroundColor: const Color(
                                            0xFFE84A68,
                                          ),
                                          onTap:
                                              _loading ||
                                                  !_googleConfigOk ||
                                                  !_firebaseReady
                                              ? null
                                              : () => _handleSocialAuth(
                                                  _signInWithGoogle,
                                                  provider: 'google',
                                                ),
                                        ),
                                      ],
                                    ),
                                    if (!_firebaseReady ||
                                        !_googleConfigOk ||
                                        !_appleConfigOk) ...[
                                      const SizedBox(height: 10),
                                      Text(
                                        !_firebaseReady
                                            ? l10n.firebaseConfigMissing
                                            : (!_googleConfigOk
                                                  ? l10n.googleConfigMissingIosScheme
                                                  : l10n.appleConfigMissing),
                                        style: theme.textTheme.bodySmall
                                            ?.copyWith(
                                              color: theme.colorScheme.error,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.loginNoAccount,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () => context.push('/register'),
                              child: Text(l10n.registerButtonLabel),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () => context.push('/admin/login'),
                          child: const Text('Yönetici Girişi'),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.copyrightNotice,
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.55,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftTextField extends StatelessWidget {
  const _SoftTextField({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.95),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.black.withValues(alpha: 0.08)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE96A84), width: 1.3),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFB3261E), width: 1.3),
          ),
        ),
      ),
      child: child,
    );
  }
}

class _SocialCircleButton extends StatelessWidget {
  const _SocialCircleButton({
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.borderColor,
    this.foregroundColor,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;
  final Color? borderColor;
  final Color? foregroundColor;

  @override
  Widget build(BuildContext context) {
    final fg = foregroundColor ?? (filled ? Colors.white : Colors.black87);
    final bg = filled ? Colors.black : Colors.white;
    return InkResponse(
      onTap: onTap,
      radius: 30,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: onTap == null ? bg.withValues(alpha: 0.45) : bg,
          border: Border.all(
            color: (borderColor ?? Colors.black).withValues(alpha: 0.45),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: fg.withValues(alpha: onTap == null ? 0.45 : 1),
        ),
      ),
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
