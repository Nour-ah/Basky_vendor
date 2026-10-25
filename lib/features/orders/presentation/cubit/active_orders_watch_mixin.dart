import 'package:flutter/foundation.dart';

import '../../../../core/realtime/realtime_refresh_mixin.dart';
import '../../domain/entities/order_summary_entity.dart';

/// Keeps a list cubit subscribed to the `orders.{id}` channels of the active
/// orders it shows, so status changes made elsewhere (admin, courier) refresh
/// the list. Status changes are not broadcast on the vendor channel.
mixin ActiveOrdersWatchMixin<S> on RealtimeRefreshMixin<S> {
  Set<int> _watchedOrderIds = const {};

  void watchActiveOrders(
    List<OrderSummaryEntity> orders, {
    required Stream<Object?> Function(Set<int> platformOrderIds) watch,
    required Future<void> Function() onRefresh,
  }) {
    final ids = orders
        .where((order) => order.status.isActive)
        .map((order) => order.platformOrderId)
        .whereType<int>()
        .toSet();
    if (setEquals(ids, _watchedOrderIds)) return;

    _watchedOrderIds = ids;
    listenForRealtimeRefresh(
      watch(ids),
      onRefresh,
      key: ActiveOrdersWatchMixin,
    );
  }
}
