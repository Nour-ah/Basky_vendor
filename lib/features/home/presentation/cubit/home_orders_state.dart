import 'package:equatable/equatable.dart';
import '../../../orders/domain/entities/order_filter_result_entity.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/domain/entities/order_summary_entity.dart';

// All valid filter statuses shown as tabs in Home Screen
const List<OrderStatus> kHomeOrderFilterStatuses = [
  OrderStatus.unknown,     // "All" tab
  OrderStatus.pending,
  OrderStatus.processing,
  OrderStatus.readyForPickup,
  OrderStatus.shipped,
  OrderStatus.delivered,
  OrderStatus.cancelled,
  OrderStatus.refunded,
];

abstract class HomeOrdersState extends Equatable {
  const HomeOrdersState();

  @override
  List<Object?> get props => [];
}

class HomeOrdersInitial extends HomeOrdersState {}

class HomeOrdersLoading extends HomeOrdersState {
  /// When true, a tab switch triggered the load (show shimmer on list only, not full screen)
  final bool isTabSwitch;
  const HomeOrdersLoading({this.isTabSwitch = false});

  @override
  List<Object?> get props => [isTabSwitch];
}

class HomeOrdersLoaded extends HomeOrdersState {
  final OrderFilterResultEntity result;
  final OrderStatus selectedStatus;
  final bool isLoadingMore;

  const HomeOrdersLoaded({
    required this.result,
    required this.selectedStatus,
    this.isLoadingMore = false,
  });

  List<OrderSummaryEntity> get orders => result.orders;

  HomeOrdersLoaded copyWith({
    OrderFilterResultEntity? result,
    OrderStatus? selectedStatus,
    bool? isLoadingMore,
  }) {
    return HomeOrdersLoaded(
      result: result ?? this.result,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }

  @override
  List<Object?> get props => [result, selectedStatus, isLoadingMore];
}

class HomeOrdersError extends HomeOrdersState {
  final String message;
  const HomeOrdersError({required this.message});

  @override
  List<Object?> get props => [message];
}
