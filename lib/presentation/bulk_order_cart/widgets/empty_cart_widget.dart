import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class EmptyCartWidget extends StatelessWidget {
  final VoidCallback? onContinueShopping;

  const EmptyCartWidget({
    super.key,
    this.onContinueShopping,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Empty Cart Illustration
            Container(
              width: 60.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30.w,
                    height: 30.w,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'shopping_cart_outlined',
                      color: theme.colorScheme.primary.withValues(alpha: 0.6),
                      size: 15.w,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Container(
                    width: 20.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Container(
                    width: 15.w,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            // Empty State Text
            Text(
              'Your cart is empty',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Add menstrual care products to your cart\nto get started with bulk ordering',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            // Continue Shopping Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onContinueShopping ??
                    () {
                      Navigator.pushNamed(context, '/supplier-directory');
                    },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'shopping_bag',
                      color: theme.colorScheme.onPrimary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Continue Shopping',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 2.h),
            // Quick Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/order-history');
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'history',
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Order History',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      // Navigate to wishlist or saved items
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Wishlist feature coming soon!'),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'favorite_border',
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Wishlist',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            // Educational Content
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb_outline',
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Did you know?',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bulk ordering helps reduce costs and ensures consistent supply of menstrual care products for your community or pharmacy.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
