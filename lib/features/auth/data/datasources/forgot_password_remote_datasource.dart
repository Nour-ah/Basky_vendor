import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../domain/entities/auth_action_result.dart';
import '../../domain/entities/reset_token_result.dart';

abstract class ForgotPasswordRemoteDataSource {
  Future<AuthActionResult> sendResetCode({required String email});
  Future<ResetTokenResult> verifyResetCode({
    required String code,
    required String email,
  });
  Future<AuthActionResult> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  });
}

class ForgotPasswordRemoteDataSourceImpl
    implements ForgotPasswordRemoteDataSource {
  final Dio dio;

  ForgotPasswordRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthActionResult> sendResetCode({required String email}) async {
    debugPrint('🔵 ForgotPasswordDataSource: Sending reset code to $email');
    final response = await dio.post(
      '/auth/reset-password/send-code',
      data: {'email': email},
    );
    debugPrint('✅ ForgotPasswordDataSource: Code sent');
    return _parseActionResponse(response.data);
  }

  @override
  Future<ResetTokenResult> verifyResetCode({
    required String code,
    required String email,
  }) async {
    debugPrint('🔵 ForgotPasswordDataSource: Verifying reset code');
    final response = await dio.post(
      '/auth/reset-password/verify-code',
      data: {'code': code, 'email': email},
    );
    debugPrint('✅ ForgotPasswordDataSource: Code verified');
    return _parseTokenResponse(response.data);
  }

  @override
  Future<AuthActionResult> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) async {
    debugPrint('🔵 ForgotPasswordDataSource: Setting new password');
    final response = await dio.post(
      '/auth/reset-password/set-new-password',
      data: {
        'reset_token': resetToken,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    debugPrint('✅ ForgotPasswordDataSource: Password reset');
    return _parseActionResponse(response.data);
  }

  AuthActionResult _parseActionResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return AuthActionResult(
        success: data['success'] == true,
        message: data['message'] as String? ?? '',
      );
    }
    return const AuthActionResult(success: true, message: 'Success');
  }

  ResetTokenResult _parseTokenResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return ResetTokenResult(
        success: data['success'] == true,
        message: data['message'] as String? ?? '',
        resetToken: data['data']?['reset_token'] as String?,
      );
    }
    return const ResetTokenResult(
      success: false,
      message: 'Invalid response',
    );
  }
}
