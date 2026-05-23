import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_verification_code_usecase.dart';
import '../../domain/usecases/verify_phone_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;
  final VerifyPhoneUseCase verifyPhoneUseCase;
  final ResendVerificationCodeUseCase resendVerificationCodeUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;

  AuthCubit({
    required this.loginUseCase,
    required this.registerUseCase,
    required this.verifyPhoneUseCase,
    required this.resendVerificationCodeUseCase,
    required this.logoutUseCase,
    required this.getCurrentUserUseCase,
    required this.isLoggedInUseCase,
  }) : super(AuthInitial());

  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    final isLoggedIn = await isLoggedInUseCase().then((either) => either.fold((_) => false, (isLoggedIn) => isLoggedIn));
    emit(AuthCheckStatus(isLoggedIn: isLoggedIn));
  }

  Future<void> login({required String login, required String password}) async {
    emit(AuthLoading());
    final result = await loginUseCase(login: login, password: password);
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (response) => emit(AuthLoginSuccess(user: response.user, token: response.token)),
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
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (message) => emit(
        AuthRegisterSuccess(
          message: message,
          phone: ownerPhone,
          email: ownerEmail,
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
    await logoutUseCase().then((_) => emit(AuthLogoutSuccess()));
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