import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction_entity.dart';
import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWalletDetails();
  
  Future<Either<Failure, List<TransactionEntity>>> getWalletHistory();
  
  Future<Either<Failure, Unit>> requestWithdrawal({
    required double amount,
    required String method,
    String? notes,
  });
}
