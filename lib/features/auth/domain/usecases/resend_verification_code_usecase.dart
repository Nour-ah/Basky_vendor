import '../entities/auth_action_result.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationCodeUseCase {
  final AuthRepository repository;
  ResendVerificationCodeUseCase(this.repository);

  Future<AuthActionResult> call({required String email}) {
    return repository.resendVerificationCode(email: email);
  }
}
