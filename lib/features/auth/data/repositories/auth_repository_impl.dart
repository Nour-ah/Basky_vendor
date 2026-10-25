import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/notifications/device_token_service.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/utils/vendor_access.dart';
import '../../domain/entities/auth_action_result.dart';
import '../../domain/entities/auth_response.dart';
import '../../domain/entities/register_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/vendor_type.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final DeviceTokenService? deviceTokenService;
  final RealtimeClient? realtimeClient;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    this.deviceTokenService,
    this.realtimeClient,
  });

  @override
  Future<Either<Failure, AuthResponse>> login({
    required String login,
    required String password,
    String? fcmToken,
  }) async {
    return _execute(() async {
      final response = await remoteDataSource.login(
        login: login,
        password: password,
        fcmToken: fcmToken,
      );
      // A previous session's socket was authorized with the old token.
      await realtimeClient?.disconnect();
      await localDataSource.cacheToken(response.token);
      await localDataSource.cacheVendorId(response.user.vendorId);
      await localDataSource.cacheVendorTypeKey(response.user.vendorTypeKey);
      // Ensure backend also has the latest FCM token after auth.
      await deviceTokenService?.registerIfPossible();
      return response;
    });
  }

  @override
  Future<Either<Failure, RegisterResult>> register({
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
        vendorTypeId: vendorTypeId,
        imagePath: imagePath,
      );
    });
  }

  @override
  Future<Either<Failure, List<VendorType>>> getVendorTypes() async {
    return _execute(() async {
      return await remoteDataSource.getVendorTypes();
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
  Future<Either<Failure, AuthActionResult>> verifyEmail({
    required String email,
    required String code,
  }) async {
    return _execute(() async {
      return await remoteDataSource.verifyEmail(email: email, code: code);
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
      await realtimeClient?.disconnect();
      await remoteDataSource.logout();
      await localDataSource.removeToken();
    });
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    return _execute(() async {
      final user = await remoteDataSource.getCurrentUser();
      await localDataSource.cacheVendorId(user.vendorId);
      final cachedKey = VendorAccess.canonicalKey(
        await localDataSource.getVendorTypeKey(),
      );
      final parsedKey = VendorAccess.canonicalKey(user.vendorTypeKey);
      final resolvedKey = parsedKey ?? cachedKey;
      if (resolvedKey != null && resolvedKey.trim().isNotEmpty) {
        await localDataSource.cacheVendorTypeKey(resolvedKey);
      }
      if (resolvedKey == user.vendorTypeKey) return user;
      return User(
        id: user.id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        image: user.image,
        emailVerifiedAt: user.emailVerifiedAt,
        phoneVerifiedAt: user.phoneVerifiedAt,
        isActive: user.isActive,
        isVerified: user.isVerified,
        roles: user.roles,
        permissions: user.permissions,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        vendorTypeId: user.vendorTypeId,
        vendorTypeKey: resolvedKey,
        vendorId: user.vendorId,
      );
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
