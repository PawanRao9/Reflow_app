import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductCardWidget extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final VoidCallback? onCompare;
  final VoidCallback? onShare;
  final Function(int)? onQuantityChanged;

  const ProductCardWidget({
    Key? key,
    required this.product,
    this.onTap,
    this.onFavorite,
    this.onCompare,
    this.onShare,
    this.onQuantityChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isInStock = (product['stock'] as int? ?? 0) > 0;
    final bool isLowStock = (product['stock'] as int? ?? 0) <=
        (product['minOrderQuantity'] as int? ?? 1);

    return GestureDetector(
      onTap: onTap,
      onLongPress: () => _showQuickActions(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color:
                  AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with Stock Status
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CustomImageWidget(
                    imageUrl: product['image'] as String? ?? '',
                    width: double.infinity,
                    height: 20.h,
                    fit: BoxFit.cover,
                    semanticLabel:
                        product['semanticLabel'] as String? ?? 'Product image',
                  ),
                ),
                // Stock Status Badge
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isInStock
                          ? (isLowStock
                              ? AppTheme.getWarningColor(true)
                              : AppTheme.getSuccessColor(true))
                          : AppTheme.lightTheme.colorScheme.error,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      isInStock
                          ? (isLowStock ? 'Low Stock' : 'In Stock')
                          : 'Out of Stock',
                      style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Favorite Button
                Positioned(
                  top: 8,
                  left: 8,
                  child: GestureDetector(
                    onTap: onFavorite,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: (product['isFavorite'] as bool? ?? false)
                            ? 'favorite'
                            : 'favorite_border',
                        color: (product['isFavorite'] as bool? ?? false)
                            ? AppTheme.lightTheme.colorScheme.error
                            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Product Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name
                    Text(
                      product['name'] as String? ?? '',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Brand
                    Text(
                      product['brand'] as String? ?? '',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Bulk Pricing
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'Bulk: ${product['bulkPrice'] as String? ?? ''}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Minimum Order Quantity
                    Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'shopping_cart',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Min: ${product['minOrderQuantity'] as int? ?? 1} units',
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Quick Order Section
                    if (isInStock) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 32,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.lightTheme.colorScheme.outline
                                      .withValues(alpha: 0.3),
                                ),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _decrementQuantity(),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(6),
                                          bottomLeft: Radius.circular(6),
                                        ),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'remove',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Text(
                                        '${product['selectedQuantity'] as int? ?? (product['minOrderQuantity'] as int? ?? 1)}',
                                        style: AppTheme
                                            .lightTheme.textTheme.labelMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => _incrementQuantity(),
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        color: AppTheme
                                            .lightTheme.colorScheme.surface,
                                        borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'add',
                                        color: AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQuickActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'favorite_border',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Add to Favorites',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onFavorite?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'compare_arrows',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Compare',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onCompare?.call();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Share Details',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                onShare?.call();
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _incrementQuantity() {
    final currentQuantity = product['selectedQuantity'] as int? ??
        (product['minOrderQuantity'] as int? ?? 1);
    final maxStock = product['stock'] as int? ?? 0;
    if (currentQuantity < maxStock) {
      onQuantityChanged?.call(currentQuantity + 1);
    }
  }

  void _decrementQuantity() {
    final currentQuantity = product['selectedQuantity'] as int? ??
        (product['minOrderQuantity'] as int? ?? 1);
    final minQuantity = product['minOrderQuantity'] as int? ?? 1;
    if (currentQuantity > minQuantity) {
      onQuantityChanged?.call(currentQuantity - 1);
    }
  }
}
