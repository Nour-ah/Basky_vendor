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
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: parseLocalizedJsonValue(
        json['category_name'] ?? json['category']?['name'],
      ),
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      status: ProductStatus.fromString(json['status']?.toString() ?? 'active'),
    );
  }

  static String _nonEmpty(String value, {required String fallback}) {
    return value.trim().isEmpty ? fallback : value;
  }
}
