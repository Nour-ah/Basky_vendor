import '../entities/auth_action_result.dart';
import '../entities/reset_token_result.dart';

abstract class ForgotPasswordRepository {
  Future<AuthActionResult> sendResetCode({required String email});
  Future<ResetTokenResult> verifyResetCode({
    required String code,
    required String email,
  });
  Future<AuthActionResult> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}
