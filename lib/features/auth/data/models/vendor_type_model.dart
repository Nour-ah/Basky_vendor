import '../../domain/entities/vendor_type.dart';

class VendorTypeModel extends VendorType {
  const VendorTypeModel({
    required super.id,
    required super.key,
    required super.name,
    super.image,
  });

  factory VendorTypeModel.fromJson(Map<String, dynamic> json) {
    return VendorTypeModel(
      id: json['id'] as int? ?? 0,
      key: json['key'] as String? ?? '',
      name: json['name'] as String? ?? '',
      image: json['image'] as String?,
    );
  }
}
