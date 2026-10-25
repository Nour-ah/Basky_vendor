import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import 'user_model.dart';

class AuthResponseModel extends AuthResponse {
  const AuthResponseModel({
    required User user,
    required super.token,
    required super.tokenType,
  }) : super(user: user);

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    return AuthResponseModel(
      // Prefer envelope parse so sibling `vendor_type` on login data is kept.
      user: UserModel.fromApiData(json),
      token: json['token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
    );
  }
}