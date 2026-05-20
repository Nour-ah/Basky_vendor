import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/wallet_repository.dart';

class RequestWithdrawalUseCase {
  final WalletRepository repository;

  RequestWithdrawalUseCase(this.repository);

  Future<Either<Failure, Unit>> call({
    required double amount,
    required String method,
    String? notes,
  }) async {
    return await repository.requestWithdrawal(
      amount: amount,
      method: method,
      notes: notes,
    );
  }
}
