import 'package:connectivity_plus/connectivity_plus.dart';
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
import '../../features/auth/domain/usecases/verify_email_usecase.dart';
import '../../features/auth/domain/usecases/verify_phone_usecase.dart';
import '../../features/auth/domain/usecases/logout_usecase.dart';
import '../../features/auth/domain/usecases/get_current_user_usecase.dart';
import '../../features/auth/domain/usecases/is_logged_in_usecase.dart';
import '../../features/auth/domain/usecases/send_reset_code_usecase.dart';
import '../../features/auth/domain/usecases/verify_reset_code_usecase.dart';
import '../../features/auth/domain/usecases/set_new_password_usecase.dart';
import '../../features/auth/data/datasources/forgot_password_remote_datasource.dart';
import '../../features/auth/data/repositories/forgot_password_repository_impl.dart';
import '../../features/auth/domain/repositories/forgot_password_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/reset_password_cubit.dart';

import '../../features/home/data/datasources/home_remote_datasource.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_stats_usecase.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/toggle_status_cubit.dart';

import '../../features/auth/presentation/cubit/splash_cubit.dart';

import '../../features/orders/data/datasources/orders_remote_datasource.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_order_details_usecase.dart';
import '../../features/orders/domain/usecases/get_order_invoice_usecase.dart';
import '../../features/orders/domain/usecases/get_orders_usecase.dart';
import '../../features/orders/domain/usecases/update_order_status_usecase.dart';
import '../../features/orders/presentation/cubit/order_details_cubit.dart';
import '../../features/orders/presentation/cubit/order_invoice_cubit.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';

import '../../features/my_restaurant/data/datasources/restaurant_remote_datasource.dart';
import '../../features/my_restaurant/data/repositories/restaurant_repository_impl.dart';
import '../../features/my_restaurant/domain/repositories/restaurant_repository.dart';
import '../../features/my_restaurant/domain/usecases/add_product_usecase.dart';
import '../../features/my_restaurant/domain/usecases/delete_product_usecase.dart';
import '../../features/my_restaurant/domain/usecases/get_categories_usecase.dart';
import '../../features/my_restaurant/domain/usecases/get_products_usecase.dart';
import '../../features/my_restaurant/domain/usecases/get_variants_usecase.dart';
import '../../features/my_restaurant/domain/usecases/get_vendor_branch_usecase.dart';
import '../../features/my_restaurant/domain/usecases/update_product_usecase.dart';
import '../../features/my_restaurant/domain/usecases/toggle_restaurant_status_usecase.dart';
import '../../features/my_restaurant/presentation/cubit/add_food_cubit.dart';
import '../../features/my_restaurant/presentation/cubit/restaurant_catalog_cubit.dart';
import '../../features/my_restaurant/presentation/cubit/restaurant_details_cubit.dart';

// Wallet Feature
import '../../features/wallet/data/datasources/wallet_remote_datasource.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/wallet/domain/usecases/get_wallet_details_usecase.dart';
import '../../features/wallet/domain/usecases/get_wallet_history_usecase.dart';
import '../../features/wallet/domain/usecases/request_withdrawal_usecase.dart';
import '../../features/wallet/presentation/cubit/wallet_cubit.dart';

import '../../features/reviews/data/datasources/reviews_remote_datasource.dart';
import '../../features/reviews/data/repositories/reviews_repository_impl.dart';
import '../../features/reviews/domain/repositories/reviews_repository.dart';
import '../../features/reviews/domain/usecases/get_ratings_usecase.dart';
import '../../features/reviews/presentation/cubit/reviews_cubit.dart';

import '../../features/reports/data/datasources/reports_remote_datasource.dart';
import '../../features/reports/data/repositories/reports_repository_impl.dart';
import '../../features/reports/domain/repositories/reports_repository.dart';
import '../../features/reports/domain/usecases/get_reports_summary_usecase.dart';
import '../../features/reports/presentation/cubit/reports_cubit.dart';

import '../../features/time_slots/data/datasources/time_slots_remote_datasource.dart';
import '../../features/time_slots/data/repositories/time_slots_repository_impl.dart';
import '../../features/time_slots/domain/repositories/time_slots_repository.dart';
import '../../features/time_slots/domain/usecases/time_slots_usecases.dart';
import '../../features/time_slots/presentation/cubit/time_slots_cubit.dart';

 final sl = GetIt.instance;

