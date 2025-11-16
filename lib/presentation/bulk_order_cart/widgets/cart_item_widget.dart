import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CartItemWidget extends StatefulWidget {
  final Map<String, dynamic> item;
  final VoidCallback? onRemove;
  final Function(int)? onQuantityChanged;
  final VoidCallback? onMoveToWishlist;
  final VoidCallback? onDuplicate;
  final VoidCallback? onViewAlternatives;

  const CartItemWidget({
    super.key,
    required this.item,
    this.onRemove,
    this.onQuantityChanged,
    this.onMoveToWishlist,
    this.onDuplicate,
    this.onViewAlternatives,
  });

  @override
  State<CartItemWidget> createState() => _CartItemWidgetState();
}

class _CartItemWidgetState extends State<CartItemWidget>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int _quantity = 1;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _quantity = widget.item['quantity'] ?? 1;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity < 1) return;

    setState(() {
      _isUpdating = true;
      _quantity = newQuantity;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    widget.onQuantityChanged?.call(newQuantity);

    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _isUpdating = false;
        });
      }
    });
  }

  void _showContextMenu() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.outline,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'favorite_border',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Move to Wishlist',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onMoveToWishlist?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'content_copy',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'Duplicate Order',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onDuplicate?.call();
                },
              ),
              ListTile(
                leading: CustomIconWidget(
                  iconName: 'compare_arrows',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 24,
                ),
                title: Text(
                  'View Alternatives',
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
                onTap: () {
                  Navigator.pop(context);
                  widget.onViewAlternatives?.call();
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  double _calculateDiscount() {
    final unitPrice = (widget.item['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final discountPercent =
        (widget.item['bulkDiscountPercent'] as num?)?.toDouble() ?? 0.0;
    return unitPrice * _quantity * (discountPercent / 100);
  }

  double _calculateLineTotal() {
    final unitPrice = (widget.item['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final total = unitPrice * _quantity;
    return total - _calculateDiscount();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unitPrice = (widget.item['unitPrice'] as num?)?.toDouble() ?? 0.0;
    final bulkDiscountPercent =
        (widget.item['bulkDiscountPercent'] as num?)?.toDouble() ?? 0.0;
    final minOrderQty = (widget.item['minOrderQty'] as num?)?.toInt() ?? 1;
    final stockAvailable =
        (widget.item['stockAvailable'] as num?)?.toInt() ?? 0;
    final discount = _calculateDiscount();
    final lineTotal = _calculateLineTotal();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Dismissible(
            key: Key(widget.item['id'].toString()),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'delete',
                    color: theme.colorScheme.onError,
                    size: 24,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Remove',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onError,
                    ),
                  ),
                ],
              ),
            ),
            confirmDismiss: (direction) async {
              return await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Remove Item'),
                  content: const Text(
                      'Are you sure you want to remove this item from your cart?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Remove'),
                    ),
                  ],
                ),
              );
            },
            onDismissed: (direction) {
              widget.onRemove?.call();
            },
            child: GestureDetector(
              onLongPress: _showContextMenu,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Image
                        Container(
                          width: 20.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl: widget.item['image'] ?? '',
                              width: 20.w,
                              height: 20.w,
                              fit: BoxFit.cover,
                              semanticLabel: widget.item['semanticLabel'] ??
                                  'Product image',
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        // Product Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.item['name'] ?? '',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              if (widget.item['brand'] != null)
                                Text(
                                  'by ${widget.item['brand']}',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    '₹${unitPrice.toStringAsFixed(2)}',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'per unit',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                              if (stockAvailable < 10)
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.error
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Only $stockAvailable left',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.error,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Quantity Controls and Pricing
                    Row(
                      children: [
                        // Quantity Controls
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: _quantity > minOrderQty
                                    ? () => _updateQuantity(_quantity - 1)
                                    : null,
                                icon: CustomIconWidget(
                                  iconName: 'remove',
                                  color: _quantity > minOrderQty
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                              Container(
                                width: 60,
                                alignment: Alignment.center,
                                child: _isUpdating
                                    ? SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            theme.colorScheme.primary,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        _quantity.toString(),
                                        style: theme.textTheme.titleMedium
                                            ?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                              IconButton(
                                onPressed: _quantity < stockAvailable
                                    ? () => _updateQuantity(_quantity + 1)
                                    : null,
                                icon: CustomIconWidget(
                                  iconName: 'add',
                                  color: _quantity < stockAvailable
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                  size: 20,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 40,
                                  minHeight: 40,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Pricing
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (discount > 0) ...[
                              Text(
                                '₹${(unitPrice * _quantity).toStringAsFixed(2)}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  decoration: TextDecoration.lineThrough,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.successLight
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      '${bulkDiscountPercent.toInt()}% OFF',
                                      style:
                                          theme.textTheme.labelSmall?.copyWith(
                                        color: AppTheme.successLight,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '₹${lineTotal.toStringAsFixed(2)}',
                                    style:
                                        theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ] else
                              Text(
                                '₹${lineTotal.toStringAsFixed(2)}',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    if (_quantity < minOrderQty)
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.warningLight.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppTheme.warningLight.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            CustomIconWidget(
                              iconName: 'info',
                              color: AppTheme.warningLight,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Minimum order quantity: $minOrderQty units',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppTheme.warningLight,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
