import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/variant_entity.dart';

abstract class VariantRepository {
  Future<Either<Failure, List<VariantEntity>>> getVariants();

  Future<Either<Failure, void>> addVariant(String name, List<String> options);

  Future<Either<Failure, void>> updateVariant(int id, String name, List<String> options);

  Future<Either<Failure, void>> deleteVariant(int id);
}
