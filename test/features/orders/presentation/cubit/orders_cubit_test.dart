import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_filter_result_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_status.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_summary_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_details_entity.dart';
import 'package:basky_vendor/core/realtime/realtime_refresh_mixin.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_invoice_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_realtime_event.dart';
import 'package:basky_vendor/features/orders/domain/repositories/orders_repository.dart';
import 'package:basky_vendor/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:basky_vendor/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_new_vendor_orders_usecase.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_orders_status_usecase.dart';
import 'package:basky_vendor/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:basky_vendor/features/orders/presentation/cubit/orders_state.dart';

class MockOrdersRepository implements OrdersRepository {
  bool failNext = false;
  int getOrdersCalls = 0;
  final newOrders = StreamController<OrderRealtimeEvent>.broadcast();

  @override
  Stream<OrderRealtimeEvent> watchNewVendorOrders() => newOrders.stream;

  @override
  Stream<OrderRealtimeEvent> watchOrderStatus(int platformOrderId) =>
      const Stream.empty();

  @override
  Stream<OrderRealtimeEvent> watchOrdersStatus(Iterable<int> platformOrderIds) =>
      const Stream.empty();

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(int orderId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<OrderSummaryEntity>>> getOrders({OrderStatus? status, int page = 1, int limit = 15}) async {
    getOrdersCalls++;
    if (failNext) return const Left(ServerFailure('Server Error'));
    return const Right([
      OrderSummaryEntity(
        id: 1,
        orderCode: '#123',
        status: OrderStatus.pending,
        dateTime: '2024-01-01',
        orderType: 'delivery',
        itemCount: 2,
        totalAmount: 100.0,
      )
    ]);
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus({required int orderId, required OrderStatus newStatus}) async {
    return const Right(null);
  }

  @override
  Future<Either<Failure, OrderInvoiceEntity>> getOrderInvoice(int orderId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, OrderFilterResultEntity>> getFilteredOrders({
    OrderStatus? status,
    int page = 1,
    int limit = 15,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  late OrdersCubit cubit;
  late MockOrdersRepository mockRepository;
  late GetOrdersUseCase getOrdersUseCase;
  late UpdateOrderStatusUseCase updateOrderStatusUseCase;

  setUp(() {
    mockRepository = MockOrdersRepository();
    getOrdersUseCase = GetOrdersUseCase(mockRepository);
    updateOrderStatusUseCase = UpdateOrderStatusUseCase(mockRepository);
    cubit = OrdersCubit(
      getOrdersUseCase: getOrdersUseCase,
      updateOrderStatusUseCase: updateOrderStatusUseCase,
      watchNewVendorOrdersUseCase: WatchNewVendorOrdersUseCase(mockRepository),
      watchOrdersStatusUseCase: WatchOrdersStatusUseCase(mockRepository),
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be OrdersInitial', () {
    expect(cubit.state, isA<OrdersInitial>());
  });

  blocTest<OrdersCubit, OrdersState>(
    'emits [OrdersLoading, OrdersLoaded] when fetchOrders is successful',
    build: () => cubit,
    act: (cubit) => cubit.fetchOrders(),
    expect: () => [
      isA<OrdersLoading>(),
      isA<OrdersLoaded>(),
    ],
  );

  blocTest<OrdersCubit, OrdersState>(
    'emits [OrdersLoading, OrdersGenericError] when fetchOrders fails',
    build: () {
      mockRepository.failNext = true;
      return cubit;
    },
    act: (cubit) => cubit.fetchOrders(),
    expect: () => [
      isA<OrdersLoading>(),
      isA<OrdersGenericError>(),
    ],
  );

  test('new vendor order event refreshes silently (no loading) once per burst',
      () async {
    await cubit.fetchOrders();
    final callsBefore = mockRepository.getOrdersCalls;
    final emitted = <OrdersState>[];
    final sub = cubit.stream.listen(emitted.add);

    mockRepository.newOrders
      ..add(const OrderRealtimeEvent(orderId: 41, vendorOrderId: 58))
      ..add(const OrderRealtimeEvent(orderId: 42, vendorOrderId: 59));
    await Future<void>.delayed(
      RealtimeRefreshMixin.realtimeDebounce + const Duration(milliseconds: 100),
    );

    expect(mockRepository.getOrdersCalls, callsBefore + 1);
    expect(emitted.whereType<OrdersLoading>(), isEmpty);
    await sub.cancel();
  });

  test('silent refresh keeps the list when the request fails', () async {
    await cubit.fetchOrders();
    mockRepository.failNext = true;

    await cubit.refreshSilently();

    expect(cubit.state, isA<OrdersLoaded>());
  });
}
