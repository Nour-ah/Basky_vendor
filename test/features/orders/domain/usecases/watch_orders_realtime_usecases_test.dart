import 'package:basky_vendor/features/orders/domain/entities/order_realtime_event.dart';
import 'package:basky_vendor/features/orders/domain/repositories/orders_repository.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_new_vendor_orders_usecase.dart';
import 'package:basky_vendor/features/orders/domain/usecases/watch_order_status_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersRepository extends Mock implements OrdersRepository {}

void main() {
  late MockOrdersRepository repository;

  setUp(() => repository = MockOrdersRepository());

  test('WatchNewVendorOrdersUseCase forwards repository events', () {
    const event = OrderRealtimeEvent(orderId: 41, vendorOrderId: 58);
    when(() => repository.watchNewVendorOrders())
        .thenAnswer((_) => Stream.value(event));

    expect(WatchNewVendorOrdersUseCase(repository)(), emits(event));
    verify(() => repository.watchNewVendorOrders()).called(1);
  });

  test('WatchOrderStatusUseCase watches the given platform order', () {
    const event = OrderRealtimeEvent(orderId: 41, status: 'processing');
    when(() => repository.watchOrderStatus(41))
        .thenAnswer((_) => Stream.value(event));

    expect(WatchOrderStatusUseCase(repository)(41), emits(event));
    verify(() => repository.watchOrderStatus(41)).called(1);
  });
}
