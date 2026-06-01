import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/variant_repository.dart';

class UpdateVariantParams extends Equatable {
  final int id;
  final String name;
  final List<String> options;

  const UpdateVariantParams({
    required this.id,
    required this.name,
    required this.options,
  });

  @override
  List<Object?> get props => [id, name, options];
}

class UpdateVariantUseCase implements UseCase<void, UpdateVariantParams> {
  final VariantRepository repository;

  UpdateVariantUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateVariantParams params) {
    return repository.updateVariant(params.id, params.name, params.options);
  }
}
