import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/add_branch_params.dart';
import '../repositories/restaurant_repository.dart';

class UpdateBranchUseCase {
  UpdateBranchUseCase(this.repository);

  final RestaurantRepository repository;

  Future<Either<Failure, void>> call({
    required int branchId,
    required AddBranchParams params,
  }) {
    return repository.updateBranch(branchId, params);
  }
}
