import 'package:flutter/material.dart';
import 'package:my_halaqoh/gen/colors.gen.dart';

/// App Colors with Light/Dark mode support
///
/// Usage:
/// ```dart
/// // Get colors for current theme
/// final colors = AppColors.of(context);
/// 
/// Container(
///   color: colors.primary,
///   child: Text(
///     'Hello',
///     style: TextStyle(color: colors.textPrimary),
///   ),
/// )
/// ```
class AppColors {
  AppColors._();

  /// Get color set based on current theme brightness
  static AppColorSet of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark ? dark : light;
  }

  /// Light theme colors
  static const AppColorSet light = AppColorSet(
    // Primary Colors
    primary: ColorName.primary,
    secondary: ColorName.secondary,

    // Text Colors
    textPrimary: ColorName.textPrimary,
    textSecondary: ColorName.textSecondary,
    textOnButton: ColorName.textOnButton,

    // Additional Colors
    blue: ColorName.blue,
    yellow: ColorName.yellow,
    red: ColorName.red,
    green: ColorName.green,

    // Background variations
    background: ColorName.background,
    surface: ColorName.surface,

    // Border colors
    border: ColorName.border,
    borderLight: Color(0xFFF3F4F6),
  );

  /// Dark theme colors
  static const AppColorSet dark = AppColorSet(
    // Primary Colors
    primary: ColorName.primaryDark,
    secondary: ColorName.secondaryDark,

    // Text Colors
    textPrimary: ColorName.textPrimaryDark,
    textSecondary: ColorName.textSecondaryDark,
    textOnButton: ColorName.textOnButton,

    // Additional Colors
    blue: ColorName.blue,
    yellow: ColorName.yellow,
    red: ColorName.red,
    green: ColorName.green,

    // Background variations
    background: ColorName.backgroundDark,
    surface: ColorName.surfaceDark,

    // Border colors
    border: ColorName.borderDark,
    borderLight: Color(0xFF1F2937),
  );
}

/// Color set for a specific theme
class AppColorSet {
  const AppColorSet({
    required this.primary,
    required this.secondary,
    required this.textPrimary,
    required this.textSecondary,
    required this.textOnButton,
    required this.blue,
    required this.yellow,
    required this.red,
    required this.green,
    required this.background,
    required this.surface,
    required this.border,
    required this.borderLight,
  });

  // Primary Colors
  final Color primary;
  final Color secondary;

  // Text Colors
  final Color textPrimary;
  final Color textSecondary;
  final Color textOnButton;

  // Additional Colors
  final Color blue;
  final Color yellow;
  final Color red;
  final Color green;

  // Semantic Colors (for better readability)
  Color get success => green;
  Color get warning => yellow;
  Color get error => red;
  Color get info => blue;

  // Background variations
  final Color background;
  final Color surface;

  // Border colors
  final Color border;
  final Color borderLight;
}
