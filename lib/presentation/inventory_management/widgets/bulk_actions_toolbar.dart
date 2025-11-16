import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BulkActionsToolbar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onUpdateStock;
  final VoidCallback onSetReorderPoint;
  final VoidCallback onMarkReceived;
  final VoidCallback onClearSelection;

  const BulkActionsToolbar({
    Key? key,
    required this.selectedCount,
    required this.onUpdateStock,
    required this.onSetReorderPoint,
    required this.onMarkReceived,
    required this.onClearSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: selectedCount > 0 ? 8.h : 0,
      child: selectedCount > 0
          ? Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: onClearSelection,
                    child: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      size: 6.w,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    '$selectedCount selected',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      _buildActionButton(
                        iconName: 'add',
                        onPressed: onUpdateStock,
                        tooltip: 'Update Stock',
                      ),
                      SizedBox(width: 3.w),
                      _buildActionButton(
                        iconName: 'settings',
                        onPressed: onSetReorderPoint,
                        tooltip: 'Set Reorder Point',
                      ),
                      SizedBox(width: 3.w),
                      _buildActionButton(
                        iconName: 'check',
                        onPressed: onMarkReceived,
                        tooltip: 'Mark as Received',
                      ),
                    ],
                  ),
                ],
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _buildActionButton({
    required String iconName,
    required VoidCallback onPressed,
    required String tooltip,
  }) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.onPrimary
                .withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: AppTheme.lightTheme.colorScheme.onPrimary,
            size: 5.w,
          ),
        ),
      ),
    );
  }
}
