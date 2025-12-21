import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/app_notification.dart';
import '../widgets/gradient_button.dart';
import '../widgets/section_card.dart';
import '../l10n/app_localizations.dart';
import 'reset_password_page.dart'; // ✅ eklendi

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _loading = false;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  Timer? _timer;
  int _secondsLeft = 0;

  @override
  void dispose() {
    _timer?.cancel();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _startCountdown([int seconds = 60]) {
    _timer?.cancel();
    setState(() => _secondsLeft = seconds);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 1) {
        t.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    if (_secondsLeft > 0) return;

    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context)!;

    try {
      final email = _emailCtrl.text.trim().toLowerCase();
      final res = await ApiService.forgot(email);

      if (!mounted) return;
      final ok = res['ok'] == true;
      final status = res['statusCode'] ?? res['_httpStatus'] ?? 0;
      final msg = (res['message'] ?? res['error'] ?? '').toString();

      // ✅ Başarılı gönderim
      if (ok) {
        _notify(l10n.forgotCodeSent, type: AppNotificationType.success);
        _startCountdown(60);

        // Kod giriş ekranına hemen geç
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResetPasswordPage(email: email),
          ),
        );
      }
      // ❌ E-posta bulunamadı
      else if (status == 404 || msg.toLowerCase().contains('not found')) {
        _notify(l10n.forgotEmailNotFound, type: AppNotificationType.error);
      }
      // ⚠️ Çok fazla deneme
      else if (status == 429 || msg.toLowerCase().contains('too many')) {
        _notify(
          l10n.forgotTooManyAttempts,
          type: AppNotificationType.warning,
        );
      }
      // 🔹 Diğer hatalar
      else {
        _notify(
          msg.isNotEmpty ? msg : l10n.forgotCodeFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _notify(l10n.genericErrorWithDetails('$e'), type: AppNotificationType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotTitle)),
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
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 24),
                  child: Column(
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Color(0xFF2C2966), Color(0xFF005C99)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.lock_reset, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.forgotIntro,
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
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SectionHeader(
                          title: l10n.forgotEmailSectionTitle,
                          subtitle: l10n.forgotEmailSectionSubtitle,
                          icon: Icons.mail_outline,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.emailAddressLabel,
                            hintText: l10n.emailHint,
                            prefixIcon: const Icon(Icons.alternate_email),
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return l10n.validationEmailRequired;
                            }
                            final ok = RegExp(r'^\S+@\S+\.\S+$').hasMatch(v.trim());
                            if (!ok) {
                              return l10n.validationEmailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        GradientButton(
                          text: (_secondsLeft > 0)
                              ? l10n.forgotResendCountdown(_secondsLeft)
                              : l10n.forgotSendButton,
                          leading: const Icon(Icons.send_rounded),
                          onPressed:
                              (_secondsLeft > 0 || _loading) ? null : _sendCode,
                          loading: _loading,
                        ),
                        const SizedBox(height: 6),
                        TextButton.icon(
                          icon: const Icon(Icons.key),
                          label: Text(l10n.forgotAlreadyHaveCode),
                          onPressed: _loading
                              ? null
                              : () {
                                  final email = _emailCtrl.text.trim().toLowerCase();
                                  final isValid = _formKey.currentState?.validate() ?? false;
                                  if (!isValid) {
                                    _notify(
                                      l10n.forgotNeedValidEmail,
                                      type: AppNotificationType.warning,
                                    );
                                    return;
                                  }
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => ResetPasswordPage(email: email),
                                    ),
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                SectionCard(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  child: Text(
                    l10n.copyrightNotice,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
