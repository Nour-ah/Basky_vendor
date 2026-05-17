import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
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

AuthActionResult _parseActionResponse(dynamic data) {
  if (data is Map<String, dynamic>) {
    return AuthActionResult(
      success: data['success'] == true,
      message: data['message'] as String? ?? '',
    );
  }
  return const AuthActionResult(success: true, message: 'Success');
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;
  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<AuthResponseModel> login({
    required String login,
    required String password,
  }) async {
    print('🔵 DataSource: Sending login request');
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.login}',
      data: {'login': login, 'password': password},
    );
    print('✅ DataSource: Login success');
    return AuthResponseModel.fromJson(response.data['data']);
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
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.register}',
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
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? 'Registration successful';
    }
    return 'Registration successful';
  }

  @override
  Future<AuthActionResult> verifyPhone({
    required String phone,
    required String code,
  }) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.verifyPhone}',
      data: {'phone': phone, 'code': code},
    );
    return _parseActionResponse(response.data);
  }

  @override
  Future<AuthActionResult> resendVerificationCode({required String email}) async {
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.resendVerificationCode}',
      data: {'email': email},
    );
    return _parseActionResponse(response.data);
  }

  @override
  Future<void> logout() async {
    print('🔵 DataSource: Sending logout request');
    await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.logout}',
    );
    print('✅ DataSource: Logout success');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    print('🔵 DataSource: Fetching current user');
    final response = await dio.get(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.user}',
    );
    print('✅ DataSource: Get user success');
    return UserModel.fromJson(response.data['data']);
  }
}