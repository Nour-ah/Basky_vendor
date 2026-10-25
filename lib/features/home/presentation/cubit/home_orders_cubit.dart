import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/realtime/realtime_refresh_mixin.dart';
import '../../../orders/domain/entities/order_filter_result_entity.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/domain/usecases/get_filtered_orders_usecase.dart';
import '../../../orders/domain/usecases/watch_new_vendor_orders_usecase.dart';
import '../../../orders/domain/usecases/watch_orders_status_usecase.dart';
import '../../../orders/presentation/cubit/active_orders_watch_mixin.dart';
import 'home_orders_state.dart';

class HomeOrdersCubit extends Cubit<HomeOrdersState>
    with
        RealtimeRefreshMixin<HomeOrdersState>,
        ActiveOrdersWatchMixin<HomeOrdersState> {
  final GetFilteredOrdersUseCase getFilteredOrdersUseCase;
  final WatchNewVendorOrdersUseCase watchNewVendorOrdersUseCase;
  final WatchOrdersStatusUseCase watchOrdersStatusUseCase;

  static const int _limit = 15;
  OrderStatus _selectedStatus = OrderStatus.unknown;

  HomeOrdersCubit({
    required this.getFilteredOrdersUseCase,
    required this.watchNewVendorOrdersUseCase,
    required this.watchOrdersStatusUseCase,
  }) : super(HomeOrdersInitial()) {
    listenForRealtimeRefresh(
      watchNewVendorOrdersUseCase(),
      () => fetchOrders(silent: true),
    );
  }

  @override
  void onChange(Change<HomeOrdersState> change) {
    super.onChange(change);
    final next = change.nextState;
    if (next is HomeOrdersLoaded) {
      watchActiveOrders(
        next.orders,
        watch: watchOrdersStatusUseCase.call,
        onRefresh: () => fetchOrders(silent: true),
      );
    }
  }

  /// Initial load or pull-to-refresh.
  /// [silent] keeps the current list on screen and ignores failures
  /// (used for realtime updates).
  Future<void> fetchOrders({
    bool isRefresh = false,
    bool silent = false,
  }) async {
    if (isClosed) return;

    final keepCurrent = silent && state is HomeOrdersLoaded;
    if (!keepCurrent && (isRefresh || state is! HomeOrdersLoaded)) {
      emit(HomeOrdersLoading(isTabSwitch: false));
    }

    debugPrint(
      '🔵 HomeOrdersCubit: Fetching orders (status: ${_selectedStatus.toApiString()})',
    );

    final result = await getFilteredOrdersUseCase(
      status: _selectedStatus == OrderStatus.unknown ? null : _selectedStatus,
      page: 1,
      limit: _limit,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        debugPrint('❌ HomeOrdersCubit: ${failure.message}');
        if (!keepCurrent) emit(HomeOrdersError(message: failure.message));
      },
      (data) {
        debugPrint('✅ HomeOrdersCubit: Loaded ${data.orders.length} orders');
        emit(HomeOrdersLoaded(result: data, selectedStatus: _selectedStatus));
      },
    );
  }

  /// Called when user taps a filter tab
  Future<void> changeFilter(OrderStatus status) async {
    if (isClosed) return;
    if (_selectedStatus == status && state is HomeOrdersLoaded) return;

    _selectedStatus = status;
    emit(HomeOrdersLoading(isTabSwitch: true));
    await fetchOrders();
  }

  /// Pagination: load next page
  Future<void> loadMore() async {
    if (isClosed) return;
    if (state is! HomeOrdersLoaded) return;

    final currentState = state as HomeOrdersLoaded;
    if (currentState.result.hasReachedMax) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.result.currentPage + 1;
    final result = await getFilteredOrdersUseCase(
      status: _selectedStatus == OrderStatus.unknown ? null : _selectedStatus,
      page: nextPage,
      limit: _limit,
    );

    if (isClosed) return;

    result.fold(
      (failure) =>
          debugPrint('❌ HomeOrdersCubit pagination failed: ${failure.message}'),
      (data) {
        final merged = OrderFilterResultEntity(
          stats: data.stats,
          orders: [...currentState.result.orders, ...data.orders],
          currentPage: data.currentPage,
          lastPage: data.lastPage,
          total: data.total,
          appliedFilter: data.appliedFilter,
        );
        emit(HomeOrdersLoaded(result: merged, selectedStatus: _selectedStatus));
      },
    );
  }
}
