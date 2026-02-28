import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../cache_helper/local_storage.dart';
import '../network/api_client.dart';
import '../localization/cubit/locale_cubit.dart';
import '../network/network_info.dart';



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

  // ============================================================
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl());

  // ============================================================
  // Data Sources
  // ============================================================

  sl.registerFactory(() => LocaleCubit());
}
