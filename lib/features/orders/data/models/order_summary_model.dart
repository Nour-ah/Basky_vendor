import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_summary_entity.dart';

class OrderSummaryModel extends OrderSummaryEntity {
  const OrderSummaryModel({
    required super.id,
    required super.orderCode,
    required super.status,
    required super.dateTime,
    required super.orderType,
    required super.itemCount,
    required super.totalAmount,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode: json['order_code']?.toString() ?? json['code']?.toString() ?? '',
      status: OrderStatus.fromString(json['status']?.toString() ?? 'unknown'),
      dateTime: json['created_at']?.toString() ?? json['date']?.toString() ?? '',
      orderType: json['delivery_type']?.toString() ?? json['type']?.toString() ?? 'delivery',
      itemCount: json['items_count'] is int ? json['items_count'] : int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
      totalAmount: json['total'] is num ? (json['total'] as num).toDouble() : double.tryParse(json['total']?.toString() ?? '0.0') ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'status': status.toApiString(),
      'created_at': dateTime,
      'delivery_type': orderType,
      'items_count': itemCount,
      'total': totalAmount,
    };
  }
}
