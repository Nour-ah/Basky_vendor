import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/send_reset_code_usecase.dart';
import '../../domain/usecases/set_new_password_usecase.dart';
import '../../domain/usecases/verify_reset_code_usecase.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final SendResetCodeUseCase sendResetCodeUseCase;
  final VerifyResetCodeUseCase verifyResetCodeUseCase;
  final SetNewPasswordUseCase setNewPasswordUseCase;

  String? _email;
  String? _resetToken;

  ResetPasswordCubit({
    required this.sendResetCodeUseCase,
    required this.verifyResetCodeUseCase,
    required this.setNewPasswordUseCase,
  }) : super(ResetPasswordInitial());

  // Step 1: Send reset code
  Future<void> sendResetCode({required String email}) async {
    emit(ResetPasswordSendingCode());

    final result = await sendResetCodeUseCase(email: email);

    result.fold(
          (failure) {
        _email = email;
        emit(ResetPasswordError(message: failure.message, email: email));
      },
          (actionResult) {
        _email = email;
        emit(ResetPasswordCodeSent(email: email));
      },
    );
  }

  // Step 2: Verify code
  Future<void> verifyCode({required String code}) async {
    if (_email == null) {
      emit(const ResetPasswordError(message: 'Email not found'));
      return;
    }

    emit(ResetPasswordVerifyingCode(email: _email!));

    final result = await verifyResetCodeUseCase(
      code: code,
      email: _email!,
    );

    result.fold(
          (failure) {
        emit(ResetPasswordError(
          message: failure.message,
          email: _email,
        ));
      },
          (tokenResult) {
        _resetToken = tokenResult.resetToken;
        emit(ResetPasswordCodeVerified(
          email: _email!,
          resetToken: _resetToken ?? '',
        ));
      },
    );
  }

  // Step 3: Set new password
  Future<void> setNewPassword({
    required String password,
    required String passwordConfirmation,
  }) async {
    if (_email == null || _resetToken == null) {
      emit(const ResetPasswordError(
          message: 'Session expired. Please start over.'));
      return;
    }

    emit(ResetPasswordSettingPassword(
      email: _email!,
      resetToken: _resetToken!,
    ));

    final result = await setNewPasswordUseCase(
      resetToken: _resetToken!,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
          (failure) {
        emit(ResetPasswordError(
          message: failure.message,
          email: _email,
          resetToken: _resetToken,
        ));
      },
          (_) {
        emit(ResetPasswordSuccess());
      },
    );
  }

  // Reset to initial state
  void reset() {
    _email = null;
    _resetToken = null;
    emit(ResetPasswordInitial());
  }
}
