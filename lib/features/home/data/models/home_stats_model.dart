import '../../domain/entities/home_stats_entity.dart';
import 'recent_order_model.dart';

class HomeStatsModel extends HomeStatsEntity {
  const HomeStatsModel({
    required super.totalOrders,
    required super.totalEarnings,
    required super.recentOrders,
  });

  factory HomeStatsModel.fromJson(Map<String, dynamic> json) {
    final recentOrdersJson = json['recent_orders'] as List<dynamic>? ?? [];
    return HomeStatsModel(
      totalOrders: json['total_orders'] as int? ?? 0,
      totalEarnings: (json['total_earnings'] as num?)?.toDouble() ?? 0.0,
      recentOrders: recentOrdersJson
          .map((e) => RecentOrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_orders': totalOrders,
      'total_earnings': totalEarnings,
      'recent_orders': recentOrders
          .map((e) => (e as RecentOrderModel).toJson())
          .toList(),
    };
  }
}
