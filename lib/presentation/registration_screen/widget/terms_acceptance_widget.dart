import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';

class TermsAcceptanceWidget extends StatelessWidget {
  final bool isAccepted;
  final Function(bool?) onChanged;
  final VoidCallback onViewTerms;

  const TermsAcceptanceWidget({
    Key? key,
    required this.isAccepted,
    required this.onChanged,
    required this.onViewTerms,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: isAccepted,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    children: [
                      TextSpan(
                        text: 'I agree to the ',
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: onViewTerms,
                          child: Text(
                            'Terms & Conditions',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                      ),
                      WidgetSpan(
                        child: GestureDetector(
                          onTap: onViewTerms,
                          child: Text(
                            'Privacy Policy',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'By creating an account, you confirm that you are authorized to represent your business and agree to our bulk ordering terms.',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
