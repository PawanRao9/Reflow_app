import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SpecialInstructionsField extends StatefulWidget {
  final TextEditingController controller;
  final int maxLength;

  const SpecialInstructionsField({
    super.key,
    required this.controller,
    this.maxLength = 200,
  });

  @override
  State<SpecialInstructionsField> createState() =>
      _SpecialInstructionsFieldState();
}

class _SpecialInstructionsFieldState extends State<SpecialInstructionsField> {
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
                  iconName: 'note_add',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Special Instructions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Text(
              'Add any special delivery instructions or notes for your order',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            TextFormField(
              controller: widget.controller,
              maxLines: 4,
              maxLength: widget.maxLength,
              decoration: InputDecoration(
                hintText:
                    'e.g., Please call before delivery, Leave at reception, etc.',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
                contentPadding: EdgeInsets.all(3.w),
                counterStyle: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
