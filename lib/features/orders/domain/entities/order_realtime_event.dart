import 'package:equatable/equatable.dart';

/// Payload of `NewVendorOrderCreated` / `OrderStatusChanged` socket events.
///
/// [orderId] is the platform order id, [vendorOrderId] the vendor-orders row
/// id used by `GET /vendor/orders/{id}`.
class OrderRealtimeEvent extends Equatable {
  final int? orderId;
  final int? vendorOrderId;
  final String? status;
  final String? message;

  const OrderRealtimeEvent({
    this.orderId,
    this.vendorOrderId,
    this.status,
    this.message,
  });

  @override
  List<Object?> get props => [orderId, vendorOrderId, status, message];
}
