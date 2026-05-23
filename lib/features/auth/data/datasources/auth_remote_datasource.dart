import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../domain/entities/auth_action_result.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({required String login, required String password});
  Future<String> register({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
  });
  Future<AuthActionResult> verifyPhone({required String phone, required String code});
  Future<AuthActionResult> resendVerificationCode({required String email});
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login({
    required String login,
    required String password,
  }) async {
    debugPrint('🔵 DataSource: Sending login request');
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {'login': login, 'password': password},
      );
      debugPrint('✅ DataSource: Login success');
      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<String> register({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
  }) async {
    debugPrint('🔵 DataSource: Sending register request');
    try {
      final response = await dio.post(
        ApiConstants.register,
        data: FormData.fromMap({
          'owner_name': ownerName,
          'owner_email': ownerEmail,
          'owner_phone': ownerPhone,
          'owner_password': ownerPassword,
          'owner_password_confirmation': ownerPasswordConfirmation,
          'name[en]': restaurantNameEn,
          'name[ar]': restaurantNameAr,
          'phone': restaurantPhone,
          'address': address,
        }),
      );
      debugPrint('✅ DataSource: Register success');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ?? 'Registration successful';
      }
      return 'Registration successful';
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<AuthActionResult> verifyPhone({
    required String phone,
    required String code,
  }) async {
    debugPrint('🔵 DataSource: Sending verify phone request');
    try {
      final response = await dio.post(
        ApiConstants.verifyPhone,
        data: {'phone': phone, 'code': code},
      );
      debugPrint('✅ DataSource: Verify phone success');
      return _parseActionResponse(response.data);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<AuthActionResult> resendVerificationCode({required String email}) async {
    debugPrint('🔵 DataSource: Sending resend verification code request');
    try {
      final response = await dio.post(
        ApiConstants.resendVerificationCode,
        data: {'email': email},
      );
      debugPrint('✅ DataSource: Resend verification code success');
      return _parseActionResponse(response.data);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<void> logout() async {
    debugPrint('🔵 DataSource: Sending logout request');
    try {
      await dio.post(ApiConstants.logout);
      debugPrint('✅ DataSource: Logout success');
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<UserModel> getCurrentUser() async {
    debugPrint('🔵 DataSource: Fetching current user');
    try {
      final response = await dio.get(ApiConstants.user);
      debugPrint('✅ DataSource: Get user success');
      return UserModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  // ---------------------------------------------------------------------------
  // Private helpers
  // ---------------------------------------------------------------------------

  AuthActionResult _parseActionResponse(dynamic data) {
    if (data is Map<String, dynamic>) {
      return AuthActionResult(
        success: data['success'] == true,
        message: data['message'] as String? ?? '',
      );
    }
    return const AuthActionResult(success: true, message: 'Success');
  }
}