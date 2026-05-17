import '../entities/auth_action_result.dart';
import '../entities/auth_response.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<AuthResponse> login({
    required String login,
    required String password,
  });
  Future<String> register({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
  });
  Future<AuthActionResult> verifyPhone({required String phone, required String code});
  Future<AuthActionResult> resendVerificationCode({required String email});
  Future<void> logout();
  Future<User> getCurrentUser();
  Future<bool> isLoggedIn();
  Future<String?> getToken();
}