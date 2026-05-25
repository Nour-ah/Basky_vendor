import 'package:equatable/equatable.dart';
import 'order_status.dart';

class OrderSummaryEntity extends Equatable {
  final int id;
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

  @override
  List<Object?> get props => [
        id,
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
