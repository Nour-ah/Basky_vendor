import 'user.dart';

class RegisterResult {
  final String message;
  final User? user;

  const RegisterResult({
    required this.message,
    this.user,
  });
}
