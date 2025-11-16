import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Login Screen
  String get loginTitle => 'Login';
  String get email => 'Email';
  String get password => 'Password';
  String get login => 'Login';
  String get forgotPassword => 'Forgot Password?';
  String get rememberMe => 'Remember Me';
  String get biometricLogin => 'Biometric Login';
  String get newBusiness => 'New Business?';
  String get registerNow => 'Register Now';
  String get needHelp => 'Need help? Contact Support';
  String get quickLogin => 'Quick Login';
  String get welcomeBack => 'Welcome back';
  String get invalidCredentials => 'Invalid credentials. Try these demo accounts:';
  String get loginFailed => 'Login Failed';
  String get close => 'Close';
  String get tryDemo => 'Try Demo';
  String get connectionError => 'Connection Error';
  String get checkConnection => 'Please check your internet connection and try again.';
  String get offlineMode => 'Offline mode available after first login';
  String get cancel => 'Cancel';
  String get retry => 'Retry';
  String get resetPassword => 'Reset Password';
  String get enterEmail => 'Enter your email address to receive password reset instructions.';
  String get sendResetLink => 'Send Reset Link';
  String get resetInstructionsSent => 'Reset instructions sent successfully';

  // Language names
  String get english => 'English';
  String get hindi => 'हिंदी';
  String get marathi => 'मराठी';
  String get gujarati => 'ગુજરાતી';
  String get tamil => 'தமிழ்';
  String get telugu => 'తెలుగు';

  // User types
  String get pharmacyOwner => 'Pharmacy Owner';
  String get medicalDistributorUser => 'Medical Distributor';
  String get shgCoordinator => 'SHG Coordinator';

  // Common
  String get emailCopied => 'Email copied!';
  String get passwordCopied => 'Password copied!';
  String get version => 'MenstruCare Pro v2.1.0';

  // Splash Screen
  String get initializing => 'Initializing...';
  String get checkingAuth => 'Checking authentication...';
  String get loadingPermissions => 'Loading permissions...';
  String get fetchingConfig => 'Fetching configuration...';
  String get preparingInventory => 'Preparing inventory data...';
  String get ready => 'Ready!';
  String get appName => 'MenstruCare';
  String get appTagline => 'Connect';
  String get appDescription => 'Empowering Sustainable Menstrual Health';
  String get versionShort => 'Version 1.0.0';

  // Registration Screen
  String get register => 'Register';
  String get createAccount => 'Create Account';
  String get registrationSuccessful => 'Registration Successful!';
  String get accountCreated => 'Your account has been created successfully!';
  String get verificationTimeline => 'Verification Timeline:';
  String get documentReview => 'Document review: 24-48 hours';
  String get businessVerification => 'Business verification: 2-3 business days';
  String get fullAccess => 'Full access: Upon verification completion';
  String get limitedAccess => 'You can access the dashboard with limited features until verification is complete.';
  String get goToDashboard => 'Go to Dashboard';
  String get completeFields => 'Please complete all required fields and accept terms.';
  String get registrationFailed => 'Registration failed. Please try again.';
  String get locationServiceDisabled => 'Location Service Disabled';
  String get enableLocationServices => 'Please enable location services to use this feature.';
  String get locationPermissionRequired => 'Location Permission Required';
  String get locationPermissionMessage => 'Location permission is required to auto-fill your address. Please enable it in settings.';
  String get settings => 'Settings';
  String get locationFailed => 'Failed to get location. Please enter address manually.';
  String get termsAndConditions => 'Terms & Conditions';
  String get termsTitle => 'MenstruCare Pro - Terms & Conditions';
  String get acceptanceOfTerms => 'ACCEPTANCE OF TERMS';
  String get termsAcceptanceText => 'By creating an account with MenstruCare Pro, you agree to be bound by these Terms & Conditions and our Privacy Policy.';
  String get businessRequirements => 'BUSINESS ACCOUNT REQUIREMENTS';
  String get authorizedRepresentative => 'You must be authorized to represent your business';
  String get accurateInformation => 'All information provided must be accurate and current';
  String get verificationDocuments => 'Business verification documents are required';
  String get gstRequiredTerms => 'GST registration required for pharmacies and distributors';
  String get bulkOrderingTerms => 'BULK ORDERING TERMS';
  String get minimumOrderQuantities => 'Minimum order quantities apply to all products';
  String get pricingSubjectToChange => 'Pricing is subject to change based on volume';
  String get paymentTerms => 'Payment terms: Net 30 days for verified businesses';
  String get ordersSubjectToAvailability => 'Orders are subject to product availability';
  String get productInformation => 'PRODUCT INFORMATION';
  String get regulatoryStandards => 'All menstrual products meet Indian regulatory standards';
  String get productSpecifications => 'Product specifications are provided for reference';
  String get bulkPackaging => 'Bulk packaging may differ from retail packaging';
  String get deliveryLogistics => 'DELIVERY & LOGISTICS';
  String get deliveryTimelines => 'Delivery timelines vary by location';
  String get ruralDelivery => 'Rural delivery may take additional time';
  String get trackingInformation => 'Tracking information provided for all orders';
  String get paymentTermsTitle => 'PAYMENT TERMS';
  String get multiplePaymentOptions => 'Multiple payment options available';
  String get creditTerms => 'Credit terms available for verified businesses';
  String get latePaymentCharges => 'Late payment charges may apply';
  String get returnsRefunds => 'RETURNS & REFUNDS';
  String get defectiveProducts => 'Defective products can be returned within 30 days';
  String get bulkOrderPolicies => 'Bulk orders have specific return policies';
  String get refundsProcessed => 'Refunds processed within 7-10 business days';
  String get dataPrivacy => 'DATA PRIVACY';
  String get businessDataProtected => 'Your business data is protected';
  String get complianceLaws => 'We comply with Indian data protection laws';
  String get informationSharing => 'Information sharing limited to order fulfillment';
  String get limitationLiability => 'LIMITATION OF LIABILITY';
  String get serviceAsIs => 'Service provided "as is"';
  String get limitedLiability => 'Limited liability for business losses';
  String get forceMajeure => 'Force majeure events excluded';
  String get termination => 'TERMINATION';
  String get terminationNotice => 'Either party may terminate with 30 days notice';
  String get outstandingOrders => 'Outstanding orders must be fulfilled';
  String get dataRetention => 'Data retention as per privacy policy';
  String get contactSupport => 'For questions, contact: support@menstrucarepro.com';
  String get lastUpdated => 'Last updated: November 2024';

  // Registration Form Fields
  String get businessName => 'Business Name';
  String get enterBusinessName => 'Enter your business name';
  String get ownerName => 'Owner Name';
  String get enterOwnerName => 'Enter owner full name';
  String get phoneNumber => 'Phone Number';
  String get enterPhoneNumber => 'Enter 10-digit mobile number';
  String get emailAddress => 'Email Address';
  String get enterBusinessEmail => 'Enter business email';
  String get businessAddress => 'Business Address';
  String get enterCompleteAddress => 'Enter complete business address';
  String get gstNumber => 'GST Number';
  String get enterGstNumber => 'Enter 15-digit GST number';
  String get createPassword => 'Create strong password';
  String get passwordStrength => 'Password Strength: ';
  String get businessNameRequired => 'Business name is required';
  String get businessNameMinLength => 'Business name must be at least 2 characters';
  String get ownerNameRequired => 'Owner name is required';
  String get ownerNameMinLength => 'Owner name must be at least 2 characters';
  String get phoneRequired => 'Phone number is required';
  String get validPhoneNumber => 'Enter valid 10-digit mobile number';
  String get emailRequired => 'Email is required';
  String get validEmail => 'Enter valid email address';
  String get addressRequired => 'Address is required';
  String get completeAddress => 'Please enter complete address';
  String get gstRequired => 'GST number is required';
  String get validGst => 'Enter valid GST number';
  String get passwordRequired => 'Password is required';
  String get passwordMinLength => 'Password must be at least 8 characters';
  String get passwordComplexity => 'Password must contain uppercase, lowercase, number and special character';

  // Document Upload
  String get documentVerification => 'Document Verification';
  String get uploadPharmacyLicense => 'Upload Pharmacy License';
  String get uploadDistributionLicense => 'Upload Distribution License';
  String get uploadShgCertificate => 'Upload SHG Registration Certificate';
  String get uploadBusinessLicense => 'Upload Business License';
  String get uploadDocument => 'Upload Document';
  String get tapToCapture => 'Tap to capture or select from gallery';
  String get uploadedDocuments => 'Uploaded Documents';
  String get document => 'Document';
  String get selectImageSource => 'Select Image Source';
  String get camera => 'Camera';
  String get gallery => 'Gallery';
  String get permissionRequired => 'Permission Required';
  String get cameraPermissionRequired => 'Camera permission is required to capture documents. Please enable it in settings.';
  String get error => 'Error';
  String get failedToPickImage => 'Failed to pick image. Please try again.';
  String get ok => 'OK';

  // Business Types
  String get businessType => 'Business Type';
  String get pharmacy => 'Pharmacy';
  String get medicalDistributor => 'Medical Distributor';
  String get selfHelpGroup => 'Self Help Group';

  // Progress Indicator
  String get stepOfTotal => 'Step';
  String get percentComplete => '% Complete';

  // Terms Acceptance
  String get privacyPolicy => 'Privacy Policy';
  String get termsAcceptanceDescription => 'By creating an account, you confirm that you are authorized to represent your business and agree to our bulk ordering terms.';

  // Error Widget
  String get somethingWentWrong => 'Something went wrong';
  String get errorDescription => 'We encountered an unexpected error while processing your request.';
  String get back => 'Back';

  // App Bar
  String get menu => 'Menu';
  String get searchMedicines => 'Search medicines, suppliers...';
  String get filter => 'Filter';
  String get notifications => 'Notifications';
  String get profile => 'Profile';
  String get medSupply => 'MedSupply';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'mr', 'gu', 'ta', 'te'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations();
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

class AppLocalizationSetup {
  static const List<Locale> supportedLocales = [
    Locale('en', ''), // English
    Locale('hi', ''), // Hindi
    Locale('mr', ''), // Marathi
    Locale('gu', ''), // Gujarati
    Locale('ta', ''), // Tamil
    Locale('te', ''), // Telugu
  ];

  static List<LocalizationsDelegate<dynamic>> get localizationsDelegates => [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];
}
