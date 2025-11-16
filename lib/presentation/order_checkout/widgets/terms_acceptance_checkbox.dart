import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class TermsAcceptanceCheckbox extends StatefulWidget {
  final bool isAccepted;
  final Function(bool) onChanged;

  const TermsAcceptanceCheckbox({
    super.key,
    required this.isAccepted,
    required this.onChanged,
  });

  @override
  State<TermsAcceptanceCheckbox> createState() =>
      _TermsAcceptanceCheckboxState();
}

class _TermsAcceptanceCheckboxState extends State<TermsAcceptanceCheckbox> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: widget.isAccepted,
            onChanged: (value) => widget.onChanged(value ?? false),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    children: [
                      TextSpan(text: 'I agree to the '),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () => _showTermsDialog(context),
                          child: Text(
                            'Terms & Conditions',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: ' and '),
                      WidgetSpan(
                        child: InkWell(
                          onTap: () => _showPrivacyDialog(context),
                          child: Text(
                            'Privacy Policy',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.primary,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(text: ' of MenstruCare Connect.'),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'verified_user',
                      color: theme.colorScheme.tertiary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Secure & Confidential',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.tertiary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Terms & Conditions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Order Terms:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '• All orders are subject to product availability\n'
                '• Bulk orders may require additional processing time\n'
                '• Prices are inclusive of applicable taxes\n'
                '• Delivery charges may apply based on location\n'
                '• Orders cannot be cancelled once confirmed',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              Text(
                'Payment Terms:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '• Payment must be completed before order processing\n'
                '• Refunds are processed within 7-10 business days\n'
                '• COD orders require full payment on delivery\n'
                '• Failed payments will result in order cancellation',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Privacy Policy',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data Collection:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '• We collect only necessary information for order processing\n'
                '• Personal data is encrypted and stored securely\n'
                '• Payment information is processed by certified gateways\n'
                '• Location data is used only for delivery purposes',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: 2.h),
              Text(
                'Data Usage:',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '• Information is used solely for order fulfillment\n'
                '• We do not share data with third parties\n'
                '• Analytics are anonymized and aggregated\n'
                '• You can request data deletion at any time',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
