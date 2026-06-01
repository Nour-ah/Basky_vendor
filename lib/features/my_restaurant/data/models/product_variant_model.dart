import '../../domain/entities/product_variant_entity.dart';

class ProductVariantModel extends ProductVariantEntity {
  const ProductVariantModel({
    required super.id,
    required super.name,
    super.isRequired,
    super.isActive,
    required super.options,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List<dynamic>? ?? [];
    return ProductVariantModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      isRequired: json['is_required'] as bool?,
      isActive: json['is_active'] as bool?,
      options: optionsJson
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => VariantOptionEntity(
              id: e['id'] is int ? e['id'] : int.tryParse(e['id']?.toString() ?? '0') ?? 0,
              variantId: e['variant_id']?.toString(),
              name: e['name']?.toString() ?? '',
              code: e['code']?.toString(),
            ),
          )
          .toList(),
    );
  }
}
