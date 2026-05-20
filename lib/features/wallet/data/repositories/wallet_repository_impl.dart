import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/wallet_entity.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../datasources/wallet_remote_datasource.dart';

class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource remoteDataSource;

  WalletRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, WalletEntity>> getWalletDetails() async {
    return _execute(() => remoteDataSource.getWalletDetails());
  }

  @override
  Future<Either<Failure, List<TransactionEntity>>> getWalletHistory() async {
    return _execute(() => remoteDataSource.getWalletHistory());
  }

  @override
  Future<Either<Failure, Unit>> requestWithdrawal({
    required double amount,
    required String method,
    String? notes,
  }) async {
    return _execute(() async {
      await remoteDataSource.requestWithdrawal(amount: amount, method: method, notes: notes);
      return unit;
    });
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
