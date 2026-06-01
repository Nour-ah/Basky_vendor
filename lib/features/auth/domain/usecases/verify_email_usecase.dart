import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/auth_repository.dart';

class VerifyEmailUseCase {
  final AuthRepository repository;

  VerifyEmailUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({
    required String email,
    required String code,
  }) {
    return repository.verifyEmail(email: email, code: code);
  }
}
