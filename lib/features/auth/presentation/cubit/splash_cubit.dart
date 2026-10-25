import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/notifications/device_token_service.dart';
import '../../domain/usecases/get_current_user_usecase.dart';
import '../../domain/usecases/is_logged_in_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final IsLoggedInUseCase isLoggedInUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final LogoutUseCase logoutUseCase;
  final DeviceTokenService deviceTokenService;

  /// Minimum splash duration for smooth UX
  static const _minSplashDuration = Duration(seconds: 2);

  SplashCubit({
    required this.isLoggedInUseCase,
    required this.getCurrentUserUseCase,
    required this.logoutUseCase,
    required this.deviceTokenService,
  }) : super(const SplashState.loading());

  Future<void> checkAuthSession() async {
    final stopwatch = Stopwatch()..start();

    debugPrint('🔵 Splash: Checking cached token...');
    final hasTokenEither = await isLoggedInUseCase();
    final hasToken = hasTokenEither.fold((_) => false, (hasToken) => hasToken);

    if (!hasToken) {
      debugPrint('❌ Splash: No token found');
      await _waitMinDuration(stopwatch);
      if (isClosed) return;
      emit(const SplashState.unauthenticated());
      return;
    }

    debugPrint('🔵 Splash: Validating session with GET /api/user...');
    final userEither = await getCurrentUserUseCase();
    await userEither.fold(
      (failure) async {
        debugPrint('❌ Splash: API error — ${failure.message}');
        await logoutUseCase();
        await _waitMinDuration(stopwatch);
        if (isClosed) return;
        emit(
          const SplashState.unauthenticated(
            message: 'Session expired. Please login again.',
          ),
        );
      },
      (user) async {
        debugPrint('✅ Splash: Session valid — welcome ${user.name}');
        unawaited(deviceTokenService.registerIfPossible());
        await _waitMinDuration(stopwatch);
        if (isClosed) return;
        emit(SplashState.authenticated(user: user));
      },
    );
  }

  Future<void> _waitMinDuration(Stopwatch stopwatch) async {
    stopwatch.stop();
    final elapsed = stopwatch.elapsed;
    if (elapsed < _minSplashDuration) {
      await Future.delayed(_minSplashDuration - elapsed);
    }
  }
}
