import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cache_helper/local_storage.dart';
import '../network/api_client.dart';
import '../localization/cubit/locale_cubit.dart';
import '../network/network_info.dart';
import '../../features/auth/data/datasources/auth_local_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/domain/usecases/register_usecase.dart';
import '../../features/auth/domain/usecases/resend_verification_code_usecase.dart';
import '../../features/auth/domain/usecases/verify_phone_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/is_logged_in_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_stats_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

import '../../features/auth/presentation/cubit/splash_cubit.dart';

import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_order_details_usecase.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/domain/usecases/update_order_status_usecase.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

 final sl = GetIt.instance;

Future<void> initDependencies() async {
   await LocalStorage.init();

  sl.registerLazySingleton<Dio>(() => ApiClient().dio);


  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());


  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(dio: sl()),
  );

  // ============================================================
  // Auth Feature - Repositories
  // ============================================================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );

  // ============================================================
  // Auth Feature - Use Cases
  // ============================================================
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => VerifyPhoneUseCase(sl()));
  sl.registerLazySingleton(() => ResendVerificationCodeUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // ============================================================
  // Auth Feature - Cubits
  // ============================================================
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      registerUseCase: sl(),
      verifyPhoneUseCase: sl(),
      resendVerificationCodeUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );

  // ============================================================
  // Home Feature - Data Sources
  // ============================================================
  sl.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(dio: sl()),
  );

  // ============================================================
  // Home Feature - Repositories
  // ============================================================
  sl.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(remoteDataSource: sl()),
  );

  // ============================================================
  // Home Feature - Use Cases
  // ============================================================
  sl.registerLazySingleton(() => GetHomeStatsUseCase(sl()));

  // ============================================================
  // Home Feature - Cubits
  // ============================================================
  sl.registerFactory(() => HomeCubit(getHomeStatsUseCase: sl()));

  // ============================================================
  // Orders Feature
  // ============================================================
  // Data Sources
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => OrdersCubit(
      getOrdersUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );

  // ============================================================
  // Cubits
  // ============================================================
  sl.registerFactory(() => LocaleCubit());
  sl.registerFactory(
    () => SplashCubit(
      isLoggedInUseCase: sl(),
      getCurrentUserUseCase: sl(),
      logoutUseCase: sl(),
    ),
  );
}
