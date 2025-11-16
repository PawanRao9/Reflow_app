import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickActionButtonWidget extends StatelessWidget {
  final String title;
  final String iconName;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const QuickActionButtonWidget({
    Key? key,
    required this.title,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 12.h,
          margin: EdgeInsets.symmetric(horizontal: 1.w),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: iconName,
                color: iconColor,
                size: 6.w,
              ),
              SizedBox(height: 1.h),
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
