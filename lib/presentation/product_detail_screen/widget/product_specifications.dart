import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductSpecifications extends StatefulWidget {
  final Map<String, dynamic> specifications;

  const ProductSpecifications({
    Key? key,
    required this.specifications,
  }) : super(key: key);

  @override
  State<ProductSpecifications> createState() => _ProductSpecificationsState();
}

class _ProductSpecificationsState extends State<ProductSpecifications> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final basicSpecs =
        widget.specifications["basic"] as List<Map<String, dynamic>>? ?? [];
    final detailedSpecs =
        widget.specifications["detailed"] as List<Map<String, dynamic>>? ?? [];
    final certifications = widget.specifications["certifications"]
            as List<Map<String, dynamic>>? ??
        [];

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
          // Header
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(3.w),
                  topRight: Radius.circular(3.w),
                  bottomLeft: _isExpanded ? Radius.zero : Radius.circular(3.w),
                  bottomRight: _isExpanded ? Radius.zero : Radius.circular(3.w),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'description',
                    color: AppTheme.lightTheme.primaryColor,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Product Specifications',
                      style:
                          AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  CustomIconWidget(
                    iconName: _isExpanded ? 'expand_less' : 'expand_more',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 6.w,
                  ),
                ],
              ),
            ),
          ),

          // Basic specifications (always visible)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Key Details',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
                SizedBox(height: 1.h),
                ...basicSpecs
                    .map((spec) => _buildSpecificationRow(
                          spec["label"] as String,
                          spec["value"] as String,
                          spec["icon"] as String?,
                        ))
                    .toList(),
              ],
            ),
          ),

          // Expanded content
          if (_isExpanded) ...[
            Container(
              width: double.infinity,
              height: 0.5,
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.2),
            ),

            // Detailed specifications
            if (detailedSpecs.isNotEmpty) ...[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Detailed Specifications',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.lightTheme.primaryColor,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...detailedSpecs
                        .map((spec) => _buildSpecificationRow(
                              spec["label"] as String,
                              spec["value"] as String,
                              spec["icon"] as String?,
                            ))
                        .toList(),
                  ],
                ),
              ),
            ],

            // Certifications
            if (certifications.isNotEmpty) ...[
              Container(
                width: double.infinity,
                height: 0.5,
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.2),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Certifications & Compliance',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.getSuccessColor(true),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Wrap(
                      spacing: 2.w,
                      runSpacing: 1.h,
                      children: certifications
                          .map((cert) => Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 3.w, vertical: 1.h),
                                decoration: BoxDecoration(
                                  color: AppTheme.getSuccessColor(true)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(2.h),
                                  border: Border.all(
                                    color: AppTheme.getSuccessColor(true)
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'verified',
                                      color: AppTheme.getSuccessColor(true),
                                      size: 4.w,
                                    ),
                                    SizedBox(width: 1.w),
                                    Text(
                                      cert["name"] as String,
                                      style: AppTheme
                                          .lightTheme.textTheme.labelSmall
                                          ?.copyWith(
                                        color: AppTheme.getSuccessColor(true),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildSpecificationRow(String label, String value, String? iconName) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (iconName != null) ...[
            CustomIconWidget(
              iconName: iconName,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 4.w,
            ),
            SizedBox(width: 2.w),
          ],
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
