import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widget/bulk_pricing_table.dart';
import './widget/customer_reviews.dart';
import './widget/product_image_carousel.dart';
import './widget/product_specifications.dart';
import './widget/quantity_selector.dart';
import './widget/related_products.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedQuantity = 50;
  bool _isFavorite = false;
  bool _isAddingToCart = false;

  // Mock product data
  final Map<String, dynamic> productData = {
    "id": "MC001",
    "name": "EcoFlow Menstrual Cup - Medical Grade Silicone",
    "brand": "EcoFlow Healthcare",
    "model": "Premium Series",
    "description":
        "Premium medical-grade silicone menstrual cup designed for comfort and reliability. FDA approved and eco-friendly alternative to disposable products. Suitable for heavy flow days with 12-hour protection.",
    "images": [
      {
        "url":
            "https://images.unsplash.com/photo-1712842955568-806a43cc7ee1",
        "semanticLabel":
            "Medical grade silicone menstrual cup in soft pink color displayed on white background with packaging"
      },
      {
        "url":
            "https://images.unsplash.com/photo-1642853475040-fae843cbfa1a",
        "semanticLabel":
            "Close-up view of menstrual cup showing flexible rim and smooth surface texture"
      },
      {
        "url":
            "https://images.unsplash.com/photo-1525170687111-8a614dec9501",
        "semanticLabel":
            "Menstrual cup size comparison chart showing small, medium and large sizes"
      }
    ],
    "unitPrice": 450.0,
    "currency": "₹",
    "minOrderQuantity": 50,
    "maxAvailableStock": 2500,
    "bulkIncrements": [10, 50, 100],
    "pricingTiers": [
      {
        "range": "50-99 units",
        "unitPrice": "450.00",
        "savings": 0,
        "recommended": false
      },
      {
        "range": "100-499 units",
        "unitPrice": "405.00",
        "savings": 10,
        "recommended": true
      },
      {
        "range": "500-999 units",
        "unitPrice": "360.00",
        "savings": 20,
        "recommended": false
      },
      {
        "range": "1000+ units",
        "unitPrice": "315.00",
        "savings": 30,
        "recommended": false
      }
    ],
    "specifications": {
      "basic": [
        {
          "label": "Material",
          "value": "Medical Grade Silicone",
          "icon": "medical_services"
        },
        {
          "label": "Sizes Available",
          "value": "Small, Medium, Large",
          "icon": "straighten"
        },
        {"label": "Capacity", "value": "30ml (Large)", "icon": "water_drop"},
        {
          "label": "Shelf Life",
          "value": "10 years with proper care",
          "icon": "schedule"
        }
      ],
      "detailed": [
        {
          "label": "Color Options",
          "value": "Clear, Pink, Purple",
          "icon": "palette"
        },
        {
          "label": "Sterilization",
          "value": "Boiling water compatible",
          "icon": "local_fire_department"
        },
        {"label": "Weight", "value": "25g (Medium size)", "icon": "scale"},
        {
          "label": "Packaging",
          "value": "Individual sterile pouch",
          "icon": "inventory_2"
        }
      ],
      "certifications": [
        {"name": "FDA Approved"},
        {"name": "CE Marked"},
        {"name": "ISO 13485"},
        {"name": "BIS Certified"}
      ]
    },
    "averageRating": 4.6,
    "totalReviews": 1247,
    "reviews": [
      {
        "reviewerName": "Dr. Priya Sharma",
        "rating": 5.0,
        "date": "2 weeks ago",
        "comment":
            "Excellent quality product. Our pharmacy customers are very satisfied with the comfort and durability. Great bulk pricing for distributors.",
        "verified": true,
        "businessType": "Pharmacy Owner"
      },
      {
        "reviewerName": "Meera Distributors",
        "rating": 4.5,
        "date": "1 month ago",
        "comment":
            "Good product quality and fast delivery. The packaging is professional and customers trust the brand. Will order again.",
        "verified": true,
        "businessType": "Medical Distributor"
      },
      {
        "reviewerName": "Anita SHG Coordinator",
        "rating": 4.8,
        "date": "3 weeks ago",
        "comment":
            "Our self-help group members love this product. Easy to use and very cost-effective for our community program.",
        "verified": true,
        "businessType": "SHG Coordinator"
      }
    ]
  };

  final List<Map<String, dynamic>> relatedProducts = [
    {
      "id": "RP001",
      "name": "Organic Cotton Reusable Pads",
      "brand": "NatureCare",
      "price": "280.00",
      "minOrder": "25",
      "rating": 4.4,
      "reviewCount": 892,
      "image":
          "https://images.unsplash.com/photo-1588959570984-9f1e0e9a91a6",
      "semanticLabel":
          "Organic cotton reusable menstrual pads in white and beige colors with floral pattern"
    },
    {
      "id": "RP002",
      "name": "Period Panties - Leak Proof",
      "brand": "ComfortFit",
      "price": "650.00",
      "minOrder": "20",
      "rating": 4.3,
      "reviewCount": 567,
      "image":
          "https://images.unsplash.com/photo-1712677177804-245093f4f626",
      "semanticLabel":
          "Black leak-proof period panties displayed on white background showing comfortable fit design"
    },
    {
      "id": "RP003",
      "name": "Menstrual Cup Sterilizer",
      "brand": "HygieneFirst",
      "price": "1200.00",
      "minOrder": "10",
      "rating": 4.7,
      "reviewCount": 234,
      "image":
          "https://images.unsplash.com/photo-1724246924459-ed90728ceaf9",
      "semanticLabel":
          "Compact UV sterilizer device for menstrual cups with digital display and white casing"
    }
  ];

  void _onQuantityChanged(int quantity) {
    setState(() {
      _selectedQuantity = quantity;
    });
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isAddingToCart = false;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_selectedQuantity units to cart'),
        backgroundColor: AppTheme.getSuccessColor(true),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _shareProduct() {
    // Share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Product details shared successfully'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _selectedQuantity * (productData["unitPrice"] as double);

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Main content
          CustomScrollView(
            slivers: [
              // App bar with large back button and share
              SliverAppBar(
                expandedHeight: 50.h,
                pinned: true,
                backgroundColor: AppTheme.lightTheme.colorScheme.surface,
                leading: Container(
                  margin: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: CustomIconWidget(
                      iconName: 'arrow_back',
                      color: Colors.white,
                      size: 6.w,
                    ),
                  ),
                ),
                actions: [
                  Container(
                    margin: EdgeInsets.all(2.w),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(2.w),
                    ),
                    child: IconButton(
                      onPressed: _shareProduct,
                      icon: CustomIconWidget(
                        iconName: 'share',
                        color: Colors.white,
                        size: 5.w,
                      ),
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ProductImageCarousel(
                    images: (productData["images"] as List)
                        .cast<Map<String, dynamic>>(),
                    productName: productData["name"] as String,
                  ),
                ),
              ),

              // Product details
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name and basic info
                    Container(
                      padding: EdgeInsets.all(4.w),
                      color: AppTheme.lightTheme.colorScheme.surface,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            productData["name"] as String,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Row(
                            children: [
                              Text(
                                productData["brand"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              SizedBox(width: 2.w),
                              Container(
                                width: 1,
                                height: 4.w,
                                color: AppTheme.lightTheme.colorScheme.outline,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                productData["model"] as String,
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            productData["description"] as String,
                            style: AppTheme.lightTheme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 2.h),

                    // Bulk pricing table
                    BulkPricingTable(
                      pricingTiers: (productData["pricingTiers"] as List)
                          .cast<Map<String, dynamic>>(),
                      currency: productData["currency"] as String,
                    ),

                    // Quantity selector
                    QuantitySelector(
                      initialQuantity: _selectedQuantity,
                      minOrderQuantity: productData["minOrderQuantity"] as int,
                      maxAvailableStock:
                          productData["maxAvailableStock"] as int,
                      bulkIncrements:
                          (productData["bulkIncrements"] as List).cast<int>(),
                      onQuantityChanged: _onQuantityChanged,
                      unitPrice: productData["unitPrice"] as double,
                      currency: productData["currency"] as String,
                    ),

                    // Product specifications
                    ProductSpecifications(
                      specifications:
                          productData["specifications"] as Map<String, dynamic>,
                    ),

                    // Customer reviews
                    CustomerReviews(
                      reviews: (productData["reviews"] as List)
                          .cast<Map<String, dynamic>>(),
                      averageRating: productData["averageRating"] as double,
                      totalReviews: productData["totalReviews"] as int,
                    ),

                    // Related products
                    RelatedProducts(
                      products: relatedProducts,
                    ),

                    // Bottom padding for sticky bar
                    SizedBox(height: 12.h),
                  ],
                ),
              ),
            ],
          ),

          // Sticky bottom bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.lightTheme.colorScheme.shadow
                        .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    // Favorite button
                    GestureDetector(
                      onTap: _toggleFavorite,
                      child: Container(
                        width: 12.w,
                        height: 6.h,
                        decoration: BoxDecoration(
                          color: _isFavorite
                              ? AppTheme.lightTheme.colorScheme.errorContainer
                              : AppTheme.lightTheme.colorScheme.outline
                                  .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(2.w),
                          border: Border.all(
                            color: _isFavorite
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme.lightTheme.colorScheme.outline,
                          ),
                        ),
                        child: Center(
                          child: CustomIconWidget(
                            iconName:
                                _isFavorite ? 'favorite' : 'favorite_border',
                            color: _isFavorite
                                ? AppTheme.lightTheme.colorScheme.error
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 5.w,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: 3.w),

                    // Price and add to cart
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Total: ${productData["currency"]}${totalPrice.toStringAsFixed(2)}',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppTheme.lightTheme.primaryColor,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: ElevatedButton(
                              onPressed: _isAddingToCart ? null : _addToCart,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.w),
                                ),
                              ),
                              child: _isAddingToCart
                                  ? SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      ),
                                    )
                                  : Text(
                                      'Add to Cart ($_selectedQuantity units)',
                                      style: AppTheme
                                          .lightTheme.textTheme.labelLarge
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
