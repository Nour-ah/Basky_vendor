import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_action_result.dart';
import '../../domain/entities/reset_token_result.dart';
import '../../domain/repositories/forgot_password_repository.dart';
import '../datasources/forgot_password_remote_datasource.dart';

class ForgotPasswordRepositoryImpl implements ForgotPasswordRepository {
  final ForgotPasswordRemoteDataSource remoteDataSource;

  ForgotPasswordRepositoryImpl({required this.remoteDataSource});

  // ---------------------------------------------------------------------------
  // Public API
  // ---------------------------------------------------------------------------

  @override
  Future<Either<Failure, AuthActionResult>> sendResetCode({
    required String email,
  }) {
    return _execute(() => remoteDataSource.sendResetCode(email: email));
  }

  @override
  Future<Either<Failure, ResetTokenResult>> verifyResetCode({
    required String code,
    required String email,
  }) {
    return _execute(
      () => remoteDataSource.verifyResetCode(code: code, email: email),
    );
  }

  @override
  Future<Either<Failure, AuthActionResult>> setNewPassword({
    required String resetToken,
    required String password,
    required String passwordConfirmation,
  }) {
    return _execute(
      () => remoteDataSource.setNewPassword(
        resetToken: resetToken,
        password: password,
        passwordConfirmation: passwordConfirmation,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Centralised error boundary — mirrors AuthRepositoryImpl._execute
  // ---------------------------------------------------------------------------

  /// Runs [action] and maps any domain exception to the matching [Failure].
  ///
  /// [DioException] never reaches here because [DioErrorMapper] inside the
  /// datasource already converted it to a typed domain exception.
  Future<Either<Failure, T>> _execute<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message, errors: e.errors));
    } on ParsingException catch (e) {
      return Left(ParsingFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
