import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/order_details_entity.dart';
import '../../domain/entities/order_status.dart';
import 'order_item_model.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    required super.id,
    super.platformOrderId,
    required super.orderCode,
    required super.status,
    required super.dateTime,
    required super.orderType,
    required super.itemCount,
    required super.subtotal,
    required super.discount,
    required super.shippingCost,
    required super.commission,
    required super.totalAmount,
    super.notes,
    required super.vendorName,
    required super.vendorPhone,
    required super.vendorAddress,
    required super.vendorImage,
    required super.branchName,
    required super.branchPhone,
    required super.branchAddress,
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
      platformOrderId: JsonParsers.asInt(json['order_id']),
      orderCode: json['order_id']?.toString() ?? json['order_code']?.toString() ?? json['code']?.toString() ?? '',
      status: OrderStatus.fromString(json['status']?.toString() ?? 'unknown'),
      dateTime: json['created_at']?.toString() ?? json['date']?.toString() ?? '',
      orderType: json['delivery_type']?.toString() ?? json['type']?.toString() ?? 'delivery',
      itemCount: json['items_count'] is int ? json['items_count'] : int.tryParse(json['items_count']?.toString() ?? '0') ?? parsedItems.length,
      
      subtotal: json['subtotal'] is num ? (json['subtotal'] as num).toDouble() : double.tryParse(json['subtotal']?.toString() ?? '0.0') ?? 0.0,
      discount: json['discount'] is num ? (json['discount'] as num).toDouble() : double.tryParse(json['discount']?.toString() ?? '0.0') ?? 0.0,
      shippingCost: json['shipping_cost'] is num ? (json['shipping_cost'] as num).toDouble() : double.tryParse(json['shipping_cost']?.toString() ?? '0.0') ?? 0.0,
      commission: json['commission'] is num ? (json['commission'] as num).toDouble() : double.tryParse(json['commission']?.toString() ?? '0.0') ?? 0.0,
      totalAmount: json['total'] is num ? (json['total'] as num).toDouble() : double.tryParse(json['total']?.toString() ?? '0.0') ?? 0.0,

      notes: _parseNotes(json),

      vendorName: json['vendor']?['name']?.toString() ?? 'Unknown Vendor',
      vendorPhone: json['vendor']?['phone']?.toString() ?? '',
      vendorAddress: json['vendor']?['address']?.toString() ?? '',
      vendorImage: json['vendor']?['image']?.toString() ?? '',
      
      branchName: json['branch']?['name']?.toString() ?? 'Unknown Branch',
      branchPhone: json['branch']?['phone']?.toString() ?? '',
      branchAddress: json['branch']?['address']?.toString() ?? '',
      
      items: parsedItems,
    );
  }

  /// Client notes may arrive under several keys or nested on the platform order.
  static String? _parseNotes(Map<String, dynamic> json) {
    final candidates = <dynamic>[
      json['notes'],
      json['note'],
      json['customer_notes'],
      json['customer_note'],
      json['client_notes'],
      json['special_instructions'],
      json['order_notes'],
      if (json['order'] is Map) (json['order'] as Map)['notes'],
      if (json['order'] is Map) (json['order'] as Map)['note'],
      if (json['order'] is Map) (json['order'] as Map)['customer_notes'],
      if (json['customer'] is Map) (json['customer'] as Map)['notes'],
    ];
    for (final value in candidates) {
      final text = JsonParsers.asString(value);
      if (text != null) return text;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderCode,
      'status': status.toApiString(),
      'created_at': dateTime,
      'delivery_type': orderType,
      'items_count': itemCount,
      'subtotal': subtotal,
      'discount': discount,
      'shipping_cost': shippingCost,
      'commission': commission,
      'total': totalAmount,
      'notes': notes,
      'vendor': {
        'name': vendorName,
        'phone': vendorPhone,
        'address': vendorAddress,
        'image': vendorImage,
      },
      'branch': {
        'name': branchName,
        'phone': branchPhone,
        'address': branchAddress,
      },
      'items': items.map((e) => (e as OrderItemModel).toJson()).toList(),
    };
  }
}
