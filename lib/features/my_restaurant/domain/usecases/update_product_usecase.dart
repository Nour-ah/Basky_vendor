import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_product_params.dart';
import '../repositories/restaurant_repository.dart';

class UpdateProductUseCase {
  final RestaurantRepository repository;

  UpdateProductUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId, AddProductParams params) async {
    return await repository.updateProduct(productId, params);
  }
}
