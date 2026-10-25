import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/get_vendor_types_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_verification_code_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import '../../domain/usecases/verify_phone_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyPhoneUseCase verifyPhoneUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final ResendVerificationCodeUseCase resendVerificationCodeUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;
  final GetVendorTypesUseCase getVendorTypesUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyPhoneUseCase,
    required this.verifyEmailUseCase,
    required this.resendVerificationCodeUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.isLoggedInUseCase,
    required this.getVendorTypesUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final isLoggedIn = await isLoggedInUseCase().then((either) => either.fold((_) => false, (isLoggedIn) => isLoggedIn));
    emit(AuthCheckStatus(isLoggedIn: isLoggedIn));
  }

  Future<void> login({required String login, required String password}) async {
    emit(AuthLoading());
    String? fcmToken;
    try {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Login FCM token fetch failed: $e');
      }
    }
    final result = await loginUseCase(
      login: login,
      password: password,
      fcmToken: fcmToken,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) => emit(AuthLoginSuccess(user: response.user, token: response.token)),
    );
  }

  Future<void> loadVendorTypes() async {
    final result = await getVendorTypesUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (types) => emit(AuthVendorTypesLoaded(types: types)),
    );
  }

  Future<void> register({
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
  }) async {
    emit(AuthLoading());
    final result = await registerUseCase(
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ownerPhone: ownerPhone,
      ownerPassword: ownerPassword,
      ownerPasswordConfirmation: ownerPasswordConfirmation,
      restaurantNameEn: restaurantNameEn,
      restaurantNameAr: restaurantNameAr,
      restaurantPhone: restaurantPhone,
      address: address,
      vendorTypeId: vendorTypeId,
      imagePath: imagePath,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (registerResult) => emit(
        AuthRegisterSuccess(
          message: registerResult.message,
          phone: ownerPhone,
          email: ownerEmail,
          isActive: registerResult.user?.isActive ?? true,
        ),
      ),
    );
  }

  Future<void> verifyPhone({required String phone, required String code}) async {
    emit(AuthLoading());
    final result = await verifyPhoneUseCase(phone: phone, code: code);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (resultEntity) {
        if (resultEntity.success || _isAlreadyVerified(resultEntity.message)) {
          emit(AuthVerifyPhoneSuccess(message: resultEntity.message));
        } else {
          emit(AuthError(message: resultEntity.message.isNotEmpty ? resultEntity.message : 'Verification failed'));
        }
      },
    );
  }

  Future<void> verifyEmail({required String email, required String code}) async {
    emit(AuthLoading());
    final result = await verifyEmailUseCase(email: email, code: code);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (resultEntity) {
        if (resultEntity.success || _isAlreadyVerified(resultEntity.message)) {
          emit(AuthVerifyEmailSuccess(message: resultEntity.message));
        } else {
          emit(AuthError(
            message: resultEntity.message.isNotEmpty ? resultEntity.message : 'Verification failed',
          ));
        }
      },
    );
  }

  Future<void> resendVerificationCode({required String email}) async {
    emit(AuthLoading());
    final result = await resendVerificationCodeUseCase(email: email);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (resultEntity) {
        if (resultEntity.success) {
          emit(AuthResendCodeSuccess(message: resultEntity.message));
        } else {
          emit(AuthError(message: resultEntity.message.isNotEmpty ? resultEntity.message : 'Could not resend code'));
        }
      },
    );
  }

  bool _isAlreadyVerified(String message) {
    return message.toLowerCase().contains('already verified');
  }

  Future<void> logout() async {
    emit(AuthLoading());
    final result = await logoutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) => emit(AuthLogoutSuccess()),
    );
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    final result = await getCurrentUserUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) => emit(AuthUserLoaded(user: user)),
    );
  }
}
