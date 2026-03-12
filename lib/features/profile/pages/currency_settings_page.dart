import 'package:flutter/material.dart';

import '../../../core/app_currency_mode.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';

class CurrencySettingsPage extends StatefulWidget {
  const CurrencySettingsPage({super.key});

  @override
  State<CurrencySettingsPage> createState() => _CurrencySettingsPageState();
}

class _CurrencySettingsPageState extends State<CurrencySettingsPage> {
  AppCurrency _selected = AppCurrencyMode.notifier.value;

  Future<void> _select(AppCurrency value) async {
    setState(() => _selected = value);
    await AppCurrencyMode.set(value);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafePadding = MediaQuery.viewPaddingOf(context).bottom + 96;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text('Para Birimi')),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, bottomSafePadding),
            children: [
              SectionCard(
                backgroundColor: theme.colorScheme.surface.withValues(
                  alpha: 0.96,
                ),
                child: Column(
                  children: AppCurrency.values
                      .map(
                        (currency) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _CurrencyTile(
                            currency: currency,
                            selected: _selected == currency,
                            onTap: () => _select(currency),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CurrencyTile extends StatelessWidget {
  const _CurrencyTile({
    required this.currency,
    required this.selected,
    required this.onTap,
  });

  final AppCurrency currency;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accent = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.outline;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? theme.colorScheme.primary.withValues(alpha: 0.10)
              : theme.colorScheme.surface,
          border: Border.all(color: accent.withValues(alpha: 0.5)),
        ),
        child: Row(
          children: [
            ThreeDIconBadge(icon: Icons.payments_outlined, accent: accent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                AppCurrencyMode.uiLabel(currency),
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              selected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: accent,
            ),
          ],
        ),
      ),
    );
  }
}
