import 'dart:async';

import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/core/realtime/realtime_refresh_mixin.dart';
import 'package:basky_vendor/features/home/presentation/cubit/home_orders_cubit.dart';
import 'package:basky_vendor/features/home/presentation/cubit/home_orders_state.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_filter_result_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_realtime_event.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_status.dart';
import 'package:basky_vendor/features/orders/domain/repositories/orders_repository.dart';
import 'package:basky_vendor/features/orders/domain/usecases/get_filtered_orders_usecase.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_summary_entity.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_new_vendor_orders_usecase.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_orders_status_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

OrderSummaryEntity orderWith(int platformOrderId, OrderStatus status) =>
    OrderSummaryEntity(
      id: platformOrderId + 100,
      platformOrderId: platformOrderId,
      orderCode: '$platformOrderId',
      status: status,
      dateTime: '',
      orderType: 'delivery',
      itemCount: 1,
      totalAmount: 10,
    );

OrderFilterResultEntity resultWith({
  required int today,
  required int total,
  List<OrderSummaryEntity> orders = const [],
}) =>
    OrderFilterResultEntity(
      stats: OrderFilterStatsEntity(
        todayOrdersCount: today,
        thisWeekOrdersCount: today,
        thisMonthOrdersCount: today,
      ),
      orders: orders,
      currentPage: 1,
      lastPage: 1,
      total: total,
      appliedFilter: OrderStatus.unknown,
    );

void main() {
  late MockOrdersRepository repository;
  late StreamController<OrderRealtimeEvent> newOrders;
  late StreamController<OrderRealtimeEvent> statusChanges;
  late HomeOrdersCubit cubit;

  setUpAll(() => registerFallbackValue(<int>[]));

  final waitForDebounce =
      RealtimeRefreshMixin.realtimeDebounce + const Duration(milliseconds: 100);

  void stubOrders(Either<Failure, OrderFilterResultEntity> result) {
    when(
      () => repository.getFilteredOrders(
        status: any(named: 'status'),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) async => result);
  }

  setUp(() {
    repository = MockOrdersRepository();
    newOrders = StreamController<OrderRealtimeEvent>.broadcast();
    when(
      () => repository.watchNewVendorOrders(),
    ).thenAnswer((_) => newOrders.stream);
    statusChanges = StreamController<OrderRealtimeEvent>.broadcast();
    when(
      () => repository.watchOrdersStatus(any()),
    ).thenAnswer((_) => statusChanges.stream);
    cubit = HomeOrdersCubit(
      getFilteredOrdersUseCase: GetFilteredOrdersUseCase(repository),
      watchNewVendorOrdersUseCase: WatchNewVendorOrdersUseCase(repository),
      watchOrdersStatusUseCase: WatchOrdersStatusUseCase(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
    await newOrders.close();
    await statusChanges.close();
  });

  test('watches only active orders and refetches on their status change',
      () async {
    stubOrders(Right(resultWith(today: 2, total: 2, orders: [
      orderWith(72, OrderStatus.readyForPickup),
      orderWith(73, OrderStatus.delivered),
    ])));
    await cubit.fetchOrders();

    final watched = verify(() => repository.watchOrdersStatus(captureAny()))
        .captured
        .single as Iterable<int>;
    expect(watched.toSet(), {72});

    final shipped = resultWith(today: 2, total: 2, orders: [
      orderWith(72, OrderStatus.shipped),
      orderWith(73, OrderStatus.delivered),
    ]);
    stubOrders(Right(shipped));
    statusChanges.add(const OrderRealtimeEvent(orderId: 72, status: 'shipped'));
    await Future<void>.delayed(waitForDebounce);

    expect(
      cubit.state,
      HomeOrdersLoaded(result: shipped, selectedStatus: OrderStatus.unknown),
    );
  });

  test('new order event reloads list and counters without a loader', () async {
    stubOrders(Right(resultWith(today: 0, total: 0)));
    await cubit.fetchOrders();

    stubOrders(Right(resultWith(today: 1, total: 1)));
    final emitted = <HomeOrdersState>[];
    final sub = cubit.stream.listen(emitted.add);

    newOrders.add(const OrderRealtimeEvent(orderId: 41, vendorOrderId: 58));
    await Future<void>.delayed(waitForDebounce);

    expect(emitted, [
      HomeOrdersLoaded(
        result: resultWith(today: 1, total: 1),
        selectedStatus: OrderStatus.unknown,
      ),
    ]);
    await sub.cancel();
  });

  test('a burst of events triggers a single refetch', () async {
    stubOrders(Right(resultWith(today: 0, total: 0)));
    await cubit.fetchOrders();
    clearInteractions(repository);

    newOrders
      ..add(const OrderRealtimeEvent(orderId: 41))
      ..add(const OrderRealtimeEvent(orderId: 42))
      ..add(const OrderRealtimeEvent(orderId: 43));
    await Future<void>.delayed(waitForDebounce);

    verify(
      () => repository.getFilteredOrders(
        status: any(named: 'status'),
        page: 1,
        limit: any(named: 'limit'),
      ),
    ).called(1);
  });

  test('silent refresh failure keeps the loaded list', () async {
    final loaded = resultWith(today: 2, total: 2);
    stubOrders(Right(loaded));
    await cubit.fetchOrders();

    stubOrders(const Left(ServerFailure('boom')));
    await cubit.fetchOrders(silent: true);

    expect(
      cubit.state,
      HomeOrdersLoaded(result: loaded, selectedStatus: OrderStatus.unknown),
    );
  });

  test('stops reacting to events after close', () async {
    stubOrders(Right(resultWith(today: 0, total: 0)));
    await cubit.close();
    clearInteractions(repository);

    newOrders.add(const OrderRealtimeEvent(orderId: 41));
    await Future<void>.delayed(waitForDebounce);

    verifyNever(
      () => repository.getFilteredOrders(
        status: any(named: 'status'),
        page: any(named: 'page'),
        limit: any(named: 'limit'),
      ),
    );
  });
}
