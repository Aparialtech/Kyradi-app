import 'package:flutter/material.dart';
import '../../../widgets/section_card.dart';
import '../../../models/luggage.dart';
import '../models/luggage_filter.dart';

class LuggagesSection extends StatelessWidget {
  const LuggagesSection({
    super.key,
    required this.sectionKey,
    required this.title,
    required this.subtitle,
    required this.filterOptions,
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.isLoading,
    required this.luggagesCount,
    required this.visibleLuggages,
    required this.buildLuggageCard,
    required this.emptyNoItemsLabel,
    required this.emptyFilteredLabel,
  });

  final Key? sectionKey;
  final String title;
  final String subtitle;
  final List<LuggageFilterOption> filterOptions;
  final LuggageFilter selectedFilter;
  final ValueChanged<LuggageFilter> onFilterChanged;
  final bool isLoading;
  final int luggagesCount;
  final List<LuggageModel> visibleLuggages;
  final Widget Function(LuggageModel luggage) buildLuggageCard;
  final String emptyNoItemsLabel;
  final String emptyFilteredLabel;

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      key: sectionKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            icon: Icons.wallet_travel,
          ),
          const SizedBox(height: 16),
          LayoutBuilder(
            builder: (context, constraints) {
              const compactBreakpoint = 520.0;
              if (constraints.maxWidth < compactBreakpoint) {
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: filterOptions.map((option) {
                    final isSelected = selectedFilter == option.value;
                    return ChoiceChip(
                      label: Text(option.label),
                      avatar: Icon(
                        option.icon,
                        size: 18,
                      ),
                      selected: isSelected,
                      showCheckmark: false,
                      onSelected: (_) => onFilterChanged(option.value),
                    );
                  }).toList(),
                );
              }
              return SegmentedButton<LuggageFilter>(
                segments: filterOptions
                    .map(
                      (option) => ButtonSegment(
                        value: option.value,
                        label: Text(option.label),
                        icon: Icon(option.icon),
                      ),
                    )
                    .toList(),
                selected: {selectedFilter},
                onSelectionChanged: (value) {
                  if (value.isEmpty) return;
                  onFilterChanged(value.first);
                },
              );
            },
          ),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : visibleLuggages.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 24,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              luggagesCount == 0
                                  ? emptyNoItemsLabel
                                  : emptyFilteredLabel,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: visibleLuggages.length,
                        itemBuilder: (context, index) =>
                            buildLuggageCard(visibleLuggages[index]),
                      ),
          ),
        ],
      ),
    );
  }
}

class LuggageFilterOption {
  const LuggageFilterOption({
    required this.value,
    required this.label,
    required this.icon,
  });

  final LuggageFilter value;
  final String label;
  final IconData icon;
}
