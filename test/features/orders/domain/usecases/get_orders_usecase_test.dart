import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:basky_vendor/core/error/failures.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_filter_result_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_status.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_summary_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_details_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_invoice_entity.dart';
import 'package:basky_vendor/features/orders/domain/entities/order_realtime_event.dart';
import 'package:basky_vendor/features/orders/domain/repositories/orders_repository.dart';
import 'package:basky_vendor/features/orders/domain/usecases/get_orders_usecase.dart';

class MockOrdersRepository implements OrdersRepository {
  @override
  Future<Either<Failure, OrderDetailsEntity>> getOrderDetails(int orderId) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<OrderSummaryEntity>>> getOrders({OrderStatus? status, int page = 1, int limit = 15}) async {
    if (page == 1) {
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
    return const Left(ServerFailure('Server Error'));
  }

  @override
  Future<Either<Failure, void>> updateOrderStatus({required int orderId, required OrderStatus newStatus}) {
    throw UnimplementedError();
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

  @override
  Stream<OrderRealtimeEvent> watchNewVendorOrders() {
    throw UnimplementedError();
  }

  @override
  Stream<OrderRealtimeEvent> watchOrderStatus(int platformOrderId) {
    throw UnimplementedError();
  }

  @override
  Stream<OrderRealtimeEvent> watchOrdersStatus(Iterable<int> platformOrderIds) {
    throw UnimplementedError();
  }
}

void main() {
  late GetOrdersUseCase useCase;
  late MockOrdersRepository mockRepository;

  setUp(() {
    mockRepository = MockOrdersRepository();
    useCase = GetOrdersUseCase(mockRepository);
  });

  test('should return list of orders from repository', () async {
    // act
    final result = await useCase();
    // assert
    expect(result.isRight(), true);
    result.fold(
      (l) => fail('Should not return failure'),
      (r) => expect(r.length, 1),
    );
  });
}
