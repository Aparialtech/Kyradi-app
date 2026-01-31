import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/section_card.dart';
import '../models/saved_card.dart';
import '../widgets/saved_card_visual.dart';

class WalletTopUpSavedCardPage extends StatefulWidget {
  const WalletTopUpSavedCardPage({super.key});

  @override
  State<WalletTopUpSavedCardPage> createState() =>
      _WalletTopUpSavedCardPageState();
}

class _WalletTopUpSavedCardPageState extends State<WalletTopUpSavedCardPage> {
  final _amountCtrl = TextEditingController();
  bool _loading = true;
  bool _submitting = false;
  List<SavedCard> _cards = [];
  SavedCard? _selected;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('saved_cards');
    if (!mounted) return;
    if (raw == null || raw.isEmpty) {
      setState(() {
        _cards = [];
        _loading = false;
      });
      return;
    }
    final list = (jsonDecode(raw) as List)
        .whereType<Map>()
        .map((e) => SavedCard.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    setState(() {
      _cards = list;
      _loading = false;
    });
  }

  Future<void> _submit() async {
    final loc = AppLocalizations.of(context)!;
    if (_submitting) return;
    final amount = double.tryParse(_amountCtrl.text.replaceAll(',', '.')) ?? 0;
    if (amount <= 0) {
      AppNotification.show(
        context,
        message: loc.topUpInvalidAmountMessage,
        type: AppNotificationType.warning,
      );
      return;
    }
    if (_selected == null) {
      AppNotification.show(
        context,
        message: loc.topUpSelectCardMessage,
        type: AppNotificationType.warning,
      );
      return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(loc.topUpConfirmTitle),
        content: Text(
          loc.topUpConfirmMessage(
            amount.toStringAsFixed(2),
            '**** ${_selected!.last4}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(loc.dialogDismiss),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(loc.dialogConfirm),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    setState(() => _submitting = true);
    await _showProcessingDialog(loc);
    if (!mounted) return;
    Navigator.of(context).pop({
      'amount': amount,
      'method': 'saved',
      'label': '${cardBrandLabel(_selected!.brand)} •••• ${_selected!.last4}',
    });
  }

  Future<void> _showProcessingDialog(AppLocalizations loc) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(loc.topUpProcessingTitle),
        content: Row(
          children: [
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(loc.topUpProcessingSubtitle)),
          ],
        ),
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(loc.topUpUseSavedCardTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.topUpAmountTitle,
                  subtitle: loc.topUpAmountSubtitle,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _AmountChip(
                      label: '100 ₺',
                      onTap: () => _amountCtrl.text = '100',
                    ),
                    const SizedBox(width: 8),
                    _AmountChip(
                      label: '250 ₺',
                      onTap: () => _amountCtrl.text = '250',
                    ),
                    const SizedBox(width: 8),
                    _AmountChip(
                      label: '500 ₺',
                      onTap: () => _amountCtrl.text = '500',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: loc.topUpAmountLabel),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SectionHeader(
                  title: loc.topUpSelectCardTitle,
                  subtitle: loc.topUpSelectCardSubtitle,
                  icon: Icons.credit_card_outlined,
                ),
                const SizedBox(height: 12),
                if (_loading)
                  const Center(child: CircularProgressIndicator())
                else if (_cards.isEmpty)
                  ListTile(
                    leading: const Icon(Icons.credit_card_off_outlined),
                    title: Text(loc.walletCardsEmptyTitle),
                    subtitle: Text(loc.walletCardsEmptySubtitle),
                  )
                else
                  ..._cards.map(
                    (card) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Stack(
                        children: [
                          SavedCardVisual(
                            card: card,
                            onTap: () => setState(() => _selected = card),
                          ),
                          if (_selected?.id == card.id)
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  loc.selectedLabel,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submitting ? null : _submit,
            child: _submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(loc.topUpPayAction),
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      splashColor: theme.colorScheme.primary.withValues(alpha: 0.08),
      highlightColor: theme.colorScheme.primary.withValues(alpha: 0.04),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
