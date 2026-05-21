import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/reset_token_result.dart';
import '../repositories/forgot_password_repository.dart';

class VerifyResetCodeUseCase {
  final ForgotPasswordRepository repository;

  VerifyResetCodeUseCase(this.repository);

  Future<Either<Failure, ResetTokenResult>> call({
    required String code,
    required String email,
  }) async {
    try {
      final result = await repository.verifyResetCode(code: code, email: email);
      if (result.success && result.resetToken != null) {
        return Right(result);
      }
      return Left(ServerFailure(result.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
