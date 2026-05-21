import '../../domain/entities/auth_action_result.dart';
import '../../domain/entities/reset_token_result.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_remote_datasource.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remoteDataSource;

  ForgotPasswordRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthActionResult> sendResetCode({required String email}) {
    return remoteDataSource.sendResetCode(email: email);
  }

  @override
  Future<ResetTokenResult> verifyResetCode({
    required String code,
    required String email,
  }) {
    return remoteDataSource.verifyResetCode(code: code, email: email);
  }

  @override
  Future<AuthActionResult> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) {
    return remoteDataSource.setNewPassword(
      resetToken: resetToken,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
