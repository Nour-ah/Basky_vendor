import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../../../core/network/dio_error_mapper.dart';
import '../../domain/entities/auth_action_result.dart';
import '../../domain/entities/register_result.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';
import '../models/vendor_type_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String login,
    required String password,
    String? fcmToken,
  });
  Future<RegisterResult> register({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
    required int vendorTypeId,
    String? imagePath,
  });
  Future<List<VendorTypeModel>> getVendorTypes();
  Future<AuthActionResult> verifyPhone({required String phone, required String code});
  Future<AuthActionResult> verifyEmail({required String email, required String code});
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
    String? fcmToken,
  }) async {
    debugPrint('🔵 DataSource: Sending login request');
    try {
      final response = await dio.post(
        ApiConstants.login,
        data: {
          'login': login,
          'password': password,
          if (fcmToken != null && fcmToken.isNotEmpty) 'fcm_token': fcmToken,
        },
      );
      debugPrint('✅ DataSource: Login success');
      return AuthResponseModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<RegisterResult> register({
    required String ownerName,
    required String ownerEmail,
    required String ownerPhone,
    required String ownerPassword,
    required String ownerPasswordConfirmation,
    required String restaurantNameEn,
    required String restaurantNameAr,
    required String restaurantPhone,
    required String address,
    required int vendorTypeId,
    String? imagePath,
  }) async {
    debugPrint('🔵 DataSource: Sending register request');
    try {
      final map = <String, dynamic>{
        'owner_name': ownerName,
        'owner_email': ownerEmail,
        'owner_phone': ownerPhone,
        'owner_password': ownerPassword,
        'owner_password_confirmation': ownerPasswordConfirmation,
        'name[en]': restaurantNameEn,
        'name[ar]': restaurantNameAr,
        'phone': restaurantPhone,
        'address': address,
        'vendor_type_id': vendorTypeId.toString(),
      };

      if (imagePath != null && imagePath.isNotEmpty) {
        map['image'] = await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split(RegExp(r'[\\/]')).last,
        );
      }

      final response = await dio.post(
        ApiConstants.register,
        data: FormData.fromMap(map),
      );
      debugPrint('✅ DataSource: Register success');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        final message = data['message'] as String? ?? 'Registration successful';
        UserModel? user;
        final payload = data['data'];
        if (payload is Map<String, dynamic> && payload['user'] is Map<String, dynamic>) {
          user = UserModel.fromJson(payload['user'] as Map<String, dynamic>);
        }
        return RegisterResult(message: message, user: user);
      }
      return const RegisterResult(message: 'Registration successful');
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
  }

  @override
  Future<List<VendorTypeModel>> getVendorTypes() async {
    debugPrint('🔵 DataSource: Fetching vendor types');
    try {
      final response = await dio.get(ApiConstants.vendorTypes);
      debugPrint('✅ DataSource: Vendor types success');
      final data = response.data['data'];
      if (data is List) {
        return data
            .whereType<Map<String, dynamic>>()
            .map(VendorTypeModel.fromJson)
            .toList();
      }
      return [];
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
  Future<AuthActionResult> verifyEmail({
    required String email,
    required String code,
  }) async {
    debugPrint('🔵 DataSource: Sending verify email request');
    try {
      final response = await dio.post(
        ApiConstants.verifyEmail,
        data: {'email': email, 'code': code},
      );
      debugPrint('✅ DataSource: Verify email success');
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
      final data = response.data['data'];
      if (data is Map<String, dynamic>) {
        return UserModel.fromApiData(data);
      }
      throw const ParsingException(message: 'Invalid /user response payload');
    } on DioException catch (e) {
      DioErrorMapper.map(e);
    }
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
}
