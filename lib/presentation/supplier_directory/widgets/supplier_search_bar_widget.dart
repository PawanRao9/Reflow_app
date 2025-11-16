import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class SupplierSearchBarWidget extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final VoidCallback? onVoiceSearch;
  final Function(String)? onChanged;
  final VoidCallback? onClear;

  const SupplierSearchBarWidget({
    super.key,
    this.controller,
    this.hintText = 'Search suppliers, location, products...',
    this.onVoiceSearch,
    this.onChanged,
    this.onClear,
  });

  @override
  State<SupplierSearchBarWidget> createState() =>
      _SupplierSearchBarWidgetState();
}

class _SupplierSearchBarWidgetState extends State<SupplierSearchBarWidget> {
  late TextEditingController _controller;
  bool _showClearButton = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
    _showClearButton = _controller.text.isNotEmpty;
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (_showClearButton != hasText) {
      setState(() {
        _showClearButton = hasText;
      });
    }
    widget.onChanged?.call(_controller.text);
  }

  void _clearSearch() {
    _controller.clear();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.all(3.w),
            child: CustomIconWidget(
              iconName: 'search',
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_showClearButton)
                IconButton(
                  onPressed: _clearSearch,
                  icon: CustomIconWidget(
                    iconName: 'clear',
                    size: 18,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  tooltip: 'Clear search',
                ),
              IconButton(
                onPressed: widget.onVoiceSearch,
                icon: CustomIconWidget(
                  iconName: 'mic',
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                tooltip: 'Voice search',
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 4.w,
            vertical: 1.5.h,
          ),
        ),
        style: theme.textTheme.bodyMedium,
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          widget.onChanged?.call(value);
        },
      ),
    );
  }
}
