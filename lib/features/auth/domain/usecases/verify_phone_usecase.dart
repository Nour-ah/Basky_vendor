import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/auth_repository.dart';

class VerifyPhoneUseCase {
  final AuthRepository repository;
  VerifyPhoneUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({required String phone, required String code}) {
    return repository.verifyPhone(phone: phone, code: code);
  }
}
