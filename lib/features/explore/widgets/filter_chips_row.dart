import 'dart:ui';

import 'package:flutter/material.dart';

class ExploreFilterChipData {
  const ExploreFilterChipData({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
}

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.chips,
  });

  final List<ExploreFilterChipData> chips;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemCount: chips.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = chips[index];
          return _FilterChip(data: chip);
        },
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.data});

  final ExploreFilterChipData data;

  @override
  Widget build(BuildContext context) {
    const activeTint = Color(0xFF0F766E);
    return Semantics(
      button: true,
      selected: data.selected,
      label: data.label,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Material(
            color: data.selected
                ? activeTint.withValues(alpha: 0.18)
                : Colors.white.withValues(alpha: 0.56),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: data.onTap,
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: data.selected
                        ? activeTint.withValues(alpha: 0.36)
                        : Colors.white.withValues(alpha: 0.64),
                  ),
                  boxShadow: data.selected
                      ? [
                          BoxShadow(
                            color: const Color(0xFF14B8A6).withValues(alpha: 0.12),
                            blurRadius: 14,
                            spreadRadius: -2,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      data.icon,
                      size: 16,
                      color: data.selected
                          ? activeTint
                          : const Color(0xFF334155).withValues(alpha: 0.80),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      data.label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: data.selected ? FontWeight.w600 : FontWeight.w500,
                        color: data.selected
                            ? activeTint
                            : const Color(0xFF334155).withValues(alpha: 0.84),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
