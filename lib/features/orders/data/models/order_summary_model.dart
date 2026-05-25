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
    super.subtotal,
    super.discount,
    super.shippingCost,
    super.branchName,
    super.vendorName,
    super.vendorImage,
  });

  factory OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    return OrderSummaryModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode: json['order_code']?.toString() ?? json['code']?.toString() ?? json['order_id']?.toString() ?? '',
      status: OrderStatus.fromString(json['status']?.toString() ?? 'unknown'),
      dateTime: json['created_at']?.toString() ?? json['date']?.toString() ?? '',
      orderType: json['delivery_type']?.toString() ?? json['type']?.toString() ?? 'delivery',
      itemCount: json['items_count'] is int ? json['items_count'] : int.tryParse(json['items_count']?.toString() ?? '0') ?? 0,
      totalAmount: json['total'] is num ? (json['total'] as num).toDouble() : double.tryParse(json['total']?.toString() ?? '0.0') ?? 0.0,
      subtotal: json['subtotal'] is num ? (json['subtotal'] as num).toDouble() : double.tryParse(json['subtotal']?.toString() ?? '0.0') ?? 0.0,
      discount: json['discount'] is num ? (json['discount'] as num).toDouble() : double.tryParse(json['discount']?.toString() ?? '0.0') ?? 0.0,
      shippingCost: json['shipping_cost'] is num ? (json['shipping_cost'] as num).toDouble() : double.tryParse(json['shipping_cost']?.toString() ?? '0.0') ?? 0.0,
      branchName: json['branch']?['name']?.toString() ?? '',
      vendorName: json['vendor']?['name']?.toString() ?? '',
      vendorImage: json['vendor']?['image']?.toString() ?? '',
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
      'subtotal': subtotal,
      'discount': discount,
      'shipping_cost': shippingCost,
      'branch': {'name': branchName},
      'vendor': {'name': vendorName, 'image': vendorImage},
    };
  }
}
