import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/app_logo_widget.dart';
import './widgets/biometric_auth_widget.dart';
import './widgets/language_selector_widget.dart';
import './widgets/login_form_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  late AnimationController _slideAnimationController;
  late AnimationController _fadeAnimationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  bool _isBiometricAvailable = true;
  bool _rememberMe = false;
  String _selectedLanguage = 'en';
  String? _selectedRole;

  // Enhanced mock credentials with role-based access
  late List<Map<String, dynamic>> _mockCredentials;

  @override
  void initState() {
    super.initState();
    _initializeMockCredentials();
    _initializeAnimations();
    _checkBiometricAvailability();
    _loadSavedCredentials();
  }

  void _initializeMockCredentials() {
    _mockCredentials = [
      {
        "userType": AppLocalizations.of(context).pharmacyOwner,
        "role": "pharmacy",
        "email": "pharmacy@menstrucare.com",
        "phone": "+91 98765 43210",
        "password": "pharmacy123",
        "name": "Dr. Priya Sharma",
        "businessName": "Sharma Medical Store",
        "avatar":
            "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=150&h=150&fit=crop&crop=face",
        "lastLogin": "2025-01-03",
        "status": "active"
      },
      {
        "userType": AppLocalizations.of(context).medicalDistributorUser,
        "role": "distributor",
        "email": "distributor@menstrucare.com",
        "phone": "+91 87654 32109",
        "password": "distributor123",
        "name": "Rajesh Kumar",
        "businessName": "Kumar Medical Distributors",
        "avatar":
            "https://images.unsplash.com/photo-1698376621066-8bdd073dcf4a",
        "lastLogin": "2025-01-03",
        "status": "active"
      },
      {
        "userType": AppLocalizations.of(context).shgCoordinator,
        "role": "shg",
        "email": "shg@menstrucare.com",
        "phone": "+91 76543 21098",
        "password": "shg123",
        "name": "Sunita Devi",
        "businessName": "Mahila Swayam Sahayata Samuh",
        "avatar":
            "https://images.unsplash.com/photo-1709532389095-d86c10c2c187",
        "lastLogin": "2025-01-02",
        "status": "active"
      }
    ];
  }

  void _initializeAnimations() {
    _slideAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeAnimationController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _fadeAnimationController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _slideAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _slideAnimationController.dispose();
    _fadeAnimationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    await Future.delayed(Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        _isBiometricAvailable = true;
      });
    }
  }

  Future<void> _loadSavedCredentials() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedEmail = prefs.getString('saved_email');
      final savedPassword = prefs.getString('saved_password');
      final savedRememberMe = prefs.getBool('remember_me') ?? false;

      if (savedRememberMe && savedEmail != null) {
        setState(() {
          _emailController.text = savedEmail;
          if (savedPassword != null) {
            _passwordController.text = savedPassword;
          }
          _rememberMe = savedRememberMe;
        });
      }
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _saveCredentials() async {
    if (_rememberMe) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', _emailController.text.trim());
        await prefs.setString(
            'saved_password', _passwordController.text.trim());
        await prefs.setBool('remember_me', _rememberMe);
      } catch (e) {
        // Handle error silently
      }
    }
  }

  void _togglePasswordVisibility() {
    HapticFeedback.lightImpact();
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleRememberMe() {
    HapticFeedback.lightImpact();
    setState(() {
      _rememberMe = !_rememberMe;
    });
  }

  void _onLanguageChanged(String languageCode) {
    setState(() {
      _selectedLanguage = languageCode;
    });
    // TODO: Implement actual locale change
    // This would typically involve updating the app's locale
    // For now, we just store the selection
  }

  void _onRoleSelected(String role) {
    setState(() {
      _selectedRole = role;
    });

    // Auto-fill demo credentials based on role
    final credential = _mockCredentials.firstWhere(
      (cred) => cred['role'] == role,
      orElse: () => {},
    );

    if (credential.isNotEmpty) {
      _emailController.text = credential['email'];
      _passwordController.text = credential['password'];
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Hide keyboard
    FocusScope.of(context).unfocus();

    try {
      // Save credentials if remember me is checked
      await _saveCredentials();

      // Simulate API call with realistic delay
      await Future.delayed(Duration(seconds: 2));

      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Enhanced credential validation with role support
      final validCredential = _mockCredentials.firstWhere(
        (cred) =>
            (cred['email'] == email || cred['phone'] == email) &&
            cred['password'] == password &&
            cred['status'] == 'active',
        orElse: () => {},
      );

      if (validCredential.isNotEmpty) {
        // Success animations and feedback
        HapticFeedback.lightImpact();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                CustomIconWidget(
                  iconName: 'check_circle',
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Text(AppLocalizations.of(context).welcomeBack),
              ],
            ),
            backgroundColor: AppTheme.getSuccessColor(true),
            duration: Duration(seconds: 2),
          ),
        );

        // Navigate with animation delay
        await Future.delayed(Duration(milliseconds: 1500));
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      } else {
        // Show enhanced error dialog
        await _showEnhancedErrorDialog();
      }
    } catch (e) {
      _showNetworkErrorDialog();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _showEnhancedErrorDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.error
                      .withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'error_outline',
                  color: AppTheme.lightTheme.colorScheme.error,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                AppLocalizations.of(context).loginFailed,
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).invalidCredentials,
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                ),
                SizedBox(height: 3.h),
                ..._mockCredentials
                    .map((cred) => Container(
                          margin: EdgeInsets.only(bottom: 2.h),
                          padding: EdgeInsets.all(3.w),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.primaryColor
                                .withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 8.w,
                                    height: 8.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppTheme.lightTheme.primaryColor,
                                    ),
                                    child: Center(
                                      child: Text(
                                        cred['name'].toString().split(' ')[0]
                                            [0],
                                        style: AppTheme
                                            .lightTheme.textTheme.labelLarge
                                            ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 3.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          cred['userType'],
                                          style: AppTheme
                                              .lightTheme.textTheme.labelLarge
                                              ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppTheme
                                                .lightTheme.primaryColor,
                                          ),
                                        ),
                                        Text(
                                          cred['name'],
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 1.h),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Email: ${cred['email']}',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                        Text(
                                          'Password: ${cred['password']}',
                                          style: AppTheme
                                              .lightTheme.textTheme.bodySmall
                                              ?.copyWith(
                                            fontFamily: 'monospace',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: cred['email']));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(AppLocalizations.of(context).emailCopied),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(2.w),
                                      decoration: BoxDecoration(
                                        color: AppTheme.lightTheme.primaryColor
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: CustomIconWidget(
                                        iconName: 'content_copy',
                                        color: AppTheme.lightTheme.primaryColor,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                AppLocalizations.of(context).close,
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Auto-fill with first credential
                final firstCred = _mockCredentials.first;
                _emailController.text = firstCred['email'];
                _passwordController.text = firstCred['password'];
              },
              child: Text(AppLocalizations.of(context).tryDemo),
            ),
          ],
        );
      },
    );
  }

  void _showNetworkErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'wifi_off',
                  color: AppTheme.getWarningColor(true),
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                AppLocalizations.of(context).connectionError,
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).checkConnection,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Container(
                padding: EdgeInsets.all(3.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'info_outline',
                      color: AppTheme.lightTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).offlineMode,
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.lightTheme.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _handleLogin();
              },
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        );
      },
    );
  }

  void _handleForgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController resetEmailController =
            TextEditingController();

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color:
                      AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: CustomIconWidget(
                  iconName: 'lock_reset',
                  color: AppTheme.lightTheme.primaryColor,
                  size: 24,
                ),
              ),
              SizedBox(width: 3.w),
              Text(
                AppLocalizations.of(context).resetPassword,
                style: AppTheme.lightTheme.textTheme.titleLarge,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context).enterEmail,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 3.h),
              TextFormField(
                controller: resetEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context).emailAddress,
                  hintText: AppLocalizations.of(context).enterBusinessEmail,
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(AppLocalizations.of(context).resetInstructionsSent),
                      ],
                    ),
                    backgroundColor: AppTheme.getSuccessColor(true),
                  ),
                );
              },
              child: Text(AppLocalizations.of(context).sendResetLink),
            ),
          ],
        );
      },
    );
  }

  void _handleBiometricSuccess() {
    HapticFeedback.lightImpact();
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _navigateToRegistration() {
    Navigator.pushNamed(context, '/registration-screen');
  }

  Widget _buildRoleSelector() {
    return Container(
      margin: EdgeInsets.only(bottom: 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context).quickLogin,
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: _mockCredentials.map((cred) {
              final isSelected = _selectedRole == cred['role'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => _onRoleSelected(cred['role']),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.lightTheme.primaryColor
                              .withValues(alpha: 0.1)
                          : AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.lightTheme.primaryColor
                            : AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 8.w,
                          height: 8.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme.lightTheme.colorScheme.outline,
                          ),
                          child: Center(
                            child: Text(
                              cred['userType'].toString().split(' ')[0][0],
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          cred['userType'].toString().split(' ')[0],
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    MediaQuery.of(context).padding.bottom,
              ),
              child: Column(
                children: [
                  // Top Section with Language Selector
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      height: 8.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 50.w,
                            child: LanguageSelectorWidget(
                              selectedLanguage: _selectedLanguage,
                              onLanguageChanged: _onLanguageChanged,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Main Content with Animations
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.h),
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // App Logo with Enhanced Styling
                            AppLogoWidget(),
                            SizedBox(height: 6.h),

                            // Role Selector for Quick Demo Login
                            _buildRoleSelector(),

                            // Enhanced Login Form
                            LoginFormWidget(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              isPasswordVisible: _isPasswordVisible,
                              isLoading: _isLoading,
                              rememberMe: _rememberMe,
                              onTogglePasswordVisibility:
                                  _togglePasswordVisibility,
                              onToggleRememberMe: _toggleRememberMe,
                              onForgotPassword: _handleForgotPassword,
                              onLogin: _handleLogin,
                            ),

                            SizedBox(height: 4.h),

                            // Enhanced Biometric Authentication
                            BiometricAuthWidget(
                              onBiometricSuccess: _handleBiometricSuccess,
                              isAvailable: _isBiometricAvailable,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Enhanced Bottom Section
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Column(
                        children: [
                          // Registration Link
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context).newBusiness,
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToRegistration,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 3.w,
                                    vertical: 1.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.lightTheme.primaryColor
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context).registerNow,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: AppTheme.lightTheme.primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2.h),

                          // App Version and Support
                          Column(
                            children: [
                              Text(
                                AppLocalizations.of(context).version,
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                              SizedBox(height: 0.5.h),
                              GestureDetector(
                                onTap: () {
                                  // Handle support contact
                                },
                                child: Text(
                                  AppLocalizations.of(context).needHelp,
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme.lightTheme.primaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
