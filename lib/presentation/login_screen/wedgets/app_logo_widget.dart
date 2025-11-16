import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo Container
        Container(
          width: 24.w,
          height: 24.w,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.primaryColor,
                AppTheme.lightTheme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background pattern
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                ),
              ),
              // Main icon
              CustomIconWidget(
                iconName: 'favorite',
                color: Colors.white,
                size: 40,
              ),
              // Accent dot
              Positioned(
                top: 6.w,
                right: 6.w,
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: BoxDecoration(
                    color: AppTheme.getAccentColor(true),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 3.h),

        // App Name
        Text(
          'MenstruCare Pro',
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.primaryColor,
            letterSpacing: -0.5,
          ),
        ),
        SizedBox(height: 1.h),

        // Tagline
        Text(
          'Professional Inventory Management',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
