import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/forgot_password_repository.dart';

/// Sets a new password using a validated [resetToken].
///
/// Returns [Right<AuthActionResult>] on success, [Left<Failure>] on failure.
/// No exception handling here — that responsibility belongs to the repository.
class SetNewPasswordUseCase {
  final ForgotPasswordRepository repository;

  SetNewPasswordUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) =>
      repository.setNewPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
}
