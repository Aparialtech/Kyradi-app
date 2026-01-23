import 'package:flutter/material.dart';

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
                  'Filters',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: widget.onClear,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _openNow,
              contentPadding: EdgeInsets.zero,
              title: const Text('Open now'),
              onChanged: (value) => setState(() => _openNow = value),
            ),
            SwitchListTile(
              value: _availableOnly,
              contentPadding: EdgeInsets.zero,
              title: const Text('Available slots'),
              onChanged: (value) => setState(() => _availableOnly = value),
            ),
            SwitchListTile(
              value: _activeOnly,
              contentPadding: EdgeInsets.zero,
              title: const Text('Active locations'),
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
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
