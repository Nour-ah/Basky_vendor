import 'package:equatable/equatable.dart';
import 'recent_order_entity.dart';

class HomeStatsEntity extends Equatable {
  final int todayOrders;
  final double todayEarnings;
  final List<RecentOrderEntity> recentOrders;
  final int pendingOrders;
  final int preparingOrders;
  final int readyOrders;
  final int deliveredOrders;

  const HomeStatsEntity({
    required this.todayOrders,
    required this.todayEarnings,
    required this.recentOrders,
    required this.pendingOrders,
    required this.preparingOrders,
    required this.readyOrders,
    required this.deliveredOrders,
  });

  @override
  List<Object?> get props => [
    todayOrders,
    todayEarnings,
    recentOrders,
    pendingOrders,
    preparingOrders,
    readyOrders,
    deliveredOrders,
  ];
}
