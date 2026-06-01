import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/vendor_branch_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetVendorBranchUseCase {
  final RestaurantRepository repository;

  GetVendorBranchUseCase(this.repository);

  Future<Either<Failure, VendorBranchEntity?>> call() =>
      repository.getPrimaryBranch();
}
