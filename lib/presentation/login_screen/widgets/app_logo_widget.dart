import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 20.w,
          height: 20.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'favorite',
              color: Colors.white,
              size: 10.w,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          'MenstruCare',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Connect',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.8),
            fontWeight: FontWeight.w400,
            letterSpacing: 2.0,
          ),
        ),
      ],
    );
  }
}
