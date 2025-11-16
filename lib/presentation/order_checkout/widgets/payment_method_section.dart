import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PaymentMethodSection extends StatefulWidget {
  final List<Map<String, dynamic>> savedCards;
  final List<Map<String, dynamic>> upiOptions;
  final Map<String, dynamic>? selectedPayment;
  final Function(Map<String, dynamic>) onPaymentSelected;

  const PaymentMethodSection({
    super.key,
    required this.savedCards,
    required this.upiOptions,
    this.selectedPayment,
    required this.onPaymentSelected,
  });

  @override
  State<PaymentMethodSection> createState() => _PaymentMethodSectionState();
}

class _PaymentMethodSectionState extends State<PaymentMethodSection> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'payment',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                SizedBox(width: 2.w),
                Text(
                  'Payment Method',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Saved Cards Section
            if (widget.savedCards.isNotEmpty) ...[
              Text(
                'Saved Cards',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 1.h),
              ...widget.savedCards.map((card) => _buildPaymentOption(
                    context,
                    card,
                    CustomIconWidget(
                      iconName: 'credit_card',
                      color: theme.colorScheme.primary,
                      size: 5.w,
                    ),
                  )),
              SizedBox(height: 2.h),
            ],

            // UPI Options Section
            Text(
              'UPI Options',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            ...widget.upiOptions.map((upi) => _buildPaymentOption(
                  context,
                  upi,
                  CustomImageWidget(
                    imageUrl: upi["icon"] as String,
                    width: 5.w,
                    height: 5.w,
                    fit: BoxFit.contain,
                    semanticLabel: upi["semanticLabel"] as String,
                  ),
                )),
            SizedBox(height: 2.h),

            // Other Payment Methods
            Text(
              'Other Methods',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 1.h),
            _buildPaymentOption(
              context,
              {
                "id": "netbanking",
                "name": "Net Banking",
                "description": "Pay using your bank account",
                "type": "netbanking",
              },
              CustomIconWidget(
                iconName: 'account_balance',
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
            ),
            _buildPaymentOption(
              context,
              {
                "id": "cod",
                "name": "Cash on Delivery",
                "description": "Pay when you receive the order",
                "type": "cod",
              },
              CustomIconWidget(
                iconName: 'money',
                color: theme.colorScheme.primary,
                size: 5.w,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption(
      BuildContext context, Map<String, dynamic> payment, Widget icon) {
    final theme = Theme.of(context);
    final isSelected = widget.selectedPayment?["id"] == payment["id"];

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline.withValues(alpha: 0.3),
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => widget.onPaymentSelected(payment),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              Radio<String>(
                value: payment["id"] as String,
                groupValue: widget.selectedPayment?["id"] as String?,
                onChanged: (value) => widget.onPaymentSelected(payment),
              ),
              SizedBox(width: 2.w),
              icon,
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment["name"] as String,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (payment["description"] != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        payment["description"] as String,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (payment["cardNumber"] != null) ...[
                      SizedBox(height: 0.5.h),
                      Text(
                        '**** **** **** ${payment["cardNumber"]}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (payment["type"] == "card" || payment["type"] == "upi")
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'security',
                      color: theme.colorScheme.tertiary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      'Secure',
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
      ),
    );
  }
}
