import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/user.dart';
import '../../../services/api_service.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';
import '../../../widgets/avatar_image.dart';
import '../../../core/profile_avatar_cache.dart';
import '../../../l10n/app_localizations.dart';
import '../../../ui/shell/shell_spacing.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, required this.user, this.avatarPath});

  final UserModel user;
  final String? avatarPath;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _surCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _birthCtrl = TextEditingController();

  bool _saving = false;
  String? _avatarPath;
  String? _avatarUploadUrl;

  AppLocalizations get loc => AppLocalizations.of(context)!;

  @override
  void initState() {
    super.initState();
    final user = widget.user;
    _nameCtrl.text = user.name;
    _surCtrl.text = user.surname;
    _phoneCtrl.text = user.phone;
    _addressCtrl.text = user.address;
    _nationalIdCtrl.text = user.nationalId ?? '';
    _birthCtrl.text = _formatBirthDate(user.birthDate);
    _avatarPath = widget.avatarPath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _surCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _nationalIdCtrl.dispose();
    _birthCtrl.dispose();
    super.dispose();
  }

  String _formatBirthDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '';
    return raw.split('T').first;
  }

  Future<void> _pickAvatar() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (file == null) return;
    final storedPath = await _persistAvatar(file.path);
    if (!mounted) return;
    setState(() {
      _avatarPath = storedPath;
      _avatarUploadUrl = null;
    });
  }

  Future<String> _persistAvatar(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) return sourcePath;
      final directory = await getApplicationDocumentsDirectory();
      final name = sourceFile.uri.pathSegments.isNotEmpty
          ? sourceFile.uri.pathSegments.last
          : 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final target = File('${directory.path}/$name');
      if (await target.exists()) {
        return target.path;
      }
      final copied = await sourceFile.copy(target.path);
      return copied.path;
    } catch (_) {
      return sourcePath;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      var avatarUrl = _avatarPath?.trim() ?? '';
      if (avatarUrl.isNotEmpty && !avatarUrl.startsWith('http')) {
        final file = File(avatarUrl);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          final filename = file.uri.pathSegments.isNotEmpty
              ? file.uri.pathSegments.last
              : 'avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
          final uploadRes = await ApiService.uploadIdentityDocument(
            bytes: bytes,
            filename: filename,
          );
          if (uploadRes['ok'] == true && uploadRes['fileUrl'] != null) {
            avatarUrl = uploadRes['fileUrl'].toString();
            _avatarUploadUrl = avatarUrl;
          } else {
            final err =
                (uploadRes['error'] ??
                        uploadRes['message'] ??
                        'Yükleme başarısız')
                    .toString();
            AppNotification.show(
              context,
              message: err,
              type: AppNotificationType.error,
            );
            if (mounted) setState(() => _saving = false);
            return;
          }
        }
      }

      final payload = {
        'name': _nameCtrl.text.trim(),
        'surname': _surCtrl.text.trim(),
        'phone': _phoneCtrl.text.trim(),
        'address': _addressCtrl.text.trim(),
        'nationalId': _nationalIdCtrl.text.trim(),
        'birthDate': _birthCtrl.text.trim().isEmpty
            ? null
            : DateTime.tryParse(_birthCtrl.text.trim())?.toIso8601String(),
        if (avatarUrl.isNotEmpty) 'avatarUrl': avatarUrl,
      };
      final res = await ApiService.updateProfile(widget.user.id, payload);
      if (!mounted) return;
      if (res['ok'] == true || (res['statusCode'] ?? 0) == 200) {
        final cacheValue = (avatarUrl.isNotEmpty) ? avatarUrl : _avatarPath;
        final resolvedCache = cacheValue != null
            ? _resolveAvatarUrl(cacheValue)
            : null;
        await ProfileAvatarCache.set(widget.user.id, resolvedCache);
        AppNotification.show(
          context,
          message: loc.profileSavedMessage,
          type: AppNotificationType.success,
        );
        if (!mounted) return;
        Navigator.of(context).pop(true);
      } else {
        final msg = (res['message'] ?? res['error'] ?? 'Güncelleme başarısız')
            .toString();
        AppNotification.show(
          context,
          message: msg.isNotEmpty ? msg : loc.profileSaveFailed,
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: loc.profileSaveFailedWithDetails('$e'),
        type: AppNotificationType.error,
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _resolveAvatarUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;
    if (trimmed.startsWith('http')) return trimmed;
    if (File(trimmed).existsSync()) return trimmed;
    final base = ApiService.baseUrl;
    if (base.isEmpty) return trimmed;
    if (trimmed.startsWith('/')) {
      return base.endsWith('/')
          ? '${base.substring(0, base.length - 1)}$trimmed'
          : '$base$trimmed';
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final resolvedPath = _resolveAvatarUrl(_avatarPath ?? '');
    final bottomSafePadding = shellBottomContentPadding(context, extra: -8);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(loc.profileEditTitle),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(loc.profileSaveAction),
          ),
        ],
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomSafePadding),
            children: [
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: loc.profilePhotoSectionTitle,
                      subtitle: loc.profilePhotoSectionSubtitle,
                      icon: Icons.photo_camera_outlined,
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  theme.colorScheme.primary.withValues(
                                    alpha: 0.9,
                                  ),
                                  theme.colorScheme.secondary.withValues(
                                    alpha: 0.8,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: AvatarImage(
                              path: resolvedPath,
                              size: 68,
                              icon: Icons.person,
                              iconColor: theme.colorScheme.primary,
                              backgroundColor: theme.colorScheme.primary
                                  .withValues(alpha: 0.12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.profilePhotoUploadTitle,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                loc.profilePhotoUploadHint,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 10),
                              OutlinedButton.icon(
                                onPressed: _saving ? null : _pickAvatar,
                                icon: const Icon(Icons.upload),
                                label: Text(loc.profilePhotoSelectAction),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (_saving) ...[
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(999),
                        child: const LinearProgressIndicator(),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: loc.profilePersonalSectionTitle,
                        subtitle: loc.profilePersonalSectionSubtitle,
                        icon: Icons.badge_outlined,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: InputDecoration(
                          labelText: loc.profileFirstNameLabel,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return loc.validationRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _surCtrl,
                        decoration: InputDecoration(
                          labelText: loc.profileLastNameLabel,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return loc.validationRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _birthCtrl,
                        decoration: InputDecoration(
                          labelText: loc.profileBirthDateLabel,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nationalIdCtrl,
                        decoration: InputDecoration(
                          labelText: loc.profileNationalIdLabel,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionHeader(
                      title: loc.profileContactSectionTitle,
                      subtitle: loc.profileContactSectionSubtitle,
                      icon: Icons.contact_phone_outlined,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneCtrl,
                      decoration: InputDecoration(
                        labelText: loc.profilePhoneLabel,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressCtrl,
                      decoration: InputDecoration(
                        labelText: loc.profileAddressLabel,
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(loc.profileSaveAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
