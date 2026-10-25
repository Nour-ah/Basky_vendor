import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/vendor_type.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoginSuccess extends AuthState {
  final User user;
  final String token;
  const AuthLoginSuccess({required this.user, required this.token});
  @override
  List<Object?> get props => [user, token];
}

class AuthLogoutSuccess extends AuthState {}

class AuthUserLoaded extends AuthState {
  final User user;
  const AuthUserLoaded({required this.user});
  @override
  List<Object?> get props => [user];
}

class AuthError extends AuthState {
  final String message;
  const AuthError({required this.message});
  @override
  List<Object?> get props => [message];
}

class AuthCheckStatus extends AuthState {
  final bool isLoggedIn;
  const AuthCheckStatus({required this.isLoggedIn});
  @override
  List<Object?> get props => [isLoggedIn];
}

class AuthRegisterSuccess extends AuthState {
  final String message;
  final String phone;
  final String email;
  final bool isActive;

  const AuthRegisterSuccess({
    required this.message,
    required this.phone,
    required this.email,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [message, phone, email, isActive];
}

class AuthVendorTypesLoaded extends AuthState {
  final List<VendorType> types;
  const AuthVendorTypesLoaded({required this.types});
  @override
  List<Object?> get props => [types];
}

class AuthVerifyPhoneSuccess extends AuthState {
  final String message;

  const AuthVerifyPhoneSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthVerifyEmailSuccess extends AuthState {
  final String message;

  const AuthVerifyEmailSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class AuthResendCodeSuccess extends AuthState {
  final String message;

  const AuthResendCodeSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}
