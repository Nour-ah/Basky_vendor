import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/forgot_password_repository.dart';

/// Sends a password-reset code to the given [email].
///
/// Delegates entirely to [ForgotPasswordRepository] which returns
/// [Either<Failure, AuthActionResult>]. No exception handling here —
/// that responsibility belongs to the repository layer.
class SendResetCodeUseCase {
  final ForgotPasswordRepository repository;

  SendResetCodeUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({required String email}) =>
      repository.sendResetCode(email: email);
}
