import '../../../../core/utils/api_image_url.dart';
import '../../domain/entities/vendor_branch_entity.dart';

class VendorBranchModel extends VendorBranchEntity {
  const VendorBranchModel({
    required super.id,
    required super.name,
    required super.address,
    required super.isOpen,
    required super.rating,
    super.deliveryTime,
    super.deliveryFee,
    super.logoUrl,
    super.coverImageUrl,
    super.phone,
    super.latitude,
    super.longitude,
  });

  factory VendorBranchModel.fromJson(Map<String, dynamic> json) {
    return VendorBranchModel(
      id: json['id'] as int? ?? 0,
      name: _parseLocalizedName(json['name']) ??
          json['restaurant_name']?.toString() ??
          '',
      address: json['address']?.toString() ?? '',
      isOpen: _parseIsOpen(json),
      rating: _parseRating(json),
      deliveryTime: json['delivery_time']?.toString() ??
          json['estimated_delivery_time']?.toString(),
      deliveryFee: json['delivery_fee']?.toString() ??
          json['delivery_fee_amount']?.toString(),
      logoUrl: resolveApiImageUrl(
        json['logo_url']?.toString() ??
            json['logo']?.toString() ??
            json['image_url']?.toString() ??
            json['image']?.toString(),
      ),
      coverImageUrl: resolveApiImageUrl(
        json['image_url']?.toString() ??
            json['cover_image_url']?.toString() ??
            json['cover_image']?.toString() ??
            json['banner']?.toString() ??
            json['image']?.toString(),
      ),
      phone: json['phone']?.toString(),
      latitude: json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  static String? _parseLocalizedName(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is Map) {
      final en = value['en']?.toString();
      if (en != null && en.isNotEmpty) return en;
      final ar = value['ar']?.toString();
      if (ar != null && ar.isNotEmpty) return ar;
      for (final entry in value.entries) {
        final text = entry.value?.toString();
        if (text != null && text.isNotEmpty) return text;
      }
    }
    return value.toString();
  }

  static bool _parseIsOpen(Map<String, dynamic> json) {
    if (json['is_open'] is bool) return json['is_open'] as bool;
    if (json['is_active'] is bool) return json['is_active'] as bool;
    final status = json['status']?.toString().toLowerCase();
    if (status == 'open' || status == 'active') return true;
    if (status == 'closed' || status == 'inactive') return false;
    return false;
  }

  static double _parseRating(Map<String, dynamic> json) {
    final value = json['rating'] ?? json['average_rating'] ?? json['avg_rating'];
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
