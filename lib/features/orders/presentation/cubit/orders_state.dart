import 'package:equatable/equatable.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_summary_entity.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrdersLoaded extends OrdersState {
  final List<OrderSummaryEntity> orders;
  final OrderStatus filter;
  final int currentPage;
  final bool hasReachedMax;

  const OrdersLoaded({
    required this.orders,
    required this.filter,
    this.currentPage = 1,
    this.hasReachedMax = false,
  });

  OrdersLoaded copyWith({
    List<OrderSummaryEntity>? orders,
    OrderStatus? filter,
    int? currentPage,
    bool? hasReachedMax,
  }) {
    return OrdersLoaded(
      orders: orders ?? this.orders,
      filter: filter ?? this.filter,
      currentPage: currentPage ?? this.currentPage,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [orders, filter, currentPage, hasReachedMax];
}

class OrdersEmpty extends OrdersState {
  final OrderStatus filter;
  const OrdersEmpty({required this.filter});

  @override
  List<Object?> get props => [filter];
}

// ==========================================
// Dedicated Errors
// ==========================================

abstract class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class OrdersNetworkError extends OrdersError {
  const OrdersNetworkError(super.message);
}

class OrdersUnauthorizedError extends OrdersError {
  const OrdersUnauthorizedError(super.message);
}

class OrderStatusUpdateError extends OrdersError {
  const OrderStatusUpdateError(super.message);
}

class OrdersGenericError extends OrdersError {
  const OrdersGenericError(super.message);
}
