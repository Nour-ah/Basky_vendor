// import 'package:dio/dio.dart';
// import '../network/api_consumer.dart';
// import '../network/dio_consumer.dart';
// import 'package:get_it/get_it.dart';
//
// // ============================================================================
// // SERVICE LOCATOR - SHEIKHY APP
// // ============================================================================
// // This file manages dependency injection for the Sheikhy application.
// // Currently configured with only core dependencies.
// // Feature-specific dependencies will be added as features are developed.
// // ============================================================================
//
// final sl = GetIt.instance;
// final getIt = GetIt.instance;
//
// Future<void> initServiceLocator() async {
//   // ============================================================================
//   // CORE DEPENDENCIES
//   // ============================================================================
//
//   // Network
//   sl.registerLazySingleton<ApiConsumer>(() => DioConsumer(dio: sl()));
//   sl.registerLazySingleton<Dio>(() => Dio());
//
//   // ============================================================================
//   // FEATURE DEPENDENCIES (COMMENTED OUT - FROM OLD sheikhy PROJECT)
//   // ============================================================================
//   // Uncomment and update these as you develop features for Sheikhy app
//   // All old feature code has been preserved in comments for future reference
// }
