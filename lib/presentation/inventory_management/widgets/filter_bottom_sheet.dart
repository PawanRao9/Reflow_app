import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    Key? key,
    required this.currentFilters,
    required this.onFiltersApplied,
  }) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;

  final List<String> _stockStatuses = ['All', 'Adequate', 'Low', 'Critical'];
  final List<String> _categories = [
    'All',
    'Menstrual Cups',
    'Reusable Pads',
    'Period Panties'
  ];
  final List<String> _suppliers = [
    'All',
    'EcoFemme',
    'Saathi',
    'Boondh',
    'Aakar Innovations'
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Inventory',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 18.sp,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection(
                    'Stock Status',
                    _stockStatuses,
                    _filters['stockStatus'] ?? 'All',
                    (value) => setState(() => _filters['stockStatus'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Product Category',
                    _categories,
                    _filters['category'] ?? 'All',
                    (value) => setState(() => _filters['category'] = value),
                  ),
                  SizedBox(height: 3.h),
                  _buildFilterSection(
                    'Supplier',
                    _suppliers,
                    _filters['supplier'] ?? 'All',
                    (value) => setState(() => _filters['supplier'] = value),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _filters = {
                          'stockStatus': 'All',
                          'category': 'All',
                          'supplier': 'All',
                        };
                      });
                    },
                    child: Text(
                      'Clear All',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onFiltersApplied(_filters);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Apply Filters',
                      style: TextStyle(fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.surface,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                        : AppTheme.lightTheme.colorScheme.outline,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.onPrimary
                        : AppTheme.lightTheme.colorScheme.onSurface,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
