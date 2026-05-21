import 'package:equatable/equatable.dart';

/// Result from verify reset code containing the reset token
class ResetTokenResult extends Equatable {
  final bool success;
  final String message;
  final String? resetToken;

  const ResetTokenResult({
    required this.success,
    required this.message,
    this.resetToken,
  });

  @override
  List<Object?> get props => [success, message, resetToken];
}
