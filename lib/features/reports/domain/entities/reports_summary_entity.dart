import 'package:equatable/equatable.dart';

class ReportChartPointEntity extends Equatable {
  final String label;
  final double value;

  const ReportChartPointEntity({required this.label, required this.value});

  @override
  List<Object?> get props => [label, value];
}

class ReportsSummaryEntity extends Equatable {
  final String range;
  final int totalOrders;
  final double totalRevenue;
  final double averageRating;
  final int totalCustomers;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final List<ReportChartPointEntity> revenueChart;

  const ReportsSummaryEntity({
    required this.range,
    required this.totalOrders,
    required this.totalRevenue,
    required this.averageRating,
    required this.totalCustomers,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.revenueChart,
  });

  @override
  List<Object?> get props => [
        range,
        totalOrders,
        totalRevenue,
        averageRating,
        totalCustomers,
        pendingOrders,
        completedOrders,
        cancelledOrders,
        revenueChart,
      ];
}