Future<void> initDependencies() async {
   await LocalStorage.init();

  sl.registerLazySingleton<Dio>(() => ApiClient().dio);
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));


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
  sl.registerLazySingleton(() => VerifyEmailUseCase(sl()));
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
      verifyEmailUseCase: sl(),
      resendVerificationCodeUseCase: sl(),
      logoutUseCase: sl(),
      getCurrentUserUseCase: sl(),
      isLoggedInUseCase: sl(),
    ),
  );

  // ============================================================
  // Forgot Password Feature
  // ============================================================
  // Data Sources
  sl.registerLazySingleton<ForgotPasswordRemoteDataSource>(
    () => ForgotPasswordRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<ForgotPasswordRepository>(
    () => ForgotPasswordRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => SendResetCodeUseCase(sl()));
  sl.registerLazySingleton(() => VerifyResetCodeUseCase(sl()));
  sl.registerLazySingleton(() => SetNewPasswordUseCase(sl()));

  // Cubits
  sl.registerFactory(
    () => ResetPasswordCubit(
      sendResetCodeUseCase: sl(),
      verifyResetCodeUseCase: sl(),
      setNewPasswordUseCase: sl(),
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
  sl.registerFactory(
    () => HomeCubit(
      getHomeStatsUseCase: sl(),
      getCurrentUserUseCase: sl(),
      getVendorBranchUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ToggleStatusCubit(
      toggleRestaurantStatusUseCase: sl(),
    ),
  );

  // ============================================================
  // Orders Feature
  // ============================================================
  // Data Sources
  sl.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(dio: sl()),
  );

  // Restaurant Catalog Feature
  sl.registerLazySingleton<RestaurantRemoteDataSource>(
    () => RestaurantRemoteDataSourceImpl(dio: sl()),
  );

  // Wallet Feature
  sl.registerLazySingleton<WalletRemoteDataSource>(
    () => WalletRemoteDataSourceImpl(dio: sl()),
  );

  // Repositories
  sl.registerLazySingleton<OrdersRepository>(
    () => OrdersRepositoryImpl(remoteDataSource: sl()),
  );

  // Restaurant Catalog Feature
  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(remoteDataSource: sl()),
  );

  // Wallet Feature
  sl.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(remoteDataSource: sl()),
  );

  // Use Cases
  sl.registerLazySingleton(() => GetOrdersUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetOrderInvoiceUseCase(sl()));
  sl.registerLazySingleton(() => UpdateOrderStatusUseCase(sl()));

  // Restaurant Catalog Feature
  sl.registerLazySingleton(() => GetVendorBranchUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => GetVariantsUseCase(sl()));
  sl.registerLazySingleton(() => ToggleRestaurantStatusUseCase(sl()));

  // Wallet Feature
  sl.registerLazySingleton(() => GetWalletDetailsUseCase(sl()));
  sl.registerLazySingleton(() => GetWalletHistoryUseCase(sl()));
  sl.registerLazySingleton(() => RequestWithdrawalUseCase(sl()));

  // Cubit
  sl.registerFactory(
    () => OrdersCubit(
      getOrdersUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OrderDetailsCubit(
      getOrderDetailsUseCase: sl(),
      updateOrderStatusUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => OrderInvoiceCubit(getOrderInvoiceUseCase: sl()),
  );

  // Reviews Feature
  sl.registerLazySingleton<ReviewsRemoteDataSource>(
    () => ReviewsRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ReviewsRepository>(
    () => ReviewsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetRatingsUseCase(sl()));
  sl.registerFactory(() => ReviewsCubit(getRatingsUseCase: sl()));

  // Reports Feature
  sl.registerLazySingleton<ReportsRemoteDataSource>(
    () => ReportsRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<ReportsRepository>(
    () => ReportsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetReportsSummaryUseCase(sl()));
  sl.registerFactory(() => ReportsCubit(getReportsSummaryUseCase: sl()));

  // Time Slots Feature
  sl.registerLazySingleton<TimeSlotsRemoteDataSource>(
    () => TimeSlotsRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<TimeSlotsRepository>(
    () => TimeSlotsRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetTimeSlotsUseCase(sl()));
  sl.registerLazySingleton(() => AddTimeSlotUseCase(sl()));
  sl.registerLazySingleton(() => UpdateTimeSlotUseCase(sl()));
  sl.registerFactory(
    () => TimeSlotsCubit(
      getTimeSlotsUseCase: sl(),
      addTimeSlotUseCase: sl(),
      updateTimeSlotUseCase: sl(),
    ),
  );

  // Restaurant Catalog Feature
  sl.registerFactory(() => RestaurantCatalogCubit(
        getCategoriesUseCase: sl(),
        getProductsUseCase: sl(),
        deleteProductUseCase: sl(),
      ));
  sl.registerFactory(
    () => RestaurantDetailsCubit(getVendorBranchUseCase: sl()),
  );
  sl.registerFactory(() => AddFoodCubit(
        getCategoriesUseCase: sl(),
        addProductUseCase: sl(),
        updateProductUseCase: sl(),
      ));

  // Wallet Feature
  sl.registerFactory(() => WalletCubit(
        getWalletDetailsUseCase: sl(),
        getWalletHistoryUseCase: sl(),
        requestWithdrawalUseCase: sl(),
      ));

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
