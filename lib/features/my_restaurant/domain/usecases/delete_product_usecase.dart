import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/restaurant_repository.dart';

class DeleteProductUseCase {
  final RestaurantRepository repository;

  DeleteProductUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId) async {
    return await repository.deleteProduct(productId);
  }
}
