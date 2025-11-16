import 'package:flutter/material.dart';
import '../presentation/bulk_order_cart/bulk_order_cart.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/order_history/order_history.dart';
import '../presentation/order_checkout/order_checkout.dart';
import '../presentation/supplier_directory/supplier_directory.dart';
import '../presentation/profile_settings/profile_settings.dart';
import '../presentation/dashboard/dashboard.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/inventory_management/inventory_management.dart';
import '../presentation/product_catalog/product_catalog.dart';
import '../presentation/product_detail_screen/product_detail_screen.dart';
import '../presentation/registration_screen/registration_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String bulkOrderCart = '/bulk-order-cart';
  static const String splash = '/splash-screen';
  static const String orderHistory = '/order-history';
  static const String orderCheckout = '/order-checkout';
  static const String supplierDirectory = '/supplier-directory';
  static const String profileSettings = '/profile-settings';
  static const String dashboard = '/dashboard';
  static const String login = '/login-screen';
  static const String inventoryManagement = '/inventory-management';
  static const String productCatalog = '/product-catalog';
  static const String productDetail = '/product-detail-screen';
  static const String registration = '/registration-screen';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    bulkOrderCart: (context) => const BulkOrderCart(),
    splash: (context) => const SplashScreen(),
    orderHistory: (context) => const OrderHistory(),
    orderCheckout: (context) => const OrderCheckout(),
    supplierDirectory: (context) => const SupplierDirectory(),
    profileSettings: (context) => const ProfileSettings(),
    dashboard: (context) => const Dashboard(),
    login: (context) => const LoginScreen(),
    inventoryManagement: (context) => const InventoryManagement(),
    productCatalog: (context) => const ProductCatalog(),
    productDetail: (context) => const ProductDetailScreen(),
    registration: (context) => const RegistrationScreen(),
  };
}
