import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? image;
  final String? emailVerifiedAt;
  final String? phoneVerifiedAt;
  final bool isActive;
  final bool isVerified;
  final List<String> roles;
  final List<String> permissions;
  final String createdAt;
  final String updatedAt;
  final int? vendorTypeId;
  final String? vendorTypeKey;

  /// Vendor this user owns/works for; differs from [id].
  final int? vendorId;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.image,
    this.emailVerifiedAt,
    this.phoneVerifiedAt,
    required this.isActive,
    required this.isVerified,
    required this.roles,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
    this.vendorTypeId,
    this.vendorTypeKey,
    this.vendorId,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        image,
        emailVerifiedAt,
        phoneVerifiedAt,
        isActive,
        isVerified,
        roles,
        permissions,
        createdAt,
        updatedAt,
        vendorTypeId,
        vendorTypeKey,
        vendorId,
      ];
}
