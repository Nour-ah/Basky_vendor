import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/variant_repository.dart';

class AddVariantParams extends Equatable {
  final String name;
  final List<String> options;

  const AddVariantParams({required this.name, required this.options});

  @override
  List<Object?> get props => [name, options];
}

class AddVariantUseCase implements UseCase<void, AddVariantParams> {
  final VariantRepository repository;

  AddVariantUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(AddVariantParams params) {
    return repository.addVariant(params.name, params.options);
  }
}
