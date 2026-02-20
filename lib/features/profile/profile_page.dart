import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../screens/change_password_page.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';
import '../../widgets/app_notification.dart';
import '../../core/profile_avatar_cache.dart';
import '../../core/app_theme_mode.dart';
import '../../core/notification_prefs.dart';
import '../../widgets/section_card.dart';
import '../../widgets/app_logo_overlay.dart';
import '../../widgets/app_mesh_background.dart';
import 'pages/about_page.dart';
import 'pages/faq_page.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/security_section.dart';
import 'widgets/support_section.dart';
import 'widgets/verification_section.dart';
import '../../screens/crash_log_page.dart';
import 'pages/verification_form_page.dart';
import 'pages/profile_edit_page.dart';
import 'pages/profile_settings_page.dart';
import 'pages/identity_verification_page.dart';
import '../admin/admin_panel_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  String? _error;
  bool _loading = false;
  String? _userId;
  bool _inAppNotifications = true;
  bool _emailNotifications = true;
  bool _criticalOnly = false;
  String _languageCode = 'tr';
  ThemeMode _themeMode = AppThemeMode.notifier.value;
  String? _avatarPath;

  bool get _canOpenAdminPanel {
    final role = (_user?.role ?? 'user').toLowerCase();
    return role == 'admin' || role == 'editor';
  }

  @override
  void initState() {
    super.initState();
    ProfileAvatarCache.notifier.addListener(_handleAvatarUpdate);
    _restoreUser();
    AppThemeMode.notifier.addListener(_handleThemeUpdate);
    NotificationPrefs.load().then((_) {
      if (!mounted) return;
      setState(() => _criticalOnly = NotificationPrefs.criticalOnly.value);
    });
  }

  @override
  void dispose() {
    ProfileAvatarCache.notifier.removeListener(_handleAvatarUpdate);
    AppThemeMode.notifier.removeListener(_handleThemeUpdate);
    super.dispose();
  }

  void _handleAvatarUpdate() {
    if (!mounted) return;
    setState(() => _avatarPath = ProfileAvatarCache.notifier.value);
  }

  void _handleThemeUpdate() {
    if (!mounted) return;
    setState(() => _themeMode = AppThemeMode.notifier.value);
  }

  Future<void> _restoreUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _userId = prefs.getString('userId');
    await ProfileAvatarCache.load(_userId);
    _avatarPath = ProfileAvatarCache.notifier.value;
    if (_userId == null || _userId!.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'USER_ID_MISSING';
      });
      return;
    }
    await _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (_userId == null) return;
    setState(() => _loading = true);
    String? errorMessage;
    try {
      final result = await ApiService.getProfile(_userId!);
      if (!mounted) return;
      if (result['ok'] == true) {
        final raw = result['profile'] ?? result['data'] ?? result;
        if (raw is Map<String, dynamic>) {
          _user = UserModel.fromJson(Map<String, dynamic>.from(raw));
          _inAppNotifications = _user?.pushReminderEnabled ?? true;
          _emailNotifications = _user?.emailReminderEnabled ?? true;
          final remoteAvatar = _user?.avatarUrl?.trim() ?? '';
          if (remoteAvatar.isNotEmpty) {
            final resolved = _resolveAvatarUrl(remoteAvatar);
            if (ProfileAvatarCache.notifier.value != resolved) {
              await ProfileAvatarCache.set(_userId, resolved);
              _avatarPath = resolved;
            }
          }
        }
      } else {
        errorMessage = (result['message'] ?? result['error'] ?? 'Load failed')
            .toString();
      }
    } catch (e) {
      errorMessage = e.toString();
    }
    if (!mounted) return;
    if (errorMessage != null) {
      _error = errorMessage;
    }
    setState(() => _loading = false);
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

  Future<void> _openSettings() async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProfileSettingsPage(
          inAppNotifications: _inAppNotifications,
          emailNotifications: _emailNotifications,
          onInAppChanged: (value) => _updateNotificationSettings(inApp: value),
          onEmailChanged: (value) => _updateNotificationSettings(email: value),
          languageCode: _languageCode,
          onLanguageChanged: (value) => setState(() => _languageCode = value),
          themeMode: _themeMode,
          onThemeChanged: (value) => setState(() => _themeMode = value),
          criticalOnly: _criticalOnly,
          onCriticalOnlyChanged: _updateCriticalOnly,
        ),
      ),
    );
  }

  Future<void> _openEditProfile() async {
    if (_user == null) return;
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProfileEditPage(user: _user!, avatarPath: _avatarPath),
      ),
    );
    if (!mounted) return;
    if (updated == true) {
      _avatarPath = ProfileAvatarCache.notifier.value;
      await _loadProfile();
      setState(() {});
    }
  }

  Future<void> _updateNotificationSettings({bool? inApp, bool? email}) async {
    if (_userId == null) return;
    setState(() {
      if (inApp != null) _inAppNotifications = inApp;
      if (email != null) _emailNotifications = email;
    });
    try {
      final res = await ApiService.updateProfile(_userId!, {
        if (inApp != null) 'pushReminderEnabled': inApp,
        if (email != null) 'emailReminderEnabled': email,
      });
      if (!mounted) return;
      if (res['ok'] != true) {
        AppNotification.show(
          context,
          message: 'Ayarlar güncellenemedi.',
          type: AppNotificationType.error,
        );
      }
    } catch (e) {
      if (!mounted) return;
      AppNotification.show(
        context,
        message: 'Ayarlar güncellenemedi: $e',
        type: AppNotificationType.error,
      );
    }
  }

  Future<void> _updateCriticalOnly(bool value) async {
    setState(() => _criticalOnly = value);
    await NotificationPrefs.setCriticalOnly(value);
  }

  Future<void> _openVerification() async {
    if (_user == null) return;
    final loc = AppLocalizations.of(context)!;
    final choice = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const ThreeDIconBadge(icon: Icons.mail_outline),
                  title: Text(loc.emailVerificationTitle),
                  subtitle: Text(loc.emailVerificationSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop('email'),
                ),
                ListTile(
                  leading: const ThreeDIconBadge(icon: Icons.badge_outlined),
                  title: Text(loc.identityVerificationTitle),
                  subtitle: Text(loc.identityVerificationSubtitle),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).pop('identity'),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (!mounted || choice == null) return;
    if (choice == 'email') {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => VerificationFormPage(user: _user!)),
      );
    } else {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const IdentityVerificationPage()),
      );
    }
    if (!mounted) return;
    await _loadProfile();
  }

  Future<void> _confirmLogout() async {
    final loc = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(loc.logoutDialogTitle),
        content: Text(loc.logoutDialogMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(loc.dialogDismiss),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(loc.dialogConfirm),
          ),
        ],
      ),
    );

    if (result == true) {
      await ApiService.clearSession();
      if (!mounted) return;
      AppLogoOverlayController.hide();
      context.go('/intro');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: kDebugMode
              ? () {
                  // Debug-only log viewer for TestFlight crash triage.
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CrashLogPage()),
                  );
                }
              : null,
          child: Text(loc.profile),
        ),
      ),
      body: Stack(
        children: [
          const AppMeshBackground(),
          _loading
              ? ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: const [
                    AppSkeleton(height: 120, radius: 20),
                    SizedBox(height: 16),
                    AppSkeleton(height: 90, radius: 20),
                    SizedBox(height: 16),
                    AppSkeleton(height: 140, radius: 20),
                    SizedBox(height: 16),
                    AppSkeleton(height: 160, radius: 20),
                  ],
                )
              : _error != null
              ? AppErrorState(
                  message: _error == 'USER_ID_MISSING'
                      ? loc.userIdMissing
                      : _error!,
                  onRetry: _restoreUser,
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: [
                    if (_user != null)
                      ProfileHeaderCard(
                        user: _user!,
                        onEdit: _openEditProfile,
                        avatarPath: _avatarPath,
                      ),
                    if (_user != null) ...[
                      const SizedBox(height: 16),
                      _ProfileDetailsCard(user: _user!),
                    ],
                    const SizedBox(height: 16),
                    VerificationSection(
                      status: _user?.verificationStatus ?? 'unverified',
                      identityVerified: _user?.identityVerified ?? false,
                      onManage: _openVerification,
                    ),
                    const SizedBox(height: 16),
                    SectionCard(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.surface.withValues(alpha: 0.92),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: ListTile(
                        leading: const ThreeDIconBadge(
                          icon: Icons.settings_outlined,
                        ),
                        title: Text(loc.settingsTitle),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: _openSettings,
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_canOpenAdminPanel)
                      SectionCard(
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.surface.withValues(alpha: 0.92),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: const ThreeDIconBadge(
                            icon: Icons.admin_panel_settings_outlined,
                          ),
                          title: const Text('Yonetim Paneli'),
                          subtitle: Text(
                            'Lokasyon, kampanya ve kullanici yonetimi',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AdminPanelPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    if (_canOpenAdminPanel) const SizedBox(height: 16),
                    SecuritySection(
                      onChangePassword: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage(),
                          ),
                        );
                      },
                      onLogout: _confirmLogout,
                    ),
                    const SizedBox(height: 16),
                    SupportSection(
                      onFaq: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FaqPage()),
                        );
                      },
                      onAbout: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AboutPage()),
                        );
                      },
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({required this.user});

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SectionCard(
      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.94),
      child: Theme(
        // Make ExpansionTile feel like a button, without extra Material padding/dividers.
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: EdgeInsets.zero,
          leading: const ThreeDIconBadge(icon: Icons.badge_outlined),
          title: Text(
            loc.profileDetailsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: Text(
            loc.profileDetailsSubtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          children: [
            const SizedBox(height: 12),
            _InfoTile(
              icon: Icons.email_outlined,
              label: loc.profileEmailLabel,
              value: user.email,
            ),
            _InfoTile(
              icon: Icons.phone_outlined,
              label: loc.profilePhoneLabel,
              value: user.phone.isEmpty ? '-' : user.phone,
            ),
            _InfoTile(
              icon: Icons.badge_outlined,
              label: loc.profileNationalIdLabel,
              value: _maskNationalId(user.nationalId),
            ),
            _InfoTile(
              icon: Icons.cake_outlined,
              label: loc.profileBirthDateLabel,
              value: _formatBirthDate(user.birthDate),
            ),
            _InfoTile(
              icon: Icons.person_outline,
              label: loc.profileGenderLabel,
              value: _genderLabel(loc, user.gender),
            ),
            _InfoTile(
              icon: Icons.location_on_outlined,
              label: loc.profileAddressLabel,
              value: user.address.isEmpty ? '-' : user.address,
            ),
            const SizedBox(height: 4),
            Divider(color: theme.colorScheme.outlineVariant),
            const SizedBox(height: 4),
            _InfoTile(
              icon: Icons.verified_user_outlined,
              label: loc.profileVerificationStatus,
              value: _statusLabel(loc, user.verificationStatus),
            ),
          ],
        ),
      ),
    );
  }

  String _maskNationalId(String? raw) {
    final value = (raw ?? '').trim();
    if (value.isEmpty) return '-';
    if (value.length <= 4) return value;
    final tail = value.substring(value.length - 4);
    return '**** **** $tail';
  }

  String _formatBirthDate(String? raw) {
    if (raw == null || raw.isEmpty) return '-';
    return raw.split('T').first;
  }

  String _statusLabel(AppLocalizations loc, String status) {
    switch (status) {
      case 'verified':
        return loc.profileVerifiedLabel;
      case 'pending':
        return loc.profileVerificationPending;
      default:
        return loc.profileVerificationMissing;
    }
  }

  String _genderLabel(AppLocalizations loc, String? raw) {
    switch ((raw ?? '').toLowerCase()) {
      case 'female':
        return loc.profileGenderFemale;
      case 'male':
        return loc.profileGenderMale;
      default:
        return loc.profileGenderUnspecified;
    }
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ThreeDIconBadge(icon: icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
