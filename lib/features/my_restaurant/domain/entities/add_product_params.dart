import 'package:equatable/equatable.dart';
import 'product_image_entity.dart';
import 'product_status.dart';

class AddProductParams extends Equatable {
  final String name;
  final String description;
  final double price;
  final double discountPercentage;
  final int categoryId;
  final int? subcategoryId;
  final int maxOrderQuantity;
  final ProductStatus status;
  final ProductImageEntity? image;
  final bool isEditMode;
  final int? productId;

  const AddProductParams({
    required this.name,
    required this.description,
    required this.price,
    required this.discountPercentage,
    required this.categoryId,
    this.subcategoryId,
    required this.maxOrderQuantity,
    required this.status,
    this.image,
    this.isEditMode = false,
    this.productId,
  });

  @override
  List<Object?> get props => [
        name,
        description,
        price,
        discountPercentage,
        categoryId,
        subcategoryId,
        maxOrderQuantity,
        status,
        image,
        isEditMode,
        productId,
      ];
}
