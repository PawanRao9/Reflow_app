import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ProductImageCarousel extends StatefulWidget {
  final List<Map<String, dynamic>> images;
  final String productName;

  const ProductImageCarousel({
    Key? key,
    required this.images,
    required this.productName,
  }) : super(key: key);

  @override
  State<ProductImageCarousel> createState() => _ProductImageCarouselState();
}

class _ProductImageCarouselState extends State<ProductImageCarousel> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  bool _isZoomed = false;
  TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _pageController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformationController.value = Matrix4.identity();
    setState(() {
      _isZoomed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.h,
      width: double.infinity,
      child: Stack(
        children: [
          // Image carousel with zoom functionality
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
              _resetZoom();
            },
            itemCount: widget.images.length,
            itemBuilder: (context, index) {
              final image = widget.images[index];
              return GestureDetector(
                onDoubleTap: () {
                  if (_isZoomed) {
                    _resetZoom();
                  } else {
                    _transformationController.value = Matrix4.identity()
                      ..scale(2.0);
                    setState(() {
                      _isZoomed = true;
                    });
                  }
                },
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  minScale: 1.0,
                  maxScale: 4.0,
                  onInteractionStart: (details) {
                    if (_transformationController.value.getMaxScaleOnAxis() >
                        1.0) {
                      setState(() {
                        _isZoomed = true;
                      });
                    }
                  },
                  onInteractionEnd: (details) {
                    if (_transformationController.value.getMaxScaleOnAxis() <=
                        1.0) {
                      setState(() {
                        _isZoomed = false;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: CustomImageWidget(
                      imageUrl: image["url"] as String,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.contain,
                      semanticLabel: image["semanticLabel"] as String,
                    ),
                  ),
                ),
              );
            },
          ),

          // Page indicators
          Positioned(
            bottom: 2.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                  width: _currentIndex == index ? 4.w : 2.w,
                  height: 1.h,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.primaryColor
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(1.h),
                  ),
                ),
              ),
            ),
          ),

          // Zoom indicator
          if (_isZoomed)
            Positioned(
              top: 2.h,
              right: 4.w,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(2.h),
                ),
                child: Text(
                  'Pinch to zoom out',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
