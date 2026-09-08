import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service that provides unique device identification and human-readable device
/// metadata for session and multi-device management.
class DeviceService {
  final SharedPreferences _prefs;
  final DeviceInfoPlugin _deviceInfoPlugin;

  static const String _deviceIdKey = 'device_installation_id';

  DeviceService(this._prefs, [DeviceInfoPlugin? deviceInfoPlugin])
      : _deviceInfoPlugin = deviceInfoPlugin ?? DeviceInfoPlugin();

  /// Returns a persistent unique device ID for this installation.
  ///
  /// Generated once and stored in [SharedPreferences]. Persists across app
  /// launches until app uninstallation or data clear.
  String getDeviceId() {
    String? deviceId = _prefs.getString(_deviceIdKey);
    if (deviceId == null || deviceId.trim().isEmpty) {
      final random = Random();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final randomSuffix = List.generate(8, (_) => random.nextInt(36).toRadixString(36)).join();
      deviceId = 'dev_${timestamp}_$randomSuffix';
      _prefs.setString(_deviceIdKey, deviceId);
    }
    return deviceId;
  }

  /// Returns a human-readable device name (e.g. "Samsung Galaxy S21" or "Xiaomi Redmi Note 10").
  Future<String> getDeviceName() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfoPlugin.androidInfo;
        final brand = androidInfo.brand;
        final model = androidInfo.model;
        if (brand.isNotEmpty && model.isNotEmpty) {
          if (model.toLowerCase().startsWith(brand.toLowerCase())) {
            return _capitalize(model);
          }
          return '${_capitalize(brand)} $model';
        }
        return model.isNotEmpty ? model : 'Android Device';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfoPlugin.iosInfo;
        return iosInfo.name.isNotEmpty ? iosInfo.name : 'iOS Device';
      }
    } catch (_) {
      // Fallback on any error reading device info
    }
    return Platform.isAndroid ? 'Android Device' : (Platform.isIOS ? 'iOS Device' : 'Unknown Device');
  }

  /// Returns the current OS platform string ('android' or 'ios').
  String getPlatform() {
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    return 'other';
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }
}
