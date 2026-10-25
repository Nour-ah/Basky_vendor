import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/realtime/realtime_refresh_mixin.dart';
import '../../domain/entities/order_status.dart';
import '../../domain/entities/order_summary_entity.dart';
import '../../domain/usecases/get_orders_usecase.dart';
import '../../domain/usecases/update_order_status_usecase.dart';
import '../../domain/usecases/watch_new_vendor_orders_usecase.dart';
import '../../domain/usecases/watch_orders_status_usecase.dart';
import 'active_orders_watch_mixin.dart';
import 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState>
    with RealtimeRefreshMixin<OrdersState>, ActiveOrdersWatchMixin<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;
  final UpdateOrderStatusUseCase updateOrderStatusUseCase;
  final WatchNewVendorOrdersUseCase watchNewVendorOrdersUseCase;
  final WatchOrdersStatusUseCase watchOrdersStatusUseCase;

  static const int _limit = 15;
  OrderStatus _filter = OrderStatus.unknown;

  OrdersCubit({
    required this.getOrdersUseCase,
    required this.updateOrderStatusUseCase,
    required this.watchNewVendorOrdersUseCase,
    required this.watchOrdersStatusUseCase,
  }) : super(OrdersInitial()) {
    listenForRealtimeRefresh(watchNewVendorOrdersUseCase(), refreshSilently);
  }

  @override
  void onChange(Change<OrdersState> change) {
    super.onChange(change);
    final next = change.nextState;
    if (next is OrdersLoaded || next is OrdersEmpty) {
      watchActiveOrders(
        next is OrdersLoaded ? next.orders : const [],
        watch: watchOrdersStatusUseCase.call,
        onRefresh: refreshSilently,
      );
    }
  }

  /// Reloads the first page of the current filter without a loader;
  /// failures are ignored so the current list stays on screen.
  Future<void> refreshSilently() async {
    if (isClosed) return;
    if (state is! OrdersLoaded && state is! OrdersEmpty) return;

    final filter = _filter;
    final result = await getOrdersUseCase(status: filter, page: 1, limit: _limit);
    if (isClosed || filter != _filter) return;

    result.fold(
      (failure) => debugPrint('❌ OrdersCubit: Silent refresh failed - ${failure.message}'),
      (orders) => emit(
        orders.isEmpty
            ? OrdersEmpty(filter: filter)
            : OrdersLoaded(
                orders: orders,
                filter: filter,
                currentPage: 1,
                hasReachedMax: orders.length < _limit,
              ),
      ),
    );
  }

  Future<void> fetchOrders({OrderStatus filter = OrderStatus.unknown, bool isRefresh = false}) async {
    if (isClosed) return;
    _filter = filter;

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
    final updatedOrders = originalOrders
        .map((order) =>
            order.id == orderId ? order.copyWith(status: newStatus) : order)
        .toList();

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
