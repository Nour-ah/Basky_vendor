import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/add_product_params.dart';
import '../repositories/restaurant_repository.dart';

class AddProductUseCase {
  final RestaurantRepository repository;

  AddProductUseCase(this.repository);

  Future<Either<Failure, void>> call(AddProductParams params) async {
    return await repository.addProduct(params);
  }
}
