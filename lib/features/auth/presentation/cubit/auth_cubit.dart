import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    try {
      final isLoggedIn = await isLoggedInUseCase();
      emit(AuthCheckStatus(isLoggedIn: isLoggedIn));
    } catch (_) {
      emit(const AuthCheckStatus(isLoggedIn: false));
    }
  }

  Future<void> login({required String login, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await loginUseCase(login: login, password: password);
      emit(AuthLoginSuccess(user: response.user, token: response.token));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
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
    try {
      final message = await registerUseCase(
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
      emit(
        AuthRegisterSuccess(
          message: message,
          phone: ownerPhone,
          email: ownerEmail,
        ),
      );
    } on DioException catch (e) {
      emit(AuthError(message: _dioErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> verifyPhone({required String phone, required String code}) async {
    emit(AuthLoading());
    try {
      final result = await verifyPhoneUseCase(phone: phone, code: code);
      if (result.success || _isAlreadyVerified(result.message)) {
        emit(AuthVerifyPhoneSuccess(message: result.message));
      } else {
        emit(AuthError(message: result.message.isNotEmpty ? result.message : 'Verification failed'));
      }
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ?? '';
        if (data['success'] == false && _isAlreadyVerified(message)) {
          emit(AuthVerifyPhoneSuccess(message: message));
          return;
        }
      }
      emit(AuthError(message: _dioErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> resendVerificationCode({required String email}) async {
    emit(AuthLoading());
    try {
      final result = await resendVerificationCodeUseCase(email: email);
      if (result.success) {
        emit(AuthResendCodeSuccess(message: result.message));
      } else {
        emit(AuthError(message: result.message.isNotEmpty ? result.message : 'Could not resend code'));
      }
    } on DioException catch (e) {
      emit(AuthError(message: _dioErrorMessage(e)));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  bool _isAlreadyVerified(String message) {
    return message.toLowerCase().contains('already verified');
  }

  String _dioErrorMessage(DioException e) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
      final errors = data['errors'];
      if (errors is Map) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
      }
    }
    return e.message ?? 'Something went wrong';
  }

  Future<void> logout() async {
    emit(AuthLoading());
    try {
      await logoutUseCase();
    } catch (_) {}
    emit(AuthLogoutSuccess());
  }

  Future<void> getCurrentUser() async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      emit(AuthUserLoaded(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}