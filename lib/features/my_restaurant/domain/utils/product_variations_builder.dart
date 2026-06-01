import 'package:collection/collection.dart';

import '../entities/product_variation_params.dart';
import '../entities/product_variant_entity.dart';

/// Builds API `variations[]` rows from selected variant options (cartesian product).
List<ProductVariationParams> buildProductVariations({
  required List<ProductVariantEntity> variants,
  required Map<int, List<int>> selectedOptionsByVariant,
  required String nameEn,
  required String nameAr,
  required double basePrice,
  String? baseSku,
}) {
  final dimensionLists = <List<VariationValueParams>>[];

  for (final entry in selectedOptionsByVariant.entries) {
    if (entry.value.isEmpty) continue;
    final variant = variants.where((v) => v.id == entry.key).firstOrNull;
    if (variant == null) continue;

    dimensionLists.add(
      entry.value.map((optionId) {
        final option = variant.options.where((o) => o.id == optionId).firstOrNull;
        if (option == null) {
          return VariationValueParams(variantId: variant.id, optionId: optionId);
        }
        return VariationValueParams(variantId: variant.id, optionId: option.id);
      }).toList(),
    );
  }

  if (dimensionLists.isEmpty) return [];

  final combinations = _cartesianProduct(dimensionLists);
  final skuBase = (baseSku != null && baseSku.trim().isNotEmpty)
      ? baseSku.trim()
      : _slugify(nameEn);

  return [
    for (var i = 0; i < combinations.length; i++)
      _variationFromCombination(
        values: combinations[i],
        variants: variants,
        nameEn: nameEn,
        nameAr: nameAr,
        basePrice: basePrice,
        skuBase: skuBase,
        index: i,
      ),
  ];
}

int countVariationCombinations(Map<int, List<int>> selectedOptionsByVariant) {
  var count = 1;
  var hasAny = false;
  for (final optionIds in selectedOptionsByVariant.values) {
    if (optionIds.isEmpty) continue;
    hasAny = true;
    count *= optionIds.length;
  }
  return hasAny ? count : 0;
}

ProductVariationParams _variationFromCombination({
  required List<VariationValueParams> values,
  required List<ProductVariantEntity> variants,
  required String nameEn,
  required String nameAr,
  required double basePrice,
  required String skuBase,
  required int index,
}) {
  final labelParts = <String>[];
  final skuParts = <String>[];

  for (final value in values) {
    final variant = variants.where((v) => v.id == value.variantId).firstOrNull;
    final option = variant?.options.where((o) => o.id == value.optionId).firstOrNull;
    if (option != null) {
      labelParts.add(option.name);
      skuParts.add(option.code ?? option.id.toString());
    }
  }

  final label = labelParts.join(' / ');
  final skuSuffix = skuParts.join('-');

  return ProductVariationParams(
    nameEn: label.isEmpty ? nameEn : '$nameEn - $label',
    nameAr: label.isEmpty ? nameAr : '$nameAr - $label',
    sku: skuSuffix.isEmpty ? '$skuBase-$index' : '$skuBase-$skuSuffix',
    price: basePrice,
    values: values,
  );
}

List<List<VariationValueParams>> _cartesianProduct(
  List<List<VariationValueParams>> dimensions,
) {
  var result = <List<VariationValueParams>>[<VariationValueParams>[]];
  for (final dimension in dimensions) {
    final next = <List<VariationValueParams>>[];
    for (final partial in result) {
      for (final value in dimension) {
        next.add([...partial, value]);
      }
    }
    result = next;
  }
  return result;
}

String _slugify(String value) {
  return value
      .trim()
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'-+'), '-')
      .replaceAll(RegExp(r'^-|-$'), '');
}
