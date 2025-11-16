import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BusinessTypeSelector extends StatelessWidget {
  final String selectedType;
  final Function(String) onTypeSelected;

  const BusinessTypeSelector({
    Key? key,
    required this.selectedType,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final businessTypes = [
      {'value': 'pharmacy', 'label': 'Pharmacy', 'icon': 'local_pharmacy'},
      {
        'value': 'distributor',
        'label': 'Medical Distributor',
        'icon': 'local_shipping'
      },
      {'value': 'shg', 'label': 'Self Help Group', 'icon': 'groups'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Type',
          style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 2.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline,
              width: 1,
            ),
          ),
          child: Column(
            children: businessTypes.map((type) {
              final isSelected = selectedType == type['value'];
              return InkWell(
                onTap: () => onTypeSelected(type['value'] as String),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: type['icon'] as String,
                        color: isSelected
                            ? AppTheme.lightTheme.colorScheme.primary
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 24,
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Text(
                          type['label'] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.colorScheme.primary
                                : AppTheme.lightTheme.colorScheme.onSurface,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
