import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class DeliveryDateSelector extends StatefulWidget {
  final List<Map<String, dynamic>> availableSlots;
  final Map<String, dynamic>? selectedSlot;
  final Function(Map<String, dynamic>) onSlotSelected;

  const DeliveryDateSelector({
    super.key,
    required this.availableSlots,
    this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  State<DeliveryDateSelector> createState() => _DeliveryDateSelectorState();
}

class _DeliveryDateSelectorState extends State<DeliveryDateSelector> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'schedule',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Delivery Date & Time',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Select your preferred delivery slot:',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            ...widget.availableSlots
                .map((slot) => _buildSlotOption(context, slot)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlotOption(BuildContext context, Map<String, dynamic> slot) {
    final theme = Theme.of(context);
    final isSelected = widget.selectedSlot?["id"] == slot["id"];
    final isAvailable = slot["available"] as bool;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: !isAvailable
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : null,
      ),
      child: InkWell(
        onTap: isAvailable ? () => widget.onSlotSelected(slot) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              Radio<int>(
                value: slot["id"] as int,
                groupValue: widget.selectedSlot?["id"] as int?,
                onChanged:
                    isAvailable ? (value) => widget.onSlotSelected(slot) : null,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          slot["date"] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: !isAvailable
                                ? theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)
                                : null,
                          ),
                        ),
                        SizedBox(width: 2.w),
                        if (!isAvailable)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Not Available',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.error,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      slot["timeSlot"] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: !isAvailable
                            ? theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'local_shipping',
                          color: !isAvailable
                              ? theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.5)
                              : theme.colorScheme.primary,
                          size: 4.w,
                        ),
                        SizedBox(width: 1.w),
                        Text(
                          slot["supplier"] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: !isAvailable
                                ? theme.colorScheme.onSurfaceVariant
                                    .withValues(alpha: 0.5)
                                : theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (slot["charges"] != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${slot["charges"]}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: !isAvailable
                            ? theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                    Text(
                      'Delivery',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: !isAvailable
                            ? theme.colorScheme.onSurfaceVariant
                                .withValues(alpha: 0.5)
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
