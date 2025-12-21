import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/app_notification.dart';
import '../widgets/gradient_button.dart';
import '../l10n/app_localizations.dart';

class VerifyCodePage extends StatefulWidget {
  const VerifyCodePage({super.key});

  @override
  State<VerifyCodePage> createState() => _VerifyCodePageState();
}

class _VerifyCodePageState extends State<VerifyCodePage> {
  final _codeCtrl = TextEditingController();
  String _email = '';
  bool _loading = false;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  int _seconds = 0;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is String) {
      _email = args;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _startCountdown([int sec = 60]) {
    _timer?.cancel();
    setState(() => _seconds = sec);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  Future<void> _verify() async {
    final l10n = AppLocalizations.of(context)!;
    final code = _codeCtrl.text.trim();
    if (code.length != 6 || !RegExp(r'^\d{6}$').hasMatch(code)) {
      _notify(l10n.verificationCodeInvalidMessage, type: AppNotificationType.warning);
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ApiService.verifyCode(_email, code);
      if (res['ok'] == true) {
        _notify(l10n.verificationSuccessMessage, type: AppNotificationType.success);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        _notify(
          res['error']?.toString() ?? l10n.verificationErrorMessage,
          type: AppNotificationType.error,
        );
      }
    } catch (_) {
      _notify(l10n.verificationErrorMessage, type: AppNotificationType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resend() async {
    if (_seconds > 0) return;
    final l10n = AppLocalizations.of(context)!;
    if (_email.isEmpty) {
      _notify(l10n.verificationMissingEmailMessage,
          type: AppNotificationType.warning);
      return;
    }
    setState(() => _loading = true);
    try {
      final res = await ApiService.resendVerify(_email);
      if (res['ok'] == true) {
        _notify(l10n.verificationResentMessage, type: AppNotificationType.success);
        _startCountdown(60); // 60 sn kilitle
      } else {
        _notify(
          res['error']?.toString() ?? l10n.verificationSendErrorMessage,
          type: AppNotificationType.error,
        );
      }
    } catch (_) {
      _notify(l10n.verificationSendErrorMessage, type: AppNotificationType.error);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(title: Text(l10n.verificationTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.verificationInstructions(_email),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: _codeCtrl,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  labelText: l10n.verificationCodeLabel,
                  counterText: '',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),

              GradientButton(
                text: l10n.verifyButtonLabel,
                loading: _loading,
                onPressed: _loading ? null : _verify,
              ),

              const SizedBox(height: 8),
              TextButton(
                onPressed: (_seconds > 0 || _loading) ? null : _resend,
                child: Text(
                  _seconds > 0
                      ? l10n.verificationCountdownLabel(_seconds)
                      : l10n.verificationResendButton,
                ),
              ),

              const Spacer(),
              Text(
                l10n.copyrightNotice,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
