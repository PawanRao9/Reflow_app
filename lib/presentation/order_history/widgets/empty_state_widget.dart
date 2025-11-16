import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback? onPlaceOrder;

  const EmptyStateWidget({
    super.key,
    this.onPlaceOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'shopping_cart_outlined',
                size: 20.w,
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            ),

            SizedBox(height: 4.h),

            // Title
            Text(
              'No Orders Yet',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 2.h),

            // Description
            Text(
              'Start building your inventory with sustainable menstrual products. Browse our catalog and place your first bulk order.',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondaryLight,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 4.h),

            // CTA Button
            ElevatedButton.icon(
              onPressed: onPlaceOrder ??
                  () {
                    Navigator.pushNamed(context, '/bulk-order-cart');
                  },
              icon: CustomIconWidget(
                iconName: 'add_shopping_cart',
                size: 5.w,
                color: Colors.white,
              ),
              label: Text(
                'Place Your First Order',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
              ),
            ),

            SizedBox(height: 2.h),

            // Secondary Action
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/supplier-directory');
              },
              child: Text(
                'Browse Suppliers',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
