import 'dart:async';
import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_notification.dart';

class EmailOtpVerifyPage extends StatefulWidget {
  const EmailOtpVerifyPage({super.key});

  @override
  State<EmailOtpVerifyPage> createState() => _EmailOtpVerifyPageState();
}

class _EmailOtpVerifyPageState extends State<EmailOtpVerifyPage> {
  final _codeCtrl = TextEditingController();
  Timer? _timer;
  int _seconds = 60;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _codeCtrl.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 60);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds <= 1) {
        t.cancel();
        setState(() => _seconds = 0);
      } else {
        setState(() => _seconds -= 1);
      }
    });
  }

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    AppNotification.show(context, message: message, type: type);
  }

  Future<void> _verify() async {
    final code = _codeCtrl.text.trim();
    if (code.length != 6) {
      _notify('6 haneli kod girin', type: AppNotificationType.warning);
      return;
    }
    setState(() => _loading = true);
    final res = await ApiService.verifyEmailCode(code);
    if (!mounted) return;
    setState(() => _loading = false);
    if (res['ok'] == true) {
      _notify('Hesap doğrulandı', type: AppNotificationType.success);
      Navigator.of(context).pop(true);
    } else {
      final msg = (res['message'] ?? res['error'] ?? 'Kod geçersiz').toString();
      _notify(msg, type: AppNotificationType.error);
    }
  }

  Future<void> _resend() async {
    final res = await ApiService.startEmailVerification();
    if (!mounted) return;
    if (res['ok'] == true) {
      _notify('Kod yeniden gönderildi', type: AppNotificationType.success);
      _startTimer();
    } else {
      final msg = (res['message'] ?? res['error'] ?? 'Gönderilemedi').toString();
      _notify(msg, type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('E-posta Doğrulama')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _codeCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: '6 haneli kod',
              ),
              maxLength: 6,
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _loading ? null : _verify,
              child: _loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Doğrula'),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _seconds == 0 ? _resend : null,
              child: Text(_seconds == 0
                  ? 'Tekrar gönder'
                  : 'Tekrar gönder ($_seconds)'),
            ),
          ],
        ),
      ),
    );
  }
}
