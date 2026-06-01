import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository.dart';
import '../datasources/reviews_remote_datasource.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReviewsSummaryEntity>> getRatings() {
    return _execute(() => remoteDataSource.getRatings());
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
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
