import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../entities/auth_response.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login({
    required String login,
    required String password,
  });
  Future<Either<Failure, String>> register({
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
  Future<Either<Failure, AuthActionResult>> verifyPhone({required String phone, required String code});
  Future<Either<Failure, AuthActionResult>> resendVerificationCode({required String email});
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, String?>> getToken();
}