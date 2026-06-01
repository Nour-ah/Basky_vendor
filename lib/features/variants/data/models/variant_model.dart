import '../../domain/entities/variant_entity.dart';

class VariantModel extends VariantEntity {
  const VariantModel({
    required super.id,
    required super.name,
    super.isRequired,
    super.isActive,
    required super.options,
  });

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    final optionsJson = json['options'] as List<dynamic>? ?? [];
    return VariantModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      isRequired: json['is_required'] as bool?,
      isActive: json['is_active'] as bool?,
      options: optionsJson
          .whereType<Map<String, dynamic>>()
          .map(
            (e) => VariantOptionModel.fromJson(e),
          )
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (isRequired != null) 'is_required': isRequired,
      if (isActive != null) 'is_active': isActive,
      'options': options.map((e) => {
        'id': e.id,
        if (e.variantId != null) 'variant_id': e.variantId,
        'name': e.name,
        if (e.code != null) 'code': e.code,
      }).toList(),
    };
  }
}

class VariantOptionModel extends VariantOptionEntity {
  const VariantOptionModel({
    required super.id,
    super.variantId,
    required super.name,
    super.code,
  });

  factory VariantOptionModel.fromJson(Map<String, dynamic> json) {
    return VariantOptionModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      variantId: json['variant_id']?.toString(),
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (variantId != null) 'variant_id': variantId,
      'name': name,
      if (code != null) 'code': code,
    };
  }
}
