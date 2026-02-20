import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/api_service.dart';
import '../../widgets/app_notification.dart';
import '../../widgets/auth_mesh_background.dart';
import '../../widgets/gradient_button.dart';
import '../../widgets/section_card.dart';
import '../../ui/components/rainbow_bar.dart';

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
          (res['error'] ?? res['message'] ?? 'Giris basarisiz').toString(),
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
          'Bu hesap yonetici yetkisine sahip degil.',
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
      _notify('Yonetici girisi basarili', type: AppNotificationType.success);
      context.go('/admin/panel');
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notify('Yonetici girisi hatasi: $e', type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const RainbowBar(height: 4),
                  const SizedBox(height: 12),
                  SectionCard(
                    backgroundColor: theme.colorScheme.surface.withValues(
                      alpha: 0.92,
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yonetici Girisi',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sadece admin/editor hesaplar bu alana erisebilir.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionCard(
                    backgroundColor: theme.colorScheme.surface.withValues(
                      alpha: 0.95,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'E-posta',
                              hintText: 'admin@kyradi.com',
                              prefixIcon: Icon(Icons.alternate_email),
                            ),
                            validator: (value) {
                              final v = (value ?? '').trim();
                              if (v.isEmpty) return 'E-posta zorunlu';
                              if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(v)) {
                                return 'Gecerli e-posta gir';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passCtrl,
                            obscureText: _obscure,
                            decoration: InputDecoration(
                              labelText: 'Sifre',
                              hintText: '******',
                              prefixIcon: const Icon(Icons.lock_outline),
                              suffixIcon: IconButton(
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            validator: (value) {
                              final v = (value ?? '').trim();
                              if (v.isEmpty) return 'Sifre zorunlu';
                              if (v.length < 6) return 'En az 6 karakter gir';
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          GradientButton(
                            text: 'Yonetim Paneline Gir',
                            onPressed: _loading ? null : _submit,
                            loading: _loading,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0F766E), Color(0xFF14B8A6)],
                            ),
                            glass: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
