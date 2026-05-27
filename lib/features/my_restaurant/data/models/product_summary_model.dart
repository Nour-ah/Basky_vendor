import '../../../../core/utils/localized_json_parser.dart';
import '../../domain/entities/product_status.dart';
import '../../domain/entities/product_summary_entity.dart';

class ProductSummaryModel extends ProductSummaryEntity {
  const ProductSummaryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.discountPrice,
    required super.categoryId,
    required super.categoryName,
    super.imageUrl,
    required super.status,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: _nonEmpty(parseLocalizedJsonValue(json['name'] ?? json['title']),
          fallback: 'Unknown Product'),
      description: parseLocalizedJsonValue(json['description'] ?? json['desc']),
      price: json['price'] is num ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      discountPrice: json['discount_price'] is num ? (json['discount_price'] as num).toDouble() : double.tryParse(json['discount_price']?.toString() ?? '0.0') ?? 0.0,
      categoryId: _parseCategoryId(json),
      categoryName: _parseCategoryName(json),
      imageUrl: json['thumb_image']?.toString() ?? json['image_url']?.toString() ?? json['image']?.toString(),
      status: ProductStatus.fromString(json['status']?.toString() ?? 'active'),
    );
  }

  static String _nonEmpty(String value, {required String fallback}) {
    return value.trim().isEmpty ? fallback : value;
  }

  static int _parseCategoryId(Map<String, dynamic> json) {
    if (json['category_id'] != null) {
      return json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0;
    }
    if (json['categories'] is List && (json['categories'] as List).isNotEmpty) {
      final firstCategory = (json['categories'] as List).first;
      if (firstCategory is Map) {
        return firstCategory['id'] is int ? firstCategory['id'] : int.tryParse(firstCategory['id']?.toString() ?? '0') ?? 0;
      }
    }
    return 0;
  }

  static String _parseCategoryName(Map<String, dynamic> json) {
    if (json['category_name'] != null || json['category'] != null) {
      return parseLocalizedJsonValue(json['category_name'] ?? json['category']?['name']);
    }
    if (json['categories'] is List && (json['categories'] as List).isNotEmpty) {
      final firstCategory = (json['categories'] as List).first;
      if (firstCategory is Map) {
        return parseLocalizedJsonValue(firstCategory['name']);
      }
    }
    return 'Unknown Category';
  }
}
