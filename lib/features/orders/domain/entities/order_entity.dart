import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final int id;
  final String orderCode;
  final String status;
  final String dateTime;
  final String orderType;
  final int itemCount;

  const OrderEntity({
    required this.id,
    required this.orderCode,
    required this.status,
    required this.dateTime,
    required this.orderType,
    required this.itemCount,
  });

  @override
  List<Object?> get props => [id, orderCode, status, dateTime, orderType, itemCount];
}
