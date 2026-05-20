import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final IsLoggedInUseCase isLoggedInUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;

  /// Minimum splash duration for smooth UX
  static const _minSplashDuration = Duration(seconds: 2);

  SplashCubit({
    required this.isLoggedInUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
  }) : super(const SplashState.loading());

  Future<void> checkAuthSession() async {
    final stopwatch = Stopwatch()..start();

    try {
      // Step 1: Check cached token
      debugPrint('🔵 Splash: Checking cached token...');
      final hasToken = await isLoggedInUseCase();

      if (!hasToken) {
        debugPrint('❌ Splash: No token found');
        await _waitMinDuration(stopwatch);
        emit(const SplashState.unauthenticated());
        return;
      }

      // Step 2: Validate session with server
      debugPrint('🔵 Splash: Validating session with GET /api/user...');
      try {
        final user = await getCurrentUserUseCase();
        debugPrint('✅ Splash: Session valid — welcome ${user.name}');
        await _waitMinDuration(stopwatch);
        emit(SplashState.authenticated(user: user));
      } on DioException catch (e) {
        if (e.response?.statusCode == 401) {
          debugPrint('❌ Splash: Session expired (401) — clearing token');
          await logoutUseCase();
          await _waitMinDuration(stopwatch);
          emit(const SplashState.unauthenticated(
            message: 'Session expired. Please login again.',
          ));
        } else if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.connectionError) {
          // Scenario D: No internet but valid cached token
          debugPrint('⚠️ Splash: Network error — allowing offline access');
          await _waitMinDuration(stopwatch);
          emit(const SplashState.unauthenticated(
            message: 'No internet connection.',
          ));
        } else {
          debugPrint('❌ Splash: API error — ${e.message}');
          await _waitMinDuration(stopwatch);
          emit(const SplashState.unauthenticated(
            message: 'Something went wrong.',
          ));
        }
      }
    } catch (e) {
      debugPrint('❌ Splash: Unexpected error — $e');
      await _waitMinDuration(stopwatch);
      emit(SplashState.unauthenticated(message: e.toString()));
    }
  }

  /// Ensures the splash stays visible for at least [_minSplashDuration]
  Future<void> _waitMinDuration(Stopwatch stopwatch) async {
    stopwatch.stop();
    final elapsed = stopwatch.elapsed;
    if (elapsed < _minSplashDuration) {
      await Future.delayed(_minSplashDuration - elapsed);
    }
  }
}
