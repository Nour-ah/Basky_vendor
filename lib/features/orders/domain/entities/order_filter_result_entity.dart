import 'package:equatable/equatable.dart';
import 'order_status.dart';
import 'order_summary_entity.dart';

class OrderFilterStatsEntity extends Equatable {
  final int todayOrdersCount;
  final int thisWeekOrdersCount;
  final int thisMonthOrdersCount;

  const OrderFilterStatsEntity({
    required this.todayOrdersCount,
    required this.thisWeekOrdersCount,
    required this.thisMonthOrdersCount,
  });

  @override
  List<Object?> get props => [todayOrdersCount, thisWeekOrdersCount, thisMonthOrdersCount];
}

class OrderFilterResultEntity extends Equatable {
  final OrderFilterStatsEntity stats;
  final List<OrderSummaryEntity> orders;
  final int currentPage;
  final int lastPage;
  final int total;
  final OrderStatus appliedFilter;

  const OrderFilterResultEntity({
    required this.stats,
    required this.orders,
    required this.currentPage,
    required this.lastPage,
    required this.total,
    required this.appliedFilter,
  });

  bool get hasReachedMax => currentPage >= lastPage;

  @override
  List<Object?> get props => [stats, orders, currentPage, lastPage, total, appliedFilter];
}
