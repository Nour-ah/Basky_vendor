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
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/is_logged_in_usecase.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

/// Service locator instance
final sl = GetIt.instance;

/// Initialize dependency injection
/// Call this once during app initialization
Future<void> initDependencies() async {
  // Initialize local storage
  await LocalStorage.init();

  // ============================================================
  // External Dependencies (Third-party packages)
  // ============================================================
  sl.registerLazySingleton<Dio>(() => ApiClient().dio);

  // SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ============================================================
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // ============================================================
  // Auth Feature - Data Sources
  // ============================================================
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
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
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => IsLoggedInUseCase(sl()));

  // ============================================================
  // Auth Feature - Cubits
  // ============================================================
  sl.registerFactory(
    () => AuthCubit(
      loginUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );

  // ============================================================
  // Cubits
  // ============================================================
  sl.registerFactory(() => LocaleCubit());
}
