import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

class ActiveFiltersWidget extends StatelessWidget {
  final Map<String, dynamic> activeFilters;
  final Function(String, dynamic) onRemoveFilter;
  final VoidCallback onClearAll;

  const ActiveFiltersWidget({
    Key? key,
    required this.activeFilters,
    required this.onRemoveFilter,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> filterChips = _buildFilterChips();

    if (filterChips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Active Filters',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear All',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: filterChips,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFilterChips() {
    List<Widget> chips = [];

    // Price Range Filter
    if (activeFilters.containsKey('minPrice') ||
        activeFilters.containsKey('maxPrice')) {
      final minPrice = activeFilters['minPrice'] as double? ?? 50;
      final maxPrice = activeFilters['maxPrice'] as double? ?? 2000;
      if (minPrice != 50 || maxPrice != 2000) {
        chips.add(_buildFilterChip(
          label: '₹${minPrice.round()} - ₹${maxPrice.round()}',
          onRemove: () {
            onRemoveFilter('minPrice', null);
            onRemoveFilter('maxPrice', null);
          },
        ));
      }
    }

    // Brand Filters
    final selectedBrands = activeFilters['selectedBrands'] as List<String>?;
    if (selectedBrands != null && selectedBrands.isNotEmpty) {
      for (String brand in selectedBrands) {
        chips.add(_buildFilterChip(
          label: brand,
          onRemove: () => onRemoveFilter('selectedBrands', brand),
        ));
      }
    }

    // Material Filters
    final selectedMaterials =
        activeFilters['selectedMaterials'] as List<String>?;
    if (selectedMaterials != null && selectedMaterials.isNotEmpty) {
      for (String material in selectedMaterials) {
        chips.add(_buildFilterChip(
          label: material,
          onRemove: () => onRemoveFilter('selectedMaterials', material),
        ));
      }
    }

    // Size Filters
    final selectedSizes = activeFilters['selectedSizes'] as List<String>?;
    if (selectedSizes != null && selectedSizes.isNotEmpty) {
      for (String size in selectedSizes) {
        chips.add(_buildFilterChip(
          label: 'Size: $size',
          onRemove: () => onRemoveFilter('selectedSizes', size),
        ));
      }
    }

    // Stock Filters
    if (activeFilters['inStockOnly'] as bool? ?? false) {
      chips.add(_buildFilterChip(
        label: 'In Stock Only',
        onRemove: () => onRemoveFilter('inStockOnly', null),
      ));
    }

    if (activeFilters['lowStockAlert'] as bool? ?? false) {
      chips.add(_buildFilterChip(
        label: 'Low Stock Alert',
        onRemove: () => onRemoveFilter('lowStockAlert', null),
      ));
    }

    return chips;
  }

  Widget _buildFilterChip({
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'close',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
