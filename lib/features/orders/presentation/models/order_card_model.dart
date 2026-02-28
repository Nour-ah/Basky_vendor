class OrderCardModel {
  final String orderCode;
  final String status; // e.g., "Delivered", "Returned"
  final String dateTime;
  final String orderType; // e.g., "Delivery"
  final int itemCount;

  OrderCardModel({
    required this.orderCode,
    required this.status,
    required this.dateTime,
    required this.orderType,
    required this.itemCount,
  });

  bool get isDelivered => status.toLowerCase() == 'delivered';
}
