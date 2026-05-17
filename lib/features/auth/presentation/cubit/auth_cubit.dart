import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final IsLoggedInUseCase isLoggedInUseCase;

  AuthCubit({
    required this.loginUseCase,
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