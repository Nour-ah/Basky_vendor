import 'package:basky_vendor/core/realtime/realtime_channels.dart';
import 'package:basky_vendor/core/realtime/realtime_client.dart';
import 'package:basky_vendor/features/orders/data/datasources/orders_realtime_datasource.dart';
import 'package:basky_vendor/features/orders/data/models/order_realtime_event_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRealtimeClient extends Mock implements RealtimeClient {}

void main() {
  late MockRealtimeClient client;

  setUp(() => client = MockRealtimeClient());

  OrdersRealtimeDataSourceImpl buildDataSource({int? vendorId = 13}) {
    return OrdersRealtimeDataSourceImpl(
      realtimeClient: client,
      vendorIdProvider: () async => vendorId,
    );
  }

  test('subscribes to the vendor orders channel and parses the payload',
      () async {
    when(() => client.listen(
          channelName: 'vendor.13.orders',
          eventName: RealtimeChannels.newVendorOrderCreated,
        )).thenAnswer((_) => Stream.value({
          'order_id': '41',
          'vendor_order_id': 58,
          'status': 'pending',
          'message': 'New order received',
          'vendor_order': {'id': 58},
        }));

    final events = await buildDataSource().watchNewVendorOrders().toList();

    expect(events, const [
      OrderRealtimeEventModel(
        orderId: 41,
        vendorOrderId: 58,
        status: 'pending',
        message: 'New order received',
      ),
    ]);
  });

  test('stays silent when no vendor id is cached', () async {
    final events =
        await buildDataSource(vendorId: null).watchNewVendorOrders().toList();

    expect(events, isEmpty);
    verifyNever(() => client.listen(
          channelName: any(named: 'channelName'),
          eventName: any(named: 'eventName'),
        ));
  });

  test('subscribes to the platform order channel for status changes', () async {
    when(() => client.listen(
          channelName: 'orders.41',
          eventName: RealtimeChannels.orderStatusChanged,
        )).thenAnswer((_) => Stream.value({
          'order_id': 41,
          'vendor_order_id': 58,
          'status': 'cancelled',
        }));

    final events = await buildDataSource().watchOrderStatus(41).toList();

    expect(events.single.status, 'cancelled');
    expect(events.single.vendorOrderId, 58);
  });
}
