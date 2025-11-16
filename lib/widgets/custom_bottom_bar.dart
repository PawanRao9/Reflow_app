import 'package:flutter/material.dart';

/// Custom bottom navigation bar for healthcare B2B application
/// Provides navigation to core application functions with professional styling
class CustomBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  static const List<BottomNavigationBarItem> _navigationItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.shopping_cart_outlined),
      activeIcon: Icon(Icons.shopping_cart),
      label: 'Cart',
      tooltip: 'Bulk Order Cart',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.receipt_long_outlined),
      activeIcon: Icon(Icons.receipt_long),
      label: 'Checkout',
      tooltip: 'Order Checkout',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.history_outlined),
      activeIcon: Icon(Icons.history),
      label: 'History',
      tooltip: 'Order History',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business_outlined),
      activeIcon: Icon(Icons.business),
      label: 'Suppliers',
      tooltip: 'Supplier Directory',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
      tooltip: 'Profile Settings',
    ),
  ];

  static const List<String> _routes = [
    '/bulk-order-cart',
    '/order-checkout',
    '/order-history',
    '/supplier-directory',
    '/profile-settings',
  ];

  void _handleNavigation(BuildContext context, int index) {
    if (index != currentIndex && index < _routes.length) {
      Navigator.pushNamed(context, _routes[index]);
    }
    onTap?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex.clamp(0, _navigationItems.length - 1),
          onTap: (index) => _handleNavigation(context, index),
          items: _navigationItems,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.colorScheme.onSurfaceVariant,
          selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
          unselectedLabelStyle:
              theme.bottomNavigationBarTheme.unselectedLabelStyle,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          enableFeedback: true,
        ),
      ),
    );
  }
}
