import 'user.dart';

class AuthResponse {
  final User user;
  final String token;
  final String tokenType;

  const AuthResponse({
    required this.user,
    required this.token,
    required this.tokenType,
  });
}