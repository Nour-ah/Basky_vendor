import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/restaurant_repository.dart';

class DeleteBranchUseCase {
  DeleteBranchUseCase(this.repository);

  final RestaurantRepository repository;

  Future<Either<Failure, void>> call(int branchId) {
    return repository.deleteBranch(branchId);
  }
}
