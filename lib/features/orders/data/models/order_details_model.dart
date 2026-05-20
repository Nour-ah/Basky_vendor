import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';
import 'order_item_model.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    required super.id,
    required super.orderCode,
    required super.status,
    required super.dateTime,
    required super.orderType,
    required super.itemCount,
    required super.totalAmount,
    required super.deliveryFee,
    required super.tax,
    required super.customerName,
    required super.customerPhone,
    required super.deliveryAddress,
    required super.paymentMethod,
    required super.items,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    // Defensively parse items list
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    final parsedItems = itemsJson
        .whereType<Map<String, dynamic>>()
        .map((e) => OrderItemModel.fromJson(e))
        .toList();

    return OrderDetailsModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderCode: json['order_code']?.toString() ?? json['code']?.toString() ?? '',
      status: OrderStatus.fromString(json['status']?.toString() ?? 'unknown'),
      dateTime: json['created_at']?.toString() ?? json['date']?.toString() ?? '',
      orderType: json['delivery_type']?.toString() ?? json['type']?.toString() ?? 'delivery',
      itemCount: json['items_count'] is int ? json['items_count'] : int.tryParse(json['items_count']?.toString() ?? '0') ?? parsedItems.length,
      totalAmount: json['total'] is num ? (json['total'] as num).toDouble() : double.tryParse(json['total']?.toString() ?? '0.0') ?? 0.0,
      
      deliveryFee: json['delivery_fee'] is num ? (json['delivery_fee'] as num).toDouble() : double.tryParse(json['delivery_fee']?.toString() ?? '0.0') ?? 0.0,
      tax: json['tax'] is num ? (json['tax'] as num).toDouble() : double.tryParse(json['tax']?.toString() ?? '0.0') ?? 0.0,
      
      customerName: json['customer_name']?.toString() ?? json['user']?['name']?.toString() ?? 'Unknown Customer',
      customerPhone: json['customer_phone']?.toString() ?? json['user']?['phone']?.toString() ?? '',
      deliveryAddress: json['delivery_address']?.toString() ?? json['address']?.toString() ?? '',
      paymentMethod: json['payment_method']?.toString() ?? 'cash',
      
      items: parsedItems,
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
      'delivery_fee': deliveryFee,
      'tax': tax,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'payment_method': paymentMethod,
      'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
    };
  }
}
