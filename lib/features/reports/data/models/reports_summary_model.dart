import '../../domain/entities/reports_summary_entity.dart';

class ReportsSummaryModel extends ReportsSummaryEntity {
  const ReportsSummaryModel({
    required super.range,
    required super.totalOrders,
    required super.totalRevenue,
    required super.averageRating,
    required super.totalCustomers,
    required super.pendingOrders,
    required super.completedOrders,
    required super.cancelledOrders,
    required super.revenueChart,
  });

  factory ReportsSummaryModel.fromJson(Map<String, dynamic> json, {String range = 'last_30_days'}) {
    final chartJson = json['revenue_chart'] ?? json['chart'] ?? json['daily_revenue'] ?? [];
    final chart = (chartJson as List)
        .whereType<Map<String, dynamic>>()
        .map(
          (e) => ReportChartPointEntity(
            label: e['label']?.toString() ?? e['date']?.toString() ?? '',
            value: e['value'] is num
                ? (e['value'] as num).toDouble()
                : double.tryParse(e['value']?.toString() ?? e['revenue']?.toString() ?? '0') ?? 0,
          ),
        )
        .toList();

    final byStatus = json['orders_by_status'] as Map<String, dynamic>? ?? {};

    return ReportsSummaryModel(
      range: json['range']?.toString() ?? range,
      totalOrders: _toInt(json['total_orders']),
      totalRevenue: _toDouble(json['total_revenue'] ?? json['total_earnings']),
      averageRating: _toDouble(json['average_rating'] ?? json['avg_rating']),
      totalCustomers: _toInt(json['total_customers'] ?? json['customers_count']),
      pendingOrders: _toInt(byStatus['pending'] ?? json['pending_orders']),
      completedOrders: _toInt(byStatus['delivered'] ?? byStatus['complete'] ?? json['completed_orders']),
      cancelledOrders: _toInt(byStatus['cancelled'] ?? json['cancelled_orders']),
      revenueChart: chart,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '0') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString() ?? '0') ?? 0;
  }
}
