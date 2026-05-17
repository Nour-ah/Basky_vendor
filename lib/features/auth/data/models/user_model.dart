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
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      emailVerifiedAt: json['email_verified_at'],
      phoneVerifiedAt: json['phone_verified_at'],
      isActive: json['is_active'] ?? false,
      isVerified: json['is_verified'] ?? false,
      roles: List<String>.from(json['roles'] ?? []),
      permissions: List<String>.from(json['permissions'] ?? []),
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
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
      };
}