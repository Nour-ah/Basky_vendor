import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/product_variation_params.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/product_variant_entity.dart';
import 'package:basky_vendor/features/my_restaurant/domain/utils/product_variations_builder.dart';

void main() {
  const colorVariant = ProductVariantEntity(
    id: 1,
    name: 'اللون',
    options: [
      VariantOptionEntity(id: 1, name: 'أحمر', code: 'red'),
      VariantOptionEntity(id: 2, name: 'أخضر', code: 'green'),
    ],
  );

  test('builds one variation per selected option for a single variant', () {
    final variations = buildProductVariations(
      variants: const [colorVariant],
      selectedOptionsByVariant: {1: [1, 2]},
      nameEn: 'Shirt',
      nameAr: 'قميص',
      basePrice: 100,
      baseSku: 'SHIRT',
    );

    expect(variations.length, 2);
    expect(variations.first.values, [
      const VariationValueParams(variantId: 1, optionId: 1),
    ]);
    expect(variations.first.sku, contains('red'));
  });

  test('countVariationCombinations returns cartesian product size', () {
    expect(
      countVariationCombinations({1: [1, 2], 2: [4, 5, 6]}),
      6,
    );
  });
}
