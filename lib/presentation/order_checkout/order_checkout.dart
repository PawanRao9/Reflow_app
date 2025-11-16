import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/checkout_progress_indicator.dart';
import './widgets/delivery_date_selector.dart';
import './widgets/delivery_information_card.dart';
import './widgets/order_summary_card.dart';
import './widgets/payment_method_section.dart';
import './widgets/special_instructions_field.dart';
import './widgets/terms_acceptance_checkbox.dart';

class OrderCheckout extends StatefulWidget {
  const OrderCheckout({super.key});

  @override
  State<OrderCheckout> createState() => _OrderCheckoutState();
}

class _OrderCheckoutState extends State<OrderCheckout> {
  int _currentStep = 0;
  final List<String> _steps = ['Review', 'Payment', 'Confirmation'];

  // Form controllers
  final _instructionsController = TextEditingController();

  // Selection states
  Map<String, dynamic>? _selectedAddress;
  Map<String, dynamic>? _selectedDeliverySlot;
  Map<String, dynamic>? _selectedPayment;
  bool _termsAccepted = false;
  bool _isProcessingOrder = false;

  // Mock data
  final List<Map<String, dynamic>> _orderItems = [
    {
      "id": 1,
      "name": "Menstrual Cup - Size S",
      "image":
          "https://images.unsplash.com/photo-1712659847335-1252d0b33eb4",
      "semanticLabel":
          "Pink silicone menstrual cup displayed on white background with soft lighting",
      "quantity": 50,
      "price": 450.0,
      "total": 22500.0,
    },
    {
      "id": 2,
      "name": "Reusable Cloth Pads - Regular",
      "image":
          "https://images.unsplash.com/photo-1643297133069-fd5ae3f440d0",
      "semanticLabel":
          "Colorful organic cotton reusable menstrual pads arranged in a neat stack",
      "quantity": 100,
      "price": 180.0,
      "total": 18000.0,
    },
    {
      "id": 3,
      "name": "Period Panties - Medium",
      "image":
          "https://images.unsplash.com/photo-1705957946296-d5739f903fba",
      "semanticLabel":
          "Black period underwear with absorbent layer displayed on neutral background",
      "quantity": 75,
      "price": 320.0,
      "total": 24000.0,
    },
  ];

  final Map<String, dynamic> _orderTotals = {
    "subtotal": 64500.0,
    "gst": 11610.0,
    "delivery": 500.0,
    "total": 76610.0,
  };

  final List<Map<String, dynamic>> _savedAddresses = [
    {
      "id": 1,
      "name": "Dr. Priya Sharma",
      "phone": "+91 98765 43210",
      "address": "123 Medical Complex, MG Road",
      "city": "Mumbai",
      "pincode": "400001",
      "type": "Clinic",
    },
    {
      "id": 2,
      "name": "Asha Women's SHG",
      "phone": "+91 87654 32109",
      "address": "456 Community Center, Gandhi Nagar",
      "city": "Pune",
      "pincode": "411001",
      "type": "SHG",
    },
  ];

  final List<Map<String, dynamic>> _availableSlots = [
    {
      "id": 1,
      "date": "Tomorrow, Nov 10",
      "timeSlot": "9:00 AM - 1:00 PM",
      "supplier": "MedSupply Express",
      "charges": 0,
      "available": true,
    },
    {
      "id": 2,
      "date": "Nov 11, 2025",
      "timeSlot": "2:00 PM - 6:00 PM",
      "supplier": "HealthCare Logistics",
      "charges": 200,
      "available": true,
    },
    {
      "id": 3,
      "date": "Nov 12, 2025",
      "timeSlot": "10:00 AM - 2:00 PM",
      "supplier": "Quick Delivery Co",
      "charges": 150,
      "available": false,
    },
  ];

  final List<Map<String, dynamic>> _savedCards = [
    {
      "id": "card1",
      "name": "HDFC Debit Card",
      "cardNumber": "4532",
      "type": "card",
      "description": "Expires 12/26",
    },
    {
      "id": "card2",
      "name": "SBI Credit Card",
      "cardNumber": "5678",
      "type": "card",
      "description": "Expires 08/27",
    },
  ];

  final List<Map<String, dynamic>> _upiOptions = [
    {
      "id": "gpay",
      "name": "Google Pay",
      "type": "upi",
      "description": "Pay using Google Pay UPI",
      "icon":
          "https://img.rocket.new/generatedImages/rocket_gen_img_15e581737-1762701520143.png",
      "semanticLabel":
          "Google Pay logo with colorful G symbol on white background",
    },
    {
      "id": "phonepe",
      "name": "PhonePe",
      "type": "upi",
      "description": "Pay using PhonePe UPI",
      "icon":
          "https://img.rocket.new/generatedImages/rocket_gen_img_16fce12b8-1762701522713.png",
      "semanticLabel": "PhonePe logo with purple phone icon and brand name",
    },
    {
      "id": "paytm",
      "name": "Paytm",
      "type": "upi",
      "description": "Pay using Paytm UPI",
      "icon":
          "https://img.rocket.new/generatedImages/rocket_gen_img_18f125583-1762701520184.png",
      "semanticLabel":
          "Paytm logo with blue and white brand colors and payment symbol",
    },
  ];

  @override
  void initState() {
    super.initState();
    // Set default selections
    if (_savedAddresses.isNotEmpty) {
      _selectedAddress = _savedAddresses.first;
    }
    if (_availableSlots.where((slot) => slot["available"] as bool).isNotEmpty) {
      _selectedDeliverySlot =
          _availableSlots.firstWhere((slot) => slot["available"] as bool);
    }
  }

