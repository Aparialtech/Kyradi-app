import 'package:flutter/material.dart';
import '../widgets/app_notification.dart';
import '../widgets/gradient_button.dart';
import '../services/api_service.dart';
import '../l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _codeCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  bool _loading = false;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final l10n = AppLocalizations.of(context)!;

    final res = await ApiService.reset(
      widget.email,
      _codeCtrl.text.trim(),
      _passCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    final ok = res['ok'] == true;
    final msg = res['message'] ?? res['error'] ?? l10n.unknownError;
    _notify(
      msg,
      type: ok ? AppNotificationType.success : AppNotificationType.error,
    );

    if (ok) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, "/login");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.resetTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.email,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.resetSubtitle,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.65,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _codeCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.verificationCodeLabel,
                            prefixIcon: const Icon(
                              Icons.confirmation_number_outlined,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) return l10n.validationVerificationCodeRequired;
                            if (v.length != 6) return l10n.validationVerificationCodeLength;
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _passCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.resetNewPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (v) {
                            if (v == null || v.length < 6) {
                              return l10n.validationMinChars('6');
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _pass2Ctrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: l10n.resetConfirmPasswordLabel,
                            prefixIcon: const Icon(Icons.verified_user_outlined),
                          ),
                          validator: (v) {
                            if (v != _passCtrl.text) {
                              return l10n.passwordMismatch;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 22),
                        GradientButton(
                          text: l10n.resetSubmitButton,
                          leading: const Icon(Icons.save_alt),
                          onPressed: _loading ? null : _submit,
                          loading: _loading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                l10n.copyrightNotice,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
