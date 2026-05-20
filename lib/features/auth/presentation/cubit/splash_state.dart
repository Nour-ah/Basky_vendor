import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';

enum SplashStatus {
  loading,
  authenticated,
  unauthenticated,
}

class SplashState extends Equatable {
  final SplashStatus status;
  final User? user;
  final String? message;

  const SplashState({
    required this.status,
    this.user,
    this.message,
  });

  const SplashState.loading()
      : status = SplashStatus.loading,
        user = null,
        message = null;

  const SplashState.authenticated({required User this.user})
      : status = SplashStatus.authenticated,
        message = null;

  const SplashState.unauthenticated({this.message})
      : status = SplashStatus.unauthenticated,
        user = null;

  @override
  List<Object?> get props => [status, user, message];
}
