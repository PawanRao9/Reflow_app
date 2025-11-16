import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class CheckoutProgressIndicator extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const CheckoutProgressIndicator({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Row(
        children: List.generate(steps.length, (index) {
          final isActive = index <= currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.outline
                                  .withValues(alpha: 0.3),
                          border: isCurrent
                              ? Border.all(
                                  color: theme.colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: isActive
                            ? CustomIconWidget(
                                iconName:
                                    index < currentStep ? 'check' : 'circle',
                                color: theme.colorScheme.onPrimary,
                                size: 4.w,
                              )
                            : null,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        steps[index],
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: isActive
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurfaceVariant,
                          fontWeight:
                              isCurrent ? FontWeight.w600 : FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                if (index < steps.length - 1)
                  Container(
                    width: 8.w,
                    height: 1,
                    color: index < currentStep
                        ? theme.colorScheme.primary
                        : theme.colorScheme.outline.withValues(alpha: 0.3),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
