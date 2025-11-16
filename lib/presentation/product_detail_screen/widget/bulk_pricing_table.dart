import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkPricingTable extends StatelessWidget {
  final List<Map<String, dynamic>> pricingTiers;
  final String currency;

  const BulkPricingTable({
    Key? key,
    required this.pricingTiers,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.w),
                topRight: Radius.circular(3.w),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_offer',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Bulk Pricing Tiers',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Table header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface
                  .withValues(alpha: 0.5),
              border: Border(
                bottom: BorderSide(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Quantity Range',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Per Unit Price',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Total Savings',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),

          // Pricing rows
          ...pricingTiers.asMap().entries.map((entry) {
            final index = entry.key;
            final tier = entry.value;
            final isRecommended = tier["recommended"] as bool? ?? false;

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isRecommended
                    ? AppTheme.lightTheme.colorScheme.secondaryContainer
                        .withValues(alpha: 0.1)
                    : Colors.transparent,
                border: Border(
                  bottom: index < pricingTiers.length - 1
                      ? BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                        )
                      : BorderSide.none,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        Text(
                          tier["range"] as String,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            fontWeight: isRecommended
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                        if (isRecommended) ...[
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme.lightTheme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(1.h),
                            ),
                            child: Text(
                              'Best Value',
                              style: AppTheme.lightTheme.textTheme.labelSmall
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                                fontSize: 8.sp,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '$currency${tier["unitPrice"]}',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${tier["savings"]}%',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getSuccessColor(true),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          // Footer note
          Container(
            padding: EdgeInsets.all(4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Prices are exclusive of taxes. Additional discounts may apply for registered distributors.',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}