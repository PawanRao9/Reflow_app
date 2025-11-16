import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class FilterBottomSheetWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterBottomSheetWidget({
    Key? key,
    required this.currentFilters,
    required this.onFiltersChanged,
  }) : super(key: key);

  @override
  State<FilterBottomSheetWidget> createState() =>
      _FilterBottomSheetWidgetState();
}

class _FilterBottomSheetWidgetState extends State<FilterBottomSheetWidget> {
  late Map<String, dynamic> _filters;
  RangeValues _priceRange = const RangeValues(50, 2000);

  final List<String> _brands = [
    'DivaCup',
    'Saalt',
    'Lunette',
    'OrganiCup',
    'Ruby Cup'
  ];
  final List<String> _materials = [
    'Medical Silicone',
    'Organic Cotton',
    'Bamboo Fiber',
    'Merino Wool'
  ];
  final List<String> _sizes = ['Small', 'Medium', 'Large', 'Extra Large'];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
    _priceRange = RangeValues(
      (_filters['minPrice'] as double?) ?? 50.0,
      (_filters['maxPrice'] as double?) ?? 2000.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Filter Products',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Filter Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Range
                  _buildFilterSection(
                    title: 'Price Range',
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '₹${_priceRange.start.round()}',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '₹${_priceRange.end.round()}',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        RangeSlider(
                          values: _priceRange,
                          min: 50,
                          max: 2000,
                          divisions: 39,
                          onChanged: (RangeValues values) {
                            setState(() {
                              _priceRange = values;
                              _filters['minPrice'] = values.start;
                              _filters['maxPrice'] = values.end;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Brand Filter
                  _buildFilterSection(
                    title: 'Brand',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _brands
                          .map((brand) => _buildFilterChip(
                                label: brand,
                                isSelected: (_filters['selectedBrands']
                                            as List<String>?)
                                        ?.contains(brand) ??
                                    false,
                                onTap: () => _toggleBrandFilter(brand),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Material Filter
                  _buildFilterSection(
                    title: 'Material',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _materials
                          .map((material) => _buildFilterChip(
                                label: material,
                                isSelected: (_filters['selectedMaterials']
                                            as List<String>?)
                                        ?.contains(material) ??
                                    false,
                                onTap: () => _toggleMaterialFilter(material),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Size Filter
                  _buildFilterSection(
                    title: 'Size Options',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _sizes
                          .map((size) => _buildFilterChip(
                                label: size,
                                isSelected:
                                    (_filters['selectedSizes'] as List<String>?)
                                            ?.contains(size) ??
                                        false,
                                onTap: () => _toggleSizeFilter(size),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stock Availability
                  _buildFilterSection(
                    title: 'Stock Availability',
                    child: Column(
                      children: [
                        CheckboxListTile(
                          title: Text(
                            'In Stock Only',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          value: _filters['inStockOnly'] as bool? ?? false,
                          onChanged: (value) {
                            setState(() {
                              _filters['inStockOnly'] = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                        CheckboxListTile(
                          title: Text(
                            'Low Stock Alert',
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                          value: _filters['lowStockAlert'] as bool? ?? false,
                          onChanged: (value) {
                            setState(() {
                              _filters['lowStockAlert'] = value ?? false;
                            });
                          },
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Apply Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersChanged(_filters);
                      Navigator.pop(context);
                    },
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection({
    required String title,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  void _toggleBrandFilter(String brand) {
    setState(() {
      final selectedBrands =
          (_filters['selectedBrands'] as List<String>?) ?? <String>[];
      if (selectedBrands.contains(brand)) {
        selectedBrands.remove(brand);
      } else {
        selectedBrands.add(brand);
      }
      _filters['selectedBrands'] = selectedBrands;
    });
  }

  void _toggleMaterialFilter(String material) {
    setState(() {
      final selectedMaterials =
          (_filters['selectedMaterials'] as List<String>?) ?? <String>[];
      if (selectedMaterials.contains(material)) {
        selectedMaterials.remove(material);
      } else {
        selectedMaterials.add(material);
      }
      _filters['selectedMaterials'] = selectedMaterials;
    });
  }

  void _toggleSizeFilter(String size) {
    setState(() {
      final selectedSizes =
          (_filters['selectedSizes'] as List<String>?) ?? <String>[];
      if (selectedSizes.contains(size)) {
        selectedSizes.remove(size);
      } else {
        selectedSizes.add(size);
      }
      _filters['selectedSizes'] = selectedSizes;
    });
  }

  void _clearAllFilters() {
    setState(() {
      _filters.clear();
      _priceRange = const RangeValues(50, 2000);
    });
  }
}
