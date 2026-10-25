import '../../../../core/utils/json_parsers.dart';
import '../../domain/entities/home_stats_entity.dart';
import 'recent_order_model.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.todayOrders,
    required super.todayEarnings,
    required super.recentOrders,
    required super.pendingOrders,
    required super.preparingOrders,
    required super.readyOrders,
    required super.deliveredOrders,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    final recentOrdersJson = json['recent_orders'] as List<dynamic>? ?? [];
    return HomeStatsModel(
      todayOrders: JsonParsers.asIntOr(json['today_orders_count']),
      todayEarnings: JsonParsers.asDouble(json['today_earnings']) ?? 0.0,
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
      'today_orders_count': todayOrders,
      'today_earnings': todayEarnings,
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
