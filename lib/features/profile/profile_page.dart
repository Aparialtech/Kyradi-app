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
import '../../widgets/section_card.dart';
import 'pages/about_page.dart';
import 'pages/faq_page.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/security_section.dart';
import 'widgets/settings_section.dart';
import 'widgets/support_section.dart';
import 'widgets/verification_section.dart';
import '../../screens/crash_log_page.dart';
import 'pages/verification_form_page.dart';
import 'pages/profile_edit_page.dart';

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
  String _languageCode = 'tr';
  ThemeMode _themeMode = AppThemeMode.notifier.value;
  String? _avatarPath;

  @override
  void initState() {
    super.initState();
    ProfileAvatarCache.notifier.addListener(_handleAvatarUpdate);
    _restoreUser();
    AppThemeMode.notifier.addListener(_handleThemeUpdate);
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
        }
      } else {
        errorMessage =
            (result['message'] ?? result['error'] ?? 'Load failed').toString();
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

  void _openLuggageCenter() {
    context.push('/luggage');
  }

  Future<void> _openEditProfile() async {
    if (_user == null) return;
    final updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => ProfileEditPage(
          user: _user!,
          avatarPath: _avatarPath,
        ),
      ),
    );
    if (!mounted) return;
    if (updated == true) {
      _avatarPath = ProfileAvatarCache.notifier.value;
      await _loadProfile();
      setState(() {});
    }
  }

  Future<void> _updateNotificationSettings({
    bool? inApp,
    bool? email,
  }) async {
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


  Future<void> _openVerification() async {
    if (_user == null) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VerificationFormPage(user: _user!),
      ),
    );
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
      body: _loading
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
                      onManage: _openVerification,
                    ),
                    const SizedBox(height: 16),
                    SettingsSection(
                      inAppNotifications: _inAppNotifications,
                      emailNotifications: _emailNotifications,
                      onInAppChanged: (value) =>
                          _updateNotificationSettings(inApp: value),
                      onEmailChanged: (value) =>
                          _updateNotificationSettings(email: value),
                      languageCode: _languageCode,
                      onLanguageChanged: (value) =>
                          setState(() => _languageCode = value),
                      themeMode: _themeMode,
                      onThemeChanged: (value) =>
                          setState(() => _themeMode = value),
                    ),
                    const SizedBox(height: 16),
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
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.luggage_outlined),
                      title: Text(loc.myLuggages),
                      subtitle: Text(loc.luggagesSectionSubtitle),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openLuggageCenter,
                    ),
                  ],
                ),
    );
  }
}

class _ProfileDetailsCard extends StatelessWidget {
  const _ProfileDetailsCard({
    required this.user,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: loc.profileDetailsTitle,
            subtitle: loc.profileDetailsSubtitle,
            icon: Icons.badge_outlined,
          ),
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
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: theme.colorScheme.primary, size: 18),
          ),
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
