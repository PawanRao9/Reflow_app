import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/order_card_widget.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isLoading = false;
  bool _isSearching = false;
  List<Map<String, dynamic>> _filteredOrders = [];
  List<Map<String, dynamic>> _selectedOrders = [];
  bool _isMultiSelectMode = false;

  Map<String, dynamic> _currentFilters = {
    'status': 'All',
    'supplier': 'All Suppliers',
  };

  // Mock order data
  final List<Map<String, dynamic>> _mockOrders = [
    {
      "id": "ORD-2024-001",
      "orderNumber": "ORD-2024-001",
      "date": "08 Nov 2024",
      "supplierName": "MedCare Distributors",
      "totalAmount": "₹45,250",
      "status": "Delivered",
      "itemCount": 15,
      "timeline": [
        {
          "title": "Order Placed",
          "timestamp": "08 Nov 2024, 10:30 AM",
          "isCompleted": true,
        },
        {
          "title": "Order Confirmed",
          "timestamp": "08 Nov 2024, 11:15 AM",
          "isCompleted": true,
        },
        {
          "title": "Shipped",
          "timestamp": "09 Nov 2024, 02:45 PM",
          "isCompleted": true,
        },
        {
          "title": "Out for Delivery",
          "timestamp": "10 Nov 2024, 09:00 AM",
          "isCompleted": true,
        },
        {
          "title": "Delivered",
          "timestamp": "10 Nov 2024, 03:30 PM",
          "isCompleted": true,
        },
      ],
      "items": [
        {"name": "Menstrual Cup - Size S", "quantity": 50, "price": "₹15,000"},
        {
          "name": "Reusable Pads - Regular",
          "quantity": 100,
          "price": "₹20,000"
        },
        {"name": "Period Panties - Medium", "quantity": 75, "price": "₹10,250"},
      ],
    },
    {
      "id": "ORD-2024-002",
      "orderNumber": "ORD-2024-002",
      "date": "06 Nov 2024",
      "supplierName": "HealthFirst Supply Co.",
      "totalAmount": "₹32,800",
      "status": "Shipped",
      "itemCount": 12,
      "timeline": [
        {
          "title": "Order Placed",
          "timestamp": "06 Nov 2024, 02:15 PM",
          "isCompleted": true,
        },
        {
          "title": "Order Confirmed",
          "timestamp": "06 Nov 2024, 04:30 PM",
          "isCompleted": true,
        },
        {
          "title": "Shipped",
          "timestamp": "07 Nov 2024, 11:20 AM",
          "isCompleted": true,
        },
        {
          "title": "Out for Delivery",
          "timestamp": null,
          "isCompleted": false,
        },
        {
          "title": "Delivered",
          "timestamp": null,
          "isCompleted": false,
        },
      ],
      "items": [
        {"name": "Menstrual Cup - Size M", "quantity": 40, "price": "₹12,800"},
        {
          "name": "Reusable Pads - Heavy Flow",
          "quantity": 80,
          "price": "₹20,000"
        },
      ],
    },
    {
      "id": "ORD-2024-003",
      "orderNumber": "ORD-2024-003",
      "date": "04 Nov 2024",
      "supplierName": "WellnessHub Ltd.",
      "totalAmount": "₹28,500",
      "status": "Confirmed",
      "itemCount": 10,
      "timeline": [
        {
          "title": "Order Placed",
          "timestamp": "04 Nov 2024, 09:45 AM",
          "isCompleted": true,
        },
        {
          "title": "Order Confirmed",
          "timestamp": "04 Nov 2024, 01:20 PM",
          "isCompleted": true,
        },
        {
          "title": "Shipped",
          "timestamp": null,
          "isCompleted": false,
        },
        {
          "title": "Out for Delivery",
          "timestamp": null,
          "isCompleted": false,
        },
        {
          "title": "Delivered",
          "timestamp": null,
          "isCompleted": false,
        },
      ],
      "items": [
        {"name": "Period Panties - Large", "quantity": 60, "price": "₹18,000"},
        {"name": "Menstrual Cup - Size L", "quantity": 35, "price": "₹10,500"},
      ],
    },
    {
      "id": "ORD-2024-004",
      "orderNumber": "ORD-2024-004",
      "date": "02 Nov 2024",
      "supplierName": "CarePoint Medical",
      "totalAmount": "₹18,750",
      "status": "Pending",
      "itemCount": 8,
      "timeline": [
        {
          "title": "Order Placed",
          "timestamp": "02 Nov 2024, 04:10 PM",
          "isCompleted": true,
        },
        {
          "title": "Order Confirmed",
          "timestamp": null,
          "isCompleted": false,
        },
        {
          "title": "Shipped",
          "timestamp": null,
          "isCompleted": false,
        },
        {
          "title": "Out for Delivery",
          "timestamp": null,
          "isCompleted": false,
        },
        {
          "title": "Delivered",
          "timestamp": null,
          "isCompleted": false,
        },
      ],
      "items": [
        {
          "name": "Reusable Pads - Light Flow",
          "quantity": 120,
          "price": "₹18,750"
        },
      ],
    },
    {
      "id": "ORD-2024-005",
      "orderNumber": "ORD-2024-005",
      "date": "30 Oct 2024",
      "supplierName": "VitalSupply Partners",
      "totalAmount": "₹8,200",
      "status": "Cancelled",
      "itemCount": 3,
      "timeline": [
        {
          "title": "Order Placed",
          "timestamp": "30 Oct 2024, 11:25 AM",
          "isCompleted": true,
        },
        {
          "title": "Order Cancelled",
          "timestamp": "30 Oct 2024, 02:15 PM",
          "isCompleted": true,
        },
      ],
      "items": [
        {"name": "Menstrual Cup - Size S", "quantity": 25, "price": "₹8,200"},
      ],
    },
  ];

  @override
  void initState() {
    super.initState();
    _filteredOrders = List.from(_mockOrders);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      _filteredOrders = _mockOrders.where((order) {
        final orderNumber = (order['orderNumber'] as String).toLowerCase();
        final supplierName = (order['supplierName'] as String).toLowerCase();
        final items = (order['items'] as List).cast<Map<String, dynamic>>();
        final itemNames = items
            .map((item) => (item['name'] as String).toLowerCase())
            .join(' ');

        return orderNumber.contains(query) ||
            supplierName.contains(query) ||
            itemNames.contains(query);
      }).toList();
    });
  }

  void _applyFilters(Map<String, dynamic> filters) {
    setState(() {
      _currentFilters = filters;
      _filteredOrders = _mockOrders.where((order) {
        bool matchesStatus = filters['status'] == 'All' ||
            (order['status'] as String) == filters['status'];

        bool matchesSupplier = filters['supplier'] == 'All Suppliers' ||
            (order['supplierName'] as String) == filters['supplier'];

        bool matchesDateRange = true;
        if (filters['startDate'] != null && filters['endDate'] != null) {
          final orderDate = DateTime.parse(
              '2024-11-${(order['date'] as String).split(' ')[0].padLeft(2, '0')}');
          final startDate = DateTime.parse(filters['startDate'] as String);
          final endDate = DateTime.parse(filters['endDate'] as String);
          matchesDateRange =
              orderDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                  orderDate.isBefore(endDate.add(const Duration(days: 1)));
        }

        return matchesStatus && matchesSupplier && matchesDateRange;
      }).toList();
    });

    // Apply search filter if active
    if (_searchController.text.isNotEmpty) {
      _onSearchChanged();
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: _applyFilters,
      ),
    );
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _filteredOrders = List.from(_mockOrders);
    });

    // Apply current filters
    _applyFilters(_currentFilters);
  }

  void _toggleMultiSelectMode() {
    setState(() {
      _isMultiSelectMode = !_isMultiSelectMode;
      if (!_isMultiSelectMode) {
        _selectedOrders.clear();
      }
    });
  }

  void _toggleOrderSelection(Map<String, dynamic> order) {
    setState(() {
      if (_selectedOrders.contains(order)) {
        _selectedOrders.remove(order);
      } else {
        _selectedOrders.add(order);
      }

      if (_selectedOrders.isEmpty) {
        _isMultiSelectMode = false;
      }
    });
  }

  void _handleReorder(Map<String, dynamic> order) {
    // Copy items to cart
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${order['itemCount']} items added to cart'),
        action: SnackBarAction(
          label: 'View Cart',
          onPressed: () {
            Navigator.pushNamed(context, '/bulk-order-cart');
          },
        ),
      ),
    );
  }

  void _handleViewInvoice(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Downloading invoice for ${order['orderNumber']}'),
      ),
    );
  }

  void _handleTrackShipment(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening tracking for ${order['orderNumber']}'),
      ),
    );
  }

  void _handleContactSupplier(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Contacting ${order['supplierName']}'),
      ),
    );
  }

  void _handleBulkExport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exporting ${_selectedOrders.length} orders'),
      ),
    );
  }

  void _handleBulkArchive() {
    setState(() {
      _selectedOrders.clear();
      _isMultiSelectMode = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Orders archived successfully'),
      ),
    );
  }

  void _handleBulkReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating report for ${_selectedOrders.length} orders'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search orders, suppliers, products...',
          hintStyle: TextStyle(
            color: AppTheme.textSecondaryLight,
            fontSize: 12.sp,
          ),
          prefixIcon: CustomIconWidget(
            iconName: 'search',
            size: 5.w,
            color: AppTheme.textSecondaryLight,
          ),
          suffixIcon: _isSearching
              ? IconButton(
                  onPressed: () {
                    _searchController.clear();
                  },
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    size: 4.w,
                    color: AppTheme.textSecondaryLight,
                  ),
                )
              : IconButton(
                  onPressed: _showFilterBottomSheet,
                  icon: CustomIconWidget(
                    iconName: 'filter_list',
                    size: 5.w,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 2.h,
          ),
        ),
        style: TextStyle(
          fontSize: 12.sp,
          color: AppTheme.textPrimaryLight,
        ),
      ),
    );
  }

  Widget _buildMultiSelectActions() {
    if (!_isMultiSelectMode || _selectedOrders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        border: Border(
          bottom: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        children: [
          Text(
            '${_selectedOrders.length} selected',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppTheme.textPrimaryLight,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: _handleBulkExport,
            icon: CustomIconWidget(
              iconName: 'file_download',
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: Text(
              'Export',
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
          TextButton.icon(
            onPressed: _handleBulkArchive,
            icon: CustomIconWidget(
              iconName: 'archive',
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: Text(
              'Archive',
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
          TextButton.icon(
            onPressed: _handleBulkReport,
            icon: CustomIconWidget(
              iconName: 'assessment',
              size: 4.w,
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
            label: Text(
              'Report',
              style: TextStyle(fontSize: 10.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_filteredOrders.isEmpty) {
      return const EmptyStateWidget();
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      color: AppTheme.lightTheme.colorScheme.primary,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _filteredOrders.length,
        itemBuilder: (context, index) {
          final order = _filteredOrders[index];
          final isSelected = _selectedOrders.contains(order);

          return Slidable(
            key: ValueKey(order['id']),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (_) => _handleViewInvoice(order),
                  backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
                  foregroundColor: Colors.white,
                  icon: Icons.receipt,
                  label: 'Invoice',
                ),
                SlidableAction(
                  onPressed: (_) => _handleTrackShipment(order),
                  backgroundColor: AppTheme.lightTheme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  icon: Icons.local_shipping,
                  label: 'Track',
                ),
                SlidableAction(
                  onPressed: (_) => _handleReorder(order),
                  backgroundColor: AppTheme.successLight,
                  foregroundColor: Colors.white,
                  icon: Icons.refresh,
                  label: 'Reorder',
                ),
                SlidableAction(
                  onPressed: (_) => _handleContactSupplier(order),
                  backgroundColor: AppTheme.accentLight,
                  foregroundColor: Colors.white,
                  icon: Icons.phone,
                  label: 'Contact',
                ),
              ],
            ),
            child: GestureDetector(
              onLongPress: () {
                if (!_isMultiSelectMode) {
                  _toggleMultiSelectMode();
                }
                _toggleOrderSelection(order);
              },
              child: Container(
                decoration: isSelected
                    ? BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.1),
                      )
                    : null,
                child: Row(
                  children: [
                    if (_isMultiSelectMode) ...[
                      Checkbox(
                        value: isSelected,
                        onChanged: (_) => _toggleOrderSelection(order),
                      ),
                      SizedBox(width: 2.w),
                    ],
                    Expanded(
                      child: OrderCardWidget(
                        order: order,
                        onReorder: () => _handleReorder(order),
                        onViewInvoice: () => _handleViewInvoice(order),
                        onTrackShipment: () => _handleTrackShipment(order),
                        onContactSupplier: () => _handleContactSupplier(order),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order History',
        variant: CustomAppBarVariant.back,
        actions: [
          if (_isMultiSelectMode)
            IconButton(
              onPressed: _toggleMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'close',
                size: 5.w,
                color: AppTheme.textPrimaryLight,
              ),
            )
          else
            IconButton(
              onPressed: _toggleMultiSelectMode,
              icon: CustomIconWidget(
                iconName: 'checklist',
                size: 5.w,
                color: AppTheme.textPrimaryLight,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildMultiSelectActions(),
          Expanded(
            child: _isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  )
                : _buildOrdersList(),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomBar(currentIndex: 2),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/bulk-order-cart');
        },
        child: CustomIconWidget(
          iconName: 'add_shopping_cart',
          size: 6.w,
          color: Colors.white,
        ),
      ),
    );
  }
}
