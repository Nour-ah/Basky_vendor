import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
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

    // Step 1: Check cached token
    debugPrint('🔵 Splash: Checking cached token...');
    final hasTokenEither = await isLoggedInUseCase();
    final hasToken = hasTokenEither.fold((_) => false, (hasToken) => hasToken);

    if (!hasToken) {
      debugPrint('❌ Splash: No token found');
      await _waitMinDuration(stopwatch);
      emit(const SplashState.unauthenticated());
      return;
    }

    // Step 2: Validate session with server
    debugPrint('🔵 Splash: Validating session with GET /api/user...');
    final userEither = await getCurrentUserUseCase();
    userEither.fold(
      (failure) {
        debugPrint('❌ Splash: API error — ${failure.message}');
        // Treat any failure as unauthenticated (including 401)
        await logoutUseCase(); // Ignore result
        await _waitMinDuration(stopwatch);
        emit(const SplashState.unauthenticated(
          message: 'Session expired. Please login again.',
        ));
      },
      (user) {
        debugPrint('✅ Splash: Session valid — welcome ${user.name}');
        await _waitMinDuration(stopwatch);
        emit(SplashState.authenticated(user: user));
      },
    );
  }
}
