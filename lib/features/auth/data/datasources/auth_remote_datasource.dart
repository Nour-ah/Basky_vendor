import 'package:dio/dio.dart';
import '../../../../core/network/api_constants.dart';
import '../models/user_model.dart';
import '../models/auth_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponseModel> login({required String login, required String password});
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
    print('🔵 DataSource: Sending login request');
    final response = await dio.post(
      '${ApiConstants.baseUrl}${ApiConstants.apiVersion}${ApiConstants.login}',
      data: {'login': login, 'password': password},
    );
    print('✅ DataSource: Login success');
    return AuthResponseModel.fromJson(response.data['data']);
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