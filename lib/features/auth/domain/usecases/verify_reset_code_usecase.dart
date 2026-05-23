import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/reset_token_result.dart';
import '../repositories/forgot_password_repository.dart';

/// Verifies the password-reset code sent to the user's email.
///
/// Returns [Right<ResetTokenResult>] on success, [Left<Failure>] on failure.
/// No exception handling here — that responsibility belongs to the repository.
class VerifyResetCodeUseCase {
  final ForgotPasswordRepository repository;

  VerifyResetCodeUseCase(this.repository);

  Future<Either<Failure, ResetTokenResult>> call({
    required String code,
    required String email,
  }) =>
      repository.verifyResetCode(code: code, email: email);
}
