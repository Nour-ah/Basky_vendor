import '../cache_helper/local_storage.dart';
import '../../features/auth/domain/entities/user.dart';

/// Centralized pharmacy vendor access checks.
class VendorAccess {
  VendorAccess._();

  static const String pharmacyKey = 'pharmacy';

  /// Localized labels the API may send instead of the stable `key`.
  static const Map<String, String> _aliases = {
    'pharmacy': pharmacyKey,
    'pharmacies': pharmacyKey,
    'صيدلية': pharmacyKey,
    'صيدليه': pharmacyKey,
  };

  /// Maps API vendor type text to a stable key.
  /// Prefer this over raw `type` / `name`, which change with language.
  static String? canonicalKey(String? raw) {
    final text = raw?.trim().toLowerCase();
    if (text == null || text.isEmpty) return null;
    return _aliases[text] ?? text;
  }

  static bool isPharmacyVendor(User? user) {
    return canonicalKey(user?.vendorTypeKey) == pharmacyKey;
  }

  static Future<bool> isPharmacyVendorCached({User? user}) async {
    if (isPharmacyVendor(user)) return true;
    final cached = canonicalKey(await LocalStorage.getUserType());
    return cached == pharmacyKey;
  }

  static Future<void> persistVendorTypeKey(String? key) async {
    final normalized = canonicalKey(key);
    if (normalized == null || normalized.isEmpty) return;
    await LocalStorage.saveUserType(normalized);
  }
}

extension UserVendorAccessX on User {
  bool get isPharmacyVendor => VendorAccess.isPharmacyVendor(this);
}
