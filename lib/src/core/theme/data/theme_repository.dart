import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_halaqoh/src/core/theme/theme_mode.dart';

/// Repository for theme persistence
/// 
/// Handles saving and loading theme preferences using SharedPreferences
class ThemeRepository {
  ThemeRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _themeKey = 'app_theme_mode';

  /// Get saved theme mode
  /// 
  /// Returns [AppThemeMode.system] if no preference is saved
  Future<AppThemeMode> getThemeMode() async {
    final themeString = _prefs.getString(_themeKey);
    if (themeString == null) {
      return AppThemeMode.system;
    }
    return AppThemeMode.fromJson(themeString);
  }

  /// Save theme mode preference
  Future<void> saveThemeMode(AppThemeMode mode) async {
    await _prefs.setString(_themeKey, mode.toJson());
  }
}
