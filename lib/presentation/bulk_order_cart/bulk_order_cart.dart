import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/bulk_discount_calculator_widget.dart';
import './widgets/cart_item_widget.dart';
import './widgets/empty_cart_widget.dart';
import './widgets/order_summary_widget.dart';

class BulkOrderCart extends StatefulWidget {
  const BulkOrderCart({super.key});

  @override
  State<BulkOrderCart> createState() => _BulkOrderCartState();
}

class _BulkOrderCartState extends State<BulkOrderCart>
    with TickerProviderStateMixin {
  late AnimationController _refreshController;
  late Animation<double> _refreshAnimation;
  // ignore: unused_field
  bool _isRefreshing = false;
  bool _showBulkCalculator = false;
  int _selectedItemForCalculator = -1;

  // Mock cart data
  final List<Map<String, dynamic>> _cartItems = [
    {
      "id": 1,
      "name": "Reusable Menstrual Cup - Size A",
      "brand": "EcoFlow",
      "image":
          "https://images.unsplash.com/photo-1605213786077-c3aac52e6c9b",
      "semanticLabel":
          "Pink silicone menstrual cup with storage pouch on white background",
      "unitPrice": 850.0,
      "quantity": 25,
      "minOrderQty": 10,
      "stockAvailable": 150,
      "bulkDiscountPercent": 15.0,
      "category": "Menstrual Cups"
    },
    {
      "id": 2,
      "name": "Organic Cotton Reusable Pads - Heavy Flow",
      "brand": "NatureCare",
      "image":
          "https://images.unsplash.com/photo-1712677178403-a10c29e8797e",
      "semanticLabel":
          "Stack of white organic cotton menstrual pads with floral pattern on wooden surface",
      "unitPrice": 320.0,
      "quantity": 50,
      "minOrderQty": 20,
      "stockAvailable": 200,
      "bulkDiscountPercent": 12.0,
      "category": "Reusable Pads"
    },
    {
      "id": 3,
      "name": "Period Panties - Moderate Absorbency",
      "brand": "ComfortFit",
      "image":
          "https://images.unsplash.com/photo-1703498051376-97b0f4dbeb99",
      "semanticLabel":
          "Black period underwear laid flat showing absorbent layer design",
      "unitPrice": 450.0,
      "quantity": 30,
      "minOrderQty": 15,
      "stockAvailable": 80,
      "bulkDiscountPercent": 10.0,
      "category": "Period Panties"
    },
  ];

  // Bulk discount tiers
  final List<Map<String, dynamic>> _discountTiers = [
    {"minQuantity": 10, "discountPercent": 5.0},
    {"minQuantity": 25, "discountPercent": 10.0},
    {"minQuantity": 50, "discountPercent": 15.0},
    {"minQuantity": 100, "discountPercent": 20.0},
    {"minQuantity": 200, "discountPercent": 25.0},
  ];

  @override
  void initState() {
    super.initState();
    _refreshController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _refreshAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _refreshController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    _refreshController.forward();

    // Simulate API call for price and availability updates
    await Future.delayed(const Duration(seconds: 2));

    _refreshController.reverse();

    setState(() {
      _isRefreshing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Prices and availability updated!'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  void _removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Item removed from cart'),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _updateQuantity(int index, int newQuantity) {
    setState(() {
      _cartItems[index]['quantity'] = newQuantity;
    });

    // Check if bulk discount calculator should be shown
  final quantity = newQuantity;
    final hasReachedTier = _discountTiers.any((tier) =>
        quantity >= (tier['minQuantity'] as int) &&
        quantity < (tier['minQuantity'] as int) + 5);

    if (hasReachedTier && !_showBulkCalculator) {
      setState(() {
        _showBulkCalculator = true;
        _selectedItemForCalculator = index;
      });
    }
  }

  void _moveToWishlist(int index) {
    final item = _cartItems[index];
    setState(() {
      _cartItems.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} moved to wishlist'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _duplicateOrder(int index) {
    final item = Map<String, dynamic>.from(_cartItems[index]);
    item['id'] = DateTime.now().millisecondsSinceEpoch;
    setState(() {
      _cartItems.add(item);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item['name']} duplicated'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewAlternatives(int index) {
    final item = _cartItems[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing alternatives for ${item['name']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Map<String, dynamic> _calculateOrderSummary() {
    double subtotal = 0.0;
    double totalDiscount = 0.0;
    int totalItems = 0;

    for (final item in _cartItems) {
      final unitPrice = (item['unitPrice'] as num).toDouble();
      final quantity = (item['quantity'] as num).toInt();
      final discountPercent = (item['bulkDiscountPercent'] as num).toDouble();

      final itemTotal = unitPrice * quantity;
      final itemDiscount = itemTotal * (discountPercent / 100);

      subtotal += itemTotal;
      totalDiscount += itemDiscount;
      totalItems += quantity;
    }

    final afterDiscount = subtotal - totalDiscount;
    final estimatedTax = afterDiscount * 0.18; // 18% GST
    final grandTotal = afterDiscount + estimatedTax;
    final bulkSavings = totalDiscount;

    return {
      'subtotal': subtotal,
      'totalDiscount': totalDiscount,
      'estimatedTax': estimatedTax,
      'grandTotal': grandTotal,
      'totalItems': totalItems,
      'bulkSavings': bulkSavings,
    };
  }

  bool _isCheckoutEnabled() {
    for (final item in _cartItems) {
      final quantity = (item['quantity'] as num).toInt();
      final minOrderQty = (item['minOrderQty'] as num).toInt();
      final stockAvailable = (item['stockAvailable'] as num).toInt();

      if (quantity < minOrderQty || quantity > stockAvailable) {
        return false;
      }
    }
    return _cartItems.isNotEmpty;
  }

  void _proceedToCheckout() {
    if (_isCheckoutEnabled()) {
      Navigator.pushNamed(context, '/order-checkout');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final orderSummary = _calculateOrderSummary();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'Bulk Order Cart',
        variant: CustomAppBarVariant.back,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                onPressed: () {},
              ),
              if (_cartItems.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      _cartItems.length.toString(),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onError,
                        fontWeight: FontWeight.w600,
                        fontSize: 10,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'more_vert',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Show more options
            },
          ),
        ],
      ),
      body: _cartItems.isEmpty
          ? EmptyCartWidget(
              onContinueShopping: () {
                Navigator.pushNamed(context, '/supplier-directory');
              },
            )
          : Column(
              children: [
                // Header with total items and estimated value
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${orderSummary['totalItems']} items in cart',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'Estimated value: ₹${orderSummary['grandTotal'].toStringAsFixed(2)}',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (orderSummary['bulkSavings'] > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.successLight.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color:
                                  AppTheme.successLight.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomIconWidget(
                                iconName: 'savings',
                                color: AppTheme.successLight,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Saving ₹${orderSummary['bulkSavings'].toStringAsFixed(0)}',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: AppTheme.successLight,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Cart Items List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: AnimatedBuilder(
                      animation: _refreshAnimation,
                      builder: (context, child) {
                        return Transform.rotate(
                          angle: _refreshAnimation.value * 0.1,
                          child: ListView.builder(
                            padding: EdgeInsets.only(
                              bottom: _showBulkCalculator ? 0 : 20.h,
                            ),
                            itemCount: _cartItems.length +
                                (_showBulkCalculator ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (_showBulkCalculator &&
                                  index == _selectedItemForCalculator + 1) {
                                final item =
                                    _cartItems[_selectedItemForCalculator];
                                return BulkDiscountCalculatorWidget(
                                  discountTiers: _discountTiers,
                                  currentQuantity: item['quantity'],
                                  unitPrice:
                                      (item['unitPrice'] as num).toDouble(),
                                  onClose: () {
                                    setState(() {
                                      _showBulkCalculator = false;
                                      _selectedItemForCalculator = -1;
                                    });
                                  },
                                );
                              }

                              final itemIndex = _showBulkCalculator &&
                                      index > _selectedItemForCalculator + 1
                                  ? index - 1
                                  : index;

                              if (itemIndex >= _cartItems.length) {
                                return const SizedBox();
                              }

                              return CartItemWidget(
                                key:
                                    Key(_cartItems[itemIndex]['id'].toString()),
                                item: _cartItems[itemIndex],
                                onRemove: () => _removeItem(itemIndex),
                                onQuantityChanged: (quantity) =>
                                    _updateQuantity(itemIndex, quantity),
                                onMoveToWishlist: () =>
                                    _moveToWishlist(itemIndex),
                                onDuplicate: () => _duplicateOrder(itemIndex),
                                onViewAlternatives: () =>
                                    _viewAlternatives(itemIndex),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _cartItems.isEmpty
          ? const CustomBottomBar(currentIndex: 0)
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OrderSummaryWidget(
                  summary: orderSummary,
                  isCheckoutEnabled: _isCheckoutEnabled(),
                  onProceedToCheckout: _proceedToCheckout,
                ),
                const CustomBottomBar(currentIndex: 0),
              ],
            ),
    );
  }
}
