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
  bool _notRobot = false;
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final l10n = AppLocalizations.of(context)!;
    if (_birthDate == null) {
      _notify(l10n.validationBirthDateRequired, type: AppNotificationType.warning);
      return;
    }
    if (!_notRobot) {
      _notify(
        l10n.registerCaptchaWarning,
        type: AppNotificationType.warning,
      );
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
                Align(
                  alignment: Alignment.centerRight,
                  child: QuickActionTile(
                    label: l10n.serverButtonLabel,
                    icon: Icons.settings_ethernet,
                    onTap: _openServerSettings,
                  ),
                ),
                const SizedBox(height: 16),
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
                        CheckboxListTile(
                          value: _notRobot,
                          onChanged: (v) =>
                              setState(() => _notRobot = v ?? false),
                          title: Text(l10n.registerCaptchaLabel),
                          controlAffinity: ListTileControlAffinity.leading,
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        _AgreementCheckbox(
                          value: _kvkkAccepted,
                          label: l10n.registerKvkkAgreementLabel,
                          onChanged: (v) =>
                              setState(() => _kvkkAccepted = v ?? false),
                          onViewPressed: () => _showAgreementDialog(
                            title: l10n.registerKvkkDialogTitle,
                            body: _kvkkDocumentBody,
                          ),
                          viewLabel: l10n.registerAgreementView,
                        ),
                        _AgreementCheckbox(
                          value: _restrictedItemsAccepted,
                          label: l10n.registerRestrictedAgreementLabel,
                          onChanged: (v) =>
                              setState(() => _restrictedItemsAccepted = v ?? false),
                          onViewPressed: () => _showAgreementDialog(
                            title: l10n.registerRestrictedDialogTitle,
                            body: _restrictedItemsDocumentBody,
                          ),
                          viewLabel: l10n.registerAgreementView,
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
                Text(
                  l10n.serverStatus(_baseUrlLabel),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  const _AgreementCheckbox({
    required this.value,
    required this.label,
    required this.onChanged,
    required this.onViewPressed,
    required this.viewLabel,
  });

  final bool value;
  final String label;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onViewPressed;
  final String viewLabel;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      controlAffinity: ListTileControlAffinity.leading,
      dense: false,
      contentPadding: EdgeInsets.zero,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          TextButton(
            onPressed: onViewPressed,
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 32),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(viewLabel),
          ),
        ],
      ),
    );
  }
}

const String _kvkkDocumentBody = '''
1. Giriş
Bu metin, KYRADI platformu kapsamında işlenen kişisel verilerin KVKK'ya uygun şekilde nasıl işlendiğini açıklar.

2. İşlenen Kişisel Veri Türleri
2.1 Müşteri Verileri
- Ad Soyad
- Telefon
- QR kod tokenı
- Rezervasyon ve dolap bilgisi
- Ödeme tutarı ve işlem numarası

2.2 Personel Verileri
- Ad Soyad
- E-posta
- Kullanıcı rolü
- IP, işlem logları, oturum bilgisi

2.3 Teknik Veriler
- Audit log kayıtları
- Tarayıcı/cihaz bilgisi
- Hata raporları

3. Veri İşleme Amaçları
- Rezervasyon akışının sağlanması
- QR kod üretimi/doğrulaması
- Ödeme intent yönetimi
- Bagaj teslim ve iade süreci
- Sistem güvenliği ve kötüye kullanım tespiti
- Yasal saklamalar
- Raporlama ve platform iyileştirmeleri

4. Hukuki Dayanaklar
- KVKK m.5/2-c – sözleşmenin kurulması/ifası
- KVKK m.5/2-f – meşru menfaat
- KVKK m.5/2-ç – hukuki yükümlülük
- Açık rıza – isteğe bağlı bilgilendirmeler

5. Verilerin Aktarıldığı Taraflar
- Ödeme servisleri: Stripe, Iyzico
- Bulut sağlayıcılar: AWS, Google Cloud, Render, Vercel
- Kamu kurumları (zorunlu hallerde)
- Hukuk ve mali danışmanlar

6. Saklama Süreleri
- Rezervasyon: 10 yıl
- Ödeme: 10 yıl
- Audit log: 2 yıl
- Kullanıcı hesapları: kapanıştan 1 yıl sonra
- QR token: 1–24 saat

7. Güvenlik Tedbirleri
- Tenant bazlı veri izolasyonu
- Parola hashleme
- JWT tabanlı güvenlik
- Rol bazlı erişim kontrolü
- Rate limiting ve saldırı önleme
- Kritik işlemlerde audit log

8. Haklar (KVKK m.11)
- Veri işlenip işlenmediğini öğrenme
- Silme ve düzeltme talebi
- İşlemeye itiraz
- Tazminat talebi

Başvuru: kvkk@kyradi.com
''';

const String _restrictedItemsDocumentBody = '''
Bu belge, Aparial ve genel taşıma şirketleri tarafından taşınması reddedilen maddeleri özetlemektedir.

- Patlayıcı maddeler (dinamit, havai fişek, el bombası vb.)
- Yanıcı ve parlayıcı maddeler (benzin, tiner, boya, çözücü vb.)
- Basınçlı gazlar (propan, butan, oksijen tüpleri vb.)
- Toksik, zehirli veya aşındırıcı kimyasallar (asit, baz, ağartıcı vb.)
- Silahlar, mühimmat ve benzeri ateşli cihazlar
- Kesici veya delici aletler (hançer, uzun bıçak, sivri metal aletler vb.)
- Radyoaktif maddeler
- Yüksek kapasiteli veya yedek lityum piller ve bataryalar
- Ağır kokulu, duman çıkaran veya çevreyi rahatsız eden maddeler
- Gaz veya yakıt içeren cihazlar (yakıt dolu kamp ocakları vb.)
- Basınçlı aerosol kutuları (tehlikeli gaz içeren spreyler)
- Yanıcı kimyasallar içeren sıvılar veya çözücüler
- Patlama veya yangın riski oluşturan herhangi bir madde veya cihaz
- Ziynet eşyalar (altın, mücevher vb. değerli eşyalar) taşımaya kabul edilmez.
- Para (miktarına bakılmaksızın) taşımaya kabul edilmez.

Not: Bazı maddeler belirli izin, miktar veya güvenlik önlemleri ile taşınabilir. Ancak genel olarak bu tür maddeler hem Aparial hem de diğer taşıma şirketleri tarafından reddedilmektedir.
''';
