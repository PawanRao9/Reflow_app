import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widget/active_filters_widget.dart';
import './widget/category_chip_widget.dart';
import './widget/filter_bottom_sheet_widget.dart';
import './widget/product_card_widget.dart';
import './widget/search_bar_widget.dart';

class ProductCatalog extends StatefulWidget {
  const ProductCatalog({Key? key}) : super(key: key);

  @override
  State<ProductCatalog> createState() => _ProductCatalogState();
}

class _ProductCatalogState extends State<ProductCatalog>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  String _selectedCategory = 'All Products';
  Map<String, dynamic> _activeFilters = {};
  bool _isLoading = false;
  bool _isOfflineMode = false;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'All Products', 'count': 156},
    {'name': 'Menstrual Cups', 'count': 45},
    {'name': 'Reusable Pads', 'count': 67},
    {'name': 'Period Panties', 'count': 44},
  ];

  final List<Map<String, dynamic>> _allProducts = [
    {
      'id': 1,
      'name': 'DivaCup Model 1',
      'brand': 'DivaCup',
      'category': 'Menstrual Cups',
      'image':
          'https://images.unsplash.com/photo-1643296247727-df2676d3078b',
      'semanticLabel':
          'Medical grade silicone menstrual cup in clear packaging on white background',
      'bulkPrice': '₹850 (50+ units)',
      'regularPrice': '₹950',
      'minOrderQuantity': 50,
      'stock': 120,
      'material': 'Medical Silicone',
      'sizes': ['Small', 'Medium'],
      'isFavorite': false,
      'selectedQuantity': 50,
      'description':
          'Premium medical-grade silicone menstrual cup designed for comfort and reliability.',
    },
    {
      'id': 2,
      'name': 'Organic Cotton Reusable Pads',
      'brand': 'EcoFemme',
      'category': 'Reusable Pads',
      'image':
          'https://images.unsplash.com/photo-1648735256967-ca9c4d2cbc80',
      'semanticLabel':
          'Stack of organic cotton reusable menstrual pads in natural beige color with floral pattern',
      'bulkPrice': '₹320 (100+ units)',
      'regularPrice': '₹380',
      'minOrderQuantity': 100,
      'stock': 250,
      'material': 'Organic Cotton',
      'sizes': ['Regular', 'Large'],
      'isFavorite': true,
      'selectedQuantity': 100,
      'description':
          'Soft organic cotton pads with superior absorption and comfort.',
    },
    {
      'id': 3,
      'name': 'Bamboo Fiber Period Panties',
      'brand': 'Thinx',
      'category': 'Period Panties',
      'image':
          'https://images.unsplash.com/photo-1703498051376-97b0f4dbeb99',
      'semanticLabel':
          'Black bamboo fiber period underwear laid flat showing absorbent layer design',
      'bulkPrice': '₹1,200 (25+ units)',
      'regularPrice': '₹1,400',
      'minOrderQuantity': 25,
      'stock': 80,
      'material': 'Bamboo Fiber',
      'sizes': ['Small', 'Medium', 'Large', 'Extra Large'],
      'isFavorite': false,
      'selectedQuantity': 25,
      'description':
          'Ultra-absorbent bamboo fiber period underwear with leak-proof technology.',
    },
    {
      'id': 4,
      'name': 'Saalt Cup Regular',
      'brand': 'Saalt',
      'category': 'Menstrual Cups',
      'image':
          'https://images.unsplash.com/photo-1605213786077-c3aac52e6c9b',
      'semanticLabel':
          'Rose gold colored menstrual cup with carrying pouch on marble surface',
      'bulkPrice': '₹780 (30+ units)',
      'regularPrice': '₹890',
      'minOrderQuantity': 30,
      'stock': 15,
      'material': 'Medical Silicone',
      'sizes': ['Regular'],
      'isFavorite': false,
      'selectedQuantity': 30,
      'description':
          'Award-winning menstrual cup with comfortable stem and reliable seal.',
    },
    {
      'id': 5,
      'name': 'Merino Wool Period Underwear',
      'brand': 'Modibodi',
      'category': 'Period Panties',
      'image':
          'https://images.unsplash.com/photo-1649857113484-cef73e114f0c',
      'semanticLabel':
          'Gray merino wool period underwear with moisture-wicking technology displayed on wooden surface',
      'bulkPrice': '₹1,450 (20+ units)',
      'regularPrice': '₹1,650',
      'minOrderQuantity': 20,
      'stock': 0,
      'material': 'Merino Wool',
      'sizes': ['Medium', 'Large'],
      'isFavorite': true,
      'selectedQuantity': 20,
      'description':
          'Premium merino wool period underwear with natural odor resistance.',
    },
    {
      'id': 6,
      'name': 'Lunette Cup Clear',
      'brand': 'Lunette',
      'category': 'Menstrual Cups',
      'image':
          'https://images.unsplash.com/photo-1606226286062-a7cd2bd110ef',
      'semanticLabel':
          'Clear silicone menstrual cup with measurement markings in eco-friendly packaging',
      'bulkPrice': '₹920 (40+ units)',
      'regularPrice': '₹1,050',
      'minOrderQuantity': 40,
      'stock': 95,
      'material': 'Medical Silicone',
      'sizes': ['Small', 'Large'],
      'isFavorite': false,
      'selectedQuantity': 40,
      'description':
          'Finnish-designed menstrual cup with measurement markings for easy monitoring.',
    },
  ];

  List<Map<String, dynamic>> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _filteredProducts = List.from(_allProducts);
    _checkConnectivity();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOfflineMode = false; // Set to true to test offline mode
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              color: AppTheme.lightTheme.colorScheme.surface,
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Catalog'),
                  Tab(text: 'Favorites'),
                  Tab(text: 'Compare'),
                  Tab(text: 'Orders'),
                ],
              ),
            ),
            // Main Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCatalogTab(),
                  _buildFavoritesTab(),
                  _buildCompareTab(),
                  _buildOrdersTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogTab() {
    return Column(
      children: [
        // Sticky Header with Search and Offline Indicator
        Container(
          color: AppTheme.lightTheme.colorScheme.surface,
          child: Column(
            children: [
              // Offline Mode Indicator
              if (_isOfflineMode)
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'cloud_off',
                        color: AppTheme.getWarningColor(true),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Offline Mode - Showing cached products',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: AppTheme.getWarningColor(true),
                        ),
                      ),
                    ],
                  ),
                ),
              // Search Bar
              SearchBarWidget(
                searchQuery: _searchQuery,
                onSearchChanged: _onSearchChanged,
                onFilterTap: _showFilterBottomSheet,
                onVoiceSearch: _onVoiceSearch,
              ),
              // Category Chips
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return CategoryChipWidget(
                      title: category['name'] as String,
                      count: category['count'] as int,
                      isSelected: _selectedCategory == category['name'],
                      onTap: () =>
                          _onCategorySelected(category['name'] as String),
                    );
                  },
                ),
              ),
              // Active Filters
              ActiveFiltersWidget(
                activeFilters: _activeFilters,
                onRemoveFilter: _onRemoveFilter,
                onClearAll: _onClearAllFilters,
              ),
            ],
          ),
        ),
        // Product Grid
        Expanded(
          child: _isLoading
              ? _buildLoadingState()
              : _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _getCrossAxisCount(),
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ProductCardWidget(
                            product: product,
                            onTap: () => _onProductTap(product),
                            onFavorite: () => _onToggleFavorite(product),
                            onCompare: () => _onAddToCompare(product),
                            onShare: () => _onShareProduct(product),
                            onQuantityChanged: (quantity) =>
                                _onQuantityChanged(product, quantity),
                          );
                        },
                      ),
                    ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    final favoriteProducts =
        _allProducts.where((product) => product['isFavorite'] as bool).toList();

    return favoriteProducts.isEmpty
        ? _buildEmptyFavoritesState()
        : GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getCrossAxisCount(),
              childAspectRatio: 0.75,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              final product = favoriteProducts[index];
              return ProductCardWidget(
                product: product,
                onTap: () => _onProductTap(product),
                onFavorite: () => _onToggleFavorite(product),
                onCompare: () => _onAddToCompare(product),
                onShare: () => _onShareProduct(product),
                onQuantityChanged: (quantity) =>
                    _onQuantityChanged(product, quantity),
              );
            },
          );
  }

  Widget _buildCompareTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'compare_arrows',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Product Comparison',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to compare their features',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'shopping_bag',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Order History',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Your bulk orders will appear here',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppTheme.lightTheme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Loading products...',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'search_off',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _onClearAllFilters,
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyFavoritesState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'favorite_border',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'No favorites yet',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Add products to favorites for quick access',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  int _getCrossAxisCount() {
    if (100.w > 600) {
      return 3; // Tablet view
    }
    return 2; // Mobile view
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _applyFilters();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilters();
    });
  }

  void _onVoiceSearch() {
    // Voice search feedback handled in SearchBarWidget
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        currentFilters: _activeFilters,
        onFiltersChanged: (filters) {
          setState(() {
            _activeFilters = filters;
            _applyFilters();
          });
        },
      ),
    );
  }

  void _onRemoveFilter(String key, dynamic value) {
    setState(() {
      if (value == null) {
        _activeFilters.remove(key);
      } else {
        if (_activeFilters[key] is List) {
          (_activeFilters[key] as List).remove(value);
          if ((_activeFilters[key] as List).isEmpty) {
            _activeFilters.remove(key);
          }
        }
      }
      _applyFilters();
    });
  }

  void _onClearAllFilters() {
    setState(() {
      _activeFilters.clear();
      _selectedCategory = 'All Products';
      _searchQuery = '';
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<Map<String, dynamic>> filtered = List.from(_allProducts);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final brand = (product['brand'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) ||
            brand.contains(query) ||
            category.contains(query);
      }).toList();
    }

    // Apply category filter
    if (_selectedCategory != 'All Products') {
      filtered = filtered
          .where((product) => product['category'] == _selectedCategory)
          .toList();
    }

    // Apply price range filter
    if (_activeFilters.containsKey('minPrice') ||
        _activeFilters.containsKey('maxPrice')) {
      final minPrice = _activeFilters['minPrice'] as double? ?? 0;
      final maxPrice = _activeFilters['maxPrice'] as double? ?? double.infinity;
      filtered = filtered.where((product) {
        final priceString = (product['regularPrice'] as String)
            .replaceAll('₹', '')
            .replaceAll(',', '');
        final price = double.tryParse(priceString) ?? 0;
        return price >= minPrice && price <= maxPrice;
      }).toList();
    }

    // Apply brand filter
    final selectedBrands = _activeFilters['selectedBrands'] as List<String>?;
    if (selectedBrands != null && selectedBrands.isNotEmpty) {
      filtered = filtered
          .where((product) => selectedBrands.contains(product['brand']))
          .toList();
    }

    // Apply material filter
    final selectedMaterials =
        _activeFilters['selectedMaterials'] as List<String>?;
    if (selectedMaterials != null && selectedMaterials.isNotEmpty) {
      filtered = filtered
          .where((product) => selectedMaterials.contains(product['material']))
          .toList();
    }

    // Apply size filter
    final selectedSizes = _activeFilters['selectedSizes'] as List<String>?;
    if (selectedSizes != null && selectedSizes.isNotEmpty) {
      filtered = filtered.where((product) {
        final productSizes = product['sizes'] as List<String>;
        return selectedSizes.any((size) => productSizes.contains(size));
      }).toList();
    }

    // Apply stock filters
    if (_activeFilters['inStockOnly'] as bool? ?? false) {
      filtered =
          filtered.where((product) => (product['stock'] as int) > 0).toList();
    }

    if (_activeFilters['lowStockAlert'] as bool? ?? false) {
      filtered = filtered.where((product) {
        final stock = product['stock'] as int;
        final minOrder = product['minOrderQuantity'] as int;
        return stock <= minOrder && stock > 0;
      }).toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network refresh
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catalog updated successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onProductTap(Map<String, dynamic> product) {
    Navigator.pushNamed(context, '/product-detail-screen', arguments: product);
  }

  void _onToggleFavorite(Map<String, dynamic> product) {
    setState(() {
      product['isFavorite'] = !(product['isFavorite'] as bool);
    });

    final message = (product['isFavorite'] as bool)
        ? 'Added to favorites'
        : 'Removed from favorites';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _onAddToCompare(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to comparison'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onShareProduct(Map<String, dynamic> product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing ${product['name']}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onQuantityChanged(Map<String, dynamic> product, int quantity) {
    setState(() {
      product['selectedQuantity'] = quantity;
    });
  }
}
