import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/variant_entity.dart';
import '../repositories/variant_repository.dart';

class GetVariantsUseCase implements UseCase<List<VariantEntity>, NoParams> {
  final VariantRepository repository;

  GetVariantsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VariantEntity>>> call(NoParams params) {
    return repository.getVariants();
  }
}
