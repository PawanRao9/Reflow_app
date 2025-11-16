import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventorySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final VoidCallback onScanPressed;

  const InventorySearchBar({
    Key? key,
    required this.controller,
    required this.onChanged,
    required this.onScanPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: 'Search products...',
                  hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 14.sp,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'search',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 4.w,
                    vertical: 2.h,
                  ),
                ),
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
          SizedBox(width: 3.w),
          GestureDetector(
            onTap: onScanPressed,
            child: Container(
              width: 12.w,
              height: 6.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'qr_code_scanner',
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  size: 6.w,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
