import 'package:flutter/material.dart';

import '../../../core/payment_method_prefs.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/section_card.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  bool _loading = true;
  bool _creditCardEnabled = true;
  bool _debitCardEnabled = true;
  bool _hotelPayEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final methods = await PaymentMethodPrefs.load();
    if (!mounted) return;
    setState(() {
      _creditCardEnabled = methods.creditCardEnabled;
      _debitCardEnabled = methods.debitCardEnabled;
      _hotelPayEnabled = methods.hotelPayEnabled;
      _loading = false;
    });
  }

  Future<void> _setMethod({
    required bool value,
    required void Function() apply,
    required Future<void> Function(bool value) save,
  }) async {
    apply();
    await save(value);
    if (!mounted) return;
    AppNotification.show(
      context,
      message: 'Odeme yontemi guncellendi.',
      type: AppNotificationType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomSafePadding = MediaQuery.viewPaddingOf(context).bottom + 96;
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Odeme Yontemleri')),
      body: Stack(
        children: [
          const AppMeshBackground(),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else
            ListView(
              padding: EdgeInsets.fromLTRB(16, 16, 16, bottomSafePadding),
              children: [
                SectionCard(
                  backgroundColor: theme.colorScheme.surface.withValues(
                    alpha: 0.96,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionHeader(
                        title: 'Odeme secenekleri',
                        subtitle:
                            'Kullanici tarafinda aktif/kapali olarak yonet.',
                        iconWidget: ThreeDIconBadge(
                          icon: Icons.account_balance_wallet_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  backgroundColor: theme.colorScheme.surface.withValues(
                    alpha: 0.96,
                  ),
                  child: Column(
                    children: [
                      _PaymentMethodTile(
                        icon: Icons.credit_card_rounded,
                        title: 'Kredi Karti',
                        subtitle: 'Visa, MasterCard vb.',
                        enabled: _creditCardEnabled,
                        onChanged: (value) => _setMethod(
                          value: value,
                          save: PaymentMethodPrefs.setCreditEnabled,
                          apply: () =>
                              setState(() => _creditCardEnabled = value),
                        ),
                      ),
                      const Divider(height: 20),
                      _PaymentMethodTile(
                        icon: Icons.account_balance_rounded,
                        title: 'Banka Karti',
                        subtitle: 'Debit kart ile odeme',
                        enabled: _debitCardEnabled,
                        onChanged: (value) => _setMethod(
                          value: value,
                          save: PaymentMethodPrefs.setDebitEnabled,
                          apply: () =>
                              setState(() => _debitCardEnabled = value),
                        ),
                      ),
                      const Divider(height: 20),
                      _PaymentMethodTile(
                        icon: Icons.storefront_rounded,
                        title: 'Otelde Ode',
                        subtitle: 'Lokasyonda nakit/kart odeme',
                        enabled: _hotelPayEnabled,
                        onChanged: (value) => _setMethod(
                          value: value,
                          save: PaymentMethodPrefs.setHotelEnabled,
                          apply: () => setState(() => _hotelPayEnabled = value),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.enabled,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = enabled
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurfaceVariant;
    return Row(
      children: [
        ThreeDIconBadge(icon: icon, accent: accent),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        _StatusChip(enabled: enabled),
        const SizedBox(width: 8),
        Switch.adaptive(value: enabled, onChanged: onChanged),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = enabled ? const Color(0xFF0F766E) : const Color(0xFF64748B);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: color.withValues(alpha: 0.14),
        border: Border.all(color: color.withValues(alpha: 0.36)),
      ),
      child: Text(
        enabled ? 'Aktif' : 'Kapali',
        style: theme.textTheme.labelSmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
