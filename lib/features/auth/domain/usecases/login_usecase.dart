import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Either<Failure, AuthResponse>> call({required String login, required String password}) {
    return repository.login(login: login, password: password);
  }
}