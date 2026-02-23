/// App Theme Mode
/// 
/// Represents the current theme mode of the application
enum AppThemeMode {
  /// Light theme
  light,
  
  /// Dark theme
  dark,
  
  /// System theme (follows device settings)
  system;

  /// Convert to string for persistence
  String toJson() => name;

  /// Create from string
  static AppThemeMode fromJson(String json) {
    return AppThemeMode.values.firstWhere(
      (mode) => mode.name == json,
      orElse: () => AppThemeMode.system,
    );
  }
}
