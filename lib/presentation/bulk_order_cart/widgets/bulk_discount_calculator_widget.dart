import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkDiscountCalculatorWidget extends StatelessWidget {
  final List<Map<String, dynamic>> discountTiers;
  final int currentQuantity;
  final double unitPrice;
  final VoidCallback? onClose;

  const BulkDiscountCalculatorWidget({
    super.key,
    required this.discountTiers,
    required this.currentQuantity,
    required this.unitPrice,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTier = _getCurrentTier();
    final nextTier = _getNextTier();

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.successLight.withValues(alpha: 0.1),
            AppTheme.successLight.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.successLight.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.successLight.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CustomIconWidget(
                  iconName: 'calculate',
                  color: AppTheme.successLight,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bulk Discount Calculator',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successLight,
                      ),
                    ),
                    Text(
                      'Save more with higher quantities',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (onClose != null)
                IconButton(
                  onPressed: onClose,
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Current Savings
          if (currentTier != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.successLight.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.successLight.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'savings',
                    color: AppTheme.successLight,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Savings',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${currentTier['discountPercent']}% off • Save ₹${_calculateSavings(currentTier).toStringAsFixed(2)}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.successLight,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Next Tier Opportunity
          if (nextTier != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color:
                    theme.colorScheme.primaryContainer.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color:
                      theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'trending_up',
                        color: theme.colorScheme.primary,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Next Tier Opportunity',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Order ${nextTier['minQuantity'] - currentQuantity} more units to get ${nextTier['discountPercent']}% discount',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Additional savings: ₹${(_calculateSavings(nextTier) - (currentTier != null ? _calculateSavings(currentTier) : 0)).toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          // Discount Tiers Table
          Text(
            'All Discount Tiers',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.5),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Quantity',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Discount',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Price per Unit',
                          style: theme.textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                // Table Rows
                ...discountTiers.asMap().entries.map((entry) {
                  final index = entry.key;
                  final tier = entry.value;
                  final isCurrentTier = currentTier != null &&
                      tier['minQuantity'] == currentTier['minQuantity'];
                  final discountedPrice =
                      unitPrice * (1 - tier['discountPercent'] / 100);

                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isCurrentTier
                          ? AppTheme.successLight.withValues(alpha: 0.1)
                          : null,
                      border: index < discountTiers.length - 1
                          ? Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.outline
                                    .withValues(alpha: 0.2),
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Row(
                            children: [
                              Text(
                                '${tier['minQuantity']}+',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight:
                                      isCurrentTier ? FontWeight.w600 : null,
                                  color: isCurrentTier
                                      ? AppTheme.successLight
                                      : null,
                                ),
                              ),
                              if (isCurrentTier) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.successLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'ACTIVE',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 8,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${tier['discountPercent']}%',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isCurrentTier ? FontWeight.w600 : null,
                              color:
                                  isCurrentTier ? AppTheme.successLight : null,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '₹${discountedPrice.toStringAsFixed(2)}',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight:
                                  isCurrentTier ? FontWeight.w600 : null,
                              color:
                                  isCurrentTier ? AppTheme.successLight : null,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic>? _getCurrentTier() {
    Map<String, dynamic>? currentTier;
    for (final tier in discountTiers) {
      if (currentQuantity >= (tier['minQuantity'] as int)) {
        currentTier = tier;
      }
    }
    return currentTier;
  }

  Map<String, dynamic>? _getNextTier() {
    for (final tier in discountTiers) {
      if (currentQuantity < (tier['minQuantity'] as int)) {
        return tier;
      }
    }
    return null;
  }

  double _calculateSavings(Map<String, dynamic> tier) {
    final discountPercent = (tier['discountPercent'] as num).toDouble();
    return unitPrice * currentQuantity * (discountPercent / 100);
  }
}
