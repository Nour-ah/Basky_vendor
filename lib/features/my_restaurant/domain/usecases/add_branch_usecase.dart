import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/add_branch_params.dart';
import '../repositories/restaurant_repository.dart';

class AddBranchUseCase {
  AddBranchUseCase(this.repository);

  final RestaurantRepository repository;

  Future<Either<Failure, void>> call(AddBranchParams params) {
    return repository.addBranch(params);
  }
}
