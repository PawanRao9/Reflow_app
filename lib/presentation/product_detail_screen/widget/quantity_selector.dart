import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuantitySelector extends StatefulWidget {
  final int initialQuantity;
  final int minOrderQuantity;
  final int maxAvailableStock;
  final List<int> bulkIncrements;
  final Function(int) onQuantityChanged;
  final double unitPrice;
  final String currency;

  const QuantitySelector({
    Key? key,
    required this.initialQuantity,
    required this.minOrderQuantity,
    required this.maxAvailableStock,
    required this.bulkIncrements,
    required this.onQuantityChanged,
    required this.unitPrice,
    required this.currency,
  }) : super(key: key);

  @override
  State<QuantitySelector> createState() => _QuantitySelectorState();
}

class _QuantitySelectorState extends State<QuantitySelector> {
  late int _currentQuantity;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.initialQuantity >= widget.minOrderQuantity
        ? widget.initialQuantity
        : widget.minOrderQuantity;
    _quantityController =
        TextEditingController(text: _currentQuantity.toString());
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _updateQuantity(int newQuantity) {
    if (newQuantity >= widget.minOrderQuantity &&
        newQuantity <= widget.maxAvailableStock) {
      setState(() {
        _currentQuantity = newQuantity;
        _quantityController.text = newQuantity.toString();
      });
      widget.onQuantityChanged(newQuantity);
    }
  }

  void _incrementBy(int increment) {
    _updateQuantity(_currentQuantity + increment);
  }

  void _decrementBy(int decrement) {
    _updateQuantity(_currentQuantity - decrement);
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = _currentQuantity * widget.unitPrice;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              CustomIconWidget(
                iconName: 'shopping_cart',
                color: AppTheme.lightTheme.primaryColor,
                size: 5.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Select Quantity',
                style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Minimum order info
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.getWarningColor(true).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
              border: Border.all(
                color: AppTheme.getWarningColor(true).withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'info',
                  color: AppTheme.getWarningColor(true),
                  size: 4.w,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Text(
                    'Minimum order quantity: ${widget.minOrderQuantity} units',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.getWarningColor(true),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Quantity input and controls
          Row(
            children: [
              // Decrease button
              GestureDetector(
                onTap: () => _decrementBy(1),
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _currentQuantity > widget.minOrderQuantity
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'remove',
                      color: _currentQuantity > widget.minOrderQuantity
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Quantity input field
              Expanded(
                child: Container(
                  height: 6.h,
                  child: TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 3.w),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.w),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.outline,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(2.w),
                        borderSide: BorderSide(
                          color: AppTheme.lightTheme.primaryColor,
                          width: 2,
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      final quantity = int.tryParse(value);
                      if (quantity != null) {
                        _updateQuantity(quantity);
                      }
                    },
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Increase button
              GestureDetector(
                onTap: () => _incrementBy(1),
                child: Container(
                  width: 12.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color: _currentQuantity < widget.maxAvailableStock
                        ? AppTheme.lightTheme.primaryColor
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2.w),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'add',
                      color: _currentQuantity < widget.maxAvailableStock
                          ? Colors.white
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 5.w,
                    ),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Bulk increment buttons
          Text(
            'Quick Add:',
            style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          SizedBox(height: 1.h),

          Wrap(
            spacing: 2.w,
            runSpacing: 1.h,
            children: widget.bulkIncrements.map((increment) {
              final canAdd =
                  _currentQuantity + increment <= widget.maxAvailableStock;
              return GestureDetector(
                onTap: canAdd ? () => _incrementBy(increment) : null,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
                  decoration: BoxDecoration(
                    color: canAdd
                        ? AppTheme.lightTheme.colorScheme.secondaryContainer
                        : AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(2.h),
                    border: Border.all(
                      color: canAdd
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.outline
                              .withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '+$increment',
                    style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                      color: canAdd
                          ? AppTheme.lightTheme.colorScheme.onSecondaryContainer
                          : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 3.h),

          // Total price display
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${widget.currency}${totalPrice.toStringAsFixed(2)}',
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.lightTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ),

          // Stock availability
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'inventory',
                color: widget.maxAvailableStock > 100
                    ? AppTheme.getSuccessColor(true)
                    : AppTheme.getWarningColor(true),
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                '${widget.maxAvailableStock} units available in stock',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: widget.maxAvailableStock > 100
                      ? AppTheme.getSuccessColor(true)
                      : AppTheme.getWarningColor(true),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
