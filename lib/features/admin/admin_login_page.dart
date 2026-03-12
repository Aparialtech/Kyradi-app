import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/auth_mesh_background.dart';
import '../../widgets/gradient_button.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _notify(
    String message, {
    AppNotificationType type = AppNotificationType.info,
  }) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_loading) return;
    setState(() => _loading = true);
    try {
      final email = _emailCtrl.text.trim().toLowerCase();
      final password = _passCtrl.text.trim();
      final res = await ApiService.login(email, password);
      if (!mounted) return;
      if (res['ok'] != true) {
        setState(() => _loading = false);
        _notify(
          (res['error'] ?? res['message'] ?? 'Giriş başarısız').toString(),
          type: AppNotificationType.error,
        );
        return;
      }

      final profile = (res['profile'] is Map)
          ? Map<String, dynamic>.from(res['profile'] as Map)
          : <String, dynamic>{};
      final role = (profile['role'] ?? 'user').toString().toLowerCase();
      final isAdmin = role == 'admin' || role == 'editor';
      if (!isAdmin) {
        await ApiService.clearSession();
        if (!mounted) return;
        setState(() => _loading = false);
        _notify(
          'Bu hesap yönetici yetkisine sahip değil.',
          type: AppNotificationType.warning,
        );
        return;
      }

      final userId = (profile['id'] ?? profile['_id'] ?? '').toString();
      if (userId.isNotEmpty) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
      }
      if (!mounted) return;
      setState(() => _loading = false);
      _notify('Yönetici girişi başarılı', type: AppNotificationType.success);
      context.go('/admin/panel');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notify('Yönetici girişi hatası: $e', type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final adminTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFFE96A84),
        brightness: Brightness.light,
      ),
    );
    return Theme(
      data: adminTheme,
      child: Builder(
        builder: (context) {
          final theme = Theme.of(context);
          return Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  if (Navigator.of(context).canPop()) {
                    Navigator.of(context).maybePop();
                    return;
                  }
                  context.go('/login');
                },
              ),
            ),
            body: Stack(
              fit: StackFit.expand,
              children: [
                const AuthMeshBackground(),
                SafeArea(
                  child: Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: ConstrainedBox(
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
                            padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
                            child: Theme(
                              data: theme.copyWith(
                                inputDecorationTheme: InputDecorationTheme(
                                  filled: true,
                                  fillColor: Colors.white.withValues(
                                    alpha: 0.95,
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide: BorderSide(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                    ),
                                  ),
                                  focusedBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFE96A84),
                                      width: 1.3,
                                    ),
                                  ),
                                  errorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFB3261E),
                                      width: 1.1,
                                    ),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    borderSide: BorderSide(
                                      color: Color(0xFFB3261E),
                                      width: 1.3,
                                    ),
                                  ),
                                ),
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Admin Sign In',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Sadece admin/editor hesaplar bu alana erisebilir.',
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: const Color(0xFF4D5361),
                                            height: 1.4,
                                          ),
                                    ),
                                    const SizedBox(height: 18),
                                    Text(
                                      'E-posta',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF626878),
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _emailCtrl,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: const InputDecoration(
                                        hintText: 'admin@kyradi.com',
                                        prefixIcon: _AdminFieldIcon(
                                          icon: Icons.alternate_email,
                                        ),
                                      ),
                                      validator: (value) {
                                        final v = (value ?? '').trim();
                                        if (v.isEmpty) return 'E-posta zorunlu';
                                        if (!RegExp(
                                          r'^\\S+@\\S+\\.\\S+$',
                                        ).hasMatch(v)) {
                                          return 'Geçerli e-posta gir';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Şifre',
                                      style: theme.textTheme.labelLarge
                                          ?.copyWith(
                                            color: const Color(0xFF626878),
                                          ),
                                    ),
                                    const SizedBox(height: 6),
                                    TextFormField(
                                      controller: _passCtrl,
                                      obscureText: _obscure,
                                      decoration: InputDecoration(
                                        hintText: '******',
                                        prefixIcon: const _AdminFieldIcon(
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
                                      validator: (value) {
                                        final v = (value ?? '').trim();
                                        if (v.isEmpty) return 'Şifre zorunlu';
                                        if (v.length < 6) {
                                          return 'En az 6 karakter gir';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 18),
                                    GradientButton(
                                      text: 'Yönetim Paneline Gir',
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
                                      glass: false,
                                      radius: 18,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
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
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AdminFieldIcon extends StatelessWidget {
  const _AdminFieldIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [Color(0xFFF8B8C5), Color(0xFFF192A6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE96A84).withValues(alpha: 0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, size: 15, color: Colors.white),
    );
  }
}
