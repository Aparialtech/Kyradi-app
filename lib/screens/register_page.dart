import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/validators.dart';
import '../widgets/gradient_button.dart';
import '../widgets/api_settings_dialog.dart';
import '../widgets/section_card.dart';
import '../services/api_service.dart';
import '../widgets/app_notification.dart';
import '../l10n/app_localizations.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _surCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _tcCtrl = TextEditingController();
  final _telCtrl = TextEditingController(text: '+90 ');
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();
  DateTime? _birthDate;

  String _gender = 'none';
  bool _loading = false;
  bool _kvkkAccepted = false;
  bool _restrictedItemsAccepted = false;
  String _baseUrlLabel = ApiService.baseUrl;

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    if (!mounted) return;
    AppNotification.show(context, message: message, type: type);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surCtrl.dispose();
    _emailCtrl.dispose();
    _tcCtrl.dispose();
    _telCtrl.dispose();
    _passCtrl.dispose();
    _pass2Ctrl.dispose();
    super.dispose();
  }

  Future<void> _pickBirth() async {
    final now = DateTime.now();
    final l10n = AppLocalizations.of(context)!;
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: DateTime(now.year - 100),
      lastDate: DateTime(now.year - 10),
      helpText: l10n.birthDate,
    );
    if (!mounted) return;
    if (picked != null) setState(() => _birthDate = picked);
  }

  Future<void> _openServerSettings() async {
    final outcome = await showApiSettingsDialog(context);
    if (outcome == null) return;
    if (!mounted) return;
    setState(() => _baseUrlLabel = ApiService.baseUrl);
    _notify(outcome.message, type: AppNotificationType.info);
  }

  Future<void> _showAgreementDialog({
    required String title,
    required String body,
  }) async {
    final loc = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: SelectableText(body),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(loc.dialogDismiss),
          ),
        ],
      ),
    );
  }

  Future<void> _openAgreementPage({
    required String title,
    required String body,
    required ValueChanged<bool> onAccepted,
  }) async {
    final accepted = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => AgreementReadPage(
          title: title,
          body: body,
        ),
      ),
    );
    if (accepted == true) {
      if (!mounted) return;
      onAccepted(true);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_birthDate == null) {
      _notify(l10n.validationBirthDateRequired, type: AppNotificationType.warning);
      return;
    }
    if (!_kvkkAccepted) {
      _notify(
        l10n.registerKvkkAgreementWarning,
        type: AppNotificationType.warning,
      );
      return;
    }
    if (!_restrictedItemsAccepted) {
      _notify(
        l10n.registerRestrictedAgreementWarning,
        type: AppNotificationType.warning,
      );
      return;
    }

    final sanitizedTc = _tcCtrl.text.replaceAll(RegExp(r'\s+'), '');
    String sanitizedPhone =
        _telCtrl.text.replaceAll(RegExp(r'\s+'), '').replaceAll('-', '');
    sanitizedPhone = sanitizedPhone.replaceAll('+', '');
    if (sanitizedPhone.isNotEmpty) {
      sanitizedPhone = '+$sanitizedPhone';
    }

    setState(() => _loading = true);
    try {
      final res = await ApiService.register({
        "name": _nameCtrl.text.trim(),
        "surname": _surCtrl.text.trim(),
        "email": _emailCtrl.text.trim().toLowerCase(),
        "tc": sanitizedTc,
        "phone": sanitizedPhone,
        "password": _passCtrl.text.trim(),
        "birthDate": _birthDate!.toIso8601String(),
        "gender": _gender,
      });

      if (!mounted) return;
      setState(() => _loading = false);

      final ok = res["ok"] == true;
      final status = res["statusCode"] ?? res["_httpStatus"] ?? 0;
      final msg = (res["message"] ?? res["error"] ?? "").toString();

      if (ok) {
        _notify(
          l10n.registerSuccessMessage,
          type: AppNotificationType.success,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          '/verify',
          arguments: _emailCtrl.text.trim(),
        );
      }
      // 🔹 409 veya “email already” gibi durumlar
      else if (status == 409 ||
          msg.toLowerCase().contains("email") ||
          msg.toLowerCase().contains("already")) {
        _notify(l10n.registerEmailExistsMessage, type: AppNotificationType.error);
      }
      // 🔹 diğer backend hataları
      else {
        _notify(
          msg.isNotEmpty ? msg : l10n.registerGenericErrorMessage,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _notify(l10n.genericErrorWithDetails('$e'), type: AppNotificationType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
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
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SectionCard(
                  child: Column(
                    children: [
                      SectionHeader(
                        title: l10n.registerPersonalSectionTitle,
                        subtitle: l10n.registerPersonalSectionSubtitle,
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 18),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _nameCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.firstName,
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? l10n.validationRequired : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _surCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.lastName,
                                prefixIcon: const Icon(Icons.person_rounded),
                              ),
                              validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? l10n.validationRequired : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      InkWell(
                        onTap: _pickBirth,
                        borderRadius: BorderRadius.circular(18),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n.birthDate,
                            prefixIcon: const Icon(Icons.event),
                          ),
                          child: Text(
                            _birthDate == null
                                ? l10n.formNotSelected
                                : '${_birthDate!.day.toString().padLeft(2, '0')}.'
                                  '${_birthDate!.month.toString().padLeft(2, '0')}.'
                                  '${_birthDate!.year}',
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        key: ValueKey(_gender),
                        initialValue: _gender,
                        items: [
                          DropdownMenuItem(
                            value: 'male',
                            child: Text(l10n.genderMale),
                          ),
                          DropdownMenuItem(
                            value: 'female',
                            child: Text(l10n.genderFemale),
                          ),
                          DropdownMenuItem(
                            value: 'none',
                            child: Text(l10n.genderUndisclosed),
                          ),
                        ],
                        onChanged: (v) => setState(() => _gender = v ?? 'none'),
                        decoration: InputDecoration(
                          labelText: l10n.gender,
                          prefixIcon: const Icon(Icons.wc),
                        ),
                      ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                SectionCard(
                  child: Column(
                    children: [
                      SectionHeader(
                        title: l10n.registerContactSectionTitle,
                        subtitle: l10n.registerContactSectionSubtitle,
                        icon: Icons.contact_mail_outlined,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: l10n.emailAddressLabel,
                          hintText: l10n.emailHint,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        validator: (v) => AppValidators.email(v, l10n),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _tcCtrl,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(11),
                          AppValidators.digitsOnlyFormatter,
                        ],
                        decoration: InputDecoration(
                          labelText: l10n.nationalIdLabel,
                          prefixIcon: const Icon(Icons.credit_card),
                        ),
                        validator: (v) => AppValidators.tcKimlik(v, l10n),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _telCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: l10n.phone,
                          hintText: l10n.phoneHint,
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                        validator: (v) => AppValidators.phone(v, l10n),
                      ),
                    ],
                  ),
                ),
                  const SizedBox(height: 18),
                SectionCard(
                  child: Column(
                    children: [
                      SectionHeader(
                        title: l10n.registerSecuritySectionTitle,
                        subtitle: l10n.registerSecuritySectionSubtitle,
                        icon: Icons.lock_outline_rounded,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _passCtrl,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.passwordLabel,
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                          onChanged: (_) => _formKey.currentState?.validate(),
                          validator: (v) => AppValidators.password(v, l10n),
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _pass2Ctrl,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'\s')),
                          ],
                          decoration: InputDecoration(
                            labelText: l10n.registerPasswordRepeatLabel,
                            prefixIcon: const Icon(Icons.verified_user_outlined),
                          ),
                          onChanged: (_) => _formKey.currentState?.validate(),
                          validator: (v) => AppValidators.passwordRepeat(
                            v?.trim(),
                            _passCtrl.text.trim(),
                            l10n,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _AgreementTile(
                          accepted: _kvkkAccepted,
                          label: l10n.registerKvkkAgreementLabel,
                          onOpen: () => _openAgreementPage(
                            title: l10n.registerKvkkDialogTitle,
                            body: l10n.registerKvkkDocumentBody,
                            onAccepted: (v) => setState(() => _kvkkAccepted = v),
                          ),
                          actionLabel: l10n.registerAgreementView,
                        ),
                        _AgreementTile(
                          accepted: _restrictedItemsAccepted,
                          label: l10n.registerRestrictedAgreementLabel,
                          onOpen: () => _openAgreementPage(
                            title: l10n.registerRestrictedDialogTitle,
                            body: l10n.registerRestrictedDocumentBody,
                            onAccepted: (v) => setState(
                              () => _restrictedItemsAccepted = v,
                            ),
                          ),
                          actionLabel: l10n.registerAgreementView,
                        ),
                        const SizedBox(height: 8),
                        GradientButton(
                          text: l10n.registerButtonLabel,
                          onPressed: _loading ? null : _submit,
                          loading: _loading,
                        ),
                      ],
                    ),
                ),
                const SizedBox(height: 18),
                Text(
                  l10n.copyrightNotice,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementTile extends StatelessWidget {
  const _AgreementTile({
    required this.accepted,
    required this.label,
    required this.onOpen,
    required this.actionLabel,
  });

  final bool accepted;
  final String label;
  final VoidCallback onOpen;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: accepted ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: const Icon(
              Icons.check_circle,
              color: Color(0xFF2E7D32),
              size: 20,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label),
                TextButton(
                  onPressed: onOpen,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    actionLabel,
                    style: theme.textTheme.labelLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AgreementReadPage extends StatefulWidget {
  const AgreementReadPage({
    super.key,
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  State<AgreementReadPage> createState() => _AgreementReadPageState();
}

class _AgreementReadPageState extends State<AgreementReadPage> {
  final ScrollController _controller = ScrollController();
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_handleScroll);
    _controller.dispose();
    super.dispose();
  }

  void _handleScroll() {
    if (!_controller.hasClients) return;
    final max = _controller.position.maxScrollExtent;
    final current = max <= 0 ? 0.0 : (_controller.offset / max);
    setState(() => _progress = current.clamp(0.0, 1.0));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final atEnd = _progress >= 1.0;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: BackButton(
          onPressed: () => Navigator.of(context).pop(atEnd),
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: SelectableText(widget.body),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    height: 14,
                    color: theme.colorScheme.surfaceContainerHighest,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 200),
                        tween: Tween<double>(begin: 0, end: _progress),
                        builder: (context, value, _) {
                          return FractionallySizedBox(
                            widthFactor: value.clamp(0.0, 1.0),
                            child: Container(
                              color: const Color(0xFF2E7D32),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedOpacity(
                opacity: atEnd ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(
                  Icons.check_circle,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
