import 'package:equatable/equatable.dart';
import 'product_image_entity.dart';
import 'product_status.dart';
import 'product_type.dart';

class AddProductParams extends Equatable {
  final String nameEn;
  final String nameAr;
  final String descriptionEn;
  final String descriptionAr;

  /// Product type — only 'simple' or 'variable' are accepted by the API.
  final ProductType productType;

  final double price;
  final double discountPercentage;

  /// Always 'percentage' by default; extend if backend supports 'fixed'.
  final String discountType;

  final int categoryId;
  final ProductStatus status;
  final bool isFeatured;
  final bool isNew;
  final bool isBookable;
  final String? sku;
  final String? slug;
  final ProductImageEntity? image;
  final List<ProductImageEntity>? images;
  final bool isEditMode;
  final int? productId;

  const AddProductParams({
    required this.nameEn,
    required this.nameAr,
    this.descriptionEn = '',
    this.descriptionAr = '',
    this.productType = ProductType.simple,
    required this.price,
    this.discountPercentage = 0,
    this.discountType = 'percentage',
    required this.categoryId,
    this.status = ProductStatus.active,
    this.isFeatured = false,
    this.isNew = false,
    this.isBookable = false,
    this.sku,
    this.slug,
    this.image,
    this.images,
    this.isEditMode = false,
    this.productId,
  });

  @override
  List<Object?> get props => [
        nameEn,
        nameAr,
        descriptionEn,
        descriptionAr,
        productType,
        price,
        discountPercentage,
        discountType,
        categoryId,
        status,
        isFeatured,
        isNew,
        isBookable,
        sku,
        slug,
        image,
        images,
        isEditMode,
        productId,
      ];
}
