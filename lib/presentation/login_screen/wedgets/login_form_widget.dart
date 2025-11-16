import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool rememberMe;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onToggleRememberMe;
  final VoidCallback onForgotPassword;
  final VoidCallback onLogin;

  const LoginFormWidget({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isPasswordVisible,
    required this.isLoading,
    required this.rememberMe,
    required this.onTogglePasswordVisibility,
    required this.onToggleRememberMe,
    required this.onForgotPassword,
    required this.onLogin,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget>
    with TickerProviderStateMixin {
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _emailHasFocus = false;
  bool _passwordHasFocus = false;

  late AnimationController _shakeAnimationController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _shakeAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _shakeAnimation = Tween<double>(
      begin: 0,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _shakeAnimationController,
      curve: Curves.elasticIn,
    ));
  }

  @override
  void dispose() {
    _shakeAnimationController.dispose();
    super.dispose();
  }

  void _triggerShakeAnimation() {
    _shakeAnimationController.forward().then((_) {
      _shakeAnimationController.reverse();
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email or phone is required';
    }

    // Check if it's a phone number (starts with + or digits)
    if (RegExp(r'^[\+]?[0-9\s\-\(\)]{10,15}$')
        .hasMatch(value.replaceAll(' ', ''))) {
      return null; // Valid phone number
    }

    // Check if it's a valid email
    if (!RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email or phone number';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  void _onEmailChanged(String value) {
    setState(() {
      _isEmailValid = _validateEmail(value) == null && value.isNotEmpty;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _isPasswordValid = _validatePassword(value) == null && value.isNotEmpty;
    });
  }

  bool get _isFormValid => _isEmailValid && _isPasswordValid;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: Form(
            key: widget.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Enhanced Email/Phone Field
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _emailHasFocus = hasFocus;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _emailHasFocus
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: TextFormField(
                      controller: widget.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: _onEmailChanged,
                      validator: (value) {
                        final error = _validateEmail(value);
                        if (error != null &&
                            value != null &&
                            value.isNotEmpty) {
                          Future.delayed(Duration.zero, _triggerShakeAnimation);
                        }
                        return error;
                      },
                      decoration: InputDecoration(
                        labelText: 'Email or Phone',
                        hintText: 'Enter your email or phone number',
                        prefixIcon: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: _emailHasFocus || _isEmailValid
                                ? 'email'
                                : 'alternate_email',
                            color: _emailHasFocus
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        suffixIcon: _isEmailValid
                            ? AnimatedScale(
                                scale: _isEmailValid ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 300),
                                child: Padding(
                                  padding: EdgeInsets.all(3.w),
                                  child: CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.getSuccessColor(true),
                                    size: 20,
                                  ),
                                ),
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _isEmailValid
                                ? AppTheme.getSuccessColor(true)
                                    .withValues(alpha: 0.5)
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.error,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 3.h),

                // Enhanced Password Field
                Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      _passwordHasFocus = hasFocus;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: _passwordHasFocus
                          ? [
                              BoxShadow(
                                color: AppTheme.lightTheme.primaryColor
                                    .withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              )
                            ]
                          : [],
                    ),
                    child: TextFormField(
                      controller: widget.passwordController,
                      obscureText: !widget.isPasswordVisible,
                      textInputAction: TextInputAction.done,
                      onChanged: _onPasswordChanged,
                      validator: (value) {
                        final error = _validatePassword(value);
                        if (error != null &&
                            value != null &&
                            value.isNotEmpty) {
                          Future.delayed(Duration.zero, _triggerShakeAnimation);
                        }
                        return error;
                      },
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.all(3.w),
                          child: CustomIconWidget(
                            iconName: _passwordHasFocus || _isPasswordValid
                                ? 'lock'
                                : 'lock_outline',
                            color: _passwordHasFocus
                                ? AppTheme.lightTheme.primaryColor
                                : AppTheme
                                    .lightTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_isPasswordValid)
                              AnimatedScale(
                                scale: _isPasswordValid ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 300),
                                child: Padding(
                                  padding: EdgeInsets.only(right: 1.w),
                                  child: CustomIconWidget(
                                    iconName: 'check_circle',
                                    color: AppTheme.getSuccessColor(true),
                                    size: 20,
                                  ),
                                ),
                              ),
                            GestureDetector(
                              onTap: widget.onTogglePasswordVisibility,
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 300),
                                padding: EdgeInsets.all(3.w),
                                child: CustomIconWidget(
                                  iconName: widget.isPasswordVisible
                                      ? 'visibility_off'
                                      : 'visibility',
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _isPasswordValid
                                ? AppTheme.getSuccessColor(true)
                                    .withValues(alpha: 0.5)
                                : AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.error,
                          ),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppTheme.lightTheme.colorScheme.error,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                // Enhanced Options Row
                Row(
                  children: [
                    // Remember Me Checkbox
                    GestureDetector(
                      onTap: widget.onToggleRememberMe,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            width: 5.w,
                            height: 5.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: widget.rememberMe
                                    ? AppTheme.lightTheme.primaryColor
                                    : AppTheme.lightTheme.colorScheme.outline,
                                width: 2,
                              ),
                              color: widget.rememberMe
                                  ? AppTheme.lightTheme.primaryColor
                                  : Colors.transparent,
                            ),
                            child: widget.rememberMe
                                ? Center(
                                    child: CustomIconWidget(
                                      iconName: 'check',
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 2.w),
                          Text(
                            'Remember Me',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Spacer(),

                    // Forgot Password Link
                    GestureDetector(
                      onTap: widget.onForgotPassword,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 1.h,
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Enhanced Login Button
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: double.infinity,
                  height: 6.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: _isFormValid && !widget.isLoading
                        ? LinearGradient(
                            colors: [
                              AppTheme.lightTheme.primaryColor,
                              AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.8),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: !_isFormValid || widget.isLoading
                        ? AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3)
                        : null,
                    boxShadow: _isFormValid && !widget.isLoading
                        ? [
                            BoxShadow(
                              color: AppTheme.lightTheme.primaryColor
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: ElevatedButton(
                    onPressed: _isFormValid && !widget.isLoading
                        ? widget.onLogin
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: widget.isLoading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 5.w,
                                height: 5.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 3.w),
                              Text(
                                'Signing In...',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CustomIconWidget(
                                iconName: 'login',
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 2.w),
                              Text(
                                'Login',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                SizedBox(height: 3.h),

                // Security Notice
                Container(
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
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'security',
                        color: AppTheme.lightTheme.primaryColor,
                        size: 16,
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: Text(
                          'Your data is protected with end-to-end encryption',
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
          ),
        );
      },
    );
  }
}
