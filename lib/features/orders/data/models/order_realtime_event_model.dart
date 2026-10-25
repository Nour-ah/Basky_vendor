import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/order_realtime_event.dart';

class OrderRealtimeEventModel extends OrderRealtimeEvent {
  const OrderRealtimeEventModel({
    super.orderId,
    super.vendorOrderId,
    super.status,
    super.message,
  });

  factory OrderRealtimeEventModel.fromJson(Map<String, dynamic> json) {
    return OrderRealtimeEventModel(
      orderId: JsonParsers.asInt(json['order_id']),
      vendorOrderId: JsonParsers.asInt(json['vendor_order_id']),
      status: JsonParsers.asString(json['status']),
      message: JsonParsers.asString(json['message']),
    );
  }
}
