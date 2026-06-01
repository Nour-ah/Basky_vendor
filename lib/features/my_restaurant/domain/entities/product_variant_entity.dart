import 'package:equatable/equatable.dart';

class VariantOptionEntity extends Equatable {
  final int id;
  final String? variantId;
  final String name;
  final String? code;

  const VariantOptionEntity({
    required this.id,
    this.variantId,
    required this.name,
    this.code,
  });

  @override
  List<Object?> get props => [id, variantId, name, code];
}

class ProductVariantEntity extends Equatable {
  final int id;
  final String name;
  final bool? isRequired;
  final bool? isActive;
  final List<VariantOptionEntity> options;

  const ProductVariantEntity({
    required this.id,
    required this.name,
    this.isRequired,
    this.isActive,
    required this.options,
  });

  @override
  List<Object?> get props => [id, name, isRequired, isActive, options];
}
