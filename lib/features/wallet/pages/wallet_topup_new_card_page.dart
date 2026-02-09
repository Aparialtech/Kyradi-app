import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/app_notification.dart';
import '../../../widgets/app_mesh_background.dart';
import '../../../widgets/section_card.dart';
import '../widgets/animated_card_preview.dart';
import '../widgets/expiry_date_formatter.dart';

class WalletTopUpNewCardPage extends StatefulWidget {
  const WalletTopUpNewCardPage({super.key});

  @override
  State<WalletTopUpNewCardPage> createState() => _WalletTopUpNewCardPageState();
}

class _WalletTopUpNewCardPageState extends State<WalletTopUpNewCardPage> {
  final _amountCtrl = TextEditingController();
  final _cardNumberCtrl = TextEditingController();
  final _cardNameCtrl = TextEditingController();
  final _cardExpiryCtrl = TextEditingController();
  final _cardCvvCtrl = TextEditingController();
  final FocusNode _cvvFocus = FocusNode();
  bool _submitting = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    _cardNumberCtrl.dispose();
    _cardNameCtrl.dispose();
    _cardExpiryCtrl.dispose();
    _cardCvvCtrl.dispose();
    _cvvFocus.dispose();
    super.dispose();
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
    if (_cardNumberCtrl.text.trim().length < 12 ||
        _cardNameCtrl.text.trim().isEmpty ||
        _cardExpiryCtrl.text.trim().length < 4 ||
        _cardCvvCtrl.text.trim().length < 3) {
      AppNotification.show(
        context,
        message: loc.topUpInvalidCardMessage,
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
            _maskCardNumber(_cardNumberCtrl.text),
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
      'method': 'new',
      'label': _maskCardNumber(_cardNumberCtrl.text),
    });
  }

  String _maskCardNumber(String raw) {
    final digits = raw.replaceAll(RegExp(r'\\s+'), '');
    if (digits.length < 4) return '****';
    final tail = digits.substring(digits.length - 4);
    return '**** **** **** $tail';
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
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: Text(loc.topUpUseNewCardTitle)),
      body: Stack(
        children: [
          const AppMeshBackground(),
          ListView(
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
                      title: loc.topUpCardDetailsTitle,
                      subtitle: loc.topUpCardDetailsSubtitle,
                      icon: Icons.credit_card_outlined,
                    ),
                    const SizedBox(height: 12),
                    AnimatedCardPreview(
                      cardNumber: _cardNumberCtrl.text,
                      cardName: _cardNameCtrl.text,
                      expiry: _cardExpiryCtrl.text,
                      cvv: _cardCvvCtrl.text,
                      showBack: _cvvFocus.hasFocus,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cardNumberCtrl,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: loc.cardNumberLabel),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cardNameCtrl,
                      decoration: InputDecoration(labelText: loc.cardHolderNameLabel),
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _cardExpiryCtrl,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              ExpiryDateFormatter(),
                            ],
                            decoration:
                                InputDecoration(labelText: loc.cardExpiryLabel),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _cardCvvCtrl,
                            focusNode: _cvvFocus,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            decoration:
                                InputDecoration(labelText: loc.cardCvvLabel),
                            onChanged: (_) => setState(() {}),
                          ),
                        ),
                      ],
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
