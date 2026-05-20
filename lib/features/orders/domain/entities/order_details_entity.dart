import 'package:equatable/equatable.dart';
import 'order_item_entity.dart';
import 'order_status.dart';

class OrderDetailsEntity extends Equatable {
  final int id;
  final String orderCode;
  final OrderStatus status;
  final String dateTime;
  final String orderType;
  final int itemCount;
  final double totalAmount;
  
  // Extra detailed fields
  final double deliveryFee;
  final double tax;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String paymentMethod;
  final List<OrderItemEntity> items;

  const OrderDetailsEntity({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.dateTime,
    required this.orderType,
    required this.itemCount,
    required this.totalAmount,
    required this.deliveryFee,
    required this.tax,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    required this.paymentMethod,
    required this.items,
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
        deliveryFee,
        tax,
        customerName,
        customerPhone,
        deliveryAddress,
        paymentMethod,
        items,
      ];
}
