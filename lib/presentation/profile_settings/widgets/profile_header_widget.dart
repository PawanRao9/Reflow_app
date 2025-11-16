import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback? onEditProfile;

  const ProfileHeaderWidget({
    super.key,
    required this.userData,
    this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(6.w),
          bottomRight: Radius.circular(6.w),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 2.h),
            Stack(
              children: [
                Container(
                  width: 25.w,
                  height: 25.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: theme.colorScheme.onPrimary,
                      width: 3,
                    ),
                  ),
                  child: ClipOval(
                    child: CustomImageWidget(
                      imageUrl: userData["avatar"] as String? ?? "",
                      width: 25.w,
                      height: 25.w,
                      fit: BoxFit.cover,
                      semanticLabel:
                          userData["avatarSemanticLabel"] as String? ??
                              "User profile avatar",
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditProfile,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.onPrimary,
                          width: 2,
                        ),
                      ),
                      child: CustomIconWidget(
                        iconName: 'edit',
                        color: theme.colorScheme.onTertiary,
                        size: 4.w,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 3.h),
            Text(
              userData["businessName"] as String? ?? "Business Name",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5.w),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomIconWidget(
                    iconName: _getAccountTypeIcon(
                        userData["accountType"] as String? ?? ""),
                    color: theme.colorScheme.onPrimary,
                    size: 4.w,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    userData["accountType"] as String? ?? "Account Type",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              userData["email"] as String? ?? "email@example.com",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  String _getAccountTypeIcon(String accountType) {
    switch (accountType.toLowerCase()) {
      case 'pharmacy':
        return 'local_pharmacy';
      case 'distributor':
        return 'business';
      case 'shg':
        return 'groups';
      default:
        return 'account_circle';
    }
  }
}
