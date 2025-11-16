import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatelessWidget {
  final VoidCallback? onBiometricSuccess;
  final bool isAvailable;

  const BiometricAuthWidget({
    Key? key,
    this.onBiometricSuccess,
    this.isAvailable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          thickness: 1,
          height: 4.h,
        ),
        Text(
          'Or continue with',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 2.h),
        ElevatedButton.icon(
          onPressed: onBiometricSuccess,
          icon: CustomIconWidget(
            iconName: 'fingerprint',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 6.w,
          ),
          label: Text(
            'Use Biometric Login',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.lightTheme.colorScheme.surface,
            foregroundColor: AppTheme.lightTheme.colorScheme.primary,
            elevation: 0,
            side: BorderSide(
              color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3.w),
            ),
          ),
        ),
      ],
    );
  }
}
