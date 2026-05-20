import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/product_summary_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetProductsUseCase {
  final RestaurantRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<ProductSummaryEntity>>> call({
    int? categoryId,
    String? searchQuery,
    int page = 1,
    int limit = 15,
  }) async {
    return await repository.getProducts(
      categoryId: categoryId,
      searchQuery: searchQuery,
      page: page,
      limit: limit,
    );
  }
}
