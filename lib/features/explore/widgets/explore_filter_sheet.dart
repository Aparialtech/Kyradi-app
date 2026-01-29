import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';

class ExploreFilterSheet extends StatefulWidget {
  const ExploreFilterSheet({
    super.key,
    required this.openNow,
    required this.availableOnly,
    required this.activeOnly,
    required this.onApply,
    required this.onClear,
  });

  final bool openNow;
  final bool availableOnly;
  final bool activeOnly;
  final void Function({
    required bool openNow,
    required bool availableOnly,
    required bool activeOnly,
  }) onApply;
  final VoidCallback onClear;

  @override
  State<ExploreFilterSheet> createState() => _ExploreFilterSheetState();
}

class _ExploreFilterSheetState extends State<ExploreFilterSheet> {
  late bool _openNow;
  late bool _availableOnly;
  late bool _activeOnly;

  @override
  void initState() {
    super.initState();
    _openNow = widget.openNow;
    _availableOnly = widget.availableOnly;
    _activeOnly = widget.activeOnly;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  loc.filtersTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.onClear,
                  child: Text(loc.resetAction),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _openNow,
              contentPadding: EdgeInsets.zero,
              title: Text(loc.filterOpenNow),
              onChanged: (value) => setState(() => _openNow = value),
            ),
            SwitchListTile(
              value: _availableOnly,
              contentPadding: EdgeInsets.zero,
              title: Text(loc.filterAvailableSlots),
              onChanged: (value) => setState(() => _availableOnly = value),
            ),
            SwitchListTile(
              value: _activeOnly,
              contentPadding: EdgeInsets.zero,
              title: Text(loc.filterActiveLocations),
              onChanged: (value) => setState(() => _activeOnly = value),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  widget.onApply(
                    openNow: _openNow,
                    availableOnly: _availableOnly,
                    activeOnly: _activeOnly,
                  );
                },
                child: Text(loc.applyAction),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
