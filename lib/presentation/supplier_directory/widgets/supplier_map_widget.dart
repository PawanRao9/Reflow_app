import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class SupplierMapWidget extends StatefulWidget {
  final List<Map<String, dynamic>> suppliers;
  final Function(Map<String, dynamic>)? onSupplierTap;

  const SupplierMapWidget({
    super.key,
    required this.suppliers,
    this.onSupplierTap,
  });

  @override
  State<SupplierMapWidget> createState() => _SupplierMapWidgetState();
}

class _SupplierMapWidgetState extends State<SupplierMapWidget> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Map<String, dynamic>? _selectedSupplier;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(20.5937, 78.9629), // Center of India
    zoom: 5.0,
  );

  @override
  void initState() {
    super.initState();
    _createMarkers();
  }

  void _createMarkers() {
    _markers = widget.suppliers.map((supplier) {
      final lat = (supplier['latitude'] as num?)?.toDouble() ?? 0.0;
      final lng = (supplier['longitude'] as num?)?.toDouble() ?? 0.0;

      return Marker(
        markerId: MarkerId(supplier['id'].toString()),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: supplier['name'] as String? ?? 'Unknown Supplier',
          snippet: supplier['location'] as String? ?? 'Location not specified',
          onTap: () => _showSupplierPreview(supplier),
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          _getMarkerColor(supplier),
        ),
        onTap: () => _showSupplierPreview(supplier),
      );
    }).toSet();
  }

  double _getMarkerColor(Map<String, dynamic> supplier) {
    final rating = (supplier['rating'] as num?)?.toDouble() ?? 0.0;
    if (rating >= 4.5) return BitmapDescriptor.hueGreen;
    if (rating >= 4.0) return BitmapDescriptor.hueYellow;
    if (rating >= 3.0) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueRed;
  }

  void _showSupplierPreview(Map<String, dynamic> supplier) {
    setState(() {
      _selectedSupplier = supplier;
    });
  }

  void _hideSupplierPreview() {
    setState(() {
      _selectedSupplier = null;
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;

    // Fit bounds to show all suppliers
    if (widget.suppliers.isNotEmpty) {
      _fitBoundsToSuppliers();
    }
  }

  void _fitBoundsToSuppliers() {
    if (widget.suppliers.isEmpty) return;

    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (final supplier in widget.suppliers) {
      final lat = (supplier['latitude'] as num?)?.toDouble() ?? 0.0;
      final lng = (supplier['longitude'] as num?)?.toDouble() ?? 0.0;

      if (lat < minLat) minLat = lat;
      if (lat > maxLat) maxLat = lat;
      if (lng < minLng) minLng = lng;
      if (lng > maxLng) maxLng = lng;
    }

    _mapController?.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat, minLng),
          northeast: LatLng(maxLat, maxLng),
        ),
        100.0, // padding
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialPosition,
          markers: _markers,
          onTap: (_) => _hideSupplierPreview(),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          zoomControlsEnabled: false,
          mapToolbarEnabled: false,
        ),

        // Supplier preview card
        if (_selectedSupplier != null)
          Positioned(
            bottom: 2.h,
            left: 4.w,
            right: 4.w,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Company logo
                        Container(
                          width: 12.w,
                          height: 12.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CustomImageWidget(
                              imageUrl:
                                  _selectedSupplier!['logo'] as String? ?? '',
                              width: 12.w,
                              height: 12.w,
                              fit: BoxFit.cover,
                              semanticLabel:
                                  _selectedSupplier!['logoSemanticLabel']
                                          as String? ??
                                      'Company logo',
                            ),
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _selectedSupplier!['name'] as String? ??
                                    'Unknown Supplier',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 0.5.h),
                              Row(
                                children: [
                                  CustomIconWidget(
                                    iconName: 'location_on',
                                    size: 14,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 1.w),
                                  Expanded(
                                    child: Text(
                                      _selectedSupplier!['location']
                                              as String? ??
                                          'Location not specified',
                                      style:
                                          theme.textTheme.bodySmall?.copyWith(
                                        color:
                                            theme.colorScheme.onSurfaceVariant,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _hideSupplierPreview,
                          icon: CustomIconWidget(
                            iconName: 'close',
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),

                    // Rating
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            final rating =
                                (_selectedSupplier!['rating'] as num?)
                                        ?.toDouble() ??
                                    0.0;
                            return CustomIconWidget(
                              iconName: index < rating.floor()
                                  ? 'star'
                                  : 'star_border',
                              size: 16,
                              color: Colors.amber,
                            );
                          }),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          ((_selectedSupplier!['rating'] as num?)?.toDouble() ??
                                  0.0)
                              .toStringAsFixed(1),
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            widget.onSupplierTap?.call(_selectedSupplier!);
                            _hideSupplierPreview();
                          },
                          child: Text('View Details'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 1.h),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
