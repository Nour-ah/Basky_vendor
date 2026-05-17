import '../entities/auth_response.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<AuthResponse> call({required String login, required String password}) {
    return repository.login(login: login, password: password);
  }
}