import 'package:my_halaqoh/gen/i18n/translations.g.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Repository for locale persistence
///
/// Handles saving and loading locale preferences using SharedPreferences
class LocaleRepository {
  LocaleRepository(this._prefs);

  final SharedPreferences _prefs;
  static const String _localeKey = 'app_locale';

  /// Get saved locale
  ///
  /// Returns [AppLocale.id] if no preference is saved
  Future<AppLocale> getLocale() async {
    final localeString = _prefs.getString(_localeKey);
    if (localeString == null) {
      return AppLocale.id;
    }
    return AppLocale.values.firstWhere(
      (l) => l.languageTag == localeString,
      orElse: () => AppLocale.id,
    );
  }

  /// Save locale preference
  Future<void> saveLocale(AppLocale locale) async {
    await _prefs.setString(_localeKey, locale.languageTag);
  }
}
