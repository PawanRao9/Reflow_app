import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RelatedProducts extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const RelatedProducts({
    Key? key,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 2.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'recommend',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Related Products',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 2.h),

          // Horizontal scrollable list
          SizedBox(
            height: 35.h,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, Map<String, dynamic> product) {
    return Container(
      width: 45.w,
      margin: EdgeInsets.only(right: 3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Container(
            height: 20.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.w),
                topRight: Radius.circular(3.w),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(3.w),
                topRight: Radius.circular(3.w),
              ),
              child: CustomImageWidget(
                imageUrl: product["image"] as String,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                semanticLabel: product["semanticLabel"] as String,
              ),
            ),
          ),

          // Product details
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    product["name"] as String,
                    style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 1.h),

                  // Brand
                  Text(
                    product["brand"] as String,
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Rating
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'star',
                        color: AppTheme.getWarningColor(true),
                        size: 3.w,
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        product["rating"].toString(),
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        '(${product["reviewCount"]})',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  Spacer(),

                  // Price and minimum order
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '₹${product["price"]}',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                      Text(
                        'Min: ${product["minOrder"]} units',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // View button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/product-detail-screen');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.lightTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 1.5.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.w),
                        ),
                      ),
                      child: Text(
                        'View Details',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
