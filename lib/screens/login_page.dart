// lib/screens/login_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/gradient_button.dart';
import '../widgets/api_settings_dialog.dart';
import '../widgets/section_card.dart';
import '../services/api_service.dart';
import '../widgets/app_notification.dart';
import '../l10n/app_localizations.dart';
import 'home_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart'; // ✅ eklendi

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String _baseUrlLabel = ApiService.baseUrl;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _openServerSettings() async {
    final outcome = await showApiSettingsDialog(context);
    if (outcome == null) return;
    if (!mounted) return;
    setState(() => _baseUrlLabel = ApiService.baseUrl);
    _notify(outcome.message, type: AppNotificationType.info);
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
        // ✅ Başarılı giriş
        final profile = res["profile"];
        final userId = profile?["id"];
        if (userId != null) {
          final prefs = await SharedPreferences.getInstance();
          if (!mounted) return;
          await prefs.setString('userId', userId.toString());
        }

        _notify(l10n.loginSuccess, type: AppNotificationType.success);
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      } else if (status == 401) {
        _notify(l10n.loginInvalidCredentials, type: AppNotificationType.error);
      } else if (status == 403) {
        await _handleVerificationRequired(email, msg);
      } else if (status == 429) {
        _notify(
          l10n.loginTooManyAttempts,
          type: AppNotificationType.warning,
        );
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

  Future<void> _handleVerificationRequired(String email, String serverMessage) async {
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
      _notify(l10n.verificationSendFailedWithDetails('$e'), type: AppNotificationType.error);
    }
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.pushNamed(context, '/verify', arguments: normalized);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F8FC), Color(0xFFEFF2F7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerRight,
                        child: QuickActionTile(
                          label: l10n.serverButtonLabel,
                          icon: Icons.settings_ethernet,
                          onTap: _openServerSettings,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SectionCard(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
                        child: Column(
                          children: [
                            Container(
                              height: 72,
                              width: 72,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2C2966), Color(0xFF005C99)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF2C3E50).withValues(alpha: 0.18),
                                    blurRadius: 24,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/images/kyradi_logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18),
                            Text(
                              l10n.appTitle,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.1,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.loginHeroSubtitle,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      SectionCard(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: l10n.loginFormTitle,
                                subtitle: l10n.loginFormSubtitle,
                                icon: Icons.key_rounded,
                              ),
                              const SizedBox(height: 18),
                              TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: l10n.email,
                                  hintText: l10n.emailHint,
                                  prefixIcon: const Icon(Icons.alternate_email),
                                ),
                                validator: (v) {
                                  if (v == null || v.trim().isEmpty) {
                                    return l10n.validationEmailRequired;
                                  }
                                  final ok = RegExp(
                                    r'^\S+@\S+\.\S+$',
                                  ).hasMatch(v.trim());
                                  if (!ok) return l10n.validationEmailInvalid;
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _passCtrl,
                                obscureText: _obscure,
                                enableSuggestions: false,
                                autocorrect: false,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(RegExp(r'\s')),
                                ],
                                decoration: InputDecoration(
                                  labelText: l10n.passwordLabel,
                                  hintText: l10n.passwordHint,
                                  prefixIcon: const Icon(Icons.lock_outline),
                                  suffixIcon: IconButton(
                                    onPressed: () =>
                                        setState(() => _obscure = !_obscure),
                                    icon: Icon(
                                      _obscure ? Icons.visibility : Icons.visibility_off,
                                    ),
                                  ),
                                ),
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return l10n.validationPasswordRequired;
                                  }
                                  if (v.length < 6) {
                                    return l10n.validationMinChars('6');
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => const ForgotPasswordPage(),
                                        ),
                                      );
                                    },
                                    child: Text(l10n.loginForgotPassword),
                                  ),
                                  TextButton.icon(
                                    onPressed: () =>
                                        setState(() => _passCtrl.clear()),
                                    icon: const Icon(Icons.clear),
                                    label: Text(l10n.clearButton),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              GradientButton(
                                text: l10n.loginButtonLabel,
                                onPressed: _loading ? null : _submit,
                                loading: _loading,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      SectionCard(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              l10n.loginNoAccount,
                              style: theme.textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const RegisterPage(),
                                  ),
                                );
                              },
                              child: Text(l10n.registerButtonLabel),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SectionCard(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        child: Column(
                          children: [
                            Text(
                              l10n.copyrightNotice,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              l10n.serverStatus(_baseUrlLabel),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
