import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BiometricAuthWidget extends StatefulWidget {
  final VoidCallback onBiometricSuccess;
  final bool isAvailable;

  const BiometricAuthWidget({
    Key? key,
    required this.onBiometricSuccess,
    required this.isAvailable,
  }) : super(key: key);

  @override
  State<BiometricAuthWidget> createState() => _BiometricAuthWidgetState();
}

class _BiometricAuthWidgetState extends State<BiometricAuthWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    if (!widget.isAvailable || _isAuthenticating) return;

    setState(() {
      _isAuthenticating = true;
    });

    _animationController.forward().then((_) {
      _animationController.reverse();
    });

    try {
      // Simulate biometric authentication
      await Future.delayed(Duration(milliseconds: 1500));

      // Provide haptic feedback
      HapticFeedback.lightImpact();

      // Call success callback
      widget.onBiometricSuccess();
    } catch (e) {
      // Handle authentication error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Biometric authentication failed. Please try again.'),
          backgroundColor: AppTheme.lightTheme.colorScheme.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isAvailable) {
      return SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(height: 3.h),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Text(
                'OR',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),

        // Biometric Authentication Button
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: GestureDetector(
                onTap: _authenticateWithBiometrics,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color:
                        AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.lightTheme.primaryColor
                          .withValues(alpha: 0.3),
                      width: 2,
                    ),
                  ),
                  child: _isAuthenticating
                      ? Center(
                          child: SizedBox(
                            width: 6.w,
                            height: 6.w,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppTheme.lightTheme.primaryColor,
                              ),
                            ),
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'fingerprint',
                          color: AppTheme.lightTheme.primaryColor,
                          size: 32,
                        ),
                ),
              ),
            );
          },
        ),
        SizedBox(height: 2.h),
        Text(
          _isAuthenticating ? 'Authenticating...' : 'Use Biometric Login',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.primaryColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
