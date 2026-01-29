import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/reservation_draft.dart';

class StepBagInfo extends StatefulWidget {
  const StepBagInfo({
    super.key,
    required this.draft,
    required this.onChanged,
  });

  final ReservationDraft draft;
  final ValueChanged<ReservationDraft> onChanged;

  @override
  State<StepBagInfo> createState() => _StepBagInfoState();
}

class _StepBagInfoState extends State<StepBagInfo> {
  late final TextEditingController _labelCtrl;
  late final TextEditingController _weightCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _labelCtrl = TextEditingController(text: widget.draft.label);
    _weightCtrl = TextEditingController(text: widget.draft.weight);
    _noteCtrl = TextEditingController(text: widget.draft.note);
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _weightCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _updateDraft(void Function(ReservationDraft draft) apply) {
    final next = widget.draft.copy();
    apply(next);
    widget.onChanged(next);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Text(
          loc.stepBagInfoTitle,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _labelCtrl,
          decoration: InputDecoration(
            labelText: loc.luggageNameHint,
            prefixIcon: const Icon(Icons.badge_outlined),
          ),
          onChanged: (value) =>
              _updateDraft((draft) => draft.label = value.trim()),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: widget.draft.size,
          decoration: InputDecoration(
            labelText: loc.luggageInfoLabelSize,
            prefixIcon: const Icon(Icons.straighten_outlined),
          ),
          items: [
            DropdownMenuItem(value: 'small', child: Text(loc.small)),
            DropdownMenuItem(value: 'medium', child: Text(loc.medium)),
            DropdownMenuItem(value: 'large', child: Text(loc.large)),
          ],
          onChanged: (value) =>
              _updateDraft((draft) => draft.size = value ?? draft.size),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _weightCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: loc.luggageInfoLabelWeight,
            prefixIcon: const Icon(Icons.scale_outlined),
          ),
          onChanged: (value) =>
              _updateDraft((draft) => draft.weight = value.trim()),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: widget.draft.color,
          decoration: InputDecoration(
            labelText: loc.luggageInfoLabelColor,
            prefixIcon: const Icon(Icons.palette_outlined),
          ),
          items: [
            DropdownMenuItem(value: 'black', child: Text(loc.black)),
            DropdownMenuItem(value: 'grey', child: Text(loc.grey)),
            DropdownMenuItem(value: 'red', child: Text(loc.red)),
            DropdownMenuItem(value: 'blue', child: Text(loc.blue)),
            DropdownMenuItem(value: 'green', child: Text(loc.green)),
            DropdownMenuItem(value: 'other', child: Text(loc.other)),
          ],
          onChanged: (value) =>
              _updateDraft((draft) => draft.color = value ?? draft.color),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _noteCtrl,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: loc.noteLabel(''),
            prefixIcon: const Icon(Icons.edit_note_outlined),
          ),
          onChanged: (value) =>
              _updateDraft((draft) => draft.note = value.trim()),
        ),
      ],
    );
  }
}
