import 'package:equatable/equatable.dart';

abstract class ResetPasswordState extends Equatable {
  const ResetPasswordState();

  @override
  List<Object?> get props => [];
}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordSendingCode extends ResetPasswordState {}

class ResetPasswordCodeSent extends ResetPasswordState {
  final String email;
  const ResetPasswordCodeSent({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordVerifyingCode extends ResetPasswordState {
  final String email;
  const ResetPasswordVerifyingCode({required this.email});

  @override
  List<Object?> get props => [email];
}

class ResetPasswordCodeVerified extends ResetPasswordState {
  final String email;
  final String resetToken;
  const ResetPasswordCodeVerified({
    required this.email,
    required this.resetToken,
  });

  @override
  List<Object?> get props => [email, resetToken];
}

class ResetPasswordSettingPassword extends ResetPasswordState {
  final String email;
  final String resetToken;
  const ResetPasswordSettingPassword({
    required this.email,
    required this.resetToken,
  });

  @override
  List<Object?> get props => [email, resetToken];
}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {
  final String message;
  final String? email;
  final String? resetToken;

  const ResetPasswordError({
    required this.message,
    this.email,
    this.resetToken,
  });

  @override
  List<Object?> get props => [message, email, resetToken];
}
