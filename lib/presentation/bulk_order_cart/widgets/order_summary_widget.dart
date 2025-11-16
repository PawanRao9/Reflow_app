import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryWidget extends StatelessWidget {
  final Map<String, dynamic> summary;
  final VoidCallback? onProceedToCheckout;
  final bool isCheckoutEnabled;

  const OrderSummaryWidget({
    super.key,
    required this.summary,
    this.onProceedToCheckout,
    this.isCheckoutEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtotal = (summary['subtotal'] as num?)?.toDouble() ?? 0.0;
    final totalDiscount = (summary['totalDiscount'] as num?)?.toDouble() ?? 0.0;
    final estimatedTax = (summary['estimatedTax'] as num?)?.toDouble() ?? 0.0;
    final grandTotal = (summary['grandTotal'] as num?)?.toDouble() ?? 0.0;
    final totalItems = (summary['totalItems'] as num?)?.toInt() ?? 0;
    final bulkSavings = (summary['bulkSavings'] as num?)?.toDouble() ?? 0.0;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Summary Header
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'receipt_long',
                    color: theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Order Summary',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$totalItems items',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Summary Details
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  children: [
                    _buildSummaryRow(
                      context,
                      'Subtotal',
                      '₹${subtotal.toStringAsFixed(2)}',
                      isSubtitle: true,
                    ),
                    if (totalDiscount > 0) ...[
                      const SizedBox(height: 8),
                      _buildSummaryRow(
                        context,
                        'Bulk Discount',
                        '-₹${totalDiscount.toStringAsFixed(2)}',
                        textColor: AppTheme.successLight,
                        icon: 'local_offer',
                      ),
                    ],
                    if (bulkSavings > 0) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: AppTheme.successLight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'savings',
                              color: AppTheme.successLight,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'You\'re saving ₹${bulkSavings.toStringAsFixed(2)} with bulk pricing!',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    _buildSummaryRow(
                      context,
                      'Estimated Tax (GST)',
                      '₹${estimatedTax.toStringAsFixed(2)}',
                      isSubtitle: true,
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    _buildSummaryRow(
                      context,
                      'Grand Total',
                      '₹${grandTotal.toStringAsFixed(2)}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Quick Actions Row
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _showQuickActions(context);
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
                            iconName: 'more_horiz',
                            color: theme.colorScheme.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'More Actions',
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
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: isCheckoutEnabled ? onProceedToCheckout : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 2.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: isCheckoutEnabled
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceContainerHighest,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'shopping_cart_checkout',
                            color: isCheckoutEnabled
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Proceed to Checkout',
                            style: theme.textTheme.titleSmall?.copyWith(
                              color: isCheckoutEnabled
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (!isCheckoutEnabled) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.warningLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppTheme.warningLight.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'info',
                        color: AppTheme.warningLight,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Please check minimum order quantities and stock availability',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.warningLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isTotal = false,
    bool isSubtitle = false,
    Color? textColor,
    String? icon,
  }) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (icon != null) ...[
          CustomIconWidget(
            iconName: icon,
            color: textColor ?? theme.colorScheme.onSurfaceVariant,
            size: 16,
          ),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: Text(
            label,
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )
                : theme.textTheme.bodyMedium?.copyWith(
                    color: isSubtitle
                        ? theme.colorScheme.onSurfaceVariant
                        : textColor,
                    fontWeight: textColor != null ? FontWeight.w500 : null,
                  ),
          ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.primary,
                )
              : theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: textColor ?? theme.colorScheme.onSurface,
                ),
        ),
      ],
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'bookmark_border',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Save for Later'),
                subtitle: const Text('Save this cart for future ordering'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cart saved for later!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'share',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: const Text('Share Cart'),
                subtitle: const Text('Share cart details with team members'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cart sharing feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'delete_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
                title: Text(
                  'Clear All',
                  style: TextStyle(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
                subtitle: const Text('Remove all items from cart'),
                onTap: () {
                  Navigator.pop(context);
                  _showClearAllConfirmation(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearAllConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text(
          'Are you sure you want to remove all items from your cart? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cart cleared successfully!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(
              foregroundColor: AppTheme.lightTheme.colorScheme.error,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }
}
