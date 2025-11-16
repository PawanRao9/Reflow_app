import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderCardWidget extends StatefulWidget {
  final Map<String, dynamic> order;
  final VoidCallback? onTap;
  final VoidCallback? onReorder;
  final VoidCallback? onViewInvoice;
  final VoidCallback? onTrackShipment;
  final VoidCallback? onContactSupplier;

  const OrderCardWidget({
    super.key,
    required this.order,
    this.onTap,
    this.onReorder,
    this.onViewInvoice,
    this.onTrackShipment,
    this.onContactSupplier,
  });

  @override
  State<OrderCardWidget> createState() => _OrderCardWidgetState();
}

class _OrderCardWidgetState extends State<OrderCardWidget>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppTheme.warningLight;
      case 'confirmed':
        return AppTheme.lightTheme.colorScheme.primary;
      case 'shipped':
        return AppTheme.lightTheme.colorScheme.secondary;
      case 'delivered':
        return AppTheme.successLight;
      case 'cancelled':
        return AppTheme.errorLight;
      default:
        return AppTheme.lightTheme.colorScheme.onSurfaceVariant;
    }
  }

  Widget _buildStatusBadge(String status) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor(status).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: _getStatusColor(status),
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOrderTimeline() {
    final List<Map<String, dynamic>> timeline =
        (widget.order['timeline'] as List).cast<Map<String, dynamic>>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Timeline',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 2.h),
        ...timeline.map((step) => _buildTimelineStep(step)).toList(),
      ],
    );
  }

  Widget _buildTimelineStep(Map<String, dynamic> step) {
    final bool isCompleted = step['isCompleted'] as bool;
    final String title = step['title'] as String;
    final String? timestamp = step['timestamp'] as String?;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4.w,
            height: 4.w,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppTheme.successLight
                  : AppTheme.lightTheme.colorScheme.outline,
              shape: BoxShape.circle,
            ),
            child: isCompleted
                ? CustomIconWidget(
                    iconName: 'check',
                    color: Colors.white,
                    size: 2.w,
                  )
                : null,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    color: isCompleted
                        ? AppTheme.textPrimaryLight
                        : AppTheme.textSecondaryLight,
                  ),
                ),
                if (timestamp != null) ...[
                  SizedBox(height: 0.5.h),
                  Text(
                    timestamp,
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onViewInvoice,
            icon: CustomIconWidget(
              iconName: 'receipt',
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: Text(
              'Invoice',
              style: TextStyle(fontSize: 10.sp),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: widget.onTrackShipment,
            icon: CustomIconWidget(
              iconName: 'local_shipping',
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: Text(
              'Track',
              style: TextStyle(fontSize: 10.sp),
            ),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
          ),
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: widget.onReorder,
            icon: CustomIconWidget(
              iconName: 'refresh',
              size: 4.w,
              color: Colors.white,
            ),
            label: Text(
              'Reorder',
              style: TextStyle(fontSize: 10.sp),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 1.h),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final String orderNumber = widget.order['orderNumber'] as String;
    final String date = widget.order['date'] as String;
    final String supplierName = widget.order['supplierName'] as String;
    final String totalAmount = widget.order['totalAmount'] as String;
    final String status = widget.order['status'] as String;
    final int itemCount = widget.order['itemCount'] as int;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: InkWell(
        onTap: () {
          _toggleExpansion();
          widget.onTap?.call();
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          orderNumber,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTheme.textSecondaryLight,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          supplierName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            color: AppTheme.textPrimaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildStatusBadge(status),
                      SizedBox(height: 1.h),
                      Text(
                        totalAmount,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimaryLight,
                        ),
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '$itemCount items',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTheme.textSecondaryLight,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Expand/Collapse Indicator
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: CustomIconWidget(
                      iconName: 'keyboard_arrow_down',
                      size: 5.w,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ],
              ),

              // Expanded Content
              SizeTransition(
                sizeFactor: _expandAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Divider(
                      color: AppTheme.lightTheme.colorScheme.outline
                          .withValues(alpha: 0.3),
                    ),
                    SizedBox(height: 2.h),

                    // Order Timeline
                    _buildOrderTimeline(),

                    SizedBox(height: 3.h),

                    // Action Buttons
                    _buildActionButtons(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
