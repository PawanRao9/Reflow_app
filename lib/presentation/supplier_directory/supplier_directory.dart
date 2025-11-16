import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/supplier_card_widget.dart';
import './widgets/supplier_filter_widget.dart';
import './widgets/supplier_map_widget.dart';
import './widgets/supplier_search_bar_widget.dart';

class SupplierDirectory extends StatefulWidget {
  const SupplierDirectory({super.key});

  @override
  State<SupplierDirectory> createState() => _SupplierDirectoryState();
}

class _SupplierDirectoryState extends State<SupplierDirectory>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final AudioRecorder _audioRecorder = AudioRecorder();

  bool _isMapView = false;
  bool _isRecording = false;
  // ignore: unused_field
  bool _isLoading = false;
  String _searchQuery = '';

  Map<String, dynamic> _filters = {
    'locationRadius': 50.0,
    'minRating': 0.0,
    'productCategories': <String>[],
    'deliveryOptions': <String>[],
    'paymentTerms': <String>[],
  };

  late TabController _tabController;

  // Mock supplier data
  final List<Map<String, dynamic>> _allSuppliers = [
    {
      'id': 1,
      'name': 'MenstruCare Solutions Pvt Ltd',
      'logo':
          'https://images.unsplash.com/photo-1698311427676-9495b8dc7244',
      'logoSemanticLabel':
          'Modern office building with glass facade representing a healthcare company headquarters',
      'location': 'Mumbai, Maharashtra',
      'latitude': 19.0760,
      'longitude': 72.8777,
      'rating': 4.8,
      'responseTime': '2 hours',
      'fulfillmentRate': '98%',
      'specializations': [
        'Menstrual Cups',
        'Reusable Pads',
        'Organic Products'
      ],
      'isFavorite': true,
      'phone': '+91 98765 43210',
      'email': 'contact@menstrucare.com',
      'whatsapp': '+91 98765 43210',
    },
    {
      'id': 2,
      'name': 'EcoFemme Distributors',
      'logo':
          'https://img.rocket.new/generatedImages/rocket_gen_img_1eb86f8dc-1762701522154.png',
      'logoSemanticLabel':
          'Green eco-friendly logo with leaf design symbolizing sustainable menstrual products',
      'location': 'Bangalore, Karnataka',
      'latitude': 12.9716,
      'longitude': 77.5946,
      'rating': 4.6,
      'responseTime': '4 hours',
      'fulfillmentRate': '95%',
      'specializations': ['Eco-Friendly', 'Period Panties', 'Reusable Pads'],
      'isFavorite': false,
      'phone': '+91 87654 32109',
      'email': 'orders@ecofemme.com',
      'whatsapp': '+91 87654 32109',
    },
    {
      'id': 3,
      'name': 'SHG Supply Network',
      'logo':
          'https://images.unsplash.com/photo-1651372381086-9861c9c81db5',
      'logoSemanticLabel':
          'Community hands joining together in a circle representing self-help group collaboration',
      'location': 'Delhi, NCR',
      'latitude': 28.7041,
      'longitude': 77.1025,
      'rating': 4.4,
      'responseTime': '6 hours',
      'fulfillmentRate': '92%',
      'specializations': ['Menstrual Cups', 'Organic Products'],
      'isFavorite': true,
      'phone': '+91 76543 21098',
      'email': 'info@shgsupply.org',
      'whatsapp': '+91 76543 21098',
    },
    {
      'id': 4,
      'name': 'Rural Health Distributors',
      'logo':
          'https://images.unsplash.com/photo-1680759291617-2923935d803a',
      'logoSemanticLabel':
          'Rural healthcare worker with medical supplies in a village setting',
      'location': 'Pune, Maharashtra',
      'latitude': 18.5204,
      'longitude': 73.8567,
      'rating': 4.2,
      'responseTime': '8 hours',
      'fulfillmentRate': '89%',
      'specializations': ['Reusable Pads', 'Period Panties'],
      'isFavorite': false,
      'phone': '+91 65432 10987',
      'email': 'support@ruralhealthdist.com',
      'whatsapp': '+91 65432 10987',
    },
    {
      'id': 5,
      'name': 'WomenCare Wholesale',
      'logo':
          'https://images.unsplash.com/photo-1691935444218-b4141c1884d3',
      'logoSemanticLabel':
          'Professional woman in healthcare uniform holding medical supplies with caring expression',
      'location': 'Chennai, Tamil Nadu',
      'latitude': 13.0827,
      'longitude': 80.2707,
      'rating': 4.7,
      'responseTime': '3 hours',
      'fulfillmentRate': '96%',
      'specializations': ['Menstrual Cups', 'Eco-Friendly', 'Organic Products'],
      'isFavorite': false,
      'phone': '+91 54321 09876',
      'email': 'wholesale@womencare.in',
      'whatsapp': '+91 54321 09876',
    },
    {
      'id': 6,
      'name': 'Sustainable Periods Co.',
      'logo':
          'https://images.unsplash.com/photo-1656147961287-3f91d30e086e',
      'logoSemanticLabel':
          'Sustainable packaging with green leaves and eco-friendly menstrual products display',
      'location': 'Hyderabad, Telangana',
      'latitude': 17.3850,
      'longitude': 78.4867,
      'rating': 4.3,
      'responseTime': '5 hours',
      'fulfillmentRate': '91%',
      'specializations': ['Period Panties', 'Eco-Friendly'],
      'isFavorite': true,
      'phone': '+91 43210 98765',
      'email': 'contact@sustainableperiods.co',
      'whatsapp': '+91 43210 98765',
    },
  ];

  List<Map<String, dynamic>> _filteredSuppliers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredSuppliers = List.from(_allSuppliers);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _applyFilters();
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredSuppliers = _allSuppliers.where((supplier) {
        // Search query filter
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          final name = (supplier['name'] as String).toLowerCase();
          final location = (supplier['location'] as String).toLowerCase();
          final specializations = (supplier['specializations'] as List<String>)
              .join(' ')
              .toLowerCase();

          if (!name.contains(query) &&
              !location.contains(query) &&
              !specializations.contains(query)) {
            return false;
          }
        }

        // Rating filter
        final rating = (supplier['rating'] as num).toDouble();
        if (rating < (_filters['minRating'] as double)) {
          return false;
        }

        // Product categories filter
        final selectedCategories =
            _filters['productCategories'] as List<String>;
        if (selectedCategories.isNotEmpty) {
          final supplierSpecs = supplier['specializations'] as List<String>;
          if (!selectedCategories.any((cat) => supplierSpecs.contains(cat))) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  Future<void> _startVoiceSearch() async {
    if (_isRecording) {
      await _stopVoiceSearch();
      return;
    }

    try {
      final hasPermission = await _audioRecorder.hasPermission();
      if (!hasPermission) {
        _showSnackBar('Microphone permission is required for voice search');
        return;
      }

      setState(() {
        _isRecording = true;
      });

      await _audioRecorder.start(const RecordConfig(),
          path: 'voice_search.m4a');

      // Auto-stop after 5 seconds
      Future.delayed(const Duration(seconds: 5), () {
        if (_isRecording) {
          _stopVoiceSearch();
        }
      });
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showSnackBar('Voice search is not available');
    }
  }

  Future<void> _stopVoiceSearch() async {
    if (!_isRecording) return;

    try {
      final path = await _audioRecorder.stop();
      setState(() {
        _isRecording = false;
      });

      if (path != null) {
        // Simulate voice recognition result
        _searchController.text = 'menstrual cups mumbai';
        _showSnackBar('Voice search completed');
      }
    } catch (e) {
      setState(() {
        _isRecording = false;
      });
      _showSnackBar('Voice search failed');
    }
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => SupplierFilterWidget(
          currentFilters: _filters,
          onFiltersChanged: (newFilters) {
            setState(() {
              _filters = newFilters;
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  void _toggleFavorite(Map<String, dynamic> supplier) {
    setState(() {
      supplier['isFavorite'] = !(supplier['isFavorite'] as bool);
    });

    final isFavorite = supplier['isFavorite'] as bool;
    _showSnackBar(isFavorite
        ? '${supplier['name']} added to favorites'
        : '${supplier['name']} removed from favorites');
  }

  void _callSupplier(Map<String, dynamic> supplier) {
    final phone = supplier['phone'] as String;
    _showSnackBar('Calling $phone...');
    // In a real app, you would use url_launcher to make the call
  }

  void _whatsAppSupplier(Map<String, dynamic> supplier) {
    final whatsapp = supplier['whatsapp'] as String;
    _showSnackBar('Opening WhatsApp for $whatsapp...');
    // In a real app, you would use url_launcher to open WhatsApp
  }

  void _emailSupplier(Map<String, dynamic> supplier) {
    final email = supplier['email'] as String;
    _showSnackBar('Opening email for $email...');
    // In a real app, you would use url_launcher to send email
  }

  void _viewCatalog(Map<String, dynamic> supplier) {
    _showSnackBar('Opening catalog for ${supplier['name']}...');
    // Navigate to catalog screen
  }

  void _onSupplierTap(Map<String, dynamic> supplier) {
    _showSupplierDetails(supplier);
  }

  void _showSupplierDetails(Map<String, dynamic> supplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => _buildSupplierDetailsSheet(
          supplier,
          scrollController,
        ),
      ),
    );
  }

  Widget _buildSupplierDetailsSheet(
    Map<String, dynamic> supplier,
    ScrollController scrollController,
  ) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 2.h),
            width: 12.w,
            height: 0.5.h,
            decoration: BoxDecoration(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        width: 16.w,
                        height: 16.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageWidget(
                            imageUrl: supplier['logo'] as String,
                            width: 16.w,
                            height: 16.w,
                            fit: BoxFit.cover,
                            semanticLabel:
                                supplier['logoSemanticLabel'] as String,
                          ),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supplier['name'] as String,
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                CustomIconWidget(
                                  iconName: 'location_on',
                                  size: 16,
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 1.w),
                                Expanded(
                                  child: Text(
                                    supplier['location'] as String,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Rating and metrics
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          final rating = (supplier['rating'] as num).toDouble();
                          return CustomIconWidget(
                            iconName:
                                index < rating.floor() ? 'star' : 'star_border',
                            size: 20,
                            color: Colors.amber,
                          );
                        }),
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        '${supplier['rating']} stars',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),

                  // Performance metrics
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricCard(
                          'Response Time',
                          supplier['responseTime'] as String,
                          'schedule',
                          theme,
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildMetricCard(
                          'Fulfillment Rate',
                          supplier['fulfillmentRate'] as String,
                          'check_circle',
                          theme,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),

                  // Specializations
                  Text(
                    'Specializations',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: (supplier['specializations'] as List<String>)
                        .map((spec) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          spec,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 3.h),

                  // Contact actions
                  Text(
                    'Contact Options',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _callSupplier(supplier);
                          },
                          icon: CustomIconWidget(
                            iconName: 'phone',
                            size: 18,
                            color: theme.colorScheme.onPrimary,
                          ),
                          label: Text('Call'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _whatsAppSupplier(supplier);
                          },
                          icon: CustomIconWidget(
                            iconName: 'chat',
                            size: 18,
                            color: Colors.green,
                          ),
                          label: Text('WhatsApp'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.green),
                            foregroundColor: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _emailSupplier(supplier);
                          },
                          icon: CustomIconWidget(
                            iconName: 'email',
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          label: Text('Email'),
                        ),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _viewCatalog(supplier);
                          },
                          icon: CustomIconWidget(
                            iconName: 'inventory_2',
                            size: 18,
                            color: theme.colorScheme.onPrimary,
                          ),
                          label: Text('View Catalog'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, String iconName, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: iconName,
            size: 24,
            color: theme.colorScheme.primary,
          ),
          SizedBox(height: 1.h),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<void> _refreshSuppliers() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _applyFilters();
    });

    _showSnackBar('Supplier directory updated');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.all(4.w),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Supplier Directory'),
        elevation: 1,
        actions: [
          IconButton(
            onPressed: _showFilterBottomSheet,
            icon: CustomIconWidget(
              iconName: 'filter_list',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: 'Filter suppliers',
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
            icon: CustomIconWidget(
              iconName: _isMapView ? 'list' : 'map',
              size: 24,
              color: theme.colorScheme.onSurface,
            ),
            tooltip: _isMapView ? 'List view' : 'Map view',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          SupplierSearchBarWidget(
            controller: _searchController,
            onVoiceSearch: _startVoiceSearch,
            onChanged: (query) {
              // Already handled by listener
            },
            onClear: () {
              _searchController.clear();
            },
          ),

          // Recording indicator
          if (_isRecording)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 1.h),
              color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'mic',
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Listening... Tap to stop',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          // Content
          Expanded(
            child: _isMapView ? _buildMapView() : _buildListView(),
          ),
        ],
      ),
    );
  }

  Widget _buildListView() {
    if (_filteredSuppliers.isEmpty && _searchQuery.isNotEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _refreshSuppliers,
      child: ListView.builder(
        itemCount: _filteredSuppliers.length,
        itemBuilder: (context, index) {
          final supplier = _filteredSuppliers[index];
          return SupplierCardWidget(
            supplier: supplier,
            onTap: () => _onSupplierTap(supplier),
            onFavoriteToggle: () => _toggleFavorite(supplier),
            onCall: () => _callSupplier(supplier),
            onWhatsApp: () => _whatsAppSupplier(supplier),
            onEmail: () => _emailSupplier(supplier),
            onViewCatalog: () => _viewCatalog(supplier),
          );
        },
      ),
    );
  }

  Widget _buildMapView() {
    return SupplierMapWidget(
      suppliers: _filteredSuppliers,
      onSupplierTap: _onSupplierTap,
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'search_off',
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            SizedBox(height: 3.h),
            Text(
              'No suppliers found',
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your search terms or filters to find more suppliers in your area.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 3.h),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _filters = {
                    'locationRadius': 50.0,
                    'minRating': 0.0,
                    'productCategories': <String>[],
                    'deliveryOptions': <String>[],
                    'paymentTerms': <String>[],
                  };
                  _applyFilters();
                });
              },
              icon: CustomIconWidget(
                iconName: 'refresh',
                size: 18,
                color: theme.colorScheme.onPrimary,
              ),
              label: Text('Clear Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
