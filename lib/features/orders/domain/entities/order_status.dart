enum OrderStatus {
  pending,
  processing,
  readyForDelivery,
  outForDelivery,
  delivered,
  cancelled,
  returned,
  unknown;

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
      case 'cooking':
      case 'confirmed':
        return OrderStatus.processing;
      case 'ready_for_delivery':
      case 'ready':
        return OrderStatus.readyForDelivery;
      case 'out_for_delivery':
      case 'on_the_way':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      case 'returned':
        return OrderStatus.returned;
      default:
        return OrderStatus.unknown;
    }
  }

  String toApiString() {
    switch (this) {
      case OrderStatus.pending:
        return 'pending';
      case OrderStatus.processing:
        return 'processing';
      case OrderStatus.readyForDelivery:
        return 'ready_for_delivery';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.returned:
        return 'returned';
      case OrderStatus.unknown:
        return 'unknown';
    }
  }

  /// Check if an order is active (not finalized)
  bool get isActive => 
      this != OrderStatus.delivered && 
      this != OrderStatus.cancelled && 
      this != OrderStatus.returned &&
      this != OrderStatus.unknown;
}
