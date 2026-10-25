import '../entities/order_realtime_event.dart';
import '../repositories/orders_repository.dart';

class WatchOrderStatusUseCase {
  final OrdersRepository repository;

  WatchOrderStatusUseCase(this.repository);

  Stream<OrderRealtimeEvent> call(int platformOrderId) =>
      repository.watchOrderStatus(platformOrderId);
}
