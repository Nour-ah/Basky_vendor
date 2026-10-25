import 'package:equatable/equatable.dart';
import 'order_status.dart';

class OrderSummaryEntity extends Equatable {
  final int id;

  /// Platform order id (`order_id`), used by the `orders.{id}` socket channel.
  final int? platformOrderId;
  final String orderCode;
  final OrderStatus status;
  final String dateTime;
  final String orderType;
  final int itemCount;
  final double totalAmount;
  final double subtotal;
  final double discount;
  final double shippingCost;
  final String branchName;
  final String vendorName;
  final String vendorImage;

  const OrderSummaryEntity({
    required this.id,
    this.platformOrderId,
    required this.orderCode,
    required this.status,
    required this.dateTime,
    required this.orderType,
    required this.itemCount,
    required this.totalAmount,
    this.subtotal = 0.0,
    this.discount = 0.0,
    this.shippingCost = 0.0,
    this.branchName = '',
    this.vendorName = '',
    this.vendorImage = '',
  });

  OrderSummaryEntity copyWith({OrderStatus? status}) {
    return OrderSummaryEntity(
      id: id,
      platformOrderId: platformOrderId,
      orderCode: orderCode,
      status: status ?? this.status,
      dateTime: dateTime,
      orderType: orderType,
      itemCount: itemCount,
      totalAmount: totalAmount,
      subtotal: subtotal,
      discount: discount,
      shippingCost: shippingCost,
      branchName: branchName,
      vendorName: vendorName,
      vendorImage: vendorImage,
    );
  }

  @override
  List<Object?> get props => [
        id,
        platformOrderId,
        orderCode,
        status,
        dateTime,
        orderType,
        itemCount,
        totalAmount,
        subtotal,
        discount,
        shippingCost,
        branchName,
        vendorName,
        vendorImage,
      ];
}
