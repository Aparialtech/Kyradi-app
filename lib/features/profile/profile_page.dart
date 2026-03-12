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
import '../../widgets/avatar_image.dart';
import '../../core/profile_avatar_cache.dart';
import '../../core/app_theme_mode.dart';
import '../../core/app_currency_mode.dart';
import '../../core/notification_prefs.dart';
import '../../widgets/section_card.dart';
import '../../widgets/app_logo_overlay.dart';
import 'pages/about_page.dart';
import 'pages/currency_settings_page.dart';
import 'pages/faq_page.dart';
import 'pages/payment_methods_page.dart';
import '../../screens/crash_log_page.dart';
import 'pages/verification_form_page.dart';
import 'pages/profile_edit_page.dart';
import 'pages/profile_settings_page.dart';
import 'pages/identity_verification_page.dart';

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
  String _currencyCode = 'tl';
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
    AppCurrencyMode.notifier.addListener(_handleCurrencyUpdate);
    _currencyCode = AppCurrencyMode.toCode(AppCurrencyMode.notifier.value);
    NotificationPrefs.load().then((_) {
      if (!mounted) return;
      setState(() => _criticalOnly = NotificationPrefs.criticalOnly.value);
    });
  }

  @override
  void dispose() {
    ProfileAvatarCache.notifier.removeListener(_handleAvatarUpdate);
    AppThemeMode.notifier.removeListener(_handleThemeUpdate);
    AppCurrencyMode.notifier.removeListener(_handleCurrencyUpdate);
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

  void _handleCurrencyUpdate() {
    if (!mounted) return;
    setState(
      () => _currencyCode = AppCurrencyMode.toCode(
        AppCurrencyMode.notifier.value,
      ),
    );
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
          currencyCode: _currencyCode,
          onCurrencyChanged: (value) => setState(() => _currencyCode = value),
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

  String _languageLabel() {
    switch (_languageCode.toLowerCase()) {
      case 'en':
        return 'English';
      case 'es':
        return 'Espanol';
      case 'ru':
        return 'Russkiy';
      default:
        return 'Turkce';
    }
  }

  String _themeLabel() {
    switch (_themeMode) {
      case ThemeMode.dark:
        return 'Koyu';
      case ThemeMode.light:
        return 'Acik';
      case ThemeMode.system:
        return 'Sistem';
    }
  }

  String _currencyLabel() {
    final currency = AppCurrencyMode.fromCode(_currencyCode);
    return AppCurrencyMode.uiLabel(currency);
  }

  String _verificationStatusLabel(AppLocalizations loc) {
    final status = (_user?.verificationStatus ?? '').toLowerCase();
    if (_user?.identityVerified == true || status == 'verified') {
      return loc.profileVerifiedLabel;
    }
    if (status == 'pending') return loc.profileVerificationPending;
    return loc.profileVerificationMissing;
  }

  Future<void> _showProfileDetailsSheet() async {
    final user = _user;
    if (user == null || !mounted) return;
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              loc.profileDetailsTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
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

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F8FA),
        surfaceTintColor: const Color(0xFFF7F8FA),
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
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
        actions: [
          IconButton(
            tooltip: 'Yenile',
            onPressed: _loadProfile,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: _loading
          ? ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: const [
                AppSkeleton(height: 180, radius: 28),
                SizedBox(height: 12),
                AppSkeleton(height: 172, radius: 24),
                SizedBox(height: 12),
                AppSkeleton(height: 220, radius: 24),
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
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 40),
              children: [
                if (_user != null)
                  _ProfileHero(
                    user: _user!,
                    avatarPath: _avatarPath,
                    onEdit: _openEditProfile,
                  ),
                const SizedBox(height: 12),
                _ProfileGroupCard(
                  title: 'Odeme Bilgileri',
                  children: [
                    _ProfileMenuTile(
                      icon: Icons.credit_card_outlined,
                      title: 'Odeme yontemleri',
                      trailing: 'Ayarla',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const PaymentMethodsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ProfileGroupCard(
                  title: 'Ayarlar',
                  children: [
                    _ProfileMenuTile(
                      icon: Icons.language_rounded,
                      title: 'Dil',
                      trailing: _languageLabel(),
                      onTap: _openSettings,
                    ),
                    _ProfileMenuTile(
                      icon: Icons.palette_outlined,
                      title: 'Tema',
                      trailing: _themeLabel(),
                      onTap: _openSettings,
                    ),
                    _ProfileMenuTile(
                      icon: Icons.payments_outlined,
                      title: 'Para birimi',
                      trailing: _currencyLabel(),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CurrencySettingsPage(),
                          ),
                        );
                      },
                    ),
                    _ProfileMenuTile(
                      icon: Icons.notifications_none_rounded,
                      title: 'Bildirimler',
                      trailing: _inAppNotifications ? 'Etkin' : 'Kapali',
                      onTap: _openSettings,
                    ),
                    _ProfileMenuTile(
                      icon: Icons.support_agent_rounded,
                      title: 'Iletisim ve destek',
                      trailing: 'Ac',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const FaqPage()),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _ProfileGroupCard(
                  title: 'Hesap',
                  children: [
                    _ProfileMenuTile(
                      icon: Icons.verified_user_outlined,
                      title: 'Kimlik dogrulama',
                      trailing: _verificationStatusLabel(loc),
                      onTap: _openVerification,
                    ),
                    _ProfileMenuTile(
                      icon: Icons.badge_outlined,
                      title: 'Kisisel bilgiler',
                      trailing: 'Detay',
                      onTap: _showProfileDetailsSheet,
                    ),
                    _ProfileMenuTile(
                      icon: Icons.lock_outline_rounded,
                      title: loc.changePasswordTitle,
                      trailing: 'Ac',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ChangePasswordPage(),
                          ),
                        );
                      },
                    ),
                    _ProfileMenuTile(
                      icon: Icons.info_outline_rounded,
                      title: 'Hakkinda',
                      trailing: 'Ac',
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const AboutPage()),
                        );
                      },
                    ),
                  ],
                ),
                if (_canOpenAdminPanel) ...[
                  const SizedBox(height: 12),
                  _ProfileGroupCard(
                    title: 'Yonetim',
                    children: [
                      _ProfileMenuTile(
                        icon: Icons.admin_panel_settings_outlined,
                        title: 'Yonetim paneli',
                        trailing: 'Ac',
                        onTap: () => context.push('/admin/panel'),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                SectionCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  backgroundColor: theme.colorScheme.surface,
                  child: ListTile(
                    leading: ThreeDIconBadge(
                      icon: Icons.logout_rounded,
                      accent: theme.colorScheme.error,
                    ),
                    title: Text(
                      'Cikis yap',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: _confirmLogout,
                  ),
                ),
              ],
            ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.user,
    required this.onEdit,
    this.avatarPath,
  });

  final UserModel user;
  final VoidCallback onEdit;
  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fullName = '${user.name} ${user.surname}'.trim();
    final avatar = avatarPath?.trim() ?? '';
    return SectionCard(
      radius: 26,
      backgroundColor: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 18),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  theme.colorScheme.primary.withValues(alpha: 0.95),
                  theme.colorScheme.secondary.withValues(alpha: 0.95),
                ],
              ),
            ),
            child: CircleAvatar(
              radius: 38,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              child: AvatarImage(
                path: avatar,
                size: 76,
                icon: Icons.person_rounded,
                iconColor: theme.colorScheme.primary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            fullName.isEmpty ? 'Kyradi Kullanici' : fullName,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Profili duzenle'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              side: BorderSide(
                color: theme.colorScheme.primary.withValues(alpha: 0.55),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileGroupCard extends StatelessWidget {
  const _ProfileGroupCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SectionCard(
      radius: 22,
      backgroundColor: theme.colorScheme.surface,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 4, 6, 10),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            children: [
              ThreeDIconBadge(icon: icon),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (trailing != null && trailing!.isNotEmpty)
                Text(
                  trailing!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              const SizedBox(width: 4),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
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
