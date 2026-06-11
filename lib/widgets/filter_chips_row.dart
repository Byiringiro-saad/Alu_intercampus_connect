import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_decorations.dart';

class FilterChipsRow extends StatelessWidget {
  const FilterChipsRow({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = AppColors.brand(isDark);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 22),
        itemCount: filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final filter = filters[i];
          final isSelected = filter == selected;
          return FilterChip(
            label: Text(filter),
            selected: isSelected,
            showCheckmark: false,
            labelStyle: TextStyle(
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              fontSize: 13,
              color: isSelected
                  ? (isDark ? AppColors.darkBackground : Colors.white)
                  : null,
            ),
            backgroundColor: isDark
                ? AppColors.darkCard
                : AppColors.surfaceMuted,
            selectedColor: activeColor,
            side: BorderSide(
              color: isSelected
                  ? activeColor
                  : AppDecorations.borderColor(context),
            ),
            onSelected: (_) => onSelected(filter),
          );
        },
      ),
    );
  }
}
