import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../repositories/forgot_password_repository.dart';

class SendResetCodeUseCase {
  final ForgotPasswordRepository repository;

  SendResetCodeUseCase(this.repository);

  Future<Either<Failure, AuthActionResult>> call({required String email}) async {
    try {
      final result = await repository.sendResetCode(email: email);
      if (result.success) {
        return Right(result);
      }
      return Left(ServerFailure(result.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
