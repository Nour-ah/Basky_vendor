import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_product_params.dart';
import '../entities/category_entity.dart';
import '../entities/product_details_entity.dart';
import '../entities/product_summary_entity.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  
  Future<Either<Failure, List<ProductSummaryEntity>>> getProducts({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  });

  Future<Either<Failure, ProductDetailsEntity>> getProductDetails(int productId);

  Future<Either<Failure, void>> addProduct(AddProductParams params);
  
  Future<Either<Failure, void>> updateProduct(int productId, AddProductParams params);

  Future<Either<Failure, void>> deleteProduct(int productId);
}
