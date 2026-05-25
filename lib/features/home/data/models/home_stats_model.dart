import '../../domain/entities/home_stats_entity.dart';
import 'recent_order_model.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.totalOrders,
    required super.totalEarnings,
    required super.recentOrders,
    required super.pendingOrders,
    required super.preparingOrders,
    required super.readyOrders,
    required super.deliveredOrders,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    final recentOrdersJson = json['recent_orders'] as List<dynamic>? ?? [];
    return HomeStatsModel(
      totalOrders: json['total_orders'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      recentOrders: recentOrdersJson
          .map((e) => RecentOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pendingOrders:
          json['pending_orders'] as int? ?? json['pending'] as int? ?? 0,
      preparingOrders:
          json['preparing_orders'] as int? ?? json['preparing'] as int? ?? 0,
      readyOrders: json['ready_orders'] as int? ?? json['ready'] as int? ?? 0,
      deliveredOrders:
          json['delivered_orders'] as int? ?? json['delivered'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'total_earnings': totalEarnings,
      'recent_orders': recentOrders
          .map((e) => (e as RecentOrderModel).toJson())
          .toList(),
      'pending_orders': pendingOrders,
      'preparing_orders': preparingOrders,
      'ready_orders': readyOrders,
      'delivered_orders': deliveredOrders,
    };
  }
}
