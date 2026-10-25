import '../entities/order_realtime_event.dart';
import '../repositories/orders_repository.dart';

class WatchNewVendorOrdersUseCase {
  final OrdersRepository repository;

  WatchNewVendorOrdersUseCase(this.repository);

  Stream<OrderRealtimeEvent> call() => repository.watchNewVendorOrders();
}
