import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_summary_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;

  static const int _limit = 15;

  OrdersCubit({
    required this.getOrdersUseCase,
    required this.updateOrderStatusUseCase,
  }) : super(OrdersInitial());

  Future<void> fetchOrders({OrderStatus filter = OrderStatus.unknown, bool isRefresh = false}) async {
    if (isClosed) return;
    
    if (isRefresh || state is! OrdersLoaded) {
      emit(OrdersLoading());
    } else if (state is OrdersLoaded && !isRefresh && (state as OrdersLoaded).filter != filter) {
      emit(OrdersLoading());
    }

    debugPrint('🔵 OrdersCubit: Loading orders (filter: ${filter.toApiString()})');
    
    final result = await getOrdersUseCase(status: filter, page: 1, limit: _limit);
    
    if (isClosed) return;

    result.fold(
      (failure) => _emitFailure(failure),
      (orders) {
        if (orders.isEmpty) {
          emit(OrdersEmpty(filter: filter));
        } else {
          emit(OrdersLoaded(
            orders: orders,
            filter: filter,
            currentPage: 1,
            hasReachedMax: orders.length < _limit,
          ));
        }
      },
    );
  }

  Future<void> loadMore() async {
    if (isClosed) return;
    if (state is! OrdersLoaded) return;
    
    final currentState = state as OrdersLoaded;
    if (currentState.hasReachedMax) return;

    final nextPage = currentState.currentPage + 1;
    final result = await getOrdersUseCase(status: currentState.filter, page: nextPage, limit: _limit);
    
    if (isClosed) return;

    result.fold(
      (failure) => debugPrint('❌ OrdersCubit: Pagination failed - ${failure.message}'),
      (newOrders) {
        if (newOrders.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            orders: List.of(currentState.orders)..addAll(newOrders),
            currentPage: nextPage,
            hasReachedMax: newOrders.length < _limit,
          ));
        }
      },
    );
  }

  Future<void> updateOrderStatus(int orderId, OrderStatus newStatus) async {
    if (isClosed) return;
    if (state is! OrdersLoaded) return;

    final currentState = state as OrdersLoaded;
    final originalOrders = List<OrderSummaryEntity>.from(currentState.orders);

    // Optimistic UI Update
    final updatedOrders = originalOrders.map((order) {
      if (order.id == orderId) {
        return OrderSummaryEntity(
          id: order.id,
          orderCode: order.orderCode,
          status: newStatus,
          dateTime: order.dateTime,
          orderType: order.orderType,
          itemCount: order.itemCount,
          totalAmount: order.totalAmount,
        );
      }
      return order;
    }).toList();

    emit(currentState.copyWith(orders: updatedOrders));

    // API Call
    final result = await updateOrderStatusUseCase(orderId: orderId, newStatus: newStatus);
    
    if (isClosed) return;

    result.fold(
      (failure) {
        // Rollback on failure
        emit(OrderStatusUpdateError(failure.message));
        emit(currentState.copyWith(orders: originalOrders));
      },
      (_) => debugPrint('✅ OrdersCubit: Status updated successfully'),
    );
  }

  void _emitFailure(Failure failure) {
    if (failure is NetworkFailure) {
      emit(OrdersNetworkError(failure.message));
    } else if (failure is UnauthorizedFailure) {
      emit(OrdersUnauthorizedError(failure.message));
    } else {
      emit(OrdersGenericError(failure.message));
    }
  }
}
