import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../profile_settings/profile_settings.dart';
import './widgets/metrics_card_widget.dart';
import './widgets/order_card_widget.dart';
import './widgets/quick_action_button_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = false;
  DateTime _lastSynced = DateTime.now();

  // Mock data for dashboard metrics
  final List<Map<String, dynamic>> _metricsData = [
    {
      "title": "Total Orders",
      "value": "1,247",
      "subtitle": "+12% this month",
      "backgroundColor": const Color(0xFFF3F4F6),
    },
    {
      "title": "Pending Deliveries",
      "value": "23",
      "subtitle": "2 urgent",
      "backgroundColor": const Color(0xFFFEF3C7),
    },
    {
      "title": "Low Stock Alerts",
      "value": "8",
      "subtitle": "Requires attention",
      "backgroundColor": const Color(0xFFFEE2E2),
    },
    {
      "title": "Monthly Revenue",
      "value": "₹2,45,680",
      "subtitle": "+18% vs last month",
      "backgroundColor": const Color(0xFFECFDF5),
    },
  ];

  // Mock data for recent orders
  final List<Map<String, dynamic>> _recentOrders = [
    {
      "orderNumber": "ORD-2024-001",
      "date": "04 Nov 2024",
      "status": "Processing",
      "total": "₹12,450",
      "items": 15,
    },
    {
      "orderNumber": "ORD-2024-002",
      "date": "03 Nov 2024",
      "status": "Delivered",
      "total": "₹8,920",
      "items": 12,
    },
    {
      "orderNumber": "ORD-2024-003",
      "date": "02 Nov 2024",
      "status": "Pending",
      "total": "₹15,670",
      "items": 20,
    },
    {
      "orderNumber": "ORD-2024-004",
      "date": "01 Nov 2024",
      "status": "Cancelled",
      "total": "₹5,340",
      "items": 8,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.index = 0; // Dashboard tab active
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
      _lastSynced = DateTime.now();
    });

    Fluttertoast.showToast(
      msg: "Data refreshed successfully",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _showMetricDetails(String title) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text('Detailed breakdown for $title would be displayed here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleQuickAction(String action) {
    switch (action) {
      case 'New Order':
        Navigator.pushNamed(context, '/product-catalog');
        break;
      case 'Check Inventory':
        Navigator.pushNamed(context, '/inventory-management');
        break;
      case 'Scan Product':
        _showScanDialog();
        break;
      case 'Contact Supplier':
        _showContactDialog();
        break;
    }
  }

  void _showScanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Scan Product'),
        content: const Text(
            'Camera functionality would be implemented here for barcode scanning.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Fluttertoast.showToast(msg: "Scan feature coming soon");
            },
            child: const Text('Open Camera'),
          ),
        ],
      ),
    );
  }

  void _showContactDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Supplier'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'phone',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              title: const Text('Call Supplier'),
              subtitle: const Text('+91 98765 43210'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Calling supplier...");
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 6.w,
              ),
              title: const Text('Email Supplier'),
              subtitle: const Text('supplier@menstrucare.com'),
              onTap: () {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Opening email...");
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _handleOrderAction(Map<String, dynamic> order, String action) {
    switch (action) {
      case 'track':
        Fluttertoast.showToast(msg: "Tracking order ${order['orderNumber']}");
        break;
      case 'reorder':
        Fluttertoast.showToast(msg: "Reordering ${order['orderNumber']}");
        break;
      case 'invoice':
        Fluttertoast.showToast(
            msg: "Viewing invoice for ${order['orderNumber']}");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'MenstruCare Pro',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Language settings");
            },
            icon: CustomIconWidget(
              iconName: 'language',
              color: AppTheme.lightTheme.colorScheme.onSurface,
              size: 6.w,
            ),
          ),
          IconButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Notifications");
            },
            icon: Stack(
              children: [
                CustomIconWidget(
                  iconName: 'notifications',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 2.w,
                    height: 2.w,
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.error,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'Catalog'),
            Tab(text: 'Orders'),
            Tab(text: 'Profile'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Dashboard Tab
          RefreshIndicator(
            onRefresh: _refreshData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Last synced info
                  Container(
                    width: double.infinity,
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                    color: AppTheme.lightTheme.colorScheme.surface,
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'sync',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 4.w,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          'Last synced: ${_lastSynced.hour.toString().padLeft(2, '0')}:${_lastSynced.minute.toString().padLeft(2, '0')}',
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme
                                .lightTheme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        if (_isLoading)
                          SizedBox(
                            width: 4.w,
                            height: 4.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Metrics Cards
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Business Overview',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  SizedBox(
                    height: 15.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      itemCount: _metricsData.length,
                      itemBuilder: (context, index) {
                        final metric = _metricsData[index];
                        return MetricsCardWidget(
                          title: metric["title"],
                          value: metric["value"],
                          subtitle: metric["subtitle"],
                          backgroundColor: metric["backgroundColor"],
                          onTap: () => _showMetricDetails(metric["title"]),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Quick Actions
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Quick Actions',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        QuickActionButtonWidget(
                          title: 'New Order',
                          iconName: 'add_shopping_cart',
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.primary
                              .withValues(alpha: 0.1),
                          iconColor: AppTheme.lightTheme.colorScheme.primary,
                          onTap: () => _handleQuickAction('New Order'),
                        ),
                        QuickActionButtonWidget(
                          title: 'Check Inventory',
                          iconName: 'inventory',
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.secondary
                              .withValues(alpha: 0.1),
                          iconColor: AppTheme.lightTheme.colorScheme.secondary,
                          onTap: () => _handleQuickAction('Check Inventory'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 1.h),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        QuickActionButtonWidget(
                          title: 'Scan Product',
                          iconName: 'qr_code_scanner',
                          backgroundColor: AppTheme
                              .lightTheme.colorScheme.tertiary
                              .withValues(alpha: 0.1),
                          iconColor: AppTheme.lightTheme.colorScheme.tertiary,
                          onTap: () => _handleQuickAction('Scan Product'),
                        ),
                        QuickActionButtonWidget(
                          title: 'Contact Supplier',
                          iconName: 'contact_phone',
                          backgroundColor: AppTheme.lightTheme.colorScheme.error
                              .withValues(alpha: 0.1),
                          iconColor: AppTheme.lightTheme.colorScheme.error,
                          onTap: () => _handleQuickAction('Contact Supplier'),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Recent Orders
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Recent Orders',
                          style: AppTheme.lightTheme.textTheme.titleLarge
                              ?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _tabController.animateTo(2); // Switch to Orders tab
                          },
                          child: Text(
                            'View All',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  _recentOrders.isEmpty
                      ? Container(
                          height: 20.h,
                          margin: EdgeInsets.symmetric(horizontal: 4.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'shopping_cart_outlined',
                                color: AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                                size: 12.w,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                'No orders yet',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(height: 1.h),
                              Text(
                                'Start by placing your first bulk order',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 2.h),
                              ElevatedButton(
                                onPressed: () =>
                                    _handleQuickAction('New Order'),
                                child: const Text('Place Order'),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recentOrders.length,
                          itemBuilder: (context, index) {
                            final order = _recentOrders[index];
                            return OrderCardWidget(
                              order: order,
                              onTrack: () => _handleOrderAction(order, 'track'),
                              onReorder: () =>
                                  _handleOrderAction(order, 'reorder'),
                              onInvoice: () =>
                                  _handleOrderAction(order, 'invoice'),
                              onTap: () {
                                Fluttertoast.showToast(
                                  msg: "Opening order ${order['orderNumber']}",
                                );
                              },
                            );
                          },
                        ),

                  SizedBox(height: 10.h), // Bottom padding for FAB
                ],
              ),
            ),
          ),

          // Catalog Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'inventory_2',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Product Catalog',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Browse our complete range of\nreusable menstrual products',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/product-catalog'),
                  child: const Text('View Catalog'),
                ),
              ],
            ),
          ),

          // Orders Tab
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'receipt_long',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20.w,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Order Management',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Track and manage all your\nbulk orders in one place',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 3.h),
                ElevatedButton(
                  onPressed: () {
                    Fluttertoast.showToast(msg: "Orders screen coming soon");
                  },
                  child: const Text('View Orders'),
                ),
              ],
            ),
          ),

          // Profile Tab
          const ProfileSettings(),
        ],
      ),
      floatingActionButton: _tabController.index == 0
          ? FloatingActionButton.extended(
              onPressed: () => _handleQuickAction('New Order'),
              icon: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 6.w,
              ),
              label: const Text('New Order'),
            )
          : null,
    );
  }
}
