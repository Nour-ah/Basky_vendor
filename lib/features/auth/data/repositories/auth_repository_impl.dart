import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
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
  Future<Either<Failure, AuthResponse>> login({
    required String login,
    required String password,
  }) async {
    return _execute(() async {
      final response = await remoteDataSource.login(
        login: login,
        password: password,
      );
      await localDataSource.cacheToken(response.token);
      return response;
    });
  }

  @override
  Future<Either<Failure, String>> register({
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
    return _execute(() async {
      return await remoteDataSource.register(
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
    });
  }

  @override
  Future<Either<Failure, AuthActionResult>> verifyPhone({
    required String phone,
    required String code,
  }) async {
    return _execute(() async {
      return await remoteDataSource.verifyPhone(phone: phone, code: code);
    });
  }

  @override
  Future<Either<Failure, AuthActionResult>> resendVerificationCode({
    required String email,
  }) async {
    return _execute(() async {
      return await remoteDataSource.resendVerificationCode(email: email);
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    return _execute(() async {
      await remoteDataSource.logout();
      await localDataSource.removeToken();
    });
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return _execute(() async {
      return await remoteDataSource.getCurrentUser();
    });
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    return _execute(() async {
      return await localDataSource.isLoggedIn();
    });
  }

  @override
  Future<Either<Failure, String?>> getToken() async {
    return _execute(() async {
      return await localDataSource.getToken();
    });
  }

  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
