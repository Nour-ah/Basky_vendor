import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/core/realtime/realtime_refresh_mixin.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_realtime_event.dart';
import 'package:basky_vendor/features/orders/domain/repositories/orders_repository.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_new_vendor_orders_usecase.dart';
import 'package:basky_vendor/features/prescriptions/domain/repositories/prescriptions_repository.dart';
import 'package:basky_vendor/features/prescriptions/domain/usecases/get_vendor_prescription_requests_usecase.dart';
import 'package:basky_vendor/features/auth/domain/entities/user.dart';
import 'package:basky_vendor/features/auth/domain/repositories/auth_repository.dart';
import 'package:basky_vendor/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:basky_vendor/features/home/domain/entities/home_stats_entity.dart';
import 'package:basky_vendor/features/home/domain/repositories/home_repository.dart';
import 'package:basky_vendor/features/home/domain/usecases/get_home_stats_usecase.dart';
import 'package:basky_vendor/features/home/presentation/cubit/home_cubit.dart';
import 'package:basky_vendor/features/home/presentation/cubit/home_state.dart';
import 'package:basky_vendor/features/my_restaurant/domain/entities/vendor_branch_entity.dart';
import 'package:basky_vendor/features/my_restaurant/domain/repositories/restaurant_repository.dart';
import 'package:basky_vendor/features/my_restaurant/domain/usecases/get_vendor_branch_usecase.dart';

class MockHomeRepository implements HomeRepository {
  HomeStatsEntity mockStats;
  final bool shouldThrow;

  MockHomeRepository({required this.mockStats, this.shouldThrow = false});

  @override
  Future<HomeStatsEntity> getHomeStats() async {
    if (shouldThrow) {
      throw Exception('Server Error');
    }
    return mockStats;
  }
}

class MockPrescriptionsRepository implements PrescriptionsRepository {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockOrdersRepository implements OrdersRepository {
  final newOrders = StreamController<OrderRealtimeEvent>.broadcast();

  @override
  Stream<OrderRealtimeEvent> watchNewVendorOrders() => newOrders.stream;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockAuthRepository implements AuthRepository {
  final User mockUser;
  final bool shouldFail;

  MockAuthRepository({required this.mockUser, this.shouldFail = false});

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    if (shouldFail) {
      return const Left(ServerFailure('User Error'));
    }
    return Right(mockUser);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockRestaurantRepository implements RestaurantRepository {
  final VendorBranchEntity? mockBranch;
  final bool shouldFail;

  MockRestaurantRepository({this.mockBranch, this.shouldFail = false});

  @override
  Future<Either<Failure, VendorBranchEntity?>> getPrimaryBranch() async {
    if (shouldFail) {
      return const Left(ServerFailure('Branch Error'));
    }
    return Right(mockBranch);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late HomeCubit cubit;
  late MockHomeRepository mockHomeRepository;
  late MockAuthRepository mockAuthRepository;
  late MockRestaurantRepository mockRestaurantRepository;
  late MockOrdersRepository mockOrdersRepository;

  HomeCubit buildCubit() => HomeCubit(
    getHomeStatsUseCase: GetHomeStatsUseCase(mockHomeRepository),
    getCurrentUserUseCase: GetCurrentUserUseCase(mockAuthRepository),
    getVendorBranchUseCase: GetVendorBranchUseCase(mockRestaurantRepository),
    getVendorPrescriptionRequestsUseCase: GetVendorPrescriptionRequestsUseCase(
      MockPrescriptionsRepository(),
    ),
    watchNewVendorOrdersUseCase: WatchNewVendorOrdersUseCase(
      mockOrdersRepository,
    ),
  );

  const tHomeStats = HomeStatsEntity(
    todayOrders: 33,
    todayEarnings: 600.0,
    recentOrders: [],
    pendingOrders: 1,
    preparingOrders: 2,
    readyOrders: 3,
    deliveredOrders: 4,
  );

  const tUser = User(
    id: 1,
    name: 'Test User',
    email: 'test@example.com',
    phone: '+123',
    isActive: true,
    isVerified: true,
    roles: [],
    permissions: [],
    createdAt: '',
    updatedAt: '',
  );

  const tBranch = VendorBranchEntity(
    id: 1,
    name: 'Test Restaurant',
    address: '123 Main St',
    isOpen: true,
    rating: 4.5,
  );

  setUp(() {
    mockHomeRepository = MockHomeRepository(mockStats: tHomeStats);
    mockAuthRepository = MockAuthRepository(mockUser: tUser);
    mockRestaurantRepository = MockRestaurantRepository(mockBranch: tBranch);
    mockOrdersRepository = MockOrdersRepository();
    cubit = buildCubit();
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be HomeInitial', () {
    expect(cubit.state, equals(HomeInitial()));
  });

  test(
    'should emit [HomeLoading, HomeLoaded] when data is gotten successfully',
    () async {
      final expected = [
        HomeLoading(),
        const HomeLoaded(
          stats: tHomeStats,
          user: tUser,
          branch: tBranch,
          selectedStatus: 'ready_for_delivery',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));

      await cubit.fetchHomeData();
    },
  );

  test(
    'should emit HomeLoaded with new selected status when filterByStatus is called',
    () async {
      // Arrange
      await cubit.fetchHomeData();

      // Act & Assert
      final expected = [
        const HomeLoaded(
          stats: tHomeStats,
          user: tUser,
          branch: tBranch,
          selectedStatus: 'pending',
        ),
      ];

      expectLater(cubit.stream, emitsInOrder(expected));
      cubit.filterByStatus('pending');
    },
  );

  test('should emit [HomeLoading, HomeError] when stats fetch fails', () async {
    mockHomeRepository = MockHomeRepository(
      mockStats: tHomeStats,
      shouldThrow: true,
    );
    cubit = buildCubit();

    final expected = [
      HomeLoading(),
      const HomeError(message: 'Exception: Server Error'),
    ];

    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.fetchHomeData();
  });

  test('should emit [HomeLoading, HomeError] when user fetch fails', () async {
    mockAuthRepository = MockAuthRepository(mockUser: tUser, shouldFail: true);
    cubit = buildCubit();

    final expected = [
      HomeLoading(),
      const HomeError(message: 'Exception: User Error'),
    ];

    expectLater(cubit.stream, emitsInOrder(expected));

    await cubit.fetchHomeData();
  });

  test('new vendor order event refreshes stats without HomeLoading', () async {
    await cubit.fetchHomeData();
    const updatedStats = HomeStatsEntity(
      todayOrders: 34,
      todayEarnings: 700.0,
      recentOrders: [],
      pendingOrders: 2,
      preparingOrders: 2,
      readyOrders: 3,
      deliveredOrders: 4,
    );
    mockHomeRepository.mockStats = updatedStats;
    final emitted = <HomeState>[];
    final sub = cubit.stream.listen(emitted.add);

    mockOrdersRepository.newOrders.add(
      const OrderRealtimeEvent(orderId: 41, vendorOrderId: 58),
    );
    await Future<void>.delayed(
      RealtimeRefreshMixin.realtimeDebounce + const Duration(milliseconds: 100),
    );

    expect(emitted, [
      const HomeLoaded(
        stats: updatedStats,
        user: tUser,
        branch: tBranch,
        selectedStatus: 'ready_for_delivery',
      ),
    ]);
    await sub.cancel();
  });
}
