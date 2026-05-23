import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/auth_repository.dart';

class ResendVerificationCodeUseCase {
  final AuthRepository repository;
  ResendVerificationCodeUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({required String email}) {
    return repository.resendVerificationCode(email: email);
  }
}
