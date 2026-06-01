import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/vendor_branch_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetVendorBranchesUseCase {
  final RestaurantRepository repository;

  GetVendorBranchesUseCase(this.repository);

  Future<Either<Failure, List<VendorBranchEntity>>> call() =>
      repository.getBranches();
}
