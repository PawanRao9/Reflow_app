import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

enum SettingsItemType {
  navigation,
  toggle,
  selection,
  action,
}

class SettingsItemWidget extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String iconName;
  final SettingsItemType type;
  final VoidCallback? onTap;
  final bool? switchValue;
  final ValueChanged<bool>? onSwitchChanged;
  final String? selectedValue;
  final Widget? trailing;
  final Color? iconColor;
  final bool showBadge;
  final String? badgeText;

  const SettingsItemWidget({
    super.key,
    required this.title,
    this.subtitle,
    required this.iconName,
    this.type = SettingsItemType.navigation,
    this.onTap,
    this.switchValue,
    this.onSwitchChanged,
    this.selectedValue,
    this.trailing,
    this.iconColor,
    this.showBadge = false,
    this.badgeText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: type != SettingsItemType.toggle ? onTap : null,
      borderRadius: BorderRadius.circular(3.w),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 3.h),
        child: Row(
          children: [
            Stack(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    color: (iconColor ?? theme.colorScheme.primary)
                        .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: iconName,
                      color: iconColor ?? theme.colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                ),
                if (showBadge)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.error,
                        shape: BoxShape.circle,
                      ),
                      constraints: BoxConstraints(
                        minWidth: 4.w,
                        minHeight: 4.w,
                      ),
                      child: badgeText != null
                          ? Text(
                              badgeText!,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontSize: 8.sp,
                              ),
                              textAlign: TextAlign.center,
                            )
                          : null,
                    ),
                  ),
              ],
            ),
            SizedBox(width: 4.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                  if (selectedValue != null) ...[
                    SizedBox(height: 0.5.h),
                    Text(
                      selectedValue!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            _buildTrailing(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTrailing(BuildContext context, ThemeData theme) {
    if (trailing != null) return trailing!;

    switch (type) {
      case SettingsItemType.toggle:
        return Switch(
          value: switchValue ?? false,
          onChanged: onSwitchChanged,
        );
      case SettingsItemType.navigation:
      case SettingsItemType.selection:
        return CustomIconWidget(
          iconName: 'chevron_right',
          color: theme.colorScheme.onSurfaceVariant,
          size: 5.w,
        );
      case SettingsItemType.action:
        return const SizedBox.shrink();
    }
  }
}
