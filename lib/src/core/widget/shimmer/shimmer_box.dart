import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// Primitive shimmer box — the building block for all shimmer skeletons.
///
/// Renders a rounded rectangle filled with [AppColors.border] and wrapped
/// in the [Shimmer] animation from `shimmer_animation`.
///
/// Usage:
/// ```dart
/// ShimmerBox(width: 120.w, height: 14.h, radius: 8.r)
/// ```
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer(
      duration: const Duration(milliseconds: 1200),
      color: isDark
          ? colors.border.withValues(alpha: 0.6)
          : colors.border.withValues(alpha: 0.8),
      colorOpacity: 0,
      enabled: true,
      direction: const ShimmerDirection.fromLTRB(),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark
              ? colors.border.withValues(alpha: 0.3)
              : colors.border.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
