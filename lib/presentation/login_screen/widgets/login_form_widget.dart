import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/app_export.dart';

class LoginFormWidget extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final bool isPasswordVisible;
  final bool isLoading;
  final bool rememberMe;
  final VoidCallback? onTogglePasswordVisibility;
  final VoidCallback? onToggleRememberMe;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onLogin;

  const LoginFormWidget({
    Key? key,
    this.formKey,
    this.emailController,
    this.passwordController,
    this.isPasswordVisible = false,
    this.isLoading = false,
    this.rememberMe = false,
    this.onTogglePasswordVisibility,
    this.onToggleRememberMe,
    this.onForgotPassword,
    this.onLogin,
  }) : super(key: key);

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Field
          Text(
            'Email Address',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Enter your email',
              prefixIcon: CustomIconWidget(
                iconName: 'email',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 2.h),

          // Password Field
          Text(
            'Password',
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 1.h),
          TextFormField(
            controller: widget.passwordController,
            obscureText: !widget.isPasswordVisible,
            decoration: InputDecoration(
              hintText: 'Enter your password',
              prefixIcon: CustomIconWidget(
                iconName: 'lock',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 6.w,
              ),
              suffixIcon: IconButton(
                onPressed: widget.onTogglePasswordVisibility,
                icon: CustomIconWidget(
                  iconName: widget.isPasswordVisible ? 'visibility_off' : 'visibility',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 6.w,
                ),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 1.h),

          // Remember Me and Forgot Password Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: widget.rememberMe,
                    onChanged: (value) => widget.onToggleRememberMe?.call(),
                    activeColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  Text(
                    'Remember me',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: widget.onForgotPassword,
                child: Text(
                  'Forgot Password?',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onLogin,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.w),
                ),
              ),
              child: widget.isLoading
                  ? SizedBox(
                      width: 6.w,
                      height: 6.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                      ),
                    )
                  : Text(
                      'Login',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
