import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/auth/domain/entities/auth_response.dart';
import 'package:spider_restaurant/features/auth/domain/entities/user.dart';
import 'package:spider_restaurant/features/auth/domain/entities/auth_action_result.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/is_logged_in_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/login_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/logout_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/register_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/resend_verification_code_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/verify_email_usecase.dart';
import 'package:spider_restaurant/features/auth/domain/usecases/verify_phone_usecase.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:spider_restaurant/features/auth/presentation/cubit/auth_state.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}
class MockRegisterUseCase extends Mock implements RegisterUseCase {}
class MockVerifyPhoneUseCase extends Mock implements VerifyPhoneUseCase {}
class MockVerifyEmailUseCase extends Mock implements VerifyEmailUseCase {}
class MockResendVerificationCodeUseCase extends Mock implements ResendVerificationCodeUseCase {}
class MockLogoutUseCase extends Mock implements LogoutUseCase {}
class MockGetCurrentUserUseCase extends Mock implements GetCurrentUserUseCase {}
class MockIsLoggedInUseCase extends Mock implements IsLoggedInUseCase {}

void main() {
  late AuthCubit cubit;
  late MockLoginUseCase mockLoginUseCase;
  late MockRegisterUseCase mockRegisterUseCase;
  late MockVerifyPhoneUseCase mockVerifyPhoneUseCase;
  late MockVerifyEmailUseCase mockVerifyEmailUseCase;
  late MockResendVerificationCodeUseCase mockResendVerificationCodeUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockIsLoggedInUseCase mockIsLoggedInUseCase;

  setUp(() {
    mockLoginUseCase = MockLoginUseCase();
    mockRegisterUseCase = MockRegisterUseCase();
    mockVerifyPhoneUseCase = MockVerifyPhoneUseCase();
    mockVerifyEmailUseCase = MockVerifyEmailUseCase();
    mockResendVerificationCodeUseCase = MockResendVerificationCodeUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockIsLoggedInUseCase = MockIsLoggedInUseCase();

    cubit = AuthCubit(
      loginUseCase: mockLoginUseCase,
      registerUseCase: mockRegisterUseCase,
      verifyPhoneUseCase: mockVerifyPhoneUseCase,
      verifyEmailUseCase: mockVerifyEmailUseCase,
      resendVerificationCodeUseCase: mockResendVerificationCodeUseCase,
      logoutUseCase: mockLogoutUseCase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
      isLoggedInUseCase: mockIsLoggedInUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  const tUser = User(
    id: 1,
    name: 'Test',
    email: 'test@test.com',
    phone: '123456789',
    isActive: true,
    isVerified: true,
    roles: ['vendor'],
    permissions: [],
    createdAt: '2023-01-01',
    updatedAt: '2023-01-01',
  );

  const tAuthResponse = AuthResponse(
    user: tUser,
    token: 'test_token',
    tokenType: 'Bearer',
  );

  group('login', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthLoginSuccess] on success',
      build: () {
        when(() => mockLoginUseCase(login: 'test', password: 'password'))
            .thenAnswer((_) async => const Right(tAuthResponse));
        return cubit;
      },
      act: (cubit) => cubit.login(login: 'test', password: 'password'),
      expect: () => [
        AuthLoading(),
        const AuthLoginSuccess(user: tUser, token: 'test_token'),
      ],
      verify: (_) {
        verify(() => mockLoginUseCase(login: 'test', password: 'password')).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthError] on failure',
      build: () {
        when(() => mockLoginUseCase(login: 'test', password: 'wrong'))
            .thenAnswer((_) async => const Left(ServerFailure('Invalid credentials')));
        return cubit;
      },
      act: (cubit) => cubit.login(login: 'test', password: 'wrong'),
      expect: () => [
        AuthLoading(),
        const AuthError(message: 'Invalid credentials'),
      ],
    );
  });

  group('logout', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthLogoutSuccess] on success',
      build: () {
        when(() => mockLogoutUseCase())
            .thenAnswer((_) async => const Right(null));
        return cubit;
      },
      act: (cubit) => cubit.logout(),
      expect: () => [
        AuthLoading(),
        AuthLogoutSuccess(),
      ],
      verify: (_) {
        verify(() => mockLogoutUseCase()).called(1);
      },
    );
  });

  group('verifyPhone', () {
    blocTest<AuthCubit, AuthState>(
      'emits [AuthLoading, AuthVerifyPhoneSuccess] when already verified (edge case)',
      build: () {
        when(() => mockVerifyPhoneUseCase(phone: '123456', code: '0000'))
            .thenAnswer((_) async => const Right(AuthActionResult(success: false, message: 'User is already verified.')));
        return cubit;
      },
      act: (cubit) => cubit.verifyPhone(phone: '123456', code: '0000'),
      expect: () => [
        AuthLoading(),
        const AuthVerifyPhoneSuccess(message: 'User is already verified.'),
      ],
    );
  });
}

