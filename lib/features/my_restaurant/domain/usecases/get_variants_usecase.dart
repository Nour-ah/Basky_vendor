import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/product_variant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetVariantsUseCase implements UseCase<List<ProductVariantEntity>, NoParams> {
  final RestaurantRepository repository;

  GetVariantsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProductVariantEntity>>> call(NoParams params) {
    return repository.getVariants();
  }
}
