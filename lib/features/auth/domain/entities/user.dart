class User {
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
  });
}