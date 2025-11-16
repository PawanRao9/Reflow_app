import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryOverviewCard extends StatelessWidget {
  final String title;
  final String count;
  final Color backgroundColor;
  final Color textColor;
  final String iconName;
  final VoidCallback? onTap;

  const InventoryOverviewCard({
    Key? key,
    required this.title,
    required this.count,
    required this.backgroundColor,
    required this.textColor,
    required this.iconName,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.w,
        height: 12.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconWidget(
                  iconName: iconName,
                  color: textColor,
                  size: 6.w,
                ),
                Text(
                  count,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.sp,
                  ),
                ),
              ],
            ),
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: 11.sp,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
