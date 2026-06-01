import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/reports_summary_entity.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource remoteDataSource;

  ReportsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ReportsSummaryEntity>> getSummary({required String range}) {
    return _execute(() => remoteDataSource.getSummary(range: range));
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
