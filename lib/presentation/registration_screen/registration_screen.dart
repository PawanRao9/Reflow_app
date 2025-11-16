import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widget/business_type_selector.dart';
import './widget/document_upload_section.dart';
import './widget/registration_form_fields.dart';
import './widget/registration_progress_indicator.dart';
import './widget/terms_acceptance_widget.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  // Form Controllers
  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _gstController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Form State
  String _selectedBusinessType = '';
  List<XFile> _uploadedDocuments = [];
  bool _termsAccepted = false;
  String _passwordStrength = '';
  int _currentStep = 1;
  final int _totalSteps = 4;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _ownerNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _gstController.dispose();
    _passwordController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final password = _passwordController.text;
    String strength = '';

    if (password.isEmpty) {
      strength = '';
    } else if (password.length < 6) {
      strength = 'Weak';
    } else if (password.length < 8 ||
        !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(password)) {
      strength = 'Medium';
    } else if (RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
        .hasMatch(password)) {
      strength = 'Strong';
    } else {
      strength = 'Medium';
    }

    if (strength != _passwordStrength) {
      setState(() {
        _passwordStrength = strength;
      });
    }
  }

  bool get _showGstField =>
      _selectedBusinessType == 'pharmacy' ||
      _selectedBusinessType == 'distributor';

  bool _canProceedToNextStep() {
    switch (_currentStep) {
      case 1:
        return _selectedBusinessType.isNotEmpty;
      case 2:
        return _formKey.currentState?.validate() ?? false;
      case 3:
        return _uploadedDocuments.isNotEmpty;
      case 4:
        return _termsAccepted;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (_canProceedToNextStep()) {
      if (_currentStep < _totalSteps) {
        setState(() {
          _currentStep++;
        });
        _pageController.nextPage(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        _submitRegistration();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 1) {
      setState(() {
        _currentStep--;
      });
      _pageController.previousPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showLocationServiceDialog();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showLocationPermissionDialog();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showLocationPermissionDialog();
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // In a real app, you would reverse geocode this to get address
      setState(() {
        _addressController.text =
            'Lat: ${position.latitude.toStringAsFixed(4)}, Lng: ${position.longitude.toStringAsFixed(4)}';
      });
    } catch (e) {
      _showErrorSnackBar(
          'Failed to get location. Please enter address manually.');
    }
  }

  void _showLocationServiceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Service Disabled'),
        content: Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Required'),
        content: Text(
            'Location permission is required to auto-fill your address. Please enable it in settings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }

  void _showTermsModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                'Terms & Conditions',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Text(
                    '''
MenstruCare Pro - Terms & Conditions

1. ACCEPTANCE OF TERMS
By creating an account with MenstruCare Pro, you agree to be bound by these Terms & Conditions and our Privacy Policy.

2. BUSINESS ACCOUNT REQUIREMENTS
- You must be authorized to represent your business
- All information provided must be accurate and current
- Business verification documents are required
- GST registration required for pharmacies and distributors

3. BULK ORDERING TERMS
- Minimum order quantities apply to all products
- Pricing is subject to change based on volume
- Payment terms: Net 30 days for verified businesses
- Orders are subject to product availability

4. PRODUCT INFORMATION
- All menstrual products meet Indian regulatory standards
- Product specifications are provided for reference
- Bulk packaging may differ from retail packaging

5. DELIVERY & LOGISTICS
- Delivery timelines vary by location
- Rural delivery may take additional time
- Tracking information provided for all orders

6. PAYMENT TERMS
- Multiple payment options available
- Credit terms available for verified businesses
- Late payment charges may apply

7. RETURNS & REFUNDS
- Defective products can be returned within 30 days
- Bulk orders have specific return policies
- Refunds processed within 7-10 business days

8. DATA PRIVACY
- Your business data is protected
- We comply with Indian data protection laws
- Information sharing limited to order fulfillment

9. LIMITATION OF LIABILITY
- Service provided "as is"
- Limited liability for business losses
- Force majeure events excluded

10. TERMINATION
- Either party may terminate with 30 days notice
- Outstanding orders must be fulfilled
- Data retention as per privacy policy

For questions, contact: support@menstrucarepro.com
Last updated: November 2024
                    ''',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRegistration() async {
    if (!_formKey.currentState!.validate() || !_termsAccepted) {
      _showErrorSnackBar(
          'Please complete all required fields and accept terms.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      // Show success dialog
      _showSuccessDialog();
    } catch (e) {
      _showErrorSnackBar('Registration failed. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: AppTheme.lightTheme.colorScheme.tertiary,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text('Registration Successful'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your account has been created successfully!'),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Verification Timeline:',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text('• Document review: 24-48 hours'),
                  Text('• Business verification: 2-3 business days'),
                  Text('• Full access: Upon verification completion'),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              'You can access the dashboard with limited features until verification is complete.',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/dashboard');
            },
            child: Text('Go to Dashboard'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.lightTheme.colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return BusinessTypeSelector(
          selectedType: _selectedBusinessType,
          onTypeSelected: (type) {
            setState(() {
              _selectedBusinessType = type;
            });
          },
        );
      case 2:
        return RegistrationFormFields(
          formKey: _formKey,
          businessNameController: _businessNameController,
          ownerNameController: _ownerNameController,
          phoneController: _phoneController,
          emailController: _emailController,
          addressController: _addressController,
          gstController: _gstController,
          passwordController: _passwordController,
          selectedBusinessType: _selectedBusinessType,
          showGstField: _showGstField,
          passwordStrength: _passwordStrength,
          onLocationPicker: _getCurrentLocation,
        );
      case 3:
        return DocumentUploadSection(
          uploadedDocuments: _uploadedDocuments,
          onDocumentsChanged: (documents) {
            setState(() {
              _uploadedDocuments = documents;
            });
          },
          selectedBusinessType: _selectedBusinessType,
        );
      case 4:
        return TermsAcceptanceWidget(
          isAccepted: _termsAccepted,
          onChanged: (value) {
            setState(() {
              _termsAccepted = value ?? false;
            });
          },
          onViewTerms: _showTermsModal,
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Register'),
        leading: _currentStep > 1
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 24,
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/login-screen'),
            child: Text(
              'Login',
              style: TextStyle(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          RegistrationProgressIndicator(
            currentStep: _currentStep,
            totalSteps: _totalSteps,
          ),

          // Step Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _totalSteps,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  padding: EdgeInsets.all(4.w),
                  child: _buildStepContent(),
                );
              },
            ),
          ),

          // Bottom Action Button
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed:
                      _canProceedToNextStep() && !_isLoading ? _nextStep : null,
                  child: _isLoading
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.lightTheme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Text(
                          _currentStep == _totalSteps
                              ? 'Create Account'
                              : 'Continue',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
