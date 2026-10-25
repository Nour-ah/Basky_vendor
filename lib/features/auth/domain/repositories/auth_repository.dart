import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_action_result.dart';
import '../entities/auth_response.dart';
import '../entities/register_result.dart';
import '../entities/user.dart';
import '../entities/vendor_type.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthResponse>> login({
    required String login,
    required String password,
    String? fcmToken,
  });
  Future<Either<Failure, RegisterResult>> register({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
    required int vendorTypeId,
    String? imagePath,
  });
  Future<Either<Failure, List<VendorType>>> getVendorTypes();
  Future<Either<Failure, AuthActionResult>> verifyPhone({required String phone, required String code});
  Future<Either<Failure, AuthActionResult>> verifyEmail({required String email, required String code});
  Future<Either<Failure, AuthActionResult>> resendVerificationCode({required String email});
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
  Future<Either<Failure, String?>> getToken();
}
