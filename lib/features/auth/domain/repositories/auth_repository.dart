import '../entities/auth_response.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({
    required String login,
    required String password,
  });
  Future<void> logout();
  Future<User> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}