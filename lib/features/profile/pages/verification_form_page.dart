import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_notification.dart';
import '../../../l10n/app_localizations.dart';
import 'email_otp_verify_page.dart';

class VerificationFormPage extends StatefulWidget {
  const VerificationFormPage({super.key, required this.user});

  final UserModel user;

  @override
  State<VerificationFormPage> createState() => _VerificationFormPageState();
}

class _VerificationFormPageState extends State<VerificationFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _surnameCtrl;
  late final TextEditingController _nationalIdCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _addressCtrl;
  DateTime? _birthDate;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.user.name);
    _surnameCtrl = TextEditingController(text: widget.user.surname);
    _nationalIdCtrl = TextEditingController(text: widget.user.nationalId ?? '');
    _phoneCtrl = TextEditingController(text: widget.user.phone);
    _addressCtrl = TextEditingController(text: widget.user.address);
    _birthDate = widget.user.birthDate != null && widget.user.birthDate!.isNotEmpty
        ? DateTime.tryParse(widget.user.birthDate!)
        : null;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _nationalIdCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 20),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 10),
    );
    if (!mounted) return;
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    AppNotification.show(context, message: message, type: type);
  }

  Future<void> _submit() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      _notify(loc.birthDateRequiredMessage, type: AppNotificationType.warning);
      return;
    }
    setState(() => _loading = true);
    final payload = {
      'name': _nameCtrl.text.trim(),
      'surname': _surnameCtrl.text.trim(),
      'birthDate': _birthDate!.toIso8601String(),
      'nationalId': _nationalIdCtrl.text.trim(),
      'phone': _phoneCtrl.text.trim(),
      'address': _addressCtrl.text.trim(),
    };
    try {
      final res = await ApiService.updateMyProfile(payload);
      if (!mounted) return;
      if (res['ok'] == true) {
        await ApiService.startEmailVerification();
        if (!mounted) return;
        setState(() => _loading = false);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const EmailOtpVerifyPage()),
        );
      } else {
        final msg = (res['message'] ?? res['error'] ?? loc.saveProfileError)
            .toString();
        setState(() => _loading = false);
        _notify(msg, type: AppNotificationType.error);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notify(loc.genericErrorWithDetails('$e'), type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.accountVerificationTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: InputDecoration(labelText: loc.firstName),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? loc.requiredFieldLabel : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _surnameCtrl,
                  decoration: InputDecoration(labelText: loc.lastName),
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? loc.requiredFieldLabel : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _nationalIdCtrl,
                  decoration: InputDecoration(labelText: loc.nationalIdLabel),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _phoneCtrl,
                  decoration: InputDecoration(labelText: loc.phone),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _addressCtrl,
                  decoration: InputDecoration(labelText: loc.address),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(_birthDate == null
                      ? loc.birthDateSelectLabel
                      : _birthDate!.toLocal().toString().split(' ').first),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: _pickBirthDate,
                ),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(loc.save),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
