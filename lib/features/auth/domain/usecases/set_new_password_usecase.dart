import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/forgot_password_repository.dart';

class SetNewPasswordUseCase {
  final ForgotPasswordRepository repository;

  SetNewPasswordUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await repository.setNewPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      if (result.success) {
        return Right(result);
      }
      return Left(ServerFailure(result.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
