import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ActiveSessionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> sessions;
  final ValueChanged<String>? onTerminateSession;

  const ActiveSessionsWidget({
    super.key,
    required this.sessions,
    this.onTerminateSession,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 2.w, bottom: 1.h),
            child: Text(
              "Active Sessions",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(3.w),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: sessions.asMap().entries.map((entry) {
                final index = entry.key;
                final session = entry.value;

                return Column(
                  children: [
                    _buildSessionItem(context, theme, session),
                    if (index < sessions.length - 1)
                      Divider(
                        height: 1,
                        thickness: 1,
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                        indent: 4.w,
                        endIndent: 4.w,
                      ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionItem(
      BuildContext context, ThemeData theme, Map<String, dynamic> session) {
    final String deviceName = session["deviceName"] as String? ?? "";
    final String location = session["location"] as String? ?? "";
    final String lastActive = session["lastActive"] as String? ?? "";
    final bool isCurrent = session["isCurrent"] as bool? ?? false;
    final String sessionId = session["sessionId"] as String? ?? "";
    final String deviceType = session["deviceType"] as String? ?? "mobile";

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Row(
        children: [
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: _getDeviceIcon(deviceType),
                color: theme.colorScheme.primary,
                size: 6.w,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        deviceName,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isCurrent)
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 2.w, vertical: 0.5.h),
                        decoration: BoxDecoration(
                          color:
                              theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(1.w),
                        ),
                        child: Text(
                          "Current",
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                Text(
                  location,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  "Last active: $lastActive",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (!isCurrent)
            TextButton(
              onPressed: () =>
                  _showTerminateConfirmation(context, sessionId, deviceName),
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              ),
              child: Text(
                "Terminate",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _showTerminateConfirmation(
      BuildContext context, String sessionId, String deviceName) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Terminate Session",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to terminate the session on $deviceName? This will log out the device immediately.",
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              onTerminateSession?.call(sessionId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
            ),
            child: Text("Terminate"),
          ),
        ],
      ),
    );
  }

  String _getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'mobile':
      case 'phone':
        return 'phone_android';
      case 'tablet':
        return 'tablet';
      case 'desktop':
      case 'computer':
        return 'computer';
      case 'web':
        return 'web';
      default:
        return 'devices';
    }
  }
}
