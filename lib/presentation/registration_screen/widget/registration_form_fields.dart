import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormFields extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController businessNameController;
  final TextEditingController ownerNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController addressController;
  final TextEditingController gstController;
  final TextEditingController passwordController;
  final String selectedBusinessType;
  final bool showGstField;
  final String passwordStrength;
  final VoidCallback onLocationPicker;

  const RegistrationFormFields({
    Key? key,
    required this.formKey,
    required this.businessNameController,
    required this.ownerNameController,
    required this.phoneController,
    required this.emailController,
    required this.addressController,
    required this.gstController,
    required this.passwordController,
    required this.selectedBusinessType,
    required this.showGstField,
    required this.passwordStrength,
    required this.onLocationPicker,
  }) : super(key: key);

  String? _validateBusinessName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Business name is required';
    }
    if (value.trim().length < 2) {
      return 'Business name must be at least 2 characters';
    }
    return null;
  }

  String? _validateOwnerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Owner name is required';
    }
    if (value.trim().length < 2) {
      return 'Owner name must be at least 2 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value.trim())) {
      return 'Enter valid 10-digit mobile number';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return 'Enter valid email address';
    }
    return null;
  }

  String? _validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 10) {
      return 'Please enter complete address';
    }
    return null;
  }

  String? _validateGst(String? value) {
    if (!showGstField) return null;
    if (value == null || value.trim().isEmpty) {
      return 'GST number is required';
    }
    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
        .hasMatch(value.trim())) {
      return 'Enter valid GST number';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(
            r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]')
        .hasMatch(value)) {
      return 'Password must contain uppercase, lowercase, number and special character';
    }
    return null;
  }

  Color _getPasswordStrengthColor() {
    switch (passwordStrength) {
      case 'Strong':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Medium':
        return Colors.orange;
      case 'Weak':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Business Name Field
          TextFormField(
            controller: businessNameController,
            decoration: InputDecoration(
              labelText: 'Business Name',
              hintText: 'Enter your business name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'business',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: _validateBusinessName,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 2.h),

          // Owner Name Field
          TextFormField(
            controller: ownerNameController,
            decoration: InputDecoration(
              labelText: 'Owner Name',
              hintText: 'Enter owner full name',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'person',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: _validateOwnerName,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 2.h),

          // Phone Number Field
          TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: 'Enter 10-digit mobile number',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: _validatePhone,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 2.h),

          // Email Field
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: 'Email Address',
              hintText: 'Enter business email',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'email',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: _validateEmail,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: 2.h),

          // Address Field with Location Picker
          TextFormField(
            controller: addressController,
            decoration: InputDecoration(
              labelText: 'Business Address',
              hintText: 'Enter complete business address',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'location_on',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                onPressed: onLocationPicker,
                icon: CustomIconWidget(
                  iconName: 'my_location',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
              ),
            ),
            validator: _validateAddress,
            maxLines: 2,
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
          ),
          SizedBox(height: 2.h),

          // GST Number Field (Conditional)
          if (showGstField) ...[
            TextFormField(
              controller: gstController,
              decoration: InputDecoration(
                labelText: 'GST Number',
                hintText: 'Enter 15-digit GST number',
                prefixIcon: Padding(
                  padding: EdgeInsets.all(3.w),
                  child: CustomIconWidget(
                    iconName: 'receipt_long',
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ),
              ),
              validator: _validateGst,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                LengthLimitingTextInputFormatter(15),
              ],
              textInputAction: TextInputAction.next,
              textCapitalization: TextCapitalization.characters,
            ),
            SizedBox(height: 2.h),
          ],

          // Password Field with Strength Indicator
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create strong password',
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: 'lock',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
            validator: _validatePassword,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),

          // Password Strength Indicator
          if (passwordController.text.isNotEmpty) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                Text(
                  'Password Strength: ',
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
                Text(
                  passwordStrength,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: _getPasswordStrengthColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
