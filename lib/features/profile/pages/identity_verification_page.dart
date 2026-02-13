import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/section_card.dart';
import '../../../utils/tc_validator.dart';

class IdentityVerificationPage extends StatefulWidget {
  const IdentityVerificationPage({super.key});

  @override
  State<IdentityVerificationPage> createState() => _IdentityVerificationPageState();
}

class _IdentityVerificationPageState extends State<IdentityVerificationPage> {
  int _step = 0;
  bool _loading = true;
  bool _submitting = false;
  String? _error;

  bool _requireSelfie = false;
  String _status = 'unverified';

  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surnameCtrl = TextEditingController();
  final _tcCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();
  DateTime? _birthDate;

  String? _frontUrl;
  String? _backUrl;
  String? _selfieUrl;

  bool _uploadingFront = false;
  bool _uploadingBack = false;
  bool _uploadingSelfie = false;

  Timer? _otpTimer;
  int _otpSecondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _boot();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surnameCtrl.dispose();
    _tcCtrl.dispose();
    _otpCtrl.dispose();
    _otpTimer?.cancel();
    super.dispose();
  }

  Future<void> _boot() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final start = await ApiService.kycIdentityStart();
      if (!mounted) return;
      if (start['ok'] != true) {
        final msg = (start['message'] ?? start['error'] ?? 'KYC başlatılamadı').toString();
        setState(() {
          _error = msg;
          _loading = false;
        });
        return;
      }
      _requireSelfie = start['requireSelfie'] == true;

      final statusRes = await ApiService.kycIdentityStatus();
      if (!mounted) return;
      if (statusRes['ok'] == true) {
        _status = (statusRes['status'] ?? 'unverified').toString();
        _requireSelfie = statusRes['requireSelfie'] == true || _requireSelfie;
        final personal = statusRes['personal'] as Map<String, dynamic>? ?? {};
        final docs = statusRes['documents'] as Map<String, dynamic>? ?? {};
        if (_nameCtrl.text.trim().isEmpty && (personal['name'] ?? '').toString().isNotEmpty) {
          _nameCtrl.text = personal['name'].toString();
        }
        if (_surnameCtrl.text.trim().isEmpty && (personal['surname'] ?? '').toString().isNotEmpty) {
          _surnameCtrl.text = personal['surname'].toString();
        }
        if (_tcCtrl.text.trim().isEmpty && (personal['tcNo'] ?? '').toString().isNotEmpty) {
          _tcCtrl.text = personal['tcNo'].toString();
        }
        final birthRaw = (personal['birthDate'] ?? '').toString().trim();
        if (_birthDate == null && birthRaw.isNotEmpty) {
          final parsed = DateTime.tryParse(birthRaw);
          if (parsed != null) _birthDate = parsed;
        }
        _frontUrl = (docs['idFrontUrl'] ?? '').toString();
        _backUrl = (docs['idBackUrl'] ?? '').toString();
        _selfieUrl = (docs['selfieUrl'] ?? '').toString();
        final missing = (statusRes['missing'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];
        if (_status != 'verified' && _status != 'pending_otp') {
          if (missing.contains('personal')) {
            _step = 0;
          } else if (missing.contains('id_front') || missing.contains('id_back')) {
            _step = 1;
          } else if (_requireSelfie && missing.contains('selfie')) {
            _step = 2;
          } else {
            _step = 3;
          }
        }
      }
      setState(() => _loading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  void _notify(String message, {AppNotificationType type = AppNotificationType.info}) {
    AppNotification.show(context, message: message, type: type);
  }

  void _startOtpTimer(int minutes) {
    _otpTimer?.cancel();
    _otpSecondsLeft = minutes * 60;
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_otpSecondsLeft <= 1) {
        timer.cancel();
        setState(() => _otpSecondsLeft = 0);
        return;
      }
      setState(() => _otpSecondsLeft -= 1);
    });
  }

  Future<void> _verifyOtp() async {
    final loc = AppLocalizations.of(context)!;
    final code = _otpCtrl.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (code.length != 6) {
      _notify(loc.verificationCodeInvalidMessage, type: AppNotificationType.warning);
      return;
    }
    try {
      final res = await ApiService.kycVerifyOtp(code);
      if (!mounted) return;
      if (res['ok'] == true) {
        _status = (res['status'] ?? 'verified').toString();
        setState(() {});
        _notify(loc.identityVerifiedTitle, type: AppNotificationType.success);
      } else {
        final msg = (res['message'] ?? res['error'] ?? loc.verificationErrorMessage).toString();
        _notify(msg, type: AppNotificationType.error);
      }
    } catch (e) {
      if (!mounted) return;
      _notify('${loc.verificationErrorMessage}: $e', type: AppNotificationType.error);
    }
  }

  Future<void> _resendOtp() async {
    final loc = AppLocalizations.of(context)!;
    try {
      final res = await ApiService.kycResendOtp();
      if (!mounted) return;
      if (res['ok'] == true) {
        final ttl = (res['otpTtlMin'] is num) ? (res['otpTtlMin'] as num).toInt() : 10;
        _startOtpTimer(ttl);
        _notify(loc.verificationResentMessage, type: AppNotificationType.success);
      } else {
        final msg = (res['message'] ?? res['error'] ?? loc.verificationSendErrorMessage).toString();
        _notify(msg, type: AppNotificationType.error);
      }
    } catch (e) {
      if (!mounted) return;
      _notify('${loc.verificationSendErrorMessage}: $e', type: AppNotificationType.error);
    }
  }

  Future<void> _pickBirthDate() async {
    final loc = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 25),
      firstDate: DateTime(now.year - 110),
      lastDate: DateTime(now.year - 10),
      helpText: loc.birthDateSelectLabel,
    );
    if (!mounted) return;
    if (picked != null) setState(() => _birthDate = picked);
  }

  String _birthDateYmd(DateTime value) {
    final y = value.year.toString().padLeft(4, '0');
    final m = value.month.toString().padLeft(2, '0');
    final d = value.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<Uint8List?> _cropBytes(
    Uint8List bytes, {
    required double aspectRatio,
    required String title,
  }) async {
    final result = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(
        builder: (_) => _CropPage(
          title: title,
          bytes: bytes,
          aspectRatio: aspectRatio,
        ),
      ),
    );
    return result;
  }

  Future<void> _pickAndUpload({
    required String type,
    required double aspectRatio,
  }) async {
    final loc = AppLocalizations.of(context)!;
    final picker = ImagePicker();
    XFile? file;
    try {
      file = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 92,
        maxWidth: 2400,
      );
    } catch (_) {
      file = null;
    }
    if (file == null && kDebugMode) {
      file = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 92,
        maxWidth: 2400,
      );
    }
    if (!mounted) return;
    if (file == null) {
      _notify(loc.identityCameraRequiredMessage, type: AppNotificationType.warning);
      return;
    }

    final raw = await file.readAsBytes();
    if (!mounted) return;
    final cropped = await _cropBytes(
      raw,
      aspectRatio: aspectRatio,
      title: type == 'selfie' ? loc.selfieLabel : loc.identityPhotoLabel,
    );
    if (!mounted) return;
    if (cropped == null) return;

    setState(() {
      if (type == 'id_front') _uploadingFront = true;
      if (type == 'id_back') _uploadingBack = true;
      if (type == 'selfie') _uploadingSelfie = true;
    });
    try {
      final res = await ApiService.uploadIdentityDocument(
        bytes: cropped,
        filename: file.name,
        type: type,
      );
      if (!mounted) return;
      if (res['ok'] == true && (res['fileUrl'] ?? res['url']) != null) {
        final url = (res['fileUrl'] ?? res['url']).toString();
        setState(() {
          if (type == 'id_front') _frontUrl = url;
          if (type == 'id_back') _backUrl = url;
          if (type == 'selfie') _selfieUrl = url;
        });
        _notify(loc.uploadSuccessMessage, type: AppNotificationType.success);
      } else {
        final msg = (res['message'] ?? res['error'] ?? 'Yükleme başarısız').toString();
        _notify(msg, type: AppNotificationType.error);
      }
    } catch (e) {
      if (!mounted) return;
      _notify('Yükleme başarısız: $e', type: AppNotificationType.error);
    } finally {
      if (!mounted) return;
      setState(() {
        if (type == 'id_front') _uploadingFront = false;
        if (type == 'id_back') _uploadingBack = false;
        if (type == 'selfie') _uploadingSelfie = false;
      });
    }
  }

  Future<void> _savePersonal() async {
    final loc = AppLocalizations.of(context)!;
    if (!_formKey.currentState!.validate()) return;
    if (_birthDate == null) {
      _notify(loc.birthDateRequiredMessage, type: AppNotificationType.warning);
      return;
    }
    final tc = _tcCtrl.text.trim();
    if (!isValidTurkishId(tc)) {
      _notify(loc.nationalIdInvalidMessage, type: AppNotificationType.error);
      return;
    }
    final res = await ApiService.kycSaveIdentityPersonal(
      name: _nameCtrl.text.trim(),
      surname: _surnameCtrl.text.trim(),
      tcNo: tc,
      birthDate: _birthDateYmd(_birthDate!),
    );
    if (!mounted) return;
    if (res['ok'] != true) {
      final msg = (res['message'] ?? res['error'] ?? loc.saveProfileError).toString();
      _notify(msg, type: AppNotificationType.error);
      return;
    }
    _notify(loc.saveSuccessMessage, type: AppNotificationType.success);
  }

  bool get _docsOk {
    if (_frontUrl == null || _frontUrl!.isEmpty) return false;
    if (_backUrl == null || _backUrl!.isEmpty) return false;
    if (_requireSelfie && (_selfieUrl == null || _selfieUrl!.isEmpty)) return false;
    return true;
  }

  Future<void> _submit() async {
    final loc = AppLocalizations.of(context)!;
    if (_submitting) return;
    await _savePersonal();
    if (!_docsOk) {
      _notify('Lütfen kimlik fotoğraflarını yükleyin.', type: AppNotificationType.warning);
      return;
    }
    setState(() => _submitting = true);
    try {
      final res = await ApiService.kycSubmitIdentity();
      if (!mounted) return;
      if (res['ok'] == true) {
        _status = (res['status'] ?? 'pending_otp').toString();
        if (_status == 'pending_otp') {
          final ttl = (res['otpTtlMin'] is num) ? (res['otpTtlMin'] as num).toInt() : 10;
          _startOtpTimer(ttl);
        }
        setState(() {});
        _notify(loc.verificationCodeSentMessage, type: AppNotificationType.success);
      } else {
        final msg = (res['message'] ?? res['error'] ?? 'Gönderim başarısız').toString();
        _notify(msg, type: AppNotificationType.error);
      }
    } catch (e) {
      if (!mounted) return;
      _notify('Gönderim başarısız: $e', type: AppNotificationType.error);
    } finally {
      if (!mounted) return;
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final locked = _status == 'verified' || _status == 'pending_otp';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.accountVerificationTitle),
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  _error!,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else
            SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  if (_status == 'verified')
                    SectionCard(
                      child: Row(
                        children: [
                          ThreeDIconBadge(icon: Icons.verified, accent: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              loc.identityVerifiedTitle,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    )
                  else if (_status == 'pending_review')
                    SectionCard(
                      child: Row(
                        children: [
                          ThreeDIconBadge(icon: Icons.pending_actions, accent: theme.colorScheme.tertiary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              loc.identityPendingReviewTitle,
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_status == 'pending_otp')
                    SectionCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ThreeDIconBadge(icon: Icons.mark_email_read, accent: theme.colorScheme.primary),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  loc.verificationTitle,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(loc.kycOtpHint, style: theme.textTheme.bodySmall),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _otpCtrl,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(6),
                            ],
                            decoration: InputDecoration(
                              labelText: loc.verificationCodeLabel,
                              counterText: '',
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              FilledButton(
                                onPressed: _verifyOtp,
                                child: Text(loc.verifyAction),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: _otpSecondsLeft > 0 ? null : _resendOtp,
                                child: Text(
                                  _otpSecondsLeft > 0
                                      ? loc.verificationCountdownLabel(_otpSecondsLeft)
                                      : loc.verificationResendButton,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 12),
                  if (_status != 'verified')
                    SectionCard(
                      child: IgnorePointer(
                        ignoring: locked,
                        child: Stepper(
                          currentStep: _step,
                          onStepContinue: () async {
                            if (_step == 0) {
                              await _savePersonal();
                              if (!mounted) return;
                              setState(() => _step = 1);
                              return;
                            }
                            if (_step == 1) {
                              if (_frontUrl == null || _backUrl == null) {
                                _notify('Kimlik ön/arka fotoğrafı gerekli.', type: AppNotificationType.warning);
                                return;
                              }
                              if (_requireSelfie) {
                                setState(() => _step = 2);
                              } else {
                                setState(() => _step = 3);
                              }
                              return;
                            }
                            if (_step == 2) {
                              if (_requireSelfie && (_selfieUrl == null || _selfieUrl!.isEmpty)) {
                                _notify('Selfie gerekli.', type: AppNotificationType.warning);
                                return;
                              }
                              setState(() => _step = 3);
                              return;
                            }
                            if (_step == 3) {
                              await _submit();
                            }
                          },
                          onStepCancel: () {
                            if (_step == 0) {
                              Navigator.of(context).pop();
                            } else {
                              setState(() => _step -= 1);
                            }
                          },
                          controlsBuilder: (context, details) {
                            final isLast = details.currentStep == 3;
                            return Row(
                              children: [
                                FilledButton(
                                  onPressed: _submitting ? null : details.onStepContinue,
                                  child: _submitting && isLast
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : Text(isLast ? loc.submit : loc.nextAction),
                                ),
                                const SizedBox(width: 12),
                                OutlinedButton(
                                  onPressed: details.onStepCancel,
                                  child: Text(details.currentStep == 0 ? loc.cancel : loc.back),
                                ),
                              ],
                            );
                          },
                          steps: [
                            Step(
                              title: Text(loc.personalInfoTitle),
                              isActive: _step >= 0,
                              state: _step > 0 ? StepState.complete : StepState.indexed,
                              content: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    TextFormField(
                                      controller: _nameCtrl,
                                      enabled: !locked,
                                      decoration: InputDecoration(labelText: loc.firstName),
                                      validator: (v) => (v == null || v.trim().length < 2)
                                          ? loc.requiredFieldLabel
                                          : null,
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _surnameCtrl,
                                      enabled: !locked,
                                      decoration: InputDecoration(labelText: loc.lastName),
                                      validator: (v) => (v == null || v.trim().length < 2)
                                          ? loc.requiredFieldLabel
                                          : null,
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: _tcCtrl,
                                      keyboardType: TextInputType.number,
                                      enabled: !locked,
                                      decoration: InputDecoration(labelText: loc.nationalIdLabel),
                                      validator: (v) {
                                        final raw = (v ?? '').trim();
                                        if (raw.isEmpty) return loc.requiredFieldLabel;
                                        if (!isValidTurkishId(raw)) return loc.nationalIdInvalidMessage;
                                        return null;
                                      },
                                    ),
                                    const SizedBox(height: 12),
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        _birthDate == null
                                            ? loc.birthDateSelectLabel
                                            : _birthDateYmd(_birthDate!),
                                      ),
                                      trailing: const Icon(Icons.calendar_today_outlined),
                                      onTap: locked ? null : _pickBirthDate,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Step(
                              title: Text(loc.identityPhotosTitle),
                              isActive: _step >= 1,
                              state: _docsOk && !_requireSelfie ? StepState.complete : StepState.indexed,
                              content: Column(
                                children: [
                                  _DocRow(
                                    title: loc.identityFrontLabel,
                                    ok: _frontUrl?.isNotEmpty == true,
                                    loading: _uploadingFront,
                                    onPick: locked
                                        ? null
                                        : () => _pickAndUpload(type: 'id_front', aspectRatio: 4 / 3),
                                  ),
                                  const SizedBox(height: 10),
                                  _DocRow(
                                    title: loc.identityBackLabel,
                                    ok: _backUrl?.isNotEmpty == true,
                                    loading: _uploadingBack,
                                    onPick: locked
                                        ? null
                                        : () => _pickAndUpload(type: 'id_back', aspectRatio: 4 / 3),
                                  ),
                                ],
                              ),
                            ),
                            Step(
                              title: Text(loc.selfieStepTitle),
                              isActive: _step >= 2,
                              state: _requireSelfie
                                  ? (_selfieUrl?.isNotEmpty == true ? StepState.complete : StepState.indexed)
                                  : StepState.disabled,
                              content: _requireSelfie
                                  ? _DocRow(
                                      title: loc.selfieLabel,
                                      ok: _selfieUrl?.isNotEmpty == true,
                                      loading: _uploadingSelfie,
                                      onPick: locked
                                          ? null
                                          : () => _pickAndUpload(type: 'selfie', aspectRatio: 1),
                                    )
                                  : Text(loc.selfieNotRequiredMessage),
                            ),
                            Step(
                              title: Text(loc.reviewAndSubmitTitle),
                              isActive: _step >= 3,
                              state: StepState.indexed,
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(loc.reviewHint, style: theme.textTheme.bodySmall),
                                  const SizedBox(height: 10),
                                  _ReviewLine(label: loc.firstName, value: _nameCtrl.text.trim()),
                                  _ReviewLine(label: loc.lastName, value: _surnameCtrl.text.trim()),
                                  _ReviewLine(label: loc.nationalIdLabel, value: _tcCtrl.text.trim()),
                                  _ReviewLine(
                                    label: loc.birthDateSelectLabel,
                                    value: _birthDate == null ? '-' : _birthDateYmd(_birthDate!),
                                  ),
                                  const SizedBox(height: 6),
                                  Divider(color: theme.colorScheme.outlineVariant),
                                  const SizedBox(height: 6),
                                  _ReviewLine(label: loc.identityFrontLabel, value: _frontUrl != null ? loc.uploadedLabel : loc.missingLabel),
                                  _ReviewLine(label: loc.identityBackLabel, value: _backUrl != null ? loc.uploadedLabel : loc.missingLabel),
                                  if (_requireSelfie)
                                    _ReviewLine(label: loc.selfieLabel, value: _selfieUrl != null ? loc.uploadedLabel : loc.missingLabel),
                                ],
                              ),
                            ),
                          ],
                        ),
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

class _DocRow extends StatelessWidget {
  const _DocRow({
    required this.title,
    required this.ok,
    required this.loading,
    required this.onPick,
  });

  final String title;
  final bool ok;
  final bool loading;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          ThreeDIconBadge(
            icon: ok ? Icons.check_circle_rounded : Icons.photo_camera_outlined,
            accent: ok ? theme.colorScheme.primary : theme.colorScheme.secondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: loading ? null : onPick,
            child: loading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(ok ? 'Değiştir' : 'Yükle'),
          ),
        ],
      ),
    );
  }
}

class _ReviewLine extends StatelessWidget {
  const _ReviewLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value.isEmpty ? '-' : value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _CropPage extends StatefulWidget {
  const _CropPage({
    required this.title,
    required this.bytes,
    required this.aspectRatio,
  });

  final String title;
  final Uint8List bytes;
  final double aspectRatio;

  @override
  State<_CropPage> createState() => _CropPageState();
}

class _CropPageState extends State<_CropPage> {
  final _boundaryKey = GlobalKey();
  bool _saving = false;

  Future<void> _confirm() async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      final boundary = _boundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        if (!mounted) return;
        Navigator.of(context).pop<Uint8List>(null);
        return;
      }
      final image = await boundary.toImage(pixelRatio: 2.6);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final png = byteData?.buffer.asUint8List();
      if (!mounted) return;
      Navigator.of(context).pop<Uint8List>(png);
    } catch (_) {
      if (!mounted) return;
      Navigator.of(context).pop<Uint8List>(null);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: FilledButton(
              onPressed: _saving ? null : _confirm,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Kullan'),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          Center(
            child: RepaintBoundary(
              key: _boundaryKey,
              child: AspectRatio(
                aspectRatio: widget.aspectRatio,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.3),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.6),
                        width: 1.2,
                      ),
                    ),
                    child: InteractiveViewer(
                      minScale: 1.0,
                      maxScale: 4.0,
                      child: Image.memory(
                        widget.bytes,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Görseli çerçeve içine alıp yakınlaştırabilirsiniz.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
