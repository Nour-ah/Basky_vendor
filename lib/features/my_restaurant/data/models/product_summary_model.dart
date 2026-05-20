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
      name: json['name']?.toString() ?? json['title']?.toString() ?? 'Unknown Product',
      description: json['description']?.toString() ?? json['desc']?.toString() ?? '',
      price: json['price'] is num ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      discountPrice: json['discount_price'] is num ? (json['discount_price'] as num).toDouble() : double.tryParse(json['discount_price']?.toString() ?? '0.0') ?? 0.0,
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: json['category_name']?.toString() ?? json['category']?['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      status: ProductStatus.fromString(json['status']?.toString() ?? 'active'),
    );
  }
}
