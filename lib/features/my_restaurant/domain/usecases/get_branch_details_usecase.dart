import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/branch_details_response_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetBranchDetailsUseCase {
  final RestaurantRepository repository;

  GetBranchDetailsUseCase(this.repository);

  Future<Either<Failure, BranchDetailsResponseEntity>> call(int branchId, {int page = 1}) =>
      repository.getBranchDetails(branchId, page: page);
}
