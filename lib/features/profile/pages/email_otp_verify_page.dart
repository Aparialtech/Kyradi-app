import 'dart:async';
import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

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
      final loc = AppLocalizations.of(context)!;
      _notify(loc.verificationSuccessMessage, type: AppNotificationType.success);
      Navigator.of(context).pop(true);
    } else {
      final loc = AppLocalizations.of(context)!;
      final msg = (res['message'] ??
              res['error'] ??
              loc.verificationCodeInvalidMessage)
          .toString();
      _notify(msg, type: AppNotificationType.error);
    }
  }

  Future<void> _resend() async {
    final loc = AppLocalizations.of(context)!;
    final res = await ApiService.startEmailVerification();
    if (!mounted) return;
    if (res['ok'] == true) {
      _notify(loc.verificationResentMessage, type: AppNotificationType.success);
      _startTimer();
    } else {
      final msg =
          (res['message'] ?? res['error'] ?? loc.verificationSendErrorMessage)
              .toString();
      _notify(msg, type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.verificationTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SectionCard(
              child: Column(
                children: [
                  TextField(
                    controller: _codeCtrl,
                    keyboardType: TextInputType.number,
                    decoration:
                        InputDecoration(labelText: loc.verificationCodeLabel),
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
                        : Text(loc.verifyButtonLabel),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _seconds == 0 ? _resend : null,
                    child: Text(_seconds == 0
                        ? loc.verificationResendButton
                        : loc.verificationCountdownLabel(_seconds)),
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
