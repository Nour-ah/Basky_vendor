import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/variant_entity.dart';
import '../../domain/repositories/variant_repository.dart';
import '../datasources/variants_remote_datasource.dart';

class VariantsRepositoryImpl implements VariantRepository {
  final VariantsRemoteDataSource remoteDataSource;

  VariantsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<VariantEntity>>> getVariants() async {
    return _execute(() => remoteDataSource.getVariants());
  }

  @override
  Future<Either<Failure, void>> addVariant(String name, List<String> options) async {
    return _execute(() => remoteDataSource.addVariant(name, options));
  }

  @override
  Future<Either<Failure, void>> updateVariant(int id, String name, List<String> options) async {
    return _execute(() => remoteDataSource.updateVariant(id, name, options));
  }

  @override
  Future<Either<Failure, void>> deleteVariant(int id) async {
    return _execute(() => remoteDataSource.deleteVariant(id));
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
