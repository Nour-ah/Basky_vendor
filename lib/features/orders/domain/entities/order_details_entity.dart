import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'order_status.dart';

class OrderDetailsEntity extends Equatable {
  /// Vendor-orders row id.
  final int id;

  /// Platform order id (`order_id`), used by the `orders.{id}` socket channel.
  final int? platformOrderId;
  final String orderCode;
  final OrderStatus status;
  final String dateTime;
  final String orderType;
  final int itemCount;
  
  // Financials
  final double subtotal;
  final double discount;
  final double shippingCost;
  final double commission;
  final double totalAmount;
  
  // Extra Info
  final String? notes;
  
  // Vendor Info
  final String vendorName;
  final String vendorPhone;
  final String vendorAddress;
  final String vendorImage;
  
  // Branch Info
  final String branchName;
  final String branchPhone;
  final String branchAddress;

  final List<OrderItemEntity> items;

  const OrderDetailsEntity({
    required this.id,
    this.platformOrderId,
    required this.orderCode,
    required this.status,
    required this.dateTime,
    required this.orderType,
    required this.itemCount,
    required this.subtotal,
    required this.discount,
    required this.shippingCost,
    required this.commission,
    required this.totalAmount,
    this.notes,
    required this.vendorName,
    required this.vendorPhone,
    required this.vendorAddress,
    required this.vendorImage,
    required this.branchName,
    required this.branchPhone,
    required this.branchAddress,
    required this.items,
  });

  @override
  List<Object?> get props => [
        id,
        platformOrderId,
        orderCode,
        status,
        dateTime,
        orderType,
        itemCount,
        subtotal,
        discount,
        shippingCost,
        commission,
        totalAmount,
        notes,
        vendorName,
        vendorPhone,
        vendorAddress,
        vendorImage,
        branchName,
        branchPhone,
        branchAddress,
        items,
      ];
}
