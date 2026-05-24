import 'package:equatable/equatable.dart';
import 'recent_order_entity.dart';

class HomeStatsEntity extends Equatable {
  final int totalOrders;
  final double totalEarnings;
  final List<RecentOrderEntity> recentOrders;
  final int pendingOrders;
  final int preparingOrders;
  final int readyOrders;
  final int deliveredOrders;

  const HomeStatsEntity({
    required this.totalOrders,
    required this.totalEarnings,
    required this.recentOrders,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.deliveredOrders,
  });

  @override
  List<Object?> get props => [
        totalOrders,
        totalEarnings,
        recentOrders,
        pendingOrders,
        preparingOrders,
        readyOrders,
        deliveredOrders,
      ];
}
