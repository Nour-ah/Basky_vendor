import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_filter_result_entity.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_status.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_summary_entity.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_details_entity.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_invoice_entity.dart';
import 'package:spider_restaurant/features/orders/domain/repositories/orders_repository.dart';
import 'package:spider_restaurant/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:spider_restaurant/features/orders/domain/usecases/update_order_status_usecase.dart';
import 'package:spider_restaurant/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:spider_restaurant/features/orders/presentation/cubit/orders_state.dart';

class MockOrdersRepository implements OrdersRepository {
  bool failNext = false;

  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(int orderId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<OrderSummaryEntity>>> getOrders({OrderStatus? status, int page = 1, int limit = 15}) async {
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
}
