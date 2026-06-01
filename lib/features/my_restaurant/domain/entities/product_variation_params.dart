import 'package:equatable/equatable.dart';

class VariationValueParams extends Equatable {
  final int variantId;
  final int optionId;

  const VariationValueParams({
    required this.variantId,
    required this.optionId,
  });

  @override
  List<Object?> get props => [variantId, optionId];
}

class ProductVariationParams extends Equatable {
  final String nameEn;
  final String nameAr;
  final String sku;
  final double price;
  final List<VariationValueParams> values;

  const ProductVariationParams({
    required this.nameEn,
    required this.nameAr,
    required this.sku,
    required this.price,
    required this.values,
  });

  @override
  List<Object?> get props => [nameEn, nameAr, sku, price, values];
}
