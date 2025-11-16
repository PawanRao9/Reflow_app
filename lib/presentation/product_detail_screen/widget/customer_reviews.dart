import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CustomerReviews extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  final double averageRating;
  final int totalReviews;

  const CustomerReviews({
    Key? key,
    required this.reviews,
    required this.averageRating,
    required this.totalReviews,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with rating summary
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.w),
                topRight: Radius.circular(3.w),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'star',
                      color: AppTheme.getWarningColor(true),
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Customer Reviews',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Rating summary
                Row(
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    _buildStarRating(averageRating),
                    SizedBox(width: 2.w),
                    Text(
                      '($totalReviews reviews)',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            height: 0.5,
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),

          // Reviews list
          ...reviews.take(3).map((review) => _buildReviewItem(review)).toList(),

          // View all reviews button
          if (reviews.length > 3)
            Container(
              padding: EdgeInsets.all(4.w),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    // Navigate to all reviews screen
                  },
                  child: Text(
                    'View All ${totalReviews} Reviews',
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      color: AppTheme.lightTheme.primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(Map<String, dynamic> review) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reviewer info and rating
          Row(
            children: [
              Container(
                width: 10.w,
                height: 10.w,
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Center(
                  child: Text(
                    (review["reviewerName"] as String)
                        .substring(0, 1)
                        .toUpperCase(),
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppTheme.lightTheme.primaryColor,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review["reviewerName"] as String,
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Row(
                      children: [
                        _buildStarRating(review["rating"] as double),
                        SizedBox(width: 2.w),
                        Text(
                          review["date"] as String,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (review["verified"] as bool? ?? false)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color:
                        AppTheme.getSuccessColor(true).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(1.h),
                    border: Border.all(
                      color:
                          AppTheme.getSuccessColor(true).withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomIconWidget(
                        iconName: 'verified',
                        color: AppTheme.getSuccessColor(true),
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        'Verified',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.getSuccessColor(true),
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          SizedBox(height: 2.h),

          // Review content
          Text(
            review["comment"] as String,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          // Business type tag
          if (review["businessType"] != null) ...[
            SizedBox(height: 1.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.secondaryContainer
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(1.h),
              ),
              child: Text(
                review["businessType"] as String,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSecondaryContainer,
                  fontSize: 8.sp,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStarRating(double rating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return CustomIconWidget(
            iconName: 'star',
            color: AppTheme.getWarningColor(true),
            size: 4.w,
          );
        } else if (index < rating) {
          return CustomIconWidget(
            iconName: 'star_half',
            color: AppTheme.getWarningColor(true),
            size: 4.w,
          );
        } else {
          return CustomIconWidget(
            iconName: 'star_border',
            color: AppTheme.lightTheme.colorScheme.outline,
            size: 4.w,
          );
        }
      }),
    );
  }
}
