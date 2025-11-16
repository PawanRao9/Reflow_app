import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class VerificationStatusWidget extends StatelessWidget {
  final Map<String, dynamic> verificationData;

  const VerificationStatusWidget({
    super.key,
    required this.verificationData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isVerified = verificationData["isVerified"] as bool? ?? false;
    final String status = verificationData["status"] as String? ?? "pending";
    final List<dynamic> documents =
        verificationData["documents"] as List<dynamic>? ?? [];

    return Container(
      padding: EdgeInsets.all(4.w),
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: _getStatusColor(status, theme).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: _getStatusColor(status, theme).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(2.w),
                ),
                child: CustomIconWidget(
                  iconName: _getStatusIcon(status),
                  color: _getStatusColor(status, theme),
                  size: 5.w,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Verification Status",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status, theme)
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(1.w),
                      ),
                      child: Text(
                        _getStatusText(status),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: _getStatusColor(status, theme),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (documents.isNotEmpty) ...[
            SizedBox(height: 3.h),
            Text(
              "Submitted Documents",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.h),
            ...documents.map((doc) => _buildDocumentItem(
                context, theme, doc as Map<String, dynamic>)),
          ],
          if (!isVerified) ...[
            SizedBox(height: 3.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle document upload
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: Text("Upload Documents"),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDocumentItem(
      BuildContext context, ThemeData theme, Map<String, dynamic> doc) {
    final String name = doc["name"] as String? ?? "";
    final String status = doc["status"] as String? ?? "pending";

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(2.w),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'description',
            color: theme.colorScheme.onSurfaceVariant,
            size: 4.w,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              name,
              style: theme.textTheme.bodyMedium,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
            decoration: BoxDecoration(
              color: _getStatusColor(status, theme).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.w),
            ),
            child: Text(
              status.toUpperCase(),
              style: theme.textTheme.labelSmall?.copyWith(
                color: _getStatusColor(status, theme),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status, ThemeData theme) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        return theme.colorScheme.primary;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return theme.colorScheme.error;
      default:
        return theme.colorScheme.onSurfaceVariant;
    }
  }

  String _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        return 'verified';
      case 'pending':
        return 'schedule';
      case 'rejected':
        return 'cancel';
      default:
        return 'help_outline';
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'verified':
        return 'Verified';
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Under Review';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }
}
