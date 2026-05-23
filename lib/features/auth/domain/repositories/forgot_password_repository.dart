import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../entities/reset_token_result.dart';

/// Domain contract for the forgot-password flow.
///
/// All methods return [Either<Failure, T>] — the domain layer
/// never sees raw exceptions or [DioException].
abstract class ForgotPasswordRepository {
  Future<Either<Failure, AuthActionResult>> sendResetCode({required String email});

  Future<Either<Failure, ResetTokenResult>> verifyResetCode({
    required String code,
    required String email,
  });

  Future<Either<Failure, AuthActionResult>> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}
