import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/features/my_restaurant/domain/entities/product_type.dart';

void main() {
  group('ProductType', () {
    test('default productType is ProductType.simple when string is unknown or null', () {
      expect(ProductType.fromString(null), ProductType.simple);
      expect(ProductType.fromString('unknown'), ProductType.simple);
      expect(ProductType.fromString(''), ProductType.simple);
    });

    test('fromString parses correctly', () {
      expect(ProductType.fromString('simple'), ProductType.simple);
      expect(ProductType.fromString('SIMPLE'), ProductType.simple);
      expect(ProductType.fromString('variable'), ProductType.variable);
      expect(ProductType.fromString('VARIABLE'), ProductType.variable);
    });

    test('toApiString() returns exact lower-case string expected by backend', () {
      expect(ProductType.simple.toApiString(), 'simple');
      expect(ProductType.variable.toApiString(), 'variable');
    });
  });
}
