import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class OrderSummaryCard extends StatefulWidget {
  final List<Map<String, dynamic>> orderItems;
  final Map<String, dynamic> orderTotals;

  const OrderSummaryCard({
    super.key,
    required this.orderItems,
    required this.orderTotals,
  });

  @override
  State<OrderSummaryCard> createState() => _OrderSummaryCardState();
}

class _OrderSummaryCardState extends State<OrderSummaryCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Summary',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '${widget.orderItems.length} items • ₹${widget.orderTotals["total"]}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: theme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            Divider(
                height: 1,
                color: theme.colorScheme.outline.withValues(alpha: 0.2)),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  ...widget.orderItems
                      .map((item) => _buildOrderItem(context, item)),
                  SizedBox(height: 2.h),
                  _buildTotalBreakdown(context),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> item) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: item["image"] as String,
              width: 15.w,
              height: 15.w,
              fit: BoxFit.cover,
              semanticLabel: item["semanticLabel"] as String,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Qty: ${item["quantity"]} • ₹${item["price"]} each',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '₹${item["total"]}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBreakdown(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        SizedBox(height: 1.h),
        _buildTotalRow('Subtotal', '₹${widget.orderTotals["subtotal"]}', theme),
        SizedBox(height: 1.h),
        _buildTotalRow('GST (18%)', '₹${widget.orderTotals["gst"]}', theme),
        SizedBox(height: 1.h),
        _buildTotalRow(
            'Delivery Charges', '₹${widget.orderTotals["delivery"]}', theme),
        SizedBox(height: 1.h),
        Divider(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
        SizedBox(height: 1.h),
        _buildTotalRow(
          'Total Amount',
          '₹${widget.orderTotals["total"]}',
          theme,
          isTotal: true,
        ),
      ],
    );
  }

  Widget _buildTotalRow(String label, String amount, ThemeData theme,
      {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
            color: isTotal
                ? theme.colorScheme.onSurface
                : theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          amount,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isTotal
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
