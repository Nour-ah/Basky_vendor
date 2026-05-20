import 'package:equatable/equatable.dart';
import 'product_status.dart';

class ProductSummaryEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final double price;
  final double discountPrice;
  final int categoryId;
  final String categoryName;
  final String? imageUrl;
  final ProductStatus status;

  const ProductSummaryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.discountPrice,
    required this.categoryId,
    required this.categoryName,
    this.imageUrl,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        discountPrice,
        categoryId,
        categoryName,
        imageUrl,
        status,
      ];
}
