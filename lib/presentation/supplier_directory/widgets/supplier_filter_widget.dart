import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SupplierFilterWidget extends StatefulWidget {
  final Map<String, dynamic> currentFilters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const SupplierFilterWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
  });

  @override
  State<SupplierFilterWidget> createState() => _SupplierFilterWidgetState();
}

class _SupplierFilterWidgetState extends State<SupplierFilterWidget> {
  late Map<String, dynamic> _filters;

  final List<String> _productCategories = [
    'Menstrual Cups',
    'Reusable Pads',
    'Period Panties',
    'Organic Products',
    'Eco-Friendly',
  ];

  final List<String> _deliveryOptions = [
    'Same Day',
    'Next Day',
    'Express',
    'Standard',
    'Bulk Delivery',
  ];

  final List<String> _paymentTerms = [
    'Cash on Delivery',
    'Net 30',
    'Net 15',
    'Advance Payment',
    'Credit Terms',
  ];

  @override
  void initState() {
    super.initState();
    _filters = Map<String, dynamic>.from(widget.currentFilters);
  }

  void _updateFilter(String key, dynamic value) {
    setState(() {
      _filters[key] = value;
    });
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
    Navigator.pop(context);
  }

  void _clearFilters() {
    setState(() {
      _filters = {
        'locationRadius': 50.0,
        'minRating': 0.0,
        'productCategories': <String>[],
        'deliveryOptions': <String>[],
        'paymentTerms': <String>[],
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Suppliers',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  size: 24,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Location Radius
          Text(
            'Location Radius',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (_filters['locationRadius'] as double?) ?? 50.0,
                  min: 5.0,
                  max: 200.0,
                  divisions: 39,
                  label:
                      '${(_filters['locationRadius'] as double?)?.round() ?? 50} km',
                  onChanged: (value) => _updateFilter('locationRadius', value),
                ),
              ),
              Text(
                '${(_filters['locationRadius'] as double?)?.round() ?? 50} km',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Minimum Rating
          Text(
            'Minimum Rating',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: (_filters['minRating'] as double?) ?? 0.0,
                  min: 0.0,
                  max: 5.0,
                  divisions: 10,
                  label:
                      '${(_filters['minRating'] as double?)?.toStringAsFixed(1) ?? '0.0'} stars',
                  onChanged: (value) => _updateFilter('minRating', value),
                ),
              ),
              Row(
                children: List.generate(5, (index) {
                  final rating = (_filters['minRating'] as double?) ?? 0.0;
                  return CustomIconWidget(
                    iconName: index < rating ? 'star' : 'star_border',
                    size: 16,
                    color: Colors.amber,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Product Categories
          Text(
            'Product Categories',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _productCategories.map((category) {
              final isSelected =
                  ((_filters['productCategories'] as List?) ?? [])
                      .contains(category);
              return FilterChip(
                label: Text(category),
                selected: isSelected,
                onSelected: (selected) {
                  final categories = List<String>.from(
                      (_filters['productCategories'] as List?) ?? []);
                  if (selected) {
                    categories.add(category);
                  } else {
                    categories.remove(category);
                  }
                  _updateFilter('productCategories', categories);
                },
                selectedColor: theme.colorScheme.primaryContainer,
                checkmarkColor: theme.colorScheme.primary,
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),

          // Delivery Options
          Text(
            'Delivery Options',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _deliveryOptions.map((option) {
              final isSelected = ((_filters['deliveryOptions'] as List?) ?? [])
                  .contains(option);
              return FilterChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (selected) {
                  final options = List<String>.from(
                      (_filters['deliveryOptions'] as List?) ?? []);
                  if (selected) {
                    options.add(option);
                  } else {
                    options.remove(option);
                  }
                  _updateFilter('deliveryOptions', options);
                },
                selectedColor: theme.colorScheme.secondaryContainer,
                checkmarkColor: theme.colorScheme.secondary,
              );
            }).toList(),
          ),
          SizedBox(height: 2.h),

          // Payment Terms
          Text(
            'Payment Terms',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: _paymentTerms.map((term) {
              final isSelected =
                  ((_filters['paymentTerms'] as List?) ?? []).contains(term);
              return FilterChip(
                label: Text(term),
                selected: isSelected,
                onSelected: (selected) {
                  final terms = List<String>.from(
                      (_filters['paymentTerms'] as List?) ?? []);
                  if (selected) {
                    terms.add(term);
                  } else {
                    terms.remove(term);
                  }
                  _updateFilter('paymentTerms', terms);
                },
                selectedColor: theme.colorScheme.tertiaryContainer,
                checkmarkColor: theme.colorScheme.tertiary,
              );
            }).toList(),
          ),
          SizedBox(height: 3.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _clearFilters,
                  child: Text('Clear All'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: _applyFilters,
                  child: Text('Apply Filters'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
