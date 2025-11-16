import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/barcode_scanner_dialog.dart';
import './widgets/bulk_actions_toolbar.dart';
import './widgets/filter_bottom_sheet.dart';
import './widgets/inventory_item_card.dart';
import './widgets/inventory_overview_card.dart';
import './widgets/inventory_search_bar.dart';
import './widgets/low_stock_alert_section.dart';

class InventoryManagement extends StatefulWidget {
  const InventoryManagement({Key? key}) : super(key: key);

  @override
  State<InventoryManagement> createState() => _InventoryManagementState();
}

class _InventoryManagementState extends State<InventoryManagement>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedItems = <int>{};

  bool _isLoading = false;
  bool _isOffline = false;
  String _searchQuery = '';
  Map<String, dynamic> _currentFilters = {
    'stockStatus': 'All',
    'category': 'All',
    'supplier': 'All',
  };

  // Mock inventory data
  final List<Map<String, dynamic>> _inventoryData = [
    {
      "id": 1,
      "name": "EcoFemme Menstrual Cup - Small",
      "category": "Menstrual Cups",
      "supplier": "EcoFemme",
      "currentStock": 45,
      "reorderPoint": 20,
      "status": "adequate",
      "image":
          "https://images.unsplash.com/photo-1712659847335-1252d0b33eb4",
      "semanticLabel":
          "Pink menstrual cup displayed on white background with soft lighting",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      "id": 2,
      "name": "Saathi Reusable Cloth Pads - Regular",
      "category": "Reusable Pads",
      "supplier": "Saathi",
      "currentStock": 12,
      "reorderPoint": 15,
      "status": "low",
      "image":
          "https://images.unsplash.com/photo-1643297133069-fd5ae3f440d0",
      "semanticLabel":
          "Colorful reusable cloth menstrual pads arranged on wooden surface",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 5)),
    },
    {
      "id": 3,
      "name": "Boondh Period Panties - Medium",
      "category": "Period Panties",
      "supplier": "Boondh",
      "currentStock": 3,
      "reorderPoint": 10,
      "status": "critical",
      "image":
          "https://images.unsplash.com/photo-1582143426894-82fce755e83d",
      "semanticLabel": "Black period underwear laid flat on neutral background",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 1)),
    },
    {
      "id": 4,
      "name": "Aakar Menstrual Cup - Large",
      "category": "Menstrual Cups",
      "supplier": "Aakar Innovations",
      "currentStock": 28,
      "reorderPoint": 15,
      "status": "adequate",
      "image":
          "https://images.unsplash.com/photo-1688885650522-1666bec321fb",
      "semanticLabel":
          "Clear silicone menstrual cup with measurement markings on white surface",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 3)),
    },
    {
      "id": 5,
      "name": "EcoFemme Reusable Pads - Heavy Flow",
      "category": "Reusable Pads",
      "supplier": "EcoFemme",
      "currentStock": 8,
      "reorderPoint": 12,
      "status": "low",
      "image":
          "https://images.unsplash.com/photo-1563391500754-1756eec31014",
      "semanticLabel":
          "Organic cotton reusable pads with floral patterns on bamboo mat",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 4)),
    },
    {
      "id": 6,
      "name": "Saathi Period Panties - Large",
      "category": "Period Panties",
      "supplier": "Saathi",
      "currentStock": 22,
      "reorderPoint": 10,
      "status": "adequate",
      "image":
          "https://images.unsplash.com/photo-1642761528861-4a1dd8391998",
      "semanticLabel":
          "Navy blue period underwear with lace trim on soft fabric background",
      "lastUpdated": DateTime.now().subtract(const Duration(hours: 6)),
    },
  ];

  List<Map<String, dynamic>> get _filteredInventory {
    List<Map<String, dynamic>> filtered = _inventoryData;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((item) {
        final name = (item['name'] as String? ?? '').toLowerCase();
        final category = (item['category'] as String? ?? '').toLowerCase();
        final supplier = (item['supplier'] as String? ?? '').toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            category.contains(query) ||
            supplier.contains(query);
      }).toList();
    }

    // Apply filters
    if (_currentFilters['stockStatus'] != 'All') {
      filtered = filtered.where((item) {
        return (item['status'] as String? ?? '').toLowerCase() ==
            _currentFilters['stockStatus'].toLowerCase();
      }).toList();
    }

    if (_currentFilters['category'] != 'All') {
      filtered = filtered.where((item) {
        return item['category'] == _currentFilters['category'];
      }).toList();
    }

    if (_currentFilters['supplier'] != 'All') {
      filtered = filtered.where((item) {
        return item['supplier'] == _currentFilters['supplier'];
      }).toList();
    }

    return filtered;
  }

  List<Map<String, dynamic>> get _lowStockItems {
    return _inventoryData.where((item) {
      final status = item['status'] as String? ?? '';
      return status == 'low' || status == 'critical';
    }).toList();
  }

  Map<String, int> get _overviewStats {
    final totalSKUs = _inventoryData.length;
    final lowStockItems =
        _inventoryData.where((item) => item['status'] == 'low').length;
    final outOfStockItems = _inventoryData
        .where((item) => (item['currentStock'] as int? ?? 0) == 0)
        .length;
    final reorderPendingItems =
        _inventoryData.where((item) => item['status'] == 'critical').length;

    return {
      'totalSKUs': totalSKUs,
      'lowStock': lowStockItems,
      'outOfStock': outOfStockItems,
      'reorderPending': reorderPendingItems,
    };
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    // Simulate connectivity check
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _isOffline = false; // Mock online status
    });
  }

  Future<void> _refreshInventory() async {
    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isLoading = false);

    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: "Inventory synced successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _showBarcodeScanner() {
    showDialog(
      context: context,
      builder: (context) => BarcodeScannerDialog(
        onBarcodeScanned: (barcode) {
          _searchController.text = barcode;
          _onSearchChanged(barcode);

          if (!kIsWeb) {
            Fluttertoast.showToast(
              msg: "Searching for: $barcode",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
            );
          }
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentFilters: _currentFilters,
        onFiltersApplied: (filters) {
          setState(() {
            _currentFilters = filters;
          });
        },
      ),
    );
  }

  void _toggleItemSelection(int itemId) {
    setState(() {
      if (_selectedItems.contains(itemId)) {
        _selectedItems.remove(itemId);
      } else {
        _selectedItems.add(itemId);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedItems.clear();
    });
  }

  void _showUpdateStockDialog(Map<String, dynamic>? item) {
    final TextEditingController quantityController = TextEditingController();
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          item != null ? 'Update Stock' : 'Bulk Update Stock',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item != null)
              Text(
                item['name'] as String? ?? '',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            SizedBox(height: 2.h),
            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantity to Add',
                hintText: 'Enter quantity',
              ),
            ),
            SizedBox(height: 2.h),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'e.g., New shipment received',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (!kIsWeb) {
                Fluttertoast.showToast(
                  msg: "Stock updated successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showSetReorderPointDialog(Map<String, dynamic>? item) {
    final TextEditingController reorderController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          item != null ? 'Set Reorder Point' : 'Bulk Set Reorder Point',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item != null)
              Text(
                item['name'] as String? ?? '',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontSize: 14.sp,
                ),
              ),
            SizedBox(height: 2.h),
            TextField(
              controller: reorderController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Reorder Point',
                hintText: 'Enter minimum stock level',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (!kIsWeb) {
                Fluttertoast.showToast(
                  msg: "Reorder point updated",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );
              }
            },
            child: const Text('Set'),
          ),
        ],
      ),
    );
  }

  void _markAsReceived(Map<String, dynamic>? item) {
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: item != null
            ? "${item['name']} marked as received"
            : "${_selectedItems.length} items marked as received",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
    _clearSelection();
  }

  void _reorderItem(Map<String, dynamic> item) {
    Navigator.pushNamed(context, '/product-catalog');
  }

  void _exportInventoryReport() {
    if (!kIsWeb) {
      Fluttertoast.showToast(
        msg: "Inventory report exported successfully",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stats = _overviewStats;
    final filteredItems = _filteredInventory;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Inventory Management',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 20.sp,
          ),
        ),
        actions: [
          if (_isOffline)
            Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: CustomIconWidget(
                iconName: 'cloud_off',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 6.w,
              ),
            ),
          GestureDetector(
            onTap: _showFilterBottomSheet,
            child: Padding(
              padding: EdgeInsets.only(right: 2.w),
              child: CustomIconWidget(
                iconName: 'filter_list',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'export':
                  _exportInventoryReport();
                  break;
                case 'sync':
                  _refreshInventory();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'export',
                child: Text('Export Report'),
              ),
              const PopupMenuItem(
                value: 'sync',
                child: Text('Sync Data'),
              ),
            ],
            child: Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: CustomIconWidget(
                iconName: 'more_vert',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // Overview Cards
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InventoryOverviewCard(
                      title: 'Total SKUs',
                      count: '${stats['totalSKUs']}',
                      backgroundColor: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      textColor: AppTheme.lightTheme.colorScheme.primary,
                      iconName: 'inventory',
                      onTap: () {},
                    ),
                    InventoryOverviewCard(
                      title: 'Low Stock',
                      count: '${stats['lowStock']}',
                      backgroundColor:
                          const Color(0xFFF57C00).withValues(alpha: 0.1),
                      textColor: const Color(0xFFF57C00),
                      iconName: 'warning',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InventoryOverviewCard(
                      title: 'Out of Stock',
                      count: '${stats['outOfStock']}',
                      backgroundColor: AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.1),
                      textColor: AppTheme.lightTheme.colorScheme.error,
                      iconName: 'remove_circle',
                      onTap: () {},
                    ),
                    InventoryOverviewCard(
                      title: 'Reorder Pending',
                      count: '${stats['reorderPending']}',
                      backgroundColor: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      textColor: AppTheme.lightTheme.colorScheme.secondary,
                      iconName: 'refresh',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Search Bar
              InventorySearchBar(
                controller: _searchController,
                onChanged: _onSearchChanged,
                onScanPressed: _showBarcodeScanner,
              ),

              // Low Stock Alerts
              LowStockAlertSection(
                lowStockItems: _lowStockItems,
                onReorderPressed: _reorderItem,
              ),

              // Inventory List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _refreshInventory,
                  color: AppTheme.lightTheme.colorScheme.primary,
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.lightTheme.colorScheme.primary,
                          ),
                        )
                      : filteredItems.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'inventory_2',
                                    color: AppTheme.lightTheme.colorScheme
                                        .onSurfaceVariant,
                                    size: 15.w,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    _searchQuery.isNotEmpty
                                        ? 'No products found for "$_searchQuery"'
                                        : 'No inventory items found',
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyLarge
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.colorScheme
                                          .onSurfaceVariant,
                                      fontSize: 16.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                final itemId = item['id'] as int;
                                final isSelected =
                                    _selectedItems.contains(itemId);

                                return GestureDetector(
                                  onLongPress: () =>
                                      _toggleItemSelection(itemId),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppTheme
                                              .lightTheme.colorScheme.primary
                                              .withValues(alpha: 0.1)
                                          : Colors.transparent,
                                    ),
                                    child: InventoryItemCard(
                                      item: item,
                                      onUpdateStock: () =>
                                          _showUpdateStockDialog(item),
                                      onSetReorderPoint: () =>
                                          _showSetReorderPointDialog(item),
                                      onMarkReceived: () =>
                                          _markAsReceived(item),
                                      onTap: _selectedItems.isNotEmpty
                                          ? () => _toggleItemSelection(itemId)
                                          : () => Navigator.pushNamed(context,
                                              '/product-detail-screen'),
                                    ),
                                  ),
                                );
                              },
                            ),
                ),
              ),
            ],
          ),

          // Bulk Actions Toolbar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BulkActionsToolbar(
              selectedCount: _selectedItems.length,
              onUpdateStock: () => _showUpdateStockDialog(null),
              onSetReorderPoint: () => _showSetReorderPointDialog(null),
              onMarkReceived: () => _markAsReceived(null),
              onClearSelection: _clearSelection,
            ),
          ),
        ],
      ),
      floatingActionButton: _selectedItems.isEmpty
          ? FloatingActionButton(
              onPressed: () => _showUpdateStockDialog(null),
              child: CustomIconWidget(
                iconName: 'add',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 6.w,
              ),
            )
          : null,
    );
  }
}
