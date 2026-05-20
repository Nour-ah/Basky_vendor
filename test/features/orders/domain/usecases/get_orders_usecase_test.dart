import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spider_restaurant/core/error/failures.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_status.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_summary_entity.dart';
import 'package:spider_restaurant/features/orders/domain/entities/order_details_entity.dart';
import 'package:spider_restaurant/features/orders/domain/repositories/orders_repository.dart';
import 'package:spider_restaurant/features/orders/domain/usecases/get_orders_usecase.dart';

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
