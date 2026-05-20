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

  const OrderSummaryEntity({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.dateTime,
    required this.orderType,
    required this.itemCount,
    required this.totalAmount,
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
      ];
}
