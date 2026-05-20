import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/transaction_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWalletHistoryUseCase {
  final WalletRepository repository;

  GetWalletHistoryUseCase(this.repository);

  Future<Either<Failure, List<TransactionEntity>>> call() async {
    return await repository.getWalletHistory();
  }
}
