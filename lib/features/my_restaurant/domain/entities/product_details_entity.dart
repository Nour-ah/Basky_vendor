import 'product_summary_entity.dart';

class ProductDetailsEntity extends ProductSummaryEntity {
  final int? subcategoryId;
  final String? subcategoryName;
  final int maxOrderQuantity;
  final List<String> addons;
  final String? prepTime;
  final bool hasVariants;

  const ProductDetailsEntity({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.discountPrice,
    required super.categoryId,
    required super.categoryName,
    super.imageUrl,
    required super.status,
    this.subcategoryId,
    this.subcategoryName,
    required this.maxOrderQuantity,
    this.addons = const [],
    this.prepTime,
    this.hasVariants = false,
  });

  @override
  List<Object?> get props => super.props..addAll([
    subcategoryId,
    subcategoryName,
    maxOrderQuantity,
    addons,
    prepTime,
    hasVariants,
  ]);
}
