import '../../domain/entities/order_filter_result_entity.dart';
import '../../domain/entities/order_status.dart';
import 'order_summary_model.dart';

class OrderFilterResultModel extends OrderFilterResultEntity {
  const OrderFilterResultModel({
    required super.stats,
    required super.orders,
    required super.currentPage,
    required super.lastPage,
    required super.total,
    required super.appliedFilter,
  });

  factory OrderFilterResultModel.fromJson(
    Map<String, dynamic> json, {
    required OrderStatus appliedFilter,
  }) {
    final statsJson = json['stats'] as Map<String, dynamic>? ?? {};
    final dataJson = json['data'] as List<dynamic>? ?? [];
    final metaJson = json['meta'] as Map<String, dynamic>? ?? {};

    final stats = OrderFilterStatsEntity(
      todayOrdersCount: statsJson['today_orders_count'] as int? ?? 0,
      thisWeekOrdersCount: statsJson['this_week_orders_count'] as int? ?? 0,
      thisMonthOrdersCount: statsJson['this_month_orders_count'] as int? ?? 0,
    );

    final orders = dataJson
        .map((e) => OrderSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return OrderFilterResultModel(
      stats: stats,
      orders: orders,
      currentPage: metaJson['current_page'] as int? ?? 1,
      lastPage: metaJson['last_page'] as int? ?? 1,
      total: metaJson['total'] as int? ?? 0,
      appliedFilter: appliedFilter,
    );
  }
}
