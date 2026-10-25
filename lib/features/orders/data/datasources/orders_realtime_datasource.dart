import '../../../../core/cache_helper/local_storage.dart';
import '../../../../core/realtime/realtime_channels.dart';
import '../../../../core/realtime/realtime_client.dart';
import '../../../../core/utils/merge_streams.dart';
import '../models/order_realtime_event_model.dart';

abstract class OrdersRealtimeDataSource {
  /// New orders for the logged-in vendor (`NewVendorOrderCreated`).
  Stream<OrderRealtimeEventModel> watchNewVendorOrders();

  /// Status changes of one platform order (`OrderStatusChanged`).
  Stream<OrderRealtimeEventModel> watchOrderStatus(int platformOrderId);

  /// Status changes of several platform orders at once.
  Stream<OrderRealtimeEventModel> watchOrdersStatus(
    Iterable<int> platformOrderIds,
  );
}

class OrdersRealtimeDataSourceImpl implements OrdersRealtimeDataSource {
  OrdersRealtimeDataSourceImpl({
    required this.realtimeClient,
    Future<int?> Function()? vendorIdProvider,
  }) : _vendorIdProvider = vendorIdProvider ?? LocalStorage.getVendorId;

  final RealtimeClient realtimeClient;
  final Future<int?> Function() _vendorIdProvider;

  @override
  Stream<OrderRealtimeEventModel> watchNewVendorOrders() async* {
    final vendorId = await _vendorIdProvider();
    if (vendorId == null || vendorId <= 0) return;

    yield* realtimeClient
        .listen(
          channelName: RealtimeChannels.vendorOrders(vendorId),
          eventName: RealtimeChannels.newVendorOrderCreated,
        )
        .map(OrderRealtimeEventModel.fromJson);
  }

  @override
  Stream<OrderRealtimeEventModel> watchOrderStatus(int platformOrderId) {
    if (platformOrderId <= 0) return const Stream.empty();

    return realtimeClient
        .listen(
          channelName: RealtimeChannels.order(platformOrderId),
          eventName: RealtimeChannels.orderStatusChanged,
        )
        .map(OrderRealtimeEventModel.fromJson);
  }

  @override
  Stream<OrderRealtimeEventModel> watchOrdersStatus(
    Iterable<int> platformOrderIds,
  ) {
    return mergeStreams(platformOrderIds.toSet().map(watchOrderStatus));
  }
}