  @override
  void dispose() {
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order Checkout',
        variant: CustomAppBarVariant.back,
        onBackPressed: _handleBackNavigation,
      ),
      body: Column(
        children: [
          CheckoutProgressIndicator(
            currentStep: _currentStep,
            steps: _steps,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  OrderSummaryCard(
                    orderItems: _orderItems,
                    orderTotals: _orderTotals,
                  ),
                  DeliveryInformationCard(
                    savedAddresses: _savedAddresses,
                    selectedAddress: _selectedAddress,
                    onAddressSelected: (address) {
                      setState(() => _selectedAddress = address);
                    },
                    onAddNewAddress: () {
                      // Handle add new address
                    },
                  ),
                  DeliveryDateSelector(
                    availableSlots: _availableSlots,
                    selectedSlot: _selectedDeliverySlot,
                    onSlotSelected: (slot) {
                      setState(() => _selectedDeliverySlot = slot);
                    },
                  ),
                  PaymentMethodSection(
                    savedCards: _savedCards,
                    upiOptions: _upiOptions,
                    selectedPayment: _selectedPayment,
                    onPaymentSelected: (payment) {
                      setState(() => _selectedPayment = payment);
                    },
                  ),
                  SpecialInstructionsField(
                    controller: _instructionsController,
                  ),
                  TermsAcceptanceCheckbox(
                    isAccepted: _termsAccepted,
                    onChanged: (accepted) {
                      setState(() => _termsAccepted = accepted);
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: ElevatedButton(
                onPressed: _canPlaceOrder() ? _placeOrder : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 7.h),
                  backgroundColor: _canPlaceOrder()
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.3),
                ),
                child: _isProcessingOrder
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 5.w,
                            height: 5.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            'Processing...',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomIconWidget(
                            iconName: 'shopping_cart_checkout',
                            color: theme.colorScheme.onPrimary,
                            size: 5.w,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Place Order • ₹${_orderTotals["total"]}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
          CustomBottomBar(
            currentIndex: 1,
            onTap: (index) {
              // Handle bottom navigation
            },
          ),
        ],
      ),
    );
  }

  bool _canPlaceOrder() {
    return _selectedAddress != null &&
        _selectedDeliverySlot != null &&
        _selectedPayment != null &&
        _termsAccepted &&
        !_isProcessingOrder;
  }

  void _handleBackNavigation() {
    if (_instructionsController.text.isNotEmpty ||
        _selectedAddress != null ||
        _selectedPayment != null) {
      _showUnsavedChangesDialog();
    } else {
      Navigator.pop(context);
    }
  }

  void _showUnsavedChangesDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Unsaved Changes',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'You have unsaved changes in your checkout. Are you sure you want to go back?',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Stay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text(
              'Go Back',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    if (!_canPlaceOrder()) return;

    setState(() => _isProcessingOrder = true);

    try {
      // Simulate order processing
      await Future.delayed(const Duration(seconds: 3));

      // Simulate payment processing based on selected method
      if (_selectedPayment?["type"] == "card") {
        await _processCardPayment();
      } else if (_selectedPayment?["type"] == "upi") {
        await _processUpiPayment();
      } else if (_selectedPayment?["id"] == "netbanking") {
        await _processNetBankingPayment();
      } else if (_selectedPayment?["id"] == "cod") {
        await _processCodOrder();
      }

      // Generate order confirmation
      final orderNumber = 'MC${DateTime.now().millisecondsSinceEpoch}';

      setState(() => _isProcessingOrder = false);

      _showOrderSuccessDialog(orderNumber);
    } catch (e) {
      setState(() => _isProcessingOrder = false);
      _showOrderErrorDialog(e.toString());
    }
  }

  Future<void> _processCardPayment() async {
    // Simulate biometric authentication for saved cards
    if (kIsWeb) {
      // Web payment processing
      await Future.delayed(const Duration(seconds: 1));
    } else {
      // Mobile biometric verification
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<void> _processUpiPayment() async {
    // Simulate UPI payment flow
    if (kIsWeb) {
      // Web UPI redirect
      await Future.delayed(const Duration(seconds: 2));
    } else {
      // Mobile app-to-app UPI
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  Future<void> _processNetBankingPayment() async {
    // Simulate net banking redirect
    await Future.delayed(const Duration(seconds: 2));
  }

  Future<void> _processCodOrder() async {
    // COD order confirmation
    await Future.delayed(const Duration(seconds: 1));
  }

  void _showOrderSuccessDialog(String orderNumber) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: CustomIconWidget(
                iconName: 'check_circle',
                color: theme.colorScheme.primary,
                size: 12.w,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Order Placed Successfully!',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Order Number: $orderNumber',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 1.h),
            Text(
              'You will receive a confirmation SMS and email shortly.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/order-history');
            },
            child: Text('View Orders'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/bulk-order-cart');
            },
            child: Text('Continue Shopping'),
          ),
        ],
      ),
    );
  }

  void _showOrderErrorDialog(String error) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'error',
              color: theme.colorScheme.error,
              size: 6.w,
            ),
            SizedBox(width: 2.w),
            Text(
              'Order Failed',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.error,
              ),
            ),
          ],
        ),
        content: Text(
          'We encountered an issue while processing your order. Please check your payment method and try again.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Try Again'),
          ),
        ],
      ),
    );
  }
}
