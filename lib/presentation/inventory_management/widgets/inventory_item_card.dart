import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class InventoryItemCard extends StatelessWidget {
  final Map<String, dynamic> item;
  final VoidCallback onUpdateStock;
  final VoidCallback onSetReorderPoint;
  final VoidCallback onMarkReceived;
  final VoidCallback? onTap;

  const InventoryItemCard({
    Key? key,
    required this.item,
    required this.onUpdateStock,
    required this.onSetReorderPoint,
    required this.onMarkReceived,
    this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'adequate':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'low':
        return const Color(0xFFF57C00);
      case 'critical':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'adequate':
        return 'In Stock';
      case 'low':
        return 'Low Stock';
      case 'critical':
        return 'Critical';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentStock = item['currentStock'] as int? ?? 0;
    final reorderPoint = item['reorderPoint'] as int? ?? 0;
    final status = item['status'] as String? ?? 'adequate';
    final productName = item['name'] as String? ?? 'Unknown Product';
    final imageUrl = item['image'] as String? ?? '';
    final semanticLabel = item['semanticLabel'] as String? ?? 'Product image';

    return Slidable(
      key: ValueKey(item['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => onUpdateStock(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
            icon: Icons.add,
            label: 'Update',
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (_) => onSetReorderPoint(),
            backgroundColor: const Color(0xFFF57C00),
            foregroundColor: Colors.white,
            icon: Icons.settings,
            label: 'Reorder',
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (_) => onMarkReceived(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: AppTheme.lightTheme.colorScheme.onSecondary,
            icon: Icons.check,
            label: 'Received',
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 15.w,
                height: 15.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.lightTheme.colorScheme.surface,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: imageUrl.isNotEmpty
                      ? CustomImageWidget(
                          imageUrl: imageUrl,
                          width: 15.w,
                          height: 15.w,
                          fit: BoxFit.cover,
                          semanticLabel: semanticLabel,
                        )
                      : Container(
                          color: AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.1),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: 'inventory',
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                              size: 6.w,
                            ),
                          ),
                        ),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        Text(
                          'Stock: $currentStock',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Reorder: $reorderPoint',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 8.h,
                color: _getStatusColor(status),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
