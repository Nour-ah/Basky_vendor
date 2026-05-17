import '../../domain/entities/auth_action_result.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthResponse> login({required String login, required String password}) async {
    final response = await remoteDataSource.login(login: login, password: password);
    await localDataSource.cacheToken(response.token);
    return response;
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
  }) {
    return remoteDataSource.register(
      ownerName: ownerName,
      ownerEmail: ownerEmail,
      ownerPhone: ownerPhone,
      ownerPassword: ownerPassword,
      ownerPasswordConfirmation: ownerPasswordConfirmation,
      restaurantNameEn: restaurantNameEn,
      restaurantNameAr: restaurantNameAr,
      restaurantPhone: restaurantPhone,
      address: address,
    );
  }

  @override
  Future<AuthActionResult> verifyPhone({
    required String phone,
    required String code,
  }) {
    return remoteDataSource.verifyPhone(phone: phone, code: code);
  }

  @override
  Future<AuthActionResult> resendVerificationCode({required String email}) {
    return remoteDataSource.resendVerificationCode(email: email);
  }

  @override
  Future<void> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {}
    await localDataSource.removeToken();
  }

  @override
  Future<User> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<bool> isLoggedIn() async {
    return await localDataSource.isLoggedIn();
  }

  @override
  Future<String?> getToken() async {
    return await localDataSource.getToken();
  }
}