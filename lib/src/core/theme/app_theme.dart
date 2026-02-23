import 'package:flutter/material.dart';
import 'package:my_halaqoh/src/core/theme/app_colors.dart';

/// App Theme
///
/// Provides complete ThemeData configurations for light and dark modes
class AppTheme {
  AppTheme._();

  /// Light theme
  static ThemeData light() {
    const colors = AppColors.light;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // Color scheme
      colorScheme: ColorScheme.light(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.error,
        onPrimary: colors.textOnButton,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onError: colors.textOnButton,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: colors.background,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.textOnButton,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide (color: colors.border),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.error),
        ),
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontFamily: 'Poppins',
        ),
        hintStyle: TextStyle(
          color: colors.textSecondary,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnButton,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Icon
      iconTheme: IconThemeData(
        color: colors.textPrimary,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
      ),
    );
  }

  /// Dark theme
  static ThemeData dark() {
    const colors = AppColors.dark;
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: ColorScheme.dark(
        primary: colors.primary,
        secondary: colors.secondary,
        surface: colors.surface,
        error: colors.error,
        onPrimary: colors.textOnButton,
        onSecondary: colors.textPrimary,
        onSurface: colors.textPrimary,
        onError: colors.textOnButton,
      ),
      
      // Scaffold
      scaffoldBackgroundColor: colors.background,
      
      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: colors.primary,
        foregroundColor: colors.textOnButton,
        elevation: 0,
        centerTitle: true,
      ),
      
      // Card
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      
      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: false,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.primary, width: 2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: colors.error),
        ),
        labelStyle: TextStyle(
          color: colors.textSecondary,
          fontFamily: 'Poppins',
        ),
        hintStyle: TextStyle(
          color: colors.textSecondary,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.textOnButton,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.primary,
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      
      // Icon
      iconTheme: IconThemeData(
        color: colors.textPrimary,
      ),
      
      // Text Theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        headlineSmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        titleLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Poppins',
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          fontFamily: 'Poppins',
        ),
      ),
      
      // Divider
      dividerTheme: DividerThemeData(
        color: colors.border,
        thickness: 1,
      ),
    );
  }
}
