import '../../../../core/utils/json_parsers.dart';
import '../../../../core/utils/vendor_access.dart';
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.image,
    super.emailVerifiedAt,
    super.phoneVerifiedAt,
    required super.isActive,
    required super.isVerified,
    required super.roles,
    required super.permissions,
    required super.createdAt,
    required super.updatedAt,
    super.vendorTypeId,
    super.vendorTypeKey,
    super.vendorId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final vendorType = _parseVendorType(json);
    return UserModel(
      id: JsonParsers.asIntOr(json['id']),
      name: JsonParsers.asString(json['name']) ?? '',
      email: JsonParsers.asString(json['email']) ?? '',
      phone: JsonParsers.asString(json['phone']) ?? '',
      image: JsonParsers.asString(json['image']),
      emailVerifiedAt: JsonParsers.asString(json['email_verified_at']),
      phoneVerifiedAt: JsonParsers.asString(json['phone_verified_at']),
      isActive: JsonParsers.asBool(json['is_active']),
      isVerified: JsonParsers.asBool(json['is_verified']),
      roles: List<String>.from(json['roles'] ?? const []),
      permissions: List<String>.from(json['permissions'] ?? const []),
      createdAt: JsonParsers.asString(json['created_at']) ?? '',
      updatedAt: JsonParsers.asString(json['updated_at']) ?? '',
      vendorTypeId: vendorType.$1,
      vendorTypeKey: vendorType.$2,
      vendorId: JsonParsers.asInt(json['vendor_id']) ??
          (json['vendor'] is Map
              ? JsonParsers.asInt((json['vendor'] as Map)['id'])
              : null),
    );
  }

  /// Parses `data.user` and promotes sibling fields like `data.vendor_type`.
  factory UserModel.fromApiData(Map<String, dynamic> data) {
    final rawUser = data['user'];
    final userJson = Map<String, dynamic>.from(
      rawUser is Map<String, dynamic> ? rawUser : data,
    );

    // Backend may put vendor_type / roles next to user, not inside it.
    if (userJson['vendor_type'] == null && data['vendor_type'] != null) {
      userJson['vendor_type'] = data['vendor_type'];
    }
    if (userJson['vendor_type_key'] == null && data['vendor_type_key'] != null) {
      userJson['vendor_type_key'] = data['vendor_type_key'];
    }
    if (userJson['vendor_id'] == null && data['vendor_id'] != null) {
      userJson['vendor_id'] = data['vendor_id'];
    }
    if ((userJson['roles'] == null ||
            (userJson['roles'] is List && (userJson['roles'] as List).isEmpty)) &&
        data['roles'] != null) {
      userJson['roles'] = data['roles'];
    }

    return UserModel.fromJson(userJson);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'image': image,
        'email_verified_at': emailVerifiedAt,
        'phone_verified_at': phoneVerifiedAt,
        'is_active': isActive,
        'is_verified': isVerified,
        'roles': roles,
        'permissions': permissions,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'vendor_type_id': vendorTypeId,
        'vendor_type_key': vendorTypeKey,
        'type': vendorTypeKey,
        'vendor_id': vendorId,
      };

  /// Prefers stable keys over localized `type` / `name`.
  /// Arabic `type: صيدلية` must not hide pharmacy features.
  static (int?, String?) _parseVendorType(Map<String, dynamic> json) {
    int? id = JsonParsers.asInt(json['vendor_type_id']);
    String? stableKey;
    String? fallback;

    void takeStable(String? value) {
      stableKey ??= JsonParsers.asString(value);
    }

    void takeFallback(String? value) {
      fallback ??= JsonParsers.asString(value);
    }

    takeStable(json['vendor_type_key']);

    final nested = json['vendor_type'];
    if (nested is String) {
      takeFallback(nested);
    } else if (nested is Map) {
      final map = Map<String, dynamic>.from(nested);
      id ??= JsonParsers.asInt(map['id']);
      takeStable(map['key']);
      takeFallback(map['slug']);
      takeFallback(map['name']);
    }

    takeFallback(json['type']);

    final resolved = VendorAccess.canonicalKey(stableKey ?? fallback);
    return (id, resolved);
  }
}
