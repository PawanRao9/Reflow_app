import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import './settings_item_widget.dart';

class NotificationPreferencesWidget extends StatefulWidget {
  final Map<String, bool> preferences;
  final ValueChanged<Map<String, bool>>? onPreferencesChanged;

  const NotificationPreferencesWidget({
    super.key,
    required this.preferences,
    this.onPreferencesChanged,
  });

  @override
  State<NotificationPreferencesWidget> createState() =>
      _NotificationPreferencesWidgetState();
}

class _NotificationPreferencesWidgetState
    extends State<NotificationPreferencesWidget> {
  late Map<String, bool> _preferences;

  final List<Map<String, dynamic>> notificationTypes = [
    {
      "key": "orderUpdates",
      "title": "Order Updates",
      "subtitle": "Get notified about order status changes",
      "icon": "shopping_bag",
    },
    {
      "key": "lowStock",
      "title": "Low Stock Alerts",
      "subtitle": "Alerts when inventory is running low",
      "icon": "inventory_2",
    },
    {
      "key": "newProducts",
      "title": "New Products",
      "subtitle": "Notifications about new product arrivals",
      "icon": "new_releases",
    },
    {
      "key": "priceChanges",
      "title": "Price Changes",
      "subtitle": "Updates on product price modifications",
      "icon": "trending_up",
    },
    {
      "key": "promotions",
      "title": "Promotions & Offers",
      "subtitle": "Special deals and discount notifications",
      "icon": "local_offer",
    },
    {
      "key": "systemUpdates",
      "title": "System Updates",
      "subtitle": "App updates and maintenance notifications",
      "icon": "system_update",
    },
    {
      "key": "marketing",
      "title": "Marketing Communications",
      "subtitle": "Newsletter and marketing content",
      "icon": "campaign",
    },
  ];

  @override
  void initState() {
    super.initState();
    _preferences = Map.from(widget.preferences);
  }

  void _updatePreference(String key, bool value) {
    setState(() {
      _preferences[key] = value;
    });
    widget.onPreferencesChanged?.call(_preferences);
  }

  void _showNotificationSettings(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(6.w)),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
              ),
              child: Row(
                children: [
                  Text(
                    "Notification Preferences",
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: theme.colorScheme.onSurfaceVariant,
                      size: 6.w,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                itemCount: notificationTypes.length,
                itemBuilder: (context, index) {
                  final notificationType = notificationTypes[index];
                  final key = notificationType["key"] as String;
                  final isEnabled = _preferences[key] ?? true;

                  return Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(3.w),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 10.w,
                          height: 10.w,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(2.w),
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: notificationType["icon"] as String,
                              color: theme.colorScheme.primary,
                              size: 5.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notificationType["title"] as String,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              Text(
                                notificationType["subtitle"] as String,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isEnabled,
                          onChanged: (value) => _updatePreference(key, value),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _getEnabledCount() {
    return _preferences.values.where((enabled) => enabled).length;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsItemWidget(
      title: "Notification Preferences",
      subtitle: "Manage your notification settings",
      iconName: 'notifications',
      type: SettingsItemType.selection,
      selectedValue:
          "${_getEnabledCount()} of ${notificationTypes.length} enabled",
      onTap: () => _showNotificationSettings(context),
    );
  }
}
