




import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unique_identifier/unique_identifier.dart';

class PlatformInfo {
  static PlatformInfo? _instance;
  static PlatformInfo get instance => _instance ??= PlatformInfo._();
  PlatformInfo._();

  // Cache variables
  static String? _cachedUdid;
  static Map<String, dynamic>? _cachedDeviceInfo;

 
  static Future<Map<String, dynamic>> getDeviceInfoForApi() async {
    try {
      // Cache check
      if (_cachedDeviceInfo != null) {
        return Map<String, dynamic>.from(_cachedDeviceInfo!);
      }

      // Generate fresh data
      final deviceInfo = DeviceInfoPlugin();
      final udid = await _getUdid();

      Map<String, dynamic> result;

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        result = {
          "user_devices_uuid": udid,
          "device_model": androidInfo.model,
          "os_id": 2,
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        result = {
          "user_devices_uuid": udid,
          "device_model": iosInfo.model,
          "os_id": 1,
        };
      } else {
        // Fallback for other platforms
        result = {
          "user_devices_uuid": udid,
          "device_model": "Unknown",
          "os_id": 0,
        };
      }

      // Cache the result
      _cachedDeviceInfo = result;
      
      // Save to persistent storage
      await _saveToStorage(result);

      return result;
    } catch (e) {
      log('Device info error: $e');
      
      // Return cached data if available
      if (_cachedDeviceInfo != null) {
        return Map<String, dynamic>.from(_cachedDeviceInfo!);
      }
      
      // Fallback data
      return await _getFallbackDeviceInfo();
    }
  }

  /// 📱 UDID faqat olish
  static Future<String> getUdid() async {
    return await _getUdid();
  }

  /// 🔄 Cache ni yangilash
  static Future<void> refreshCache() async {
    _clearCache();
    await getDeviceInfoForApi();
  }

  /// 🧹 Cache ni tozalash
  static Future<void> clearCache() async {
    _clearCache();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_device_info');
    await prefs.remove('cached_udid');
  }

  // ========================================================================================
  // 3. PRIVATE HELPER METHODS
  // ========================================================================================

  /// Get UDID with multiple fallbacks
  static Future<String> _getUdid() async {
    try {
      // Use cached if available
      if (_cachedUdid != null && _cachedUdid!.isNotEmpty) {
        return _cachedUdid!;
      }

      // Try to load from storage
      final prefs = await SharedPreferences.getInstance();
      final storedUdid = prefs.getString('cached_udid');
      if (storedUdid != null && storedUdid.isNotEmpty) {
        _cachedUdid = storedUdid;
        return storedUdid;
      }

      // Generate new UDID
      String udid = '';
      
      // Method 1: unique_identifier package
      try {
        udid = await UniqueIdentifier.serial ?? '';
      } catch (e) {
        log('UniqueIdentifier failed: $e');
      }

      // Method 2: Fallback for each platform
      if (udid.isEmpty) {
        udid = await _getPlatformSpecificId();
      }

      // Method 3: Final fallback
      if (udid.isEmpty) {
        udid = _generateFallbackId();
      }

      // Cache and save
      _cachedUdid = udid;
      await prefs.setString('cached_udid', udid);
      
      return udid;
    } catch (e) {
      log('UDID generation failed: $e');
      return _generateFallbackId();
    }
  }

  /// Platform specific ID generation
  static Future<String> _getPlatformSpecificId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        // Android ID ni unique identifier sifatida ishlatish
        return 'android_${androidInfo.id}_${androidInfo.fingerprint}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        // iOS identifier for vendor
        return 'ios_${iosInfo.identifierForVendor}_${iosInfo.systemVersion}';
      }
      
      return '';
    } catch (e) {
      log('Platform specific ID failed: $e');
      return '';
    }
  }

  /// Generate fallback ID
  static String _generateFallbackId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final platform = Platform.operatingSystem;
    final random = DateTime.now().microsecond;
    return 'fallback_${platform}_${timestamp}_$random';
  }

  /// Fallback device info
  static Future<Map<String, dynamic>> _getFallbackDeviceInfo() async {
    final udid = await _getUdid();
    return {
      "user_devices_uuid": udid,
      "device_model": Platform.isAndroid ? "Android Device" : 
                     Platform.isIOS ? "iOS Device" : "Unknown Device",
      "os_id": Platform.isAndroid ? 2 : Platform.isIOS ? 1 : 0,
    };
  }

  /// Clear memory cache
  static void _clearCache() {
    _cachedDeviceInfo = null;
    _cachedUdid = null;
  }

  /// Save to persistent storage
  static Future<void> _saveToStorage(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_device_info', data.toString());
    } catch (e) {
      log('Save to storage failed: $e');
    }
  }
}