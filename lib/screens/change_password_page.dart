import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../widgets/app_notification.dart';
import '../widgets/gradient_button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _oldCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _new2Ctrl = TextEditingController();
  bool _loading = false;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  @override
  void dispose() {
    _oldCtrl.dispose();
    _newCtrl.dispose();
    _new2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final loc = AppLocalizations.of(context)!;

    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    final userId = prefs.getString('userId');

    if (userId == null) {
      _notify(loc.profileUserMissing, type: AppNotificationType.error);
      return;
    }

    setState(() => _loading = true);

    // ✅ API çağrısı
    final res = await ApiService.changePassword(
      userId,
      _oldCtrl.text.trim(),
      _newCtrl.text.trim(),
    );

    if (!mounted) return;
    setState(() => _loading = false);

    // ✅ Geri bildirim
    final message =
        (res['message'] ?? res['error'] ?? loc.unknownError).toString();
    _notify(
      message,
      type: res['ok'] == true
          ? AppNotificationType.success
          : AppNotificationType.error,
    );

    // ✅ Başarılıysa geri dön
    if (res['ok'] == true) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.changePassword)),
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
                          loc.changePasswordIntro,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withValues(alpha: 0.75),
                              ),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _oldCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: loc.oldPassword,
                            prefixIcon: const Icon(Icons.lock_open_outlined),
                          ),
                          validator: (v) =>
                              (v == null || v.isEmpty) ? loc.validationRequired : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _newCtrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: loc.newPassword,
                            hintText: loc.changePasswordRequirementHint,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return loc.validationRequired;
                            }
                            if (v.length < 8) {
                              return loc.validationMinChars(8);
                            }
                            if (!RegExp(
                              r'^(?=.*[A-Za-z])(?=.*\d)',
                            ).hasMatch(v)) {
                              return '${loc.validationPasswordNeedsLetter}\n${loc.validationPasswordNeedsNumber}';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _new2Ctrl,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: loc.confirmNewPassword,
                            prefixIcon: const Icon(Icons.verified_user_outlined),
                          ),
                          validator: (v) =>
                              (v != _newCtrl.text) ? loc.passwordMismatch : null,
                        ),
                        const SizedBox(height: 24),
                        GradientButton(
                          text: loc.changePassword,
                          leading: const Icon(Icons.save_alt),
                          onPressed: _loading ? null : _submit,
                          loading: _loading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
