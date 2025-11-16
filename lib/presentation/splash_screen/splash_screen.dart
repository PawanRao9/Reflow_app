import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  // ignore: unused_field
  bool _isInitialized = false;
  String _loadingText = 'Initializing...';

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _animationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Simulate initialization tasks
      await _performInitializationTasks();

      if (mounted) {
        setState(() {
          _isInitialized = true;
          _loadingText = 'Ready!';
        });

        // Navigate after successful initialization
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          _navigateToNextScreen();
        }
      }
    } catch (e) {
      if (mounted) {
        _showRetryDialog();
      }
    }
  }

  Future<void> _performInitializationTasks() async {
    // Task 1: Check authentication status
    setState(() => _loadingText = 'Checking authentication...');
    await Future.delayed(const Duration(milliseconds: 800));

    // Task 2: Load user role permissions
    setState(() => _loadingText = 'Loading permissions...');
    await Future.delayed(const Duration(milliseconds: 600));

    // Task 3: Fetch essential configuration
    setState(() => _loadingText = 'Fetching configuration...');
    await Future.delayed(const Duration(milliseconds: 700));

    // Task 4: Prepare cached inventory data
    setState(() => _loadingText = 'Preparing inventory data...');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void _navigateToNextScreen() {
    // Mock authentication check - in real app, check actual auth status
    final bool isAuthenticated = _checkAuthenticationStatus();
    final String userRole = _getUserRole();

    if (isAuthenticated) {
      // Navigate to role-specific dashboard
      _navigateToRoleDashboard(userRole);
    } else {
      // Check if user is returning (has used app before)
      final bool isReturningUser = _checkReturningUserStatus();

      if (isReturningUser) {
        // Navigate to login screen for returning users
        Navigator.pushReplacementNamed(context, '/login-screen');
      } else {
        // Navigate to registration flow with role selection
        Navigator.pushReplacementNamed(context, '/registration-screen');
      }
    }
  }

  bool _checkAuthenticationStatus() {
    // Mock authentication check
    // In real implementation, check stored tokens, session validity
    return false; // Simulating non-authenticated state
  }

  String _getUserRole() {
    // Mock user role retrieval
    // In real implementation, get from secure storage or API
    return 'pharmacy'; // pharmacy, distributor, shg
  }

  bool _checkReturningUserStatus() {
    // Mock returning user check
    // In real implementation, check if user has previously registered
    return true; // Simulating returning user
  }

  void _navigateToRoleDashboard(String role) {
    // Navigate to dashboard for all authenticated users
    Navigator.pushReplacementNamed(context, '/dashboard');
  }

  void _showRetryDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Connection Error',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'Unable to initialize the app. Please check your internet connection and try again.',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: Text(
                'Retry',
                style: TextStyle(
                  color: AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitialized = false;
      _loadingText = 'Retrying...';
    });
    _animationController.reset();
    _animationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppTheme.lightTheme.colorScheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppTheme.lightTheme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.lightTheme.colorScheme.primary,
                AppTheme.lightTheme.colorScheme.primaryContainer,
                AppTheme.lightTheme.colorScheme.secondary
                    .withValues(alpha: 0.8),
              ],
              stops: const [0.0, 0.6, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 3,
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: ScaleTransition(
                            scale: _scaleAnimation,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // App Logo
                                Container(
                                  width: 25.w,
                                  height: 25.w,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4.w),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: CustomIconWidget(
                                      iconName: 'favorite',
                                      color: AppTheme
                                          .lightTheme.colorScheme.primary,
                                      size: 12.w,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                // App Name
                                Text(
                                  'MenstruCare',
                                  style: AppTheme
                                      .lightTheme.textTheme.headlineLarge
                                      ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                SizedBox(height: 1.h),
                                Text(
                                  'Connect',
                                  style: AppTheme
                                      .lightTheme.textTheme.titleLarge
                                      ?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16.sp,
                                    letterSpacing: 2.0,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                // Tagline
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 1.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(2.w),
                                  ),
                                  child: Text(
                                    'Empowering Sustainable Menstrual Health',
                                    textAlign: TextAlign.center,
                                    style: AppTheme
                                        .lightTheme.textTheme.bodyMedium
                                        ?.copyWith(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                // Loading Section
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Loading Indicator
                      SizedBox(
                        width: 8.w,
                        height: 8.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      // Loading Text
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          _loadingText,
                          key: ValueKey(_loadingText),
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Version Info
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text(
                    'Version 1.0.0',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
