import 'package:equatable/equatable.dart';
import 'recent_order_entity.dart';

class HomeStatsEntity extends Equatable {
  final int totalOrders;
  final double totalEarnings;
  final List<RecentOrderEntity> recentOrders;

  const HomeStatsEntity({
    required this.totalOrders,
    required this.totalEarnings,
    required this.recentOrders,
  });

  @override
  List<Object?> get props => [totalOrders, totalEarnings, recentOrders];
}
