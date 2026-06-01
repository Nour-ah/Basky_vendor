import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/restaurant_repository.dart';

class ToggleRestaurantStatusUseCase {
  final RestaurantRepository repository;

  ToggleRestaurantStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call() => repository.toggleStatus();
}
