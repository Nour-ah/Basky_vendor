enum OrderStatus {
  pending,
  processing,
  readyForPickup,
  readyForDelivery,
  shipped,
  outForDelivery,
  delivered,
  cancelled,
  returned,
  refunded,
  unknown;

  static OrderStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
      case 'cooking':
      case 'confirmed':
        return OrderStatus.processing;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'ready_for_delivery':
      case 'ready':
        return OrderStatus.readyForDelivery;
      case 'shipped':
        return OrderStatus.shipped;
      case 'out_for_delivery':
      case 'on_the_way':
        return OrderStatus.outForDelivery;
      case 'delivered':
      case 'complete':
        return OrderStatus.delivered;
      case 'cancelled':
      case 'canceled':
        return OrderStatus.cancelled;
      case 'returned':
        return OrderStatus.returned;
      case 'refunded':
        return OrderStatus.refunded;
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
      case OrderStatus.readyForPickup:
        return 'ready_for_pickup';
      case OrderStatus.readyForDelivery:
        return 'ready_for_delivery';
      case OrderStatus.shipped:
        return 'shipped';
      case OrderStatus.outForDelivery:
        return 'out_for_delivery';
      case OrderStatus.delivered:
        return 'delivered';
      case OrderStatus.cancelled:
        return 'cancelled';
      case OrderStatus.returned:
        return 'returned';
      case OrderStatus.refunded:
        return 'refunded';
      case OrderStatus.unknown:
        return 'unknown';
    }
  }

  /// Check if an order is active (not finalized)
  bool get isActive => 
      this != OrderStatus.delivered && 
      this != OrderStatus.cancelled && 
      this != OrderStatus.returned &&
      this != OrderStatus.refunded &&
      this != OrderStatus.unknown;
}
