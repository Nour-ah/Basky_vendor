import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/variant_repository.dart';

class DeleteVariantUseCase implements UseCase<void, int> {
  final VariantRepository repository;

  DeleteVariantUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) {
    return repository.deleteVariant(id);
  }
}
