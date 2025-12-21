import 'package:flutter/material.dart';
import 'l10n/app_localizations.dart';
import 'widgets/app_notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) =>
          AppLocalizations.of(context)?.appTitle ?? 'KYRADI',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final pages = <Widget>[
      const _DashboardTab(),
      const _ProfileTab(),
      _SettingsTab(
        onLogout: () {
          AppNotification.show(context,
              message: loc.logoutSuccess, type: AppNotificationType.info);
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appTitle),
        centerTitle: true,
      ),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: loc.dashboard,
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: loc.profile,
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: loc.settings,
          ),
        ],
      ),
    );
  }
}

/// ─── Gradient Button ───────────────────────────────
class GradientButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onPressed;

  const GradientButton({
    super.key,
    required this.text,
    this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2C2966), Color(0xFF005C99)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: icon != null ? Icon(icon, color: Colors.white) : const SizedBox.shrink(),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size.fromHeight(48),
        ),
      ),
    );
  }
}

/// ─── Ana Sayfa Tabı ───────────────────────────────
class _DashboardTab extends StatelessWidget {
  const _DashboardTab();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final luggageButtons = List.generate(3, (index) {
      final label = loc.demoLuggageButton(index + 1);
      return GradientButton(
        text: label,
        icon: Icons.luggage,
        onPressed: () => AppNotification.show(
          context,
          message: loc.demoLuggageSelected(label),
          type: AppNotificationType.info,
        ),
      );
    });
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        GradientButton(
          text: loc.map,
          icon: Icons.map,
          onPressed: () {
            AppNotification.show(context,
                message: loc.demoMapComingSoon, type: AppNotificationType.info);
          },
        ),
        const SizedBox(height: 20),
        Text(
          loc.myLuggages,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ...luggageButtons,
      ],
    );
  }
}

/// ─── Profil Tabı (Kişisel Bilgiler + Acil Durum Kişisi) ──────────
class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          loc.userInfo,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        // NOT: 'const Card' kullanmıyoruz ki içeride non-const bırakabilirim.
        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.person),
                title: Text(loc.firstName),
                subtitle: Text(loc.demoFirstNameValue),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.person_outline),
                title: Text(loc.lastName),
                subtitle: Text(loc.demoLastNameValue),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.credit_card),
                title: Text(loc.nationalIdLabel),
                subtitle: Text(loc.demoNationalIdValue),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text(loc.phone),
                subtitle: Text(loc.phoneHint),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.home),
                title: Text(loc.address),
                subtitle: Text(loc.demoAddressValue),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        Text(
          loc.emergencyContact,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),

        Card(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.contact_emergency_outlined),
                title: Text(loc.fullNameLabel),
                subtitle: Text(loc.demoEmergencyNameValue),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.phone_in_talk_outlined),
                title: Text(loc.phone),
                subtitle: Text(loc.phoneHint),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.home_work_outlined),
                title: Text(loc.address),
                subtitle: Text(loc.demoEmergencyAddressValue),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.alternate_email),
                title: Text(loc.email),
                subtitle: Text(loc.demoEmergencyEmailValue),
              ),
              const Divider(height: 0),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(loc.relationLabel),
                subtitle: Text(loc.demoEmergencyRelationValue),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),
        Text(
          loc.emergencyContactNote,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}

/// ─── Ayarlar Tabı ───────────────────────────────
class _SettingsTab extends StatelessWidget {
  final VoidCallback onLogout;
  const _SettingsTab({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Center(
      child: GradientButton(
        text: loc.logout,
        icon: Icons.logout,
        onPressed: onLogout,
      ),
    );
  }
}
