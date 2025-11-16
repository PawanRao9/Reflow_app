import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderCardWidget extends StatelessWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onTrack;
  final VoidCallback? onReorder;
  final VoidCallback? onInvoice;
  final VoidCallback? onTap;

  const OrderCardWidget({
    Key? key,
    required this.order,
    this.onTrack,
    this.onReorder,
    this.onInvoice,
    this.onTap,
  }) : super(key: key);

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'pending':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'processing':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'cancelled':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (context) => onTrack?.call(),
            backgroundColor: AppTheme.lightTheme.colorScheme.primary,
            foregroundColor: Colors.white,
            icon: Icons.track_changes,
            label: 'Track',
            borderRadius: BorderRadius.circular(8),
          ),
          SlidableAction(
            onPressed: (context) => onReorder?.call(),
            backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
            foregroundColor: Colors.white,
            icon: Icons.refresh,
            label: 'Reorder',
            borderRadius: BorderRadius.circular(8),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        onLongPress: () => _showContextMenu(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          padding: EdgeInsets.all(4.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Order #${order["orderNumber"] ?? "N/A"}',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(order["status"] ?? "")
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      order["status"] ?? "Unknown",
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: _getStatusColor(order["status"] ?? ""),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'calendar_today',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    order["date"] ?? "N/A",
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    order["total"] ?? "₹0",
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (order["items"] != null) ...[
                SizedBox(height: 1.h),
                Text(
                  '${order["items"]} items',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 2.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'track_changes',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: Text('Track Order'),
              onTap: () {
                Navigator.pop(context);
                onTrack?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'refresh',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: Text('Reorder'),
              onTap: () {
                Navigator.pop(context);
                onReorder?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'receipt',
                color: AppTheme.lightTheme.colorScheme.tertiary,
                size: 6.w,
              ),
              title: Text('View Invoice'),
              onTap: () {
                Navigator.pop(context);
                onInvoice?.call();
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
