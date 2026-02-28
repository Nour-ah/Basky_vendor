import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage Helper for managing cached data
/// Uses SharedPreferences for non-sensitive data
/// Uses FlutterSecureStorage for sensitive data (tokens, passwords)
class LocalStorage {
  static SharedPreferences? _prefs;
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Cache Keys
  static const String _authTokenKey = 'auth_token';
  static const String _userTypeKey = 'user_type';
  static const String _userDataKey = 'user_data';
  static const String _languageKey = 'language_code';

  /// Initialize SharedPreferences
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Save data to cache
  /// @param key - The key to store data under
  /// @param value - The value to store
  /// @param isSecure - Whether to use secure storage (default: false)
  static Future<void> saveData({
    required String key,
    required dynamic value,
    bool isSecure = false,
  }) async {
    if (isSecure) {
      await _secureStorage.write(key: key, value: value.toString());
    } else {
      if (value is String) {
        await _prefs?.setString(key, value);
      } else if (value is int) {
        await _prefs?.setInt(key, value);
      } else if (value is bool) {
        await _prefs?.setBool(key, value);
      } else if (value is double) {
        await _prefs?.setDouble(key, value);
      }
    }
  }

  /// Get data from cache
  /// @param key - The key to retrieve data from
  /// @param isSecure - Whether to use secure storage (default: false)
  /// @return The cached value or null if not found
  static Future<dynamic> getData({
    required String key,
    bool isSecure = false,
  }) async {
    if (isSecure) {
      return await _secureStorage.read(key: key);
    } else {
      return _prefs?.get(key);
    }
  }

  /// Remove data from cache
  static Future<void> removeData({
    required String key,
    bool isSecure = false,
  }) async {
    if (isSecure) {
      await _secureStorage.delete(key: key);
    } else {
      await _prefs?.remove(key);
    }
  }

  /// Clear all cache data
  static Future<void> clearAll() async {
    await _prefs?.clear();
    await _secureStorage.deleteAll();
  }

  // ==================== Auth-Specific Helpers ====================

  /// Save user type (student/sheikh)
  static Future<void> saveUserType(String userType) async {
    await saveData(key: _userTypeKey, value: userType);
  }

  /// Get cached user type
  static Future<String?> getUserType() async {
    return await getData(key: _userTypeKey) as String?;
  }

  /// Clear user type (when switching accounts)
  static Future<void> clearUserType() async {
    await removeData(key: _userTypeKey);
  }

  /// Save auth token (secure)
  static Future<void> saveAuthToken(String token) async {
    await saveData(key: _authTokenKey, value: token, isSecure: true);
  }

  /// Get cached auth token
  static Future<String?> getAuthToken() async {
    return await getData(key: _authTokenKey, isSecure: true) as String?;
  }

  /// Clear auth token
  static Future<void> clearAuthToken() async {
    await removeData(key: _authTokenKey, isSecure: true);
  }

  /// Save user data as JSON
  static Future<void> saveUserData(Map<String, dynamic> userData) async {
    final jsonString = jsonEncode(userData);
    await saveData(key: _userDataKey, value: jsonString);
  }

  /// Get cached user data
  static Future<Map<String, dynamic>?> getUserData() async {
    final jsonString = await getData(key: _userDataKey) as String?;
    if (jsonString == null) return null;
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// Clear user data
  static Future<void> clearUserData() async {
    await removeData(key: _userDataKey);
  }

  /// Clear auth data (token + user data) but keep user type
  /// Used on logout
  static Future<void> clearAuthData() async {
    await clearAuthToken();
    await clearUserData();
  }

  /// Check if user is logged in (has valid token)
  static Future<bool> isLoggedIn() async {
    final token = await getAuthToken();
    return token != null && token.isNotEmpty;
  }

  /// Save language code
  static Future<void> saveLanguage(String languageCode) async {
    await saveData(key: _languageKey, value: languageCode);
  }

  /// Get cached language code
  static Future<String?> getLanguage() async {
    return await getData(key: _languageKey) as String?;
  }
}
