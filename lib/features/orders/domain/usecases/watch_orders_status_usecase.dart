import '../entities/order_realtime_event.dart';
import '../repositories/orders_repository.dart';

/// Status changes of every order in a list (one socket channel per order).
class WatchOrdersStatusUseCase {
  final OrdersRepository repository;

  WatchOrdersStatusUseCase(this.repository);

  Stream<OrderRealtimeEvent> call(Iterable<int> platformOrderIds) =>
      repository.watchOrdersStatus(platformOrderIds);
}
