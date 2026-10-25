/// Reverb channel and event names, mirroring `routes/channels.php` and the
/// backend event classes. Channel names omit the `private-` prefix.
class RealtimeChannels {
  RealtimeChannels._();

  static String vendorOrders(int vendorId) => 'vendor.$vendorId.orders';

  static String order(int orderId) => 'orders.$orderId';

  /// `NewVendorOrderCreated::broadcastAs()`.
  static const String newVendorOrderCreated = 'vendor.order.created';

  /// `OrderStatusChanged::broadcastAs()`.
  static const String orderStatusChanged = 'order.status.changed';
}
