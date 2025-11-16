import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LowStockAlertSection extends StatelessWidget {
  final List<Map<String, dynamic>> lowStockItems;
  final Function(Map<String, dynamic>) onReorderPressed;

  const LowStockAlertSection({
    Key? key,
    required this.lowStockItems,
    required this.onReorderPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (lowStockItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: const Color(0xFFF57C00).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF57C00).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'warning',
                color: const Color(0xFFF57C00),
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Low Stock Alerts',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xFFF57C00),
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          ...lowStockItems.take(3).map((item) => _buildLowStockItem(item)),
          if (lowStockItems.length > 3)
            Padding(
              padding: EdgeInsets.only(top: 1.h),
              child: Text(
                '+${lowStockItems.length - 3} more items need attention',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: const Color(0xFFF57C00),
                  fontSize: 11.sp,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLowStockItem(Map<String, dynamic> item) {
    final productName = item['name'] as String? ?? 'Unknown Product';
    final currentStock = item['currentStock'] as int? ?? 0;
    final reorderPoint = item['reorderPoint'] as int? ?? 0;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  productName,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Stock: $currentStock (Reorder at: $reorderPoint)',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 2.w),
          ElevatedButton(
            onPressed: () => onReorderPressed(item),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF57C00),
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              minimumSize: Size(0, 4.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'Reorder',
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
