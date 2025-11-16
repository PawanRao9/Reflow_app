import 'package:flutter/material.dart';

/// Small helper extensions to provide a `.withValues(alpha: ...)` API used
/// across the codebase. The project uses this helper in many places; adding
/// it here avoids changing many files and keeps the intent clear.

extension ColorWithValuesExtension on Color {
  /// Returns a copy of this color with the given opacity expressed as a
  /// fractional alpha (0.0 - 1.0). Matches the project's existing call sites
  /// like `someColor.withValues(alpha: 0.1)`.
  Color withValues({double alpha = 1.0}) {
    // Convert fractional alpha (0.0 - 1.0) to 0-255 range to avoid
    // precision loss that can occur with `withOpacity`.
    final int alphaInt = (alpha.clamp(0.0, 1.0) * 255).round();
    return withAlpha(alphaInt);
  }
}
