import 'package:flutter/material.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class CategoryChipWidget extends StatelessWidget {
  final String title;
  final int count;
  final bool isSelected;
  final VoidCallback? onTap;

  const CategoryChipWidget({
    Key? key,
    required this.title,
    required this.count,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.lightTheme.colorScheme.primary
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                    : AppTheme.lightTheme.colorScheme.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.lightTheme.colorScheme.onPrimary
                        .withValues(alpha: 0.2)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                count.toString(),
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? AppTheme.lightTheme.colorScheme.onPrimary
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
