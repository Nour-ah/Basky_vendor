import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../orders/domain/entities/order_filter_result_entity.dart';
import '../../../orders/domain/entities/order_status.dart';
import '../../../orders/domain/usecases/get_filtered_orders_usecase.dart';
import 'home_orders_state.dart';

class HomeOrdersCubit extends Cubit<HomeOrdersState> {
  final GetFilteredOrdersUseCase getFilteredOrdersUseCase;

  static const int _limit = 15;
  OrderStatus _selectedStatus = OrderStatus.unknown;

  HomeOrdersCubit({required this.getFilteredOrdersUseCase}) : super(HomeOrdersInitial());

  /// Initial load or pull-to-refresh
  Future<void> fetchOrders({bool isRefresh = false}) async {
    if (isClosed) return;

    if (isRefresh) {
      emit(HomeOrdersLoading(isTabSwitch: false));
    } else if (state is! HomeOrdersLoaded) {
      emit(HomeOrdersLoading(isTabSwitch: false));
    }

    debugPrint('🔵 HomeOrdersCubit: Fetching orders (status: ${_selectedStatus.toApiString()})');

    final result = await getFilteredOrdersUseCase(
      status: _selectedStatus == OrderStatus.unknown ? null : _selectedStatus,
      page: 1,
      limit: _limit,
    );

    if (isClosed) return;

    result.fold(
      (failure) {
        debugPrint('❌ HomeOrdersCubit: ${failure.message}');
        emit(HomeOrdersError(message: failure.message));
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
      (failure) => debugPrint('❌ HomeOrdersCubit pagination failed: ${failure.message}'),
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
