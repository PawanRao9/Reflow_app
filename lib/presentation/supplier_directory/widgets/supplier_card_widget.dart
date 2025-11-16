import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SupplierCardWidget extends StatelessWidget {
  final Map<String, dynamic> supplier;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onCall;
  final VoidCallback? onWhatsApp;
  final VoidCallback? onEmail;
  final VoidCallback? onViewCatalog;

  const SupplierCardWidget({
    super.key,
    required this.supplier,
    this.onTap,
    this.onFavoriteToggle,
    this.onCall,
    this.onWhatsApp,
    this.onEmail,
    this.onViewCatalog,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isFavorite = supplier['isFavorite'] as bool? ?? false;
    final rating = (supplier['rating'] as num?)?.toDouble() ?? 0.0;
    final specializations =
        (supplier['specializations'] as List?)?.cast<String>() ?? [];

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with logo, name, and favorite
              Row(
                children: [
                  // Company logo
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CustomImageWidget(
                        imageUrl: supplier['logo'] as String? ?? '',
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                        semanticLabel:
                            supplier['logoSemanticLabel'] as String? ??
                                'Company logo',
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  // Company name and location
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier['name'] as String? ?? 'Unknown Supplier',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 0.5.h),
                        Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'location_on',
                              size: 14,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            SizedBox(width: 1.w),
                            Expanded(
                              child: Text(
                                supplier['location'] as String? ??
                                    'Location not specified',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Favorite button
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: CustomIconWidget(
                      iconName: isFavorite ? 'favorite' : 'favorite_border',
                      size: 20,
                      color: isFavorite
                          ? Colors.red
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Rating and metrics
              Row(
                children: [
                  // Rating stars
                  Row(
                    children: List.generate(5, (index) {
                      return CustomIconWidget(
                        iconName:
                            index < rating.floor() ? 'star' : 'star_border',
                        size: 16,
                        color: Colors.amber,
                      );
                    }),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    rating.toStringAsFixed(1),
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  // Response time
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Response: ${supplier['responseTime'] as String? ?? 'N/A'}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.5.h),

              // Specialization tags
              if (specializations.isNotEmpty)
                Wrap(
                  spacing: 2.w,
                  runSpacing: 1.h,
                  children: specializations.map((spec) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 3.w, vertical: 0.8.h),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: theme.colorScheme.secondary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        spec,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              SizedBox(height: 2.h),

              // Order fulfillment rate
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'check_circle_outline',
                    size: 16,
                    color: AppTheme.successLight,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Fulfillment Rate: ${supplier['fulfillmentRate'] as String? ?? 'N/A'}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.successLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onCall,
                      icon: CustomIconWidget(
                        iconName: 'phone',
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text('Call'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onWhatsApp,
                      icon: CustomIconWidget(
                        iconName: 'chat',
                        size: 16,
                        color: Colors.green,
                      ),
                      label: Text('WhatsApp'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                        side: BorderSide(color: Colors.green),
                        foregroundColor: Colors.green,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: onEmail,
                      icon: CustomIconWidget(
                        iconName: 'email',
                        size: 16,
                        color: theme.colorScheme.primary,
                      ),
                      label: Text('Email'),
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: onViewCatalog,
                      icon: CustomIconWidget(
                        iconName: 'inventory_2',
                        size: 16,
                        color: theme.colorScheme.onPrimary,
                      ),
                      label: Text('Catalog'),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 1.2.h),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
