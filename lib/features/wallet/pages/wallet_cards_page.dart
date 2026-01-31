import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/section_card.dart';
import '../models/saved_card.dart';
import '../widgets/saved_card_visual.dart';
import '../widgets/expiry_date_formatter.dart';

class WalletCardsPage extends StatefulWidget {
  const WalletCardsPage({
    super.key,
    this.selectMode = false,
  });

  final bool selectMode;

  @override
  State<WalletCardsPage> createState() => _WalletCardsPageState();
}

class _WalletCardsPageState extends State<WalletCardsPage> {
  final _numberCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _expiryCtrl = TextEditingController();
  final _cvvCtrl = TextEditingController();
  String _cardType = 'credit';
  List<SavedCard> _cards = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    _nameCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
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

  Future<void> _persistCards() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_cards.map((e) => e.toJson()).toList());
    await prefs.setString('saved_cards', raw);
  }

  String _digitsOnly(String input) =>
      input.replaceAll(RegExp(r'[^0-9]'), '');

  bool _isValidExpiry(String value) {
    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) return false;
    final parts = value.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    if (month < 1 || month > 12) return false;
    final fullYear = 2000 + year;
    final expiry = DateTime(fullYear, month + 1);
    return expiry.isAfter(DateTime.now());
  }

  Future<void> _saveCard() async {
    final loc = AppLocalizations.of(context)!;
    final digits = _digitsOnly(_numberCtrl.text);
    final name = _nameCtrl.text.trim();
    final expiry = _expiryCtrl.text.trim();
    final cvv = _cvvCtrl.text.trim();
    if (digits.length < 12 || name.isEmpty || expiry.isEmpty || cvv.isEmpty) {
      _notify(loc.walletCardInvalidMessage);
      return;
    }
    if (!_isValidExpiry(expiry)) {
      _notify(loc.walletCardExpiryInvalidMessage);
      return;
    }
    final brand = detectCardBrand(digits);
    final last4 = digits.substring(digits.length - 4);
    final card = SavedCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _cardType,
      brand: brand,
      holder: name,
      last4: last4,
      expiry: expiry,
    );
    setState(() {
      _cards = [card, ..._cards];
    });
    await _persistCards();
    _numberCtrl.clear();
    _nameCtrl.clear();
    _expiryCtrl.clear();
    _cvvCtrl.clear();
    _notify(loc.walletCardSavedMessage);
  }

  void _notify(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _openType(String type) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _CardsListPage(
          type: type,
          cards: _cards.where((c) => c.type == type).toList(),
          selectMode: widget.selectMode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.selectMode ? loc.walletSelectCardTitle : loc.walletCardsTitle,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: [
          if (!widget.selectMode) ...[
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    title: loc.walletAddCardTitle,
                    subtitle: loc.walletAddCardSubtitle,
                    icon: Icons.credit_card_outlined,
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 10,
                    children: [
                      ChoiceChip(
                        selected: _cardType == 'credit',
                        label: Text(loc.walletCreditCardLabel),
                        onSelected: (_) => setState(() => _cardType = 'credit'),
                      ),
                      ChoiceChip(
                        selected: _cardType == 'debit',
                        label: Text(loc.walletDebitCardLabel),
                        onSelected: (_) => setState(() => _cardType = 'debit'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _numberCtrl,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: loc.walletCardNumberLabel,
                      hintText: '1234 5678 9012 3456',
                      prefixIcon: const Icon(Icons.credit_card_outlined),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _nameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: loc.walletCardNameLabel,
                      hintText: 'AD SOYAD',
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _expiryCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ExpiryDateFormatter(),
                          ],
                          decoration: InputDecoration(
                            labelText: loc.walletCardExpiryLabel,
                            hintText: 'MM/YY',
                            prefixIcon:
                                const Icon(Icons.calendar_today_outlined),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _cvvCtrl,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: loc.walletCardCvvLabel,
                            hintText: 'CVV',
                            prefixIcon: const Icon(Icons.lock_outline),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _saveCard,
                    icon: const Icon(Icons.add),
                    label: Text(loc.walletAddCardAction),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          SectionCard(
            child: Row(
              children: [
                Expanded(
                  child: _TypeTile(
                    title: loc.walletCreditCardLabel,
                    subtitle: loc.walletCreditCardSubtitle,
                    icon: Icons.credit_card_rounded,
                    color: const Color(0xFF2563EB),
                    onTap: () => _openType('credit'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _TypeTile(
                    title: loc.walletDebitCardLabel,
                    subtitle: loc.walletDebitCardSubtitle,
                    icon: Icons.account_balance_rounded,
                    color: const Color(0xFF10B981),
                    onTap: () => _openType('debit'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_cards.isEmpty)
            SectionCard(
              child: ListTile(
                leading: const Icon(Icons.info_outline),
                title: Text(loc.walletCardsEmptyTitle),
                subtitle: Text(loc.walletCardsEmptySubtitle),
              ),
            )
          else
            ..._cards
                .take(widget.selectMode ? _cards.length : 3)
                .map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SavedCardVisual(
                      card: card,
                      onTap: widget.selectMode
                          ? () => Navigator.of(context).pop(card)
                          : null,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class _CardsListPage extends StatelessWidget {
  const _CardsListPage({
    required this.type,
    required this.cards,
    required this.selectMode,
  });

  final String type;
  final List<SavedCard> cards;
  final bool selectMode;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final title =
        type == 'credit' ? loc.walletCreditCardLabel : loc.walletDebitCardLabel;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        children: cards.isEmpty
            ? [
                SectionCard(
                  child: ListTile(
                    leading: const Icon(Icons.credit_card_outlined),
                    title: Text(loc.walletCardsEmptyTitle),
                    subtitle: Text(loc.walletCardsEmptySubtitle),
                  ),
                ),
              ]
            : cards
                .map(
                  (card) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: SavedCardVisual(
                      card: card,
                      onTap:
                          selectMode ? () => Navigator.of(context).pop(card) : null,
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}

class _TypeTile extends StatelessWidget {
  const _TypeTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: color.withOpacity(0.1),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ThreeDIconBadge(icon: icon, accent: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
