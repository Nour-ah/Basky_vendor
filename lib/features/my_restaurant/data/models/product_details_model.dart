import '../../domain/entities/product_details_entity.dart';
import '../../domain/entities/product_status.dart';

class ProductDetailsModel extends ProductDetailsEntity {
  const ProductDetailsModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.discountPrice,
    required super.categoryId,
    required super.categoryName,
    super.imageUrl,
    required super.status,
    super.subcategoryId,
    super.subcategoryName,
    required super.maxOrderQuantity,
    super.addons = const [],
    super.prepTime,
    super.hasVariants = false,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    // Defensively parse addons list
    final List<String> parsedAddons = [];
    if (json['addons'] is List) {
      for (var item in json['addons'] as List) {
        if (item != null) parsedAddons.add(item.toString());
      }
    }

    return ProductDetailsModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? json['title']?.toString() ?? 'Unknown Product',
      description: json['description']?.toString() ?? json['desc']?.toString() ?? '',
      price: json['price'] is num ? (json['price'] as num).toDouble() : double.tryParse(json['price']?.toString() ?? '0.0') ?? 0.0,
      discountPrice: json['discount_price'] is num ? (json['discount_price'] as num).toDouble() : double.tryParse(json['discount_price']?.toString() ?? '0.0') ?? 0.0,
      categoryId: json['category_id'] is int ? json['category_id'] : int.tryParse(json['category_id']?.toString() ?? '0') ?? 0,
      categoryName: json['category_name']?.toString() ?? json['category']?['name']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      status: ProductStatus.fromString(json['status']?.toString() ?? 'active'),
      subcategoryId: json['subcategory_id'] is int ? json['subcategory_id'] : int.tryParse(json['subcategory_id']?.toString() ?? ''),
      subcategoryName: json['subcategory_name']?.toString() ?? json['subcategory']?['name']?.toString(),
      maxOrderQuantity: json['max_order_quantity'] is int ? json['max_order_quantity'] : int.tryParse(json['max_order_quantity']?.toString() ?? '1') ?? 1,
      addons: parsedAddons,
      prepTime: json['prep_time']?.toString() ?? json['preparation_time']?.toString(),
      hasVariants: json['has_variants'] is bool ? json['has_variants'] : (json['has_variants']?.toString() == 'true' || json['has_variants']?.toString() == '1'),
    );
  }
}
