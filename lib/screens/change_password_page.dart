import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_localizations.dart';
import '../services/api_service.dart';
import '../services/local_notification_service.dart';
import '../widgets/app_notification.dart';
import '../widgets/gradient_button.dart';
import '../widgets/app_mesh_background.dart';
import '../ui/components/app_back_app_bar.dart';

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

  void _notify(
    String message, {
    AppNotificationType type = AppNotificationType.info,
  }) {
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
    final message = (res['message'] ?? res['error'] ?? loc.unknownError)
        .toString();
    _notify(
      message,
      type: res['ok'] == true
          ? AppNotificationType.success
          : AppNotificationType.error,
    );

    // ✅ Başarılıysa geri dön
    if (res['ok'] == true) {
      await LocalNotificationService.instance.showGeneric(
        title: 'KYRADI Güvenlik',
        body: 'Şifren başarıyla değiştirildi.',
        channelId: 'kyradi_auth',
        channelName: 'Hesap Bildirimleri',
        channelDescription: 'Giriş ve güvenlik bildirimleri',
      );
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const cardTextColor = Color(0xFF1F2431);
    const cardSubTextColor = Color(0xFF596074);
    final panelOuter = Colors.white.withValues(alpha: isDark ? 0.9 : 0.92);
    final panelInner = isDark
        ? const Color(0xFFF5F7FC)
        : const Color(0xFFF0F2F9);
    final formTheme = theme.copyWith(
      textTheme: theme.textTheme.apply(
        bodyColor: cardTextColor,
        displayColor: cardTextColor,
      ),
      colorScheme: theme.colorScheme.copyWith(
        onSurface: cardTextColor,
        onSurfaceVariant: cardSubTextColor,
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: buildBackAppBar(context, title: loc.changePassword),
      body: Stack(
        children: [
          const AppMeshBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 28),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(34),
                    color: panelOuter,
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
                      color: panelInner,
                    ),
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                    child: Theme(
                      data: formTheme,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              loc.changePassword,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: cardTextColor,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              loc.changePasswordIntro,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cardSubTextColor,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 18),
                            _AuthLikeField(
                              child: TextFormField(
                                controller: _oldCtrl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: loc.oldPassword,
                                  prefixIcon: const Icon(
                                    Icons.lock_open_outlined,
                                  ),
                                ),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? loc.validationRequired
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _AuthLikeField(
                              child: TextFormField(
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
                            ),
                            const SizedBox(height: 12),
                            _AuthLikeField(
                              child: TextFormField(
                                controller: _new2Ctrl,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: loc.confirmNewPassword,
                                  prefixIcon: const Icon(
                                    Icons.verified_user_outlined,
                                  ),
                                ),
                                validator: (v) => (v != _newCtrl.text)
                                    ? loc.passwordMismatch
                                    : null,
                              ),
                            ),
                            const SizedBox(height: 22),
                            GradientButton(
                              text: loc.changePassword,
                              leading: const Icon(Icons.save_alt),
                              onPressed: _loading ? null : _submit,
                              loading: _loading,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFF48FA9), Color(0xFFE66783)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              glass: false,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthLikeField extends StatelessWidget {
  const _AuthLikeField({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color(0xFF1F2431),
          displayColor: const Color(0xFF1F2431),
        ),
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(onSurface: const Color(0xFF1F2431)),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.95),
          hintStyle: const TextStyle(color: Color(0xFF7A8396)),
          labelStyle: const TextStyle(color: Color(0xFF7A8396)),
          floatingLabelStyle: const TextStyle(color: Color(0xFFE96A84)),
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
        ),
      ),
      child: child,
    );
  }
}
