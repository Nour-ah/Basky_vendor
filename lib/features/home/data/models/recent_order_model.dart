import '../../domain/entities/recent_order_entity.dart';

class RecentOrderModel extends RecentOrderEntity {
  const RecentOrderModel({
    required super.id,
    required super.orderCode,
    required super.status,
    required super.dateTime,
    required super.orderType,
    required super.itemCount,
  });

  factory RecentOrderModel.fromJson(Map<String, dynamic> json) {
    return RecentOrderModel(
      id: json['id'] as int? ?? 0,
      orderCode: json['order_code'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      dateTime: json['created_at'] as String? ?? '',
      orderType: json['delivery_type'] as String? ?? 'delivery',
      itemCount: json['items_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_code': orderCode,
      'status': status,
      'created_at': dateTime,
      'delivery_type': orderType,
      'items_count': itemCount,
    };
  }
}
