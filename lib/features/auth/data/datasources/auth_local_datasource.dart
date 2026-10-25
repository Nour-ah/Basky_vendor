import 'package:flutter/foundation.dart';
import '../../../../core/cache_helper/local_storage.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheToken(String token);
  Future<String?> getToken();
  Future<void> removeToken();
  Future<bool> isLoggedIn();
  Future<void> cacheVendorTypeKey(String? vendorTypeKey);
  Future<String?> getVendorTypeKey();
  Future<void> cacheVendorId(int? vendorId);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  AuthLocalDataSourceImpl();

  @override
  Future<void> cacheToken(String token) async {
    debugPrint('🔐 AuthLocalDataSource: Caching token...');
    await LocalStorage.saveAuthToken(token);
    debugPrint('✅ AuthLocalDataSource: Token cached to SecureStorage');
  }

  @override
  Future<String?> getToken() async {
    final token = await LocalStorage.getAuthToken();
    debugPrint('🔑 AuthLocalDataSource: Read token = ${token != null ? '${token.substring(0, 10)}...' : 'NULL'}');
    return token;
  }

  @override
  Future<void> removeToken() async {
    debugPrint('🗑️ AuthLocalDataSource: Clearing auth data (token + user cache)...');
    await LocalStorage.clearAuthData();
    debugPrint('✅ AuthLocalDataSource: Auth data cleared');
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> cacheVendorTypeKey(String? vendorTypeKey) async {
    final key = vendorTypeKey?.trim().toLowerCase();
    if (key == null || key.isEmpty) return;
    await LocalStorage.saveUserType(key);
  }

  @override
  Future<String?> getVendorTypeKey() async {
    return LocalStorage.getUserType();
  }

  @override
  Future<void> cacheVendorId(int? vendorId) async {
    if (vendorId == null || vendorId <= 0) return;
    await LocalStorage.saveVendorId(vendorId);
  }
}