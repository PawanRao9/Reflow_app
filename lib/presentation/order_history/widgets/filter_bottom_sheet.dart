import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FilterBottomSheet extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersApplied;

  const FilterBottomSheet({
    super.key,
    required this.currentFilters,
    required this.onFiltersApplied,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late Map<String, dynamic> _filters;
  DateTimeRange? _selectedDateRange;

  final List<String> _orderStatuses = [
    'All',
    'Pending',
    'Confirmed',
    'Shipped',
    'Delivered',
    'Cancelled',
  ];

  final List<String> _suppliers = [
    'All Suppliers',
    'MedCare Distributors',
    'HealthFirst Supply Co.',
    'WellnessHub Ltd.',
    'CarePoint Medical',
    'VitalSupply Partners',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);

    // Initialize date range if exists
    if (_filters['startDate'] != null && _filters['endDate'] != null) {
      _selectedDateRange = DateTimeRange(
        start: DateTime.parse(_filters['startDate'] as String),
        end: DateTime.parse(_filters['endDate'] as String),
      );
    }
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppTheme.lightTheme.colorScheme.primary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDateRange = picked;
        _filters['startDate'] = picked.start.toIso8601String();
        _filters['endDate'] = picked.end.toIso8601String();
      });
    }
  }

  void _clearDateRange() {
    setState(() {
      _selectedDateRange = null;
      _filters.remove('startDate');
      _filters.remove('endDate');
    });
  }

  void _applyFilters() {
    widget.onFiltersApplied(_filters);
    Navigator.pop(context);
  }

  void _clearAllFilters() {
    setState(() {
      _filters = {
        'status': 'All',
        'supplier': 'All Suppliers',
      };
      _selectedDateRange = null;
    });
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildStatusFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Order Status'),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: _orderStatuses.map((status) {
            final bool isSelected = _filters['status'] == status;
            return FilterChip(
              label: Text(
                status,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.textPrimaryLight,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _filters['status'] = status;
                });
              },
              selectedColor: AppTheme.lightTheme.colorScheme.primary,
              backgroundColor: AppTheme.lightTheme.colorScheme.surface,
              side: BorderSide(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSupplierFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Supplier'),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _filters['supplier'] as String? ?? 'All Suppliers',
              isExpanded: true,
              items: _suppliers.map((supplier) {
                return DropdownMenuItem<String>(
                  value: supplier,
                  child: Text(
                    supplier,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.textPrimaryLight,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _filters['supplier'] = value;
                  });
                }
              },
              icon: CustomIconWidget(
                iconName: 'keyboard_arrow_down',
                size: 5.w,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateRangeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Date Range'),
        InkWell(
          onTap: _selectDateRange,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'date_range',
                  size: 5.w,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Text(
                    _selectedDateRange != null
                        ? '${_selectedDateRange!.start.day}/${_selectedDateRange!.start.month}/${_selectedDateRange!.start.year} - ${_selectedDateRange!.end.day}/${_selectedDateRange!.end.month}/${_selectedDateRange!.end.year}'
                        : 'Select date range',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: _selectedDateRange != null
                          ? AppTheme.textPrimaryLight
                          : AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
                if (_selectedDateRange != null)
                  InkWell(
                    onTap: _clearDateRange,
                    child: CustomIconWidget(
                      iconName: 'clear',
                      size: 4.w,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Filter Orders',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimaryLight,
                  ),
                ),
                TextButton(
                  onPressed: _clearAllFilters,
                  child: Text(
                    'Clear All',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Filters Content
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStatusFilter(),
                  SizedBox(height: 2.h),
                  _buildSupplierFilter(),
                  SizedBox(height: 2.h),
                  _buildDateRangeFilter(),
                  SizedBox(height: 4.h),
                ],
              ),
            ),
          ),

          // Apply Button
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            child: ElevatedButton(
              onPressed: _applyFilters,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
              ),
              child: Text(
                'Apply Filters',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
