import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../l10n/app_localizations.dart';
import '../../models/user.dart';
import '../../services/api_service.dart';
import '../../screens/change_password_page.dart';
import '../../screens/home_page.dart';
import '../../screens/intro_splash_page.dart';
import '../../ui/components/app_error_state.dart';
import '../../ui/components/app_skeleton.dart';
import 'pages/about_page.dart';
import 'pages/faq_page.dart';
import 'widgets/profile_header_card.dart';
import 'widgets/security_section.dart';
import 'widgets/settings_section.dart';
import 'widgets/support_section.dart';
import 'widgets/verification_section.dart';

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

  @override
  void initState() {
    super.initState();
    _restoreUser();
  }

  Future<void> _restoreUser() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    _userId = prefs.getString('userId');
    if (_userId == null || _userId!.isEmpty) {
      setState(() {
        _loading = false;
        _error = 'User id not found';
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

  void _openClassic() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HomePage(initialTabIndex: 2)),
    );
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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const IntroSplashPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.profile)),
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
              ? AppErrorState(message: _error!, onRetry: _restoreUser)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                  children: [
                    if (_user != null)
                      ProfileHeaderCard(
                        user: _user!,
                        onEdit: _openClassic,
                      ),
                    const SizedBox(height: 16),
                    VerificationSection(
                      isVerified:
                          _user?.identityDocumentUrl?.isNotEmpty ?? false,
                      onManage: _openClassic,
                    ),
                    const SizedBox(height: 16),
                    SettingsSection(
                      inAppNotifications: _inAppNotifications,
                      emailNotifications: _emailNotifications,
                      onInAppChanged: (value) =>
                          setState(() => _inAppNotifications = value),
                      onEmailChanged: (value) =>
                          setState(() => _emailNotifications = value),
                      languageCode: _languageCode,
                      onLanguageChanged: (value) =>
                          setState(() => _languageCode = value),
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
                      leading: const Icon(Icons.dashboard_customize_outlined),
                      title: const Text('Open Classic Panel'),
                      subtitle: const Text('Profile & identity details'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: _openClassic,
                    ),
                  ],
                ),
    );
  }
}
